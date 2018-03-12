class ProposalsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :set_proposal, only:[:edit, :update, :destroy, :show]
  before_action :only_current_user, only:[:edit,:update,:destroy, :show]

  def index
    logger.debug "Sort Column: #{sort_column}"
    logger.debug "Sort Direction: #{sort_direction}"
    sorting = sort_column + " " + sort_direction
    logger.debug "Sort: #{sorting}"
    logger.debug "Search #{params[:search]}"
  	@proposals = Proposal.search(params[:search],current_user.id).order(sorting)
  end

  def show
  end

  def new
    if(params[:template_id])
      @template_id = params[:template_id].to_i
    end

    @proposal = Proposal.new
    @proposal.user_id = current_user.id 
    @proposal.proposal_text = current_user.proposal_setting.proposal_default_text
    if (@template_id)
      @proposal.build_from_template(@template_id)
    else
      @proposal.build_from_scratch(current_user.id)
    end
  end

  def create
    @proposal = Proposal.new(proposal_params)

    if @proposal.save
      if submit_req == "Save and Preview" 
        redirect_to proposal_path(id: @proposal.id)
      else
        flash[:success] = "Proposal Created Successfully"
        redirect_to proposals_path
      end
    else
      render :new
    end
  end


  def edit
  end

  def update
    if @proposal.update_attributes(proposal_params)
      if submit_req == "Save and Preview"
        redirect_to proposal_path(id: @proposal.id)
      else
        flash[:success] = "Proposal Modified Successfully"
        redirect_to proposals_path
      end
    else
      render :edit
    end
  end

  def destroy
    if @proposal.destroy
      flash[:success] = "Proposal Deleted Successfully"
      redirect_to proposals_path
    else
      flash[:danger] = "Proposal Could not be Deleted"
      redirect_to proposals_path
    end
  end

  def report
    @proposal = Proposal.find(params[:id])
    respond_to do |format|
      format.pdf do
        send_data ProposalDrawer.draw(@proposal, current_user), :filename => '@proposal#{@proposal.id}.pdf', :type => "application/pdf", :disposition => "inline"
      end
    end
  end  

  private

    def proposal_params
      params.require(:proposal).permit(:user_id, :proposal_status, :actual_fee, :service_type, :business_name, :address, :address2, :city, :state, :zip, :phone, :contact_first, :contact_last, :contact_email, :business_type, :fee_tier1, :fee_tier2, :fee_tier3, :proposal_text,  proposal_details_attributes:[:service_id, :id, :tier1_applicable, :tier2_applicable, :tier3_applicable])
    end

    def set_proposal
      @proposal = Proposal.find(params[:id])
    end

    def only_current_user
      redirect_to(root_url) unless @proposal.user_id == current_user.id
    end

    def sort_column
      Proposal.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end

    def submit_req
      params[:submit]
    end

end