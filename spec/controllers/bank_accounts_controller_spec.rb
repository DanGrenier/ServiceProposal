require 'spec_helper'
require 'pp'

describe BankAccountsController do 

  #Test that if a user is not signed in, they cannot access any route
  describe "Not Signed In" do 

    describe "GET Index" do 
      it "Should redirect to sign in" do 
        get :index 
        expect(response).to redirect_to (new_user_session_path) 
      end
    end

    describe "GET new" do  
      it "Should redirect to sign in" do
        get :new
        expect(response).to redirect_to (new_user_session_path) 
      end
    end


    describe "GET Edit" do 
      it "Should redirect to sign in" do 
        get :edit, {:id => 1}
        expect(response).to redirect_to (new_user_session_path)
      end
    end

    describe "POST Create" do 
      it "Should redirect to sign in" do 
        post :create, bank_account: FactoryGirl.attributes_for(:bank_account)
        expect(response).to redirect_to (new_user_session_path) 
      end
    end

    describe "POST Destroy"  do 
      it "Should redirect to sign in" do 
        @bank = FactoryGirl.create(:bank_account)
        delete :destroy, id: @bank
        expect(response).to redirect_to (new_user_session_path)
      end
    end

    describe "POST Update" do 
      it "Should redirect to sign in" do 
        @bank = FactoryGirl.create(:bank_account)
        put :update, id: @bank , bank_account: FactoryGirl.attributes_for(:bank_account)
        expect(response).to redirect_to (new_user_session_path)
      end
    end
  end

  #Test behavior of a signed in user
  describe 'Signed In' do 
    #Login the default user with franchise ID 1
    login_user
  
    #Once logged in, the current user should have a franchise id of 1
    it "Should have a franchise_id of 1" do 
      expect(subject.current_user.franchise_id).to eq(1)
    end
   
    describe 'GET INDEX' do 
      before do
        #Create 2 Franchises
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 


        #Create 3 bank accounts. 2 for Franchise 1, 1 for Franchise 2
        @bank1 = FactoryGirl.create(:bank_account)
        @bank2 = FactoryGirl.create(:bank_account_boa)
        @bank3 = FactoryGirl.create(:bank_account_boa2)
        
        #Go to the Bank Account Index Page
        get :index
      end
       
      context "Show current Bank Accounts" do
        #Based on the above, 2 bank accounts should be populated
        it "Populates the proper array of bank accounts" do 
           expect(assigns(:banks)).to eq([@bank1, @bank2])
        end

        it "Should not populate array of accounts with bank3 from franchise 2 " do 
          #Based on the above, Bank account 3 should not be part of banks
          #because it belongs to franchise 2
          expect(assigns(:banks)).to_not include(@bank3)
        end
      end
      
      
      context "Rendering" do 
        it "Should render the index page" do 
          expect(response).to render_template :index
        end
      end
    end

    #Testing the new route
    describe 'GET new' do 
      before  do 
        #Create 2 franchises first
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end
      context "New" do
        it "Should assign a new bank account variable" do 
          #Should create a new blank bank account variable
          get :new
          expect(assigns(:bank)).to_not eq(nil)
        end

        it "Should render the new page" do 
          #Should render the new form
          get :new 
          expect(response).to render_template :new
        end
      end
    end


    describe 'Testing POST create methods' do 
      before  do 
        #Create 2 franchises first
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "With valid attributes" do 
        it "Creates a bank account" do
          #Create a bank account with valid form attributes
          #Should change the BankAccount table count by 1
          expect{
          post :create, bank_account: FactoryGirl.attributes_for(:bank_account_form)}.to change(BankAccount,:count).by(1)
        end

        it "Should redirect to index" do 
          #Should be redirected to index once this is done
          post :create, bank_account: FactoryGirl.attributes_for(:bank_account_form)
          expect(response).to redirect_to bank_accounts_path    
        end
      end

      context "With invalid attributes" do
        it "Does not create a new bank account" do 
          #If you create a bank account with invalid attributes
          #such as an invalid routing number
          #It should not change the count of BankAccount table
          expect{
          post :create, bank_account: FactoryGirl.attributes_for(:invalid_gms_routing) }.to_not change(BankAccount,:count)
        end

        it "Should re-render the new template" do 
          #Render the new template again (with errors)
          post :create, bank_account: FactoryGirl.attributes_for(:invalid_gms_routing) 
          expect(response).to render_template :new
        end
      end
    end

    describe 'Testing PUT update methods' do
      before  do 
        #Create 2 franchises 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        #Create 3 bank accounts for the tests and store the tokens
        @bank1 = FactoryGirl.create(:bank_account)
        @token1 = @bank1.gms_bank_token
        @bank2 = FactoryGirl.create(:bank_account_boa)
        @token2 =@bank2.gms_bank_token
        @bank3 = FactoryGirl.create(:bank_account_boa2)
        @token3 = @bank3.gms_bank_token
      end
      
      context "With valid attributes" do 
        it "Locates and populates the requested @bank" do 
          #When edit route is invoked with 1st bank account, make sure it finds it
          get :edit , id: @bank1
          put :update, id: @bank1 , bank_account: FactoryGirl.attributes_for(:bank_account) 
          expect(assigns(:bank)).to eq(@bank1)
        end

        it "Changes the Bank Account attributes" do 
          #When changes are made, make sure they are reflected
          get :edit, id:@bank1
          #Change the bank account
          put :update, id: @bank1 , bank_account: FactoryGirl.attributes_for(:bank_account, bank_account: "666666", gms_bank_token: @token1)
          #Reload the bank account info from the database
          @bank1.reload
          #make sure the bank account change is done
          expect(@bank1.last_four).to eq("6666")
        end

        it "Redirects to the index page" do 
          put :update, id: @bank1 , bank_account: FactoryGirl.attributes_for(:bank_account, bank_account: "666666", gms_bank_token: @token1)
          expect(response).to redirect_to bank_accounts_path
        end
      end

      context "With invalid attributes" do 
        it "Locates the requested Bank Account" do 
          #Locates the proper card to be changed
          put :update , id: @bank1, bank_account: FactoryGirl.attributes_for(:invalid_gms_routing, bank_account: "666666")
          expect(assigns(:bank)).to eq(@bank1)
        end

        it "Does not change Bank attributes" do 
          #Changes the bank attributes with invalid information
          put :update , id: @bank1, bank_account: FactoryGirl.attributes_for(:invalid_gms_routing, bank_account: "666666")
          @bank1.reload
          expect(@bank1.last_four).to_not eq("6666")
        end

        it "Re-renders the edit method" do 
          #Shows the edit form again, with errors
          put :update , id: @bank1, bank_account: FactoryGirl.attributes_for(:invalid_gms_credit_card, bank_account: "666666")
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Testing DELETE destroy method' do 
      
      before :each do 
        @bank = FactoryGirl.create(:bank_account)
      end

      it "Deletes the bank account" do 
        #Make sure delete action changes the count by -1
        expect{delete :destroy, id: @bank}.to change(BankAccount,:count).by(-1)   
      end

      it "Redirects to index page" do 
        #Make sure delete brings you back to index page
        delete :destroy, id: @bank
        expect(response).to redirect_to bank_accounts_path
      end
    end
  end


  describe "Testing attempted forgery" do 
    #Login with user franchise ID 1
    login_user
    before do
      #Create 2 franchises
      @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
      @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      #Create 3 bank accounts with tokens
      @bank1 = FactoryGirl.create(:bank_account)
      @token1 = @bank1.gms_bank_token
      @bank2 = FactoryGirl.create(:bank_account_boa)
      @token2 =@bank2.gms_bank_token
      @bank3 = FactoryGirl.create(:bank_account_boa2)
      @token3 = @bank3.gms_bank_token
    end

    context "Edit Bank Account From Another User" do 
      

      it "should redirect to root" do 
        #Safeguards should redirect to root when another user
        #tries to enter the url of a bank account that belongs to another user
        get :edit, id: @bank3
        expect(response).to redirect_to root_path
      end
    end

    context 'Update Bank Account from another user' do 
     

      it "Should redirect to root" do 
        put :update , id: @bank3, bank_account: FactoryGirl.attributes_for(:bank_account_boa2, franchise_id: 2), submit: 'Save'
        expect(response).to  redirect_to root_path
      end

      it "Should process the update from the same user though" do 
          put :update, id: @bank2 , bank_account: FactoryGirl.attributes_for(:bank_account_boa, bank_account: "55698744" , gms_bank_token: @token2) , submit: 'Save'
          expect(response).to redirect_to bank_accounts_path
      end
    end
  end
end

  