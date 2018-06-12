require 'spec_helper'
require 'pp'
RSpec.feature "User Logs In", :js=> true do 
  before do 
  	@franchise = FactoryGirl.create(:franchise)
  	@franchise3 = FactoryGirl.create(:franchise, id:3 )
  	@admin = FactoryGirl.create(:adminuser)
  	@user = FactoryGirl.create(:user)
  end	

  scenario "Franchise User with valid credentials"	do 
  	visit '/'
  	first(:link, "Log In").click
	fill_in "user_email", :with => @user.email
	fill_in "user_password", :with => @user.password
	click_button "Log in"
	expect(page).to have_content "Royalty Activity" 
  end

  scenario "Admin User with valid credentials" do 
    visit '/'
    first(:link, "Log In").click
    fill_in "user_email", :with => @admin.email
	fill_in "user_password", :with => @admin.password
	click_button "Log in"
	expect(page).to have_content "Franchise Activity"
  end

  scenario "Franchise user with bad credentials" do
    visit '/'
    first(:link, "Log In").click
    fill_in "user_email", :with => "test@test.com"
	fill_in "user_password", :with => "potato"
	click_button "Log in"
	expect(page).to have_content "Invalid email or password"
  end

  

end

