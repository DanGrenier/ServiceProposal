require 'spec_helper'
require 'pp'
RSpec.feature "User visits their User profile", :js=> true do 
  before do 
    @franchise = FactoryGirl.create(:franchise)
	@user = FactoryGirl.create(:user)
  end

  scenario "Should display users email address" do 
  	visit '/'
  	first(:link, "Log In").click
	fill_in "user_email", :with => @user.email
	fill_in "user_password", :with => @user.password
	click_button "Log in"
	pp page
  	#click_link "User Profile"
  	#expect(page).to have_content @user.email


  end
end