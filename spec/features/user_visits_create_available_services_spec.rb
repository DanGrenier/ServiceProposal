require 'spec_helper'
require 'pp'
RSpec.feature "User visits Available Services", :js=>true do 
  before do 
    @user = create_logged_in_user
  
	end

  scenario "Should display the default values from initial seedings" do 
  	visit root_path
    click_link "Proposals"
    click_link "Available Services"
    expect(page).to have_content("Setup Accounts")

  end

  scenario "Should allow to add an available service" do
    visit root_path
    click_link "Proposals"
    click_link "Available Services"
    click_button "New Service"
    fill_in "available_service_service_description", :with => "My Custom Service"
    select("Accounting", :from => "available_service_service_type")
    click_button "Save Changes"
    click_link "Proposals"
    click_link "Available Services"
    expect(page).to have_content("My Custom Service")
    
  end
end