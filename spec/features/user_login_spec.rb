require 'spec_helper'
require 'pp'
RSpec.feature "User Logs In", :js=> true do 
  before do 
    @user = FactoryBot.create(:user)
  end 
  
  scenario "User with valid credentials"	do 
    visit root_path
    first(:link, "Log In").click
	  fill_in "user_email", :with => @user.email
	  fill_in "user_password", :with => @user.password
    click_button "Log in"
    expect(page).to have_content "Proposal Statistics" 
  end

  
  scenario "User with bad credentials" do
    visit root_path
    first(:link, "Log In").click
    fill_in "user_email", :with => "test@test.com"
	fill_in "user_password", :with => "potato"
	click_button "Log in"
	expect(page).to have_content "Invalid email or password"
  end

  

end

