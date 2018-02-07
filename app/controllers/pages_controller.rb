class PagesController < ApplicationController
  def home
    #If a user is signed in?
    if current_user
      @profile_incomplete =  current_user.profile_incomplete?
    end
  end
      
end
