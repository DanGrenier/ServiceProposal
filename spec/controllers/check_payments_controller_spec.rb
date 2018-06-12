require 'spec_helper'
require 'pp'

describe CheckPaymentsController do 


  describe "Not signed in" do 

    before do 
       @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end


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
    	  post :create, check_payment: FactoryGirl.attributes_for(:check_payment)
    	  expect(response).to redirect_to (new_user_session_path)	
         end
     end

    describe "POST Destroy"  do 
    	it "Should redirect to sign in" do 
    		@check_payment = FactoryGirl.create(:check_payment)
    	  delete :destroy, id: @check_payment	
    	  expect(response).to redirect_to (new_user_session_path)

    	end
    end

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@check_payment = FactoryGirl.create(:check_payment)
    		put :update, id: @check_payment , check_payment: FactoryGirl.attributes_for(:check_payment)
    		expect(response).to redirect_to (new_user_session_path)
    	end
    end
  end

  describe 'Signed In' do 
    login_user
  
    
    
    it "Should have a franchise_id of 1" do 
    	expect(subject.current_user.franchise_id).to eq(1)
    end
   

    describe 'GET index' do
      before do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      it "Should redirect to root because user is not admin" do
        get :index
        expect(response).to redirect_to (root_path) 
      end
    end  

    
    describe 'GET new' do 
      before do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end
      context "New" do
        it "Should assign a check payment variable" do 
        
          get :new
          expect(assigns(:check_payment)).to_not eq(nil)
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
        
      end

      context "With valid attributes" do 
        it "Creates a new check payment" do
          expect{
           
          post :create, check_payment: FactoryGirl.attributes_for(:check_payment)}.to change(CheckPayment,:count).by(1)
          
        end

        it "Should redirect to index" do 
         post :create, check_payment: FactoryGirl.attributes_for(:check_payment) 
         expect(response).to redirect_to payments_path    
        end
      end

      context "With invalid attributes" do
        it "Does not create a new check payment" do 
          expect{
          post :create, check_payment: FactoryGirl.attributes_for(:invalid_check_payment)}.to_not change(CheckPayment,:count)
          
        end

        it "Should re-render the new template" do 
          post :create, check_payment: FactoryGirl.attributes_for(:invalid_check_payment)
          expect(response).to render_template :new
        end
      end
    end

    
    describe 'Testing PUT edit methods' do
      before do
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @payment = FactoryGirl.create(:check_payment)
      end

      context "With valid attributes" do 
        it "Locates and populates the requested check payment" do 
          put :update, id: @payment , check_payment: FactoryGirl.attributes_for(:check_payment)
          expect(assigns(:check_payment)).to eq(@payment)
        end

        it "Changes the check attributes" do 
          put :update, id: @payment , check_payment: FactoryGirl.attributes_for(:check_payment, amount: 400)
          @payment.reload
          expect(@payment.amount).to eq(400)
        end

        it "Redirects to the index page" do 
          put :update, id: @payment , check_payment: FactoryGirl.attributes_for(:check_payment)
          expect(response).to redirect_to payments_path
        end
      end
    end


    describe 'Testing DELETE destroy method' do 
      before :each do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      
        @payment = FactoryGirl.create(:check_payment)
      end

      it "Deletes the check payment" do 
        expect{
          delete :destroy, id: @payment  
        }.to change(CheckPayment,:count).by(-1)   
      end

      it "Redirects to index page" do 
        delete :destroy, id: @payment 
        expect(response).to redirect_to payments_path
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
      @check1 = FactoryGirl.create(:check_payment)
      @check2 = FactoryGirl.create(:check_payment, id:2, franchise_id: 2 , amount: 200 )
      
    end

    context "Edit check payment from another user" do 
     
      it "should redirect to root" do 
        #Safeguards should redirect to root when another user
        #tries to enter the url of a bank account that belongs to another user
        get :edit, id: @check2
        expect(response).to redirect_to root_path
      end
    end

    context 'Update check payment from another user' do 
     
      it "Should redirect to root" do 
        put :update , id: @check2, check_payment: FactoryGirl.attributes_for(:check_payment, franchise_id: 2), submit: 'Save'
        expect(response).to  redirect_to root_path
      end

      it "Should process the update from the same user though" do 
          put :update, id: @check1 , check_payment: FactoryGirl.attributes_for(:check_payment, amount: 400 ) , submit: 'Save'
          expect(response).to redirect_to payments_path
      end
    end
  end

  

  

  end




	