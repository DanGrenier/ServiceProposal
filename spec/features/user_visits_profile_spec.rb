require 'spec_helper'
require 'pp'
RSpec.feature "User visits their User profile", :js=>true do 
  before do 
    @user = create_logged_in_user
  
	end

  scenario "Should display users email address" do 
  	visit root_path
    
    click_link "Account"
    click_link "User Profile"
    expect(find_field('user_email').value).to eq @user.email
    
  end

  scenario "Should allow for a change in the city from Athens to Bogart" do
    visit root_path
    click_link "Account"
    click_link "User Profile"
    fill_in "user_city", :with => "Bogart"
    fill_in "user_current_password", :with => @user.password
    click_button "Update"
    click_link "Account"
    click_link "User Profile"
    expect(find_field('user_city').value).to eq 'Bogart'
  end
end