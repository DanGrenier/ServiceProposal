require 'spec_helper'
require 'pp'

describe "Proposals" do
  describe "Not Logged In" do 
    describe "Home Page" do 
  	  it "Should show the homepage with the 2 buttons", :js => true do 
	      visit root_path
          
	      expect(page).to have_link("Log In")
	      expect(page).to have_link("Sign Up")
      end
      
      it "Should show the login screen after clicking button" do 
        visit root_url
        first(:link, "Log In").click
        expect(page).to have_button ("Log in")
        expect(page).to have_field ("user_email")
        expect(page).to have_field ("user_password")
        
      end
    end
  end

  describe "Logged In" do  
    context "Home Page" do 
      it "Should show the Proposal Statistics and Recent Proposals" do 
        create_logged_in_user
        visit root_url
        h2s = page.all("h2")
        expect(h2s[0]).to have_content("Proposal Statistics")
        expect(h2s[1]).to have_content("Recent Proposals")
        

      end
    end


  end    

  

end
