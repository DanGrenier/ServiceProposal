require 'spec_helper'
require 'pp'

describe CardPaymentsController do 


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
    	it "Should reditect to sign in" do 
    	  post :create, card_payment: FactoryGirl.attributes_for(:card_payment)
    	  expect(response).to redirect_to (new_user_session_path)	
         end
     end

    describe "POST Destroy"  do 
    	it "Should redirect to sign in" do 
    		@card_payment = FactoryGirl.create(:card_payment)
    	  delete :destroy, id: @card_payment	
    	  expect(response).to redirect_to (new_user_session_path)

    	end
    end

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@card_payment = FactoryGirl.create(:card_payment)
    		put :update, id: @card_payment , card_payment: FactoryGirl.attributes_for(:card_payment)
    		expect(response).to redirect_to (new_user_session_path)
    	end
    end
  end

  describe 'Signed In' do 
    login_user
  
    
    
    it "Should have a franchise_id of 1" do 
    	expect(subject.current_user.franchise_id).to eq(1)
    end
   
    
    describe 'GET new' do 
      before do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end
      context "New" do
        it "Should assign a card payment variable" do 
        
          get :new
          expect(assigns(:card_payment)).to_not eq(nil)
        end

        it "Should render the new page" do 
        
          get :new 
          expect(response).to render_template :new
        end
      end
       
    end


    describe 'Testing POST create methods' do 
      before do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2)
        @card1 = FactoryGirl.create(:credit_card) 
      end

      context "With valid attributes" do 
        it "Creates a new card payment" do
          
          expect{
           
          post :create, card_payment: FactoryGirl.attributes_for(:card_payment_form, token: @card1.gms_card_token)}.to change(CardPayment,:count).by(1)
          
        end

        it "Should redirect to index" do 
         post :create, card_payment: FactoryGirl.attributes_for(:card_payment_form, token: @card1.gms_card_token) 
         expect(response).to redirect_to payments_path    
        end
      end

      context "With invalid attributes" do
        it "Does not create a new card payment" do 
          expect{
          post :create, card_payment: FactoryGirl.attributes_for(:invalid_card_payment_form, token: @card1.gms_card_token)}.to_not change(CardPayment,:count)
          
        end

        it "Should re-render the new template" do 
          post :create, card_payment: FactoryGirl.attributes_for(:invalid_card_payment_form, token: @card1.gms_card_token)
          expect(response).to render_template :new
        end
      end
    end

    

    describe 'Testing DELETE destroy method' do 
      before :each do 
        
        @payment = FactoryGirl.create(:card_payment)
      end

      it "Deletes the card payment" do 
        expect{
          delete :destroy, id: @payment  
        }.to change(CardPayment,:count).by(-1)   
      end

      it "Redirects to index page" do 
        delete :destroy, id: @payment 
        expect(response).to redirect_to payments_path
      end

    end

  end

  

  

  end




	