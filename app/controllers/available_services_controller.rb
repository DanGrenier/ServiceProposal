class AvailableServicesController < ApplicationController
before_action :authenticate_user!
before_action :set_service , only:[:edit, :update, :destroy, :show]
before_action :only_current_user,  only:[:edit, :update, :destroy]

def index
	@services = AvailableService.get_proposal_services(current_user.id)
end

def show
end

def new
	@service = AvailableService.new
  @service.build_for_user(current_user.id)
end

def create
  @service = AvailableService.new(service_params)
	if @service.save
    flash[:success] = "Proposal service created successfully!"
		redirect_to available_services_path
	else
		render :new
	end
end

def edit
end

def update
	if @service.update_attributes(service_params)
		flash[:success] = "Proposal service updated successfully!"
    redirect_to available_services_path
	else
		render :edit
	end

end

def destroy
  if @service.destroy
    flash[:success] = "Service deleted successfully!"
    redirect_to available_services_path
  else
    flash[:danger] = "Could not delete service!"
    redirect_to available_services_path
  end
end


private
  #method that gathers the params from the form 
  def service_params
    params.require(:available_service).permit(:user_id, :service_description, :service_type, :custom_service)
  end

  #method that verifies that the current logged in franchise can edit only their remittances
  def only_current_user
    redirect_to(root_url) unless @service.user_id == current_user.id
  end

  #method that finds and sets the invoice object needed for some actions
  def set_service
    @service = AvailableService.find(params[:id])
  end

end