require 'spec_helper'
require 'pp'
RSpec.feature "User visits their User profile", :js=>true do 
  before do 
    @franchise = FactoryGirl.create(:franchise)
	  @user = create_logged_in_user
	
  end

  scenario "Should display users email address" do 
  	visit '/'
    pp page.body
  	click_link "User Profile"
  	expect(page).to have_content @user.email


  end
end