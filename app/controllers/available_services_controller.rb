class AvailableServicesController < ApplicationController
decorates_assigned :services
before_action :authenticate_user!
before_action :set_service , only:[:edit, :update, :destroy, :show]
before_action :only_current_user,  only:[:edit, :update, :destroy]

def index
  #List services for the current logged in user only
  @services = AvailableService.get_proposal_services(current_user.id)
end

def show
end

def new
  #Create the new service code
	@service = AvailableService.new
  #pre-populate values for this particular user
  @service.build_for_user(current_user.id)
end

def create
  @service = AvailableService.new(service_params)
	if @service.save
    flash[:success] = "Service Item Created Successfully."
		redirect_to available_services_path
	else
		render :new
	end
end

def edit
end

def update
	if @service.update_attributes(service_params)
		flash[:success] = "Service Item Updated Successfully."
    redirect_to available_services_path
	else
		render :edit
	end

end

def destroy
  if @service.destroy
    flash[:success] = "Service Item Deleted Successfully."
    redirect_to available_services_path
  else
    flash[:error] = @service.errors.full_messages.to_sentence
    redirect_to available_services_path
  end
end

private
  #method that gathers and whitelists the params from the form 
  def service_params
    params.require(:available_service).permit(:user_id, :service_description, :service_type, :custom_service)
  end

  #Method that verifies that a user can only edit,update and destroy their own added codes
  def only_current_user
    redirect_to(root_url) unless @service.user_id == current_user.id
  end

  #Method that finds and sets the service item object needed for some actions
  def set_service
    @service = AvailableService.find(params[:id])
  end

end


