require 'spec_helper'
require 'pp'

describe "REAP" do
  describe "Not Logged In" do 
    describe "Home Page" do 
  	  it "Should show the homepage with the 2 buttons and then " do 
	      visit root_url
	      expect(page).to have_link("Log In")
	      expect(page).to have_link("Sign Up")
      end
      
      it "Should show the login screen after clicking button" do 
        visit root_url
        first(:link, "Log In").click
          
        expect(page).to have_button ("Log in")
        
      end
    end
  end

  describe "Logged In" do  
    before :each do 
    @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
    @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
    #@deposit1 = FactoryGirl.create(:deposit_tracker, fran: 1, id:1)
    #@deposit2 = FactoryGirl.create(:deposit_tracker, fran: 1, date_received: (DateTime.now + 1.days), id:2 )
    #@deposit3 = FactoryGirl.create(:deposit_tracker, fran: 1, date_received: (DateTime.now + 2.days), id:3 )
    #@deposit4 = FactoryGirl.create(:deposit_tracker, fran: 1, date_received: DateTime.now + 3.days, id:4 )

    end

    context "Home Page" do 
      it "Should show the Recent activity" do 
        create_logged_in_user
        visit root_url
        within 'h3' do
            expect(page).to have_content("Recent Activity")
        end
      end

    end

    context "Deposit Tracker Page" do 
      it "Navigates to index and check for elements" do 
        create_logged_in_user
        visit '/deposit_trackers'
        expect(page).to have_button("New Deposit Entry")
        expect(page).to have_button("Reload")
      end

      it "Navigates to new deposit entry and check for elements" do 
        create_logged_in_user
        visit '/deposit_trackers/new'
        expect(page).to have_button("Save")
        expect(page).to have_link "Discard"
      end

      it "Navigates to new deposit entry and fills in elements and submit" do 
        create_logged_in_user
        visit 'deposit_trackers/new'
        fill_in "deposit_tracker_total_deposit", :with => 1000
        fill_in "deposit_tracker_accounting", :with => 100
        fill_in "deposit_tracker_backwork", :with => 100
        fill_in "deposit_tracker_consulting", :with => 100
        fill_in "deposit_tracker_other1", :with => 100
        fill_in "deposit_tracker_other2", :with => 100
        fill_in "deposit_tracker_payroll", :with => 100
        fill_in "deposit_tracker_setup", :with => 100
        fill_in "deposit_tracker_tax_prep", :with => 300
        click_button("Save")
        expect(page).to have_content("Entry saved successfully!")

      end

    it "Navigates to new deposit entry and fills in another deposit" do 
        create_logged_in_user
        visit 'deposit_trackers/new'
        fill_in "deposit_tracker_total_deposit", :with => 1000
        fill_in "deposit_tracker_accounting", :with => 100
        fill_in "deposit_tracker_backwork", :with => 100
        fill_in "deposit_tracker_consulting", :with => 100
        fill_in "deposit_tracker_other1", :with => 100
        fill_in "deposit_tracker_other2", :with => 100
        fill_in "deposit_tracker_payroll", :with => 100
        fill_in "deposit_tracker_setup", :with => 100
        fill_in "deposit_tracker_tax_prep", :with => 300
        click_button("Save")
        expect(page).to have_content("Entry saved successfully!")

      end




      it "Navigates to new deposit entry and fills in wrong elements" do 
        create_logged_in_user
        visit 'deposit_trackers/new'
        fill_in "deposit_tracker_total_deposit", :with => 1000
        fill_in "deposit_tracker_accounting", :with => 100
        fill_in "deposit_tracker_backwork", :with => 100
        fill_in "deposit_tracker_consulting", :with => 100
        fill_in "deposit_tracker_other1", :with => 100
        fill_in "deposit_tracker_other2", :with => 100
        fill_in "deposit_tracker_payroll", :with => 100
        fill_in "deposit_tracker_setup", :with => 100
        fill_in "deposit_tracker_tax_prep", :with => 100
        click_button("Save")
        expect(page).to have_content("The sum of the deposit breakdown should match the deposit total")

      end      


    end

    context "Remittance Page" do 
      it "Navigate to index and check for elements" do 
        create_logged_in_user
        visit '/remittances'
        expect(page).to have_button ("New Royalty Entry")
        expect(page).to have_content("Pending Royalties")
        expect(page).to have_content("Posted Royalties")
      end

      it "Navigate to new remittance and check for elements" do 
        create_logged_in_user
        visit '/remittances/new'
        expect(page).to have_button "Save and Post"
        expect(page).to have_button "Save for Later"
        expect(page).to have_link "Discard"
      end


      it "Navigates to new remittance and previously entered deposits should pre-fill the info" do
        create_logged_in_user
        @deposit1 = FactoryGirl.create(:deposit_tracker, fran: 1, id: 2)
        visit '/remittances/new'
        expect(find_field('remittance_tax_prep').value).to eq ("300.00")

      end


      it "Navigates to new remittance and fills in elements and submit" do 
        create_logged_in_user
        visit '/remittances/new'
        fill_in "remittance_accounting", :with => 100
        fill_in "remittance_backwork", :with => 200
        fill_in "remittance_consulting", :with => 200
        fill_in "remittance_non_subject", :with => 200
        fill_in "remittance_other1", :with => 200
        fill_in "remittance_other2", :with => 200
        fill_in "remittance_royalty", :with => 1000
        click_button("Save for Later")
        expect(page).to have_content ("Entry saved successfully!")
      end

      it "Navigates to new remittance and fills in elements and duplicate credits" do 
        create_logged_in_user
        FactoryGirl.create(:credit)
        FactoryGirl.create(:credit, id: 2 , credit_description: 'Prior Year Rebate')
        FactoryGirl.create(:credit, id: 3 , credit_description: 'SPS Credit')
        FactoryGirl.create(:credit, id: 4 , credit_description: 'Payroll Credit')
        FactoryGirl.create(:credit, id: 0 , credit_description: '')
        FactoryGirl.create(:credit, id: 99 , credit_description: 'Payment')
        visit '/remittances/new'
        fill_in "remittance_accounting", :with => 100
        fill_in "remittance_backwork", :with => 200
        fill_in "remittance_consulting", :with => 200
        fill_in "remittance_non_subject", :with => 200
        fill_in "remittance_other1", :with => 200
        fill_in "remittance_other2", :with => 200
        fill_in "remittance_royalty", :with => 1000
        page.select("Prior Year Rebate", :from => "remittance_credit1_desc")
        page.select("Prior Year Rebate", :from => "remittance_credit2_desc")
                        
        fill_in "remittance_credit1", :with => 100
        fill_in "remittance_credit2", :with => 200
        click_button("Save for Later")
        expect(page).to have_content ("The same credit cannot be used multiple times")

      end

      it "Navigates to new remittance and submit and post without checkbox" do 
        create_logged_in_user
        visit '/remittances/new'
        fill_in "remittance_accounting", :with => 100
        fill_in "remittance_backwork", :with => 200
        fill_in "remittance_consulting", :with => 200
        fill_in "remittance_non_subject", :with => 200
        fill_in "remittance_other1", :with => 200
        fill_in "remittance_other2", :with => 200
        fill_in "remittance_royalty", :with => 1000
        click_button("Save and Post")
        expect(page).to have_content ("Please check the confirmation checkbox")
        
      end

      it "Navigates to new remittance and submit and post with checkbox" do 
        create_logged_in_user
        visit '/remittances/new'
        fill_in "remittance_accounting", :with => 100
        fill_in "remittance_backwork", :with => 200
        fill_in "remittance_consulting", :with => 200
        fill_in "remittance_non_subject", :with => 200
        fill_in "remittance_other1", :with => 200
        fill_in "remittance_other2", :with => 200
        fill_in "remittance_royalty", :with => 1000
        check 'remittance_accept_flag'
        click_button("Save and Post")
        expect(page).to have_content ("Entry saved successfully!")
        
      end



    end

    context "Credit Cards Page" do 
      it "Navigates to index and check for elements" do 
        create_logged_in_user
        visit '/credit_cards'
        expect(page).to have_button("Add New Credit Card")
        
      end

      it "Navigates to new credit card and checks for elements" do 
        create_logged_in_user
        visit '/credit_cards/new'
        expect(page).to have_button("Save")
        expect(page).to have_link "Discard"
      end

      it "Navigates to new credit card and fills Visa and submit" do 
        create_logged_in_user
        visit 'credit_cards/new'
        page.select("Visa", :from => "credit_card_cc_type")
        
        fill_in "credit_card_cc_number", :with => "4111111111111111"
        page.select("06", :from => "credit_card_cc_exp_month")
        page.select("16", :from => "credit_card_cc_exp_year")
        
        fill_in "credit_card_cc_name", :with => "Daniel Grenier"
        
        click_button("Save")
        #pp page.body
        expect(page).to have_content("Credit Card Registered Successfully")

      end

      it "Navigates to new credit card entry and fills in MasterCard" do 
        create_logged_in_user
        visit 'credit_cards/new'
        page.select("Master Card", :from => "credit_card_cc_type")
        fill_in "credit_card_cc_number", :with => "5105105105105100"
        page.select("06", :from => "credit_card_cc_exp_month")
        page.select("16", :from => "credit_card_cc_exp_year")
        
        fill_in "credit_card_cc_name", :with => "Daniel Grenier"
        
        click_button("Save")
        expect(page).to have_content("Credit Card Registered Successfully")


      end



      it "Navigates to new credit card and provide a wrong cc number" do 
        create_logged_in_user
         visit 'credit_cards/new'
        page.select("Master Card", :from => "credit_card_cc_type")
        fill_in "credit_card_cc_number", :with => "1234567890123456"
        page.select("06", :from => "credit_card_cc_exp_month")
        page.select("16", :from => "credit_card_cc_exp_year")
        
        fill_in "credit_card_cc_name", :with => "Daniel Grenier"
        
        click_button("Save")
        expect(page).to have_content("Error: Invalid account number")

      end      

      it "Creates a new card, edits it and make sure the data changed" do
        create_logged_in_user
        visit 'credit_cards/new'
        page.select("Visa", :from => "credit_card_cc_type")
        fill_in "credit_card_cc_number", :with => "4111111111111111"
        page.select("06", :from => "credit_card_cc_exp_month")
        page.select("16", :from => "credit_card_cc_exp_year")
        fill_in "credit_card_cc_name", :with => "Daniel Grenier"
        click_button("Save")
        find('tr',text:'XXXXXXXXXXXX1111').click_link("edit")
        
        fill_in "credit_card_cc_number", :with => "4111111111111111"
        page.select("10", :from => "credit_card_cc_exp_month")
        click_button("Save")
        expect(page).to have_content("10 / 16")

      end
    end

    context "Bank Accounts Page" do 
      it "Navigates to index and check for elements" do 
        create_logged_in_user
        visit '/bank_accounts'
        expect(page).to have_button("Add New Bank Account")
        
      end

       it "Navigates to new bank account and checks for elements" do 
        create_logged_in_user
        visit '/bank_accounts/new'
        expect(page).to have_button("Save")
        expect(page).to have_link "Discard"
      end

      it "Navigates to new bank account and fills National Bank Georgia and submit" do 
        create_logged_in_user
        visit 'bank_accounts/new'
        page.select("Checking", :from => "bank_account_bank_account_type")
        
        fill_in "bank_account_bank_routing", :with => "061119888"
        fill_in "bank_account_bank_account", :with => "12345678"
        
        fill_in "bank_account_bank_account_name", :with => "Daniel Grenier"
        
        click_button("Save")
        #pp page.body
        expect(page).to have_content("Bank Account Registered Successfully")

      end


      it "Navigates to new bank account and fills in Bank of America" do 
        create_logged_in_user
        visit 'bank_accounts/new'
        page.select("Checking", :from => "bank_account_bank_account_type")
        
        fill_in "bank_account_bank_routing", :with => "061000052"
        fill_in "bank_account_bank_account", :with => "87654321"
        
        fill_in "bank_account_bank_account_name", :with => "Daniel Grenier"
        
        click_button("Save")
        #pp page.body
        expect(page).to have_content("Bank Account Registered Successfully")


      end



      it "Navigates to new bank account and provide wrong routing number" do 
        create_logged_in_user
         visit 'bank_accounts/new'
        page.select("Checking", :from => "bank_account_bank_account_type")
        
        fill_in "bank_account_bank_routing", :with => "061000051"
        fill_in "bank_account_bank_account", :with => "87654321"
        
        fill_in "bank_account_bank_account_name", :with => "Daniel Grenier"
        
        click_button("Save")
        #pp page.body
        expect(page).to have_content("Error: Invalid routing number")

      end      

      it "Creates a new card, edits it and make sure the data changed" do
        create_logged_in_user
        visit 'bank_accounts/new'
        page.select("Checking", :from => "bank_account_bank_account_type")
        
        fill_in "bank_account_bank_routing", :with => "061092387"
        fill_in "bank_account_bank_account", :with => "55555555"
        
        fill_in "bank_account_bank_account_name", :with => "Daniel Grenier"
        
        click_button("Save")
        find('tr',text:'5555').click_link("edit")
        
        fill_in "bank_account_bank_account", :with => "666666666"
        click_button("Save")
        expect(page).to have_content("6666")

      end



    end    

  end

end
