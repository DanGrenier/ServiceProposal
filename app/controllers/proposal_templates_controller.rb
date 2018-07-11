class ProposalTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only:[:edit, :update, :destroy]
  before_action :only_current_user, only:[:edit,:update,:destroy]

  def index
    #Show proposal templates for current user only
  	@templates = ProposalTemplate.where("user_id = ?", current_user.id)
  end

  def new
    #Create new proposal
    @template = ProposalTemplate.new
    #Set the current user
    @template.user_id = current_user.id 
    #Builds the detail for the current user
    @services = @template.build_detail_for_user(current_user.id)
  end

  def create
    @template = ProposalTemplate.new(template_params)
    if @template.save
      flash[:success] = "Template Created Successfully"
      redirect_to proposal_templates_path
    else
      render :new
    end

  end

  def edit
  end

  def update
    if @template.update_attributes(template_params)
      flash[:success] = "Template Modified Successfully"
      redirect_to proposal_templates_path
    else
      render :edit
    end
  end

  def destroy
    if @template.destroy
      flash[:success] = "Template Deleted Successfully"
      redirect_to proposal_templates_path
    else
      flash[:danger] = "Template Could Not be Deleted"
      redirect_to proposal_templates_path
    end
  end

  private
    def template_params
      params.require(:proposal_template).permit(:user_id, :service_type, :template_description, proposal_template_details_attributes:[:id, :service_id, :tier1_applicable, :tier2_applicable, :tier3_applicable ])
    end
    #Method that finds and sets the template required for some actions
    def set_template
      @template = ProposalTemplate.find(params[:id])
    end
    #Method that makes sure users can only edit, update or delete their own templates
    def only_current_user
      redirect_to(root_url) unless @template.user_id == current_user.id
    end

end