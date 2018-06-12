require 'spec_helper'
require 'pp'
describe "user sign up" do 
	it "should allow the user to sign in" do 
	  fran = FactoryGirl.create(:franchise)
	  
	  visit '/'
	  click_link "Sign Up"
	  fill_in "Email", :with => "dgrenier@smallbizpros.com"
	  click_button "Sign Me Up"
	  expect(page).to have_content "Test" 
    end

end




