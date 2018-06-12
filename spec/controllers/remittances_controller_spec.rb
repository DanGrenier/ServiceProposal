require 'spec_helper'
require 'pp'

describe RemittancesController do 


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
    	  post :create, remittance: FactoryGirl.attributes_for(:remittance)
    	  expect(response).to redirect_to (new_user_session_path)	
         end
     end

    describe "POST Destroy"  do 
    	it "Should redirect to sign in" do 
    		@remit = FactoryGirl.create(:remittance)
    	  delete :destroy, id: @remit	
    	  expect(response).to redirect_to (new_user_session_path)

    	end
    end

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@remit = FactoryGirl.create(:remittance)
    		put :update, id: @remit , remittance: FactoryGirl.attributes_for(:remittance)
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

        #Here we are going to test the creation of a few deposits for franchise 1

        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
	      @remit1 = FactoryGirl.create(:remittance, fran: 1, month:1, id:1, posted: 1, accept_flag: 1)
        @remit2 = FactoryGirl.create(:remittance, fran: 1, month:2, id:2, posted: 1, accept_flag: 1)
        @remit3 = FactoryGirl.create(:remittance, fran: 1, month:3, id:3, posted: 1, accept_flag: 1)
        @remit4 = FactoryGirl.create(:remittance, fran: 1, month:4, id:4, posted: 0)
        @remit5 = FactoryGirl.create(:remittance, fran: 1, month:5, id:5, posted: 0)
        @remit6 = FactoryGirl.create(:remittance, fran: 1, month:6, id:6, posted: 0)
        @remit7 = FactoryGirl.create(:remittance, fran: 2, month:7, id:7, posted: 1,franchise_id: 2, accept_flag: 1)
        @remit8 = FactoryGirl.create(:remittance, fran: 2, month:8, id:8, posted: 0,franchise_id: 2)
        
        get :index
      end
  	   
  	  context "Pending" do  	
  	    it "Populates the proper array of pending remittances" do 
  	       expect(assigns(:pending)).to eq([@remit6, @remit5 , @remit4])
        end

        it "Should not populate array of pending remittances with fran2" do 
          expect(assigns(:pending)).to_not include(@remit8)
        end
      end
      
      context "Posted" do 
        it "Populates the proper array of posted remittances" do 
      	   expect(assigns(:recent)).to eq([@remit3, @remit2, @remit1])
        end

        it "Should not populate array of pending remittances with fran2" do 
           expect(assigns(:recent)).to_not include(@remit7)
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
        it "Should assign a new remittance variable" do 
        
          get :new
          expect(assigns(:remit)).to_not eq(nil)
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
        it "Creates a new remittance" do
          expect{
          post :create, remittance: FactoryGirl.attributes_for(:remittance) , submit: 'Save for Later'}.to change(Remittance,:count).by(1)
          
        end

        it "Does not create a new remittance because checkbox not checked" do 
          expect{
            post :create, remittance: FactoryGirl.attributes_for(:remittance) , submit: 'Save and Post'}.to_not change(Remittance, :count)
        end

        it "Creates the new remittance if posted and checkbox is checked" do 
        expect{
            post :create, remittance: FactoryGirl.attributes_for(:valid_confirmed_remittance) , submit: 'Save and Post'}.to change(Remittance, :count).by(1)
        end          

        it "Should redirect to index" do 
         post :create, remittance: FactoryGirl.attributes_for(:remittance) , submit: 'Save for Later'
         expect(response).to redirect_to remittances_path    
        end
      end

      context "With invalid attributes" do
        it "Does not create a new remittance" do 
          expect{
          post :create, remittance: FactoryGirl.attributes_for(:invalid_remittance) , submit: 'Save for Later'}.to_not change(Remittance,:count)
          
        end

        it "Should re-render the new template" do 
          post :create, remittance: FactoryGirl.attributes_for(:invalid_remittance) , submit: 'Save for Later'
          expect(response).to render_template :new
        end
      end


      context "With too high an amount of prior year rebate" do
        it "Does not create a new remittance" do 
          expect{
          post :create, remittance: FactoryGirl.attributes_for(:remittance, credit1_desc: 2, credit1: 5000) , submit: 'Save for Later'}.to_not change(Remittance,:count)
          
        end

        it "Should re-render the new template" do 
          post :create, remittance: FactoryGirl.attributes_for(:remittance, credit1_desc: 2, credit1: 5000) , submit: 'Save for Later'
          expect(response).to render_template :new
        end
      end
    end

    describe 'Testing PUT update methods' do
      before :each do 
         @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @remittance = FactoryGirl.create(:remittance, credit4_desc: "Testing") 
      end
      context "With valid attributes" do 
        it "Locates and populates the requested @remit" do 
          put :update, id: @remittance , remittance: FactoryGirl.attributes_for(:remittance) , submit: 'Save for Later'
          expect(assigns(:remit)).to eq(@remittance)
        end

        it "Changes the remittance attributes" do 
          put :update, id: @remittance , remittance: FactoryGirl.attributes_for(:remittance, credit4_desc: "Testing2") , submit: 'Save for Later'
          @remittance.reload
          expect(@remittance.credit4_desc).to eq("Testing2")
        end

        it "Redirects to the index page" do 
          put :update, id: @remittance , remittance: FactoryGirl.attributes_for(:remittance) , submit: 'Save for Later'
          expect(response).to redirect_to remittances_path
        end
      end

      context "With invalid attributes" do 
        it "Locates the requested remittance" do 
          put :update , id: @remittance, remittance: FactoryGirl.attributes_for(:invalid_remittance), submit: 'Save for Later'
          expect(assigns(:remit)).to eq(@remittance)
        end

        it "Does not change remittance attributes" do 
          put :update , id: @remittance, remittance: FactoryGirl.attributes_for(:invalid_remittance, credit4_desc: "Testing2"), submit: 'Save for Later'
          @remittance.reload
          expect(@remittance.credit4_desc).to_not eq("Testing2")
        end

        it "Re-renders the edit method" do 
          put :update , id: @remittance, remittance: FactoryGirl.attributes_for(:invalid_remittance), submit: 'Save for Later'
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Testing DELETE destroy method' do 
      before :each do 
        @remittance = FactoryGirl.create(:remittance)
      end

      it "Deletes the remittance" do 
        expect{
          delete :destroy, id: @remittance  
        }.to change(Remittance,:count).by(-1)   
      end

      it "Redirects to index page" do 
        delete :destroy, id: @remittance 
        expect(response).to redirect_to remittances_path 
      end

    end

  end

  describe "Testing attempted forgery" do 
    login_user

    before :each do
     @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      @remit2 = FactoryGirl.create(:remittance, fran: 1, month:2, id:2, posted: 1, accept_flag: 1)
      @remit3 = FactoryGirl.create(:remittance, fran: 1, month:3, id:3, posted: 1,accept_flag: 1)
      @remit4 = FactoryGirl.create(:remittance, fran: 1, month:4, id:4, posted: 0)
      @remit5 = FactoryGirl.create(:remittance, fran: 1, month:5, id:5, posted: 0)
      @remit6 = FactoryGirl.create(:remittance, fran: 1, month:6, id:6, posted: 0)
      @remit7 = FactoryGirl.create(:remittance, fran: 2, month:7, id:7, posted: 1, franchise_id:2,accept_flag: 1)
      @remit8 = FactoryGirl.create(:remittance, fran: 2, month:8, id:8, posted: 0, franchise_id:2)
    end

    context "Edit Remittance from another user " do 
      

      it "should redirect to root" do 
        get :edit, id: @remit8
        expect(response).to redirect_to root_path
      end
    end

    context 'Update Remittance from another user' do 
      

      it "Should redirect to root" do 
        put :update , id: @remit8, remittance: FactoryGirl.attributes_for(:remittance, franchise_id: 2), submit: 'Save for Later'
        expect(response).to  redirect_to root_path
      end

      it "Should process the update from the same user though" do 
          put :update, id: @remit4 , remittance: FactoryGirl.attributes_for(:remittance, month:4 ) , submit: 'Save for Later'
          expect(response).to redirect_to remittances_path

      end
    end

  end
 


end

	