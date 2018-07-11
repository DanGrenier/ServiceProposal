require 'spec_helper'
require 'pp'

RSpec.feature "User signs up", :js =>true do 
  
  scenario "with valid credentials" do 
  	visit "/"
  	click_link "Sign Up"
	  fill_in "user_email", with: "someone@somedomain.com"
    fill_in "user_password", with: "testing123"
    fill_in "user_password_confirmation", with: "testing123"
	  click_button "Sign up"
	  expect(page).to have_content("Welcome! You have signed up successfully.")
  end

  
end






