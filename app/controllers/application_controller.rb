class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_params, if: :devise_controller?


  def configure_permitted_params
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email,:password, :current_password, :business_name,
      :owner_first, :owner_last, :address, :address2, :city,
      :state, :zip_code, :phone, :website ) }
  end
end
