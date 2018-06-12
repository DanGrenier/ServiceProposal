require 'spec_helper'
require 'pp'

describe CreditCardsController do 


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
    	  post :create, credit_card: FactoryGirl.attributes_for(:credit_card)
    	  expect(response).to redirect_to (new_user_session_path)	
         end
     end

    describe "POST Destroy"  do 
    	it "Should redirect to sign in" do 
    		@card = FactoryGirl.create(:credit_card)
    	  delete :destroy, id: @card	
    	  expect(response).to redirect_to (new_user_session_path)

    	end
    end

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@card = FactoryGirl.create(:credit_card)
    		put :update, id: @card , credit_card: FactoryGirl.attributes_for(:credit_card)
    		expect(response).to redirect_to (new_user_session_path)
    	end
    end
  end

  describe 'Signed In' do 
    login_user
  
    #pp subject.current_user.franchise_id
    
    it "Should have a franchise_id of 1" do 
    	expect(subject.current_user.franchise_id).to eq(1)
    end
   
    describe 'GET INDEX' do 
   	  before :each do

        #Create 2 franchises
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        #Create 5 cards. 3 for Franchise 1, 2 for Franchise 2
	      @card1 = FactoryGirl.create(:credit_card)
        @card2 = FactoryGirl.create(:credit_card, cc_number: "5105105105105100", cc_type: 'M')
        @card3 = FactoryGirl.create(:credit_card, cc_number: "371449635398431", cc_type: 'A')
        @card4 = FactoryGirl.create(:credit_card, fran: 2, franchise_id: 2) 
        @card5 = FactoryGirl.create(:credit_card, fran: 2, franchise_id: 2 ,  cc_number: "5105105105105100", cc_type: 'M')
        get :index
      end
  	   
  	  context "Show current cards" do  	
  	    it "Populates the proper array of cards" do 
  	       expect(assigns(:cards)).to eq([@card1, @card2 , @card3])
        end

        it "Should not populate array of cards with card4 from franchise 2 " do 
          expect(assigns(:cards)).to_not include(@card4)
        end
      end
      
      
      context "Rendering" do 
        it "Should render the index page" do 
          expect(response).to render_template :index
        end
      end

    end


    describe 'GET new' do 
      before :each do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end
      context "New" do
        it "Should assign a new card variable" do 
        
          get :new
          expect(assigns(:card)).to_not eq(nil)
        end

        it "Should render the new page" do 
        
          get :new 
          expect(response).to render_template :new
        end
      end
       
    end


    describe 'Testing POST create methods' do 
      before :each do 
        
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "With valid attributes" do 
        it "Creates a new card" do
          expect{
          post :create, credit_card: FactoryGirl.attributes_for(:credit_card)}.to change(CreditCard,:count).by(1)
          
        end

        
        it "Should redirect to index" do 
         post :create, credit_card: FactoryGirl.attributes_for(:credit_card)
         expect(response).to redirect_to credit_cards_path    
        end
      end

      context "With invalid attributes" do
        it "Does not create a new card" do 
          expect{
          post :create, credit_card: FactoryGirl.attributes_for(:invalid_gms_credit_card) }.to_not change(Remittance,:count)
          
        end

        it "Should re-render the new template" do 
          post :create, credit_card: FactoryGirl.attributes_for(:invalid_gms_credit_card) 
          expect(response).to render_template :new
        end
      end
    end

    describe 'Testing PUT update methods' do
      before :each do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @card = FactoryGirl.create(:credit_card) 
        @token = @card.gms_card_token
      end
      context "With valid attributes" do 
        it "Locates and populates the requested @card" do 
          get :edit , id: @card
          put :update, id: @card , credit_card: FactoryGirl.attributes_for(:credit_card) 
          expect(assigns(:card)).to eq(@card)
        end

        it "Changes the card attributes" do 
          get :edit, id:@card
          put :update, id: @card , credit_card: FactoryGirl.attributes_for(:credit_card, cc_exp_month: "10" , cc_exp_year: "17", cc_number: "4111111111111111", gms_card_token: @token)
         
          @card.reload
          expect(@card.card_exp_month).to eq(10)
        end

        it "Redirects to the index page" do 
          put :update, id: @card , credit_card: FactoryGirl.attributes_for(:credit_card)
          expect(response).to redirect_to credit_cards_path
        end
      end

      context "With invalid attributes" do 
        it "Locates the requested card" do 
          put :update , id: @card, credit_card: FactoryGirl.attributes_for(:invalid_gms_credit_card)
          expect(assigns(:card)).to eq(@card)
        end

        it "Does not change card attributes" do 
          put :update , id: @card, credit_card: FactoryGirl.attributes_for(:invalid_gms_credit_card, cc_exp_month: "10" , cc_exp_year: "17",cc_number: "4123456789012345")
          @card.reload
          expect(@card.cc_exp_month).to_not eq("10")
        end

        it "Re-renders the edit method" do 
          put :update , id: @card, credit_card: FactoryGirl.attributes_for(:invalid_gms_credit_card)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Testing DELETE destroy method' do 
      before :each do 
        @card = FactoryGirl.create(:credit_card)
      end

      it "Deletes the card" do 
        expect{
          delete :destroy, id: @card  
        }.to change(CreditCard,:count).by(-1)   
      end

      it "Redirects to index page" do 
        delete :destroy, id: @card
        expect(response).to redirect_to credit_cards_path
      end

    end

  end


  describe "Testing attempted forgery" do 
    login_user

    before :each do
      @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
      @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      @credit1 = FactoryGirl.create(:credit_card, id: 1 )
      @credit2 = FactoryGirl.create(:credit_card_mc, id: 2)
      @token1 = @credit1.gms_card_token
      @token2 = @credit2.gms_card_token

    end

    context "Edit Credit Card From Another User " do 
      
      it "should redirect to root" do 
        get :edit, id: @credit2
        expect(response).to redirect_to root_path
      end
    end
  

    context 'Update Credit Card from another user' do 
      

      it "Should redirect to root" do 
        put :update , id: @credit2, credit_card: FactoryGirl.attributes_for(:credit_card_mc, franchise_id: 2), submit: 'Save'
        expect(response).to  redirect_to root_path
      end

      it "Should process the update from the same user though" do 
          put :update, id: @credit1 , credit_card: FactoryGirl.attributes_for(:credit_card, cc_number: "4111111111111111" , cc_exp_month: "09" , cc_exp_year: "17",gms_card_token: @token1) , submit: 'Save'
          expect(response).to redirect_to credit_cards_path

      end
    end

  end
 


end

	