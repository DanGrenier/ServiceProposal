require 'spec_helper'
include Warden::Test::Helpers

module RequestMacros
   def create_logged_in_user
   	user = FactoryBot.create(:user)
    login(user)
    user
    
   end

   def login(user)
   	login_as user, scope: :user
   end

	
end