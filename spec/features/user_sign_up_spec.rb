require 'spec_helper'
require 'pp'

RSpec.feature "User signs up", :js =>true do 
  before do 
    @franchise1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
  end
  scenario "with valid credentials" do 
  	visit "/"
  	click_link "Sign Up"
	  fill_in "email", with: "dgrenier@smallbizpros.com"
	  click_button "Sign Me Up"
	  expect(page).to have_content("Thank you. An email was sent to dgrenier@smallbizpros.com with instructions to choose your password.")
  end
end






