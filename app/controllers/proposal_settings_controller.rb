class ProposalSettingsController < ApplicationController

before_action :profile_complete
before_action :set_proposal_setting, only:[:edit, :update, :destroy]	
before_action :only_current_user, only: [:edit,:update,:destroy]

def edit
end

def update
  if @proposal_setting.update_attributes(proposal_settings_params)	
	flash[:success] = "Proposal Settings Updated Successfully!"
    redirect_to root_url
  else
	render :edit
  end
end

private
  #Method that gathers and whitelists the parameters returned by the form
  def proposal_settings_params
  	params.require(:proposal_setting).permit(:return_email, :tier1_name, :tier2_name, :tier3_name, :proposal_default_text)
  end
  #Method that makes sure users can only modify their own settings
  def only_current_user
  	redirect_to :root unless @proposal_setting.user_id == current_user.id
  end
  #Method that finds and set the proposal setting based on the current user
  def set_proposal_setting
  	@proposal_setting = ProposalSetting.find(params[:id])
  end
  #Method that checks if the user profile is complete before continuing with the action
  def profile_complete
    if current_user.profile_incomplete?
      redirect_to :root , :notice => "Please Complete your User Profile"
    end
  end

end
