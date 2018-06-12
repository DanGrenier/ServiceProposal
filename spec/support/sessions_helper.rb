require 'spec_helper'
include Warden::Test::Helpers

module Features
	module SessionHelpers
      def create_logged_in_user
   	    user = FactoryGirl.create(:user)
        login(user)
        user
      end

      def login(user)
   	    login_as user, scope: :user
      end
    end
end