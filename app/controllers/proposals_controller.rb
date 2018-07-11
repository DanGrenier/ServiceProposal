class ProposalsController < ApplicationController
  decorates_assigned :proposals
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!
  before_action :set_proposal, only:[:edit, :update, :destroy, :show, :report, :send_proposal_email]
  before_action :only_current_user, only:[:edit,:update,:destroy, :show, :report, :send_proposal_email]

  def index
    #Set the sorting column and sort direction with the helpers
    sorting = sort_column + " " + sort_direction
    #Grab the proposals based on the search text (grabs all if search is empty)
  	@proposals = Proposal.search(params[:search],current_user.id).order(sorting)
  end

  def show
  end

  def new
    if(params[:template_id])
      @template_id = params[:template_id].to_i
    end
    #Creates new proposal
    @proposal = Proposal.new
    #Assign user id
    @proposal.user_id = current_user.id 
    #Assign default proposal text from proposal settings of the user
    @proposal.proposal_text = current_user.proposal_setting.proposal_default_text
    #Call the building method accordingly if a proposal was created from a template
    if (@template_id)
      @proposal.build_from_template(@template_id)
    else
      @proposal.build_from_scratch(current_user.id)
    end
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      #If they clicked on save and preview, we open the new proposal for viewing immediately
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
      #If they clicked on save and preview, we open the new proposal for viewing immediately
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

  #Method to generate the proposal as a pdf document (that can then be printed or saved)
  def report
    respond_to do |format|
      format.pdf do
        #Call the Proposal Drawer to generate the proposal PDF and assign it a filename
        send_data ProposalDrawer.draw(@proposal, current_user), :filename => '@proposal#{@proposal.id}.pdf', :type => "application/pdf", :disposition => "inline"
      end
    end
  end

  #Method to generate the proposal as a pdf and email it to the client (provided there is an email address)
  def send_proposal_email
    if @proposal.contact_email.blank?
      flash[:danger] = "This Proposal does not contain a valid email address for the client. Edit the proposal to add an email address"
      redirect_to proposals_path
    else
      ProposalMailer.email_proposal_to_prospect(@proposal,current_user).deliver_now
      flash[:success] = "Proposal Sent to #{@proposal.contact_email}"
      redirect_to proposals_path
    end

  end

  private
    #Method that gathers and whitelist parameters coming from the form to create the proposal
    def proposal_params
      params.require(:proposal).permit(:user_id, :proposal_status, :actual_fee, :service_type, :business_name, :address, :address2, :city, :state, :zip, :phone, :contact_first, :contact_last, :contact_email, :business_type, :fee_tier1, :fee_tier2, :fee_tier3, :proposal_text,  proposal_details_attributes:[:service_id, :id, :tier1_applicable, :tier2_applicable, :tier3_applicable])
    end
    #Method that finds and sets the proposal needed for some Actions
    def set_proposal
      @proposal = Proposal.find(params[:id])
    end
    #Method that makes sure that users can only edit, update, destroy their own proposal
    def only_current_user
      redirect_to(root_url) unless @proposal.user_id == current_user.id
    end
    #Method that returns the sort columns
    def sort_column
      Proposal.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
    end
    #Method that returns the sort direction 
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
    end
    #Method that returns which submit button that was clicked
    def submit_req
      params[:submit]
    end

end