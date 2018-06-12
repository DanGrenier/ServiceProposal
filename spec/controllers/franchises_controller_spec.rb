require 'spec_helper'
require 'pp'

describe FranchisesController do 
  
  describe "Not Signed In" do 

    it "Should not return a correct user" do 
      expect(subject.current_user).to eq(nil) 
    end

    describe "GET index view" do 
      it "Should not assign a franchise to instance var" do 
        get :index
        expect(assigns(:franchise)).to eq(nil)  
      end
        
      it "Should be redirected to sign_in page" do 
        get :index
        expect(response).to redirect_to (new_user_session_path) 
      end
    end
  end

  describe "With a regular user login" do 
    
    login_user
    
    describe 'INDEX' do
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "Get Index" do
        it "Should not assign a franchise to instance var" do 
          get :index
          expect(assigns(:franchises)).to eq(nil)  
        end
        
        it "Should be redirected to sign_in page" do 
          get :index
          expect(response).to redirect_to (root_path)
        end
      end
    end

    describe "New" do 

      context "Get New" do 
        it "should render the new template" do 
          get :new
          expect(response).to redirect_to (root_path)
        end

        it "should assign a new franchise var" do 
          get :new 
          expect(assigns(:franchise)).to eq(nil)
        end
      end
    end

      
    describe "Edit" do
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "Get Edit" do 
        it "Should assign a franchise var and auth_users var" do 
          get :edit, { :id => @fran1 }
          expect(assigns(:franchise)).not_to eq(nil)
          expect(assigns(:auth_users)).not_to eq(nil)
        end

        it "Should render the edit template" do
          get :edit, { :id => @fran1 } 
          expect(response).to render_template :edit
        end
      end

      context "Testing PUT update methods" do 
        it "Located and populates the requested franchise" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate: 8)
         expect(assigns(:franchise)).to eq(@fran1)
        end

        it "Changes the allowed franchise attribute" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate: 8)
          @fran1.reload
          expect(@fran1.advanced_rebate).to eq(8)
        end      

        it "Redirects to the root" do  
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate: 8)
          expect(response).to redirect_to (root_path)
        end
      

        it "Doest not change restricted attribute" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, home_address: "12345 some street")
          @fran1.reload
          expect(@fran1.home_address).to_not eq("12345 some street")
        end

        it "Does not change with invalid attribute" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate:  -1)
          @fran1.reload
          expect(@fran1.home_address).to_not eq(-1)
        end        

        it "Should re-render the edit action" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate:  -1)
          expect(response).to render_template :edit
        end        
      end
    end  




    describe 'Attempted Forgery' do 
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      it "should not allow to change another user profile" do
        get :edit, { :id => @fran2 } 
          expect(response).to redirect_to (root_path)
              end
    end

    describe 'Show' do 
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context 'Get Show' do
        it "should not allow to access the show action" do
          get :show, id: @fran1
          expect(response).to redirect_to (root_path)
        end
      end


    end


  end

  
  describe "With an admin user login" do 

    login_admin

    describe 'INDEX' do
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "Get Index" do
        it "Should assign a franchise to instance var" do 
          get :index
          expect(assigns(:franchises)).to_not eq(nil)
        end
        
        it "Should be redirected to franchises list" do 
          get :index
          expect(response).to render_template :index
        end
      end
    end

    describe 'NEW' do 



      context "Get New" do 
        it "should render the new template" do 
          get :new
          expect(response).to render_template :new
        end

        it "should assign a new franchise var" do 
          get :new 
          expect(assigns(:franchise)).not_to eq(nil)
        end
      end



    end

    describe 'Testing POST create methods' do 
      context "With valid attributes" do 
        it "Creates a new franchise" do
          expect{
          post :create, franchise: FactoryGirl.attributes_for(:franchise)}.to change(Franchise,:count).by(1)
          
        end

        

        it "Should redirect to index" do 
         post :create, franchise: FactoryGirl.attributes_for(:franchise) 
         expect(response).to redirect_to franchises_path    
        end
      end

      context "With Invalid attributes" do 
        it "Does Not Create a new franchise" do
          expect{
          post :create, franchise: FactoryGirl.attributes_for(:franchise, renew_date: nil)}.to change(Franchise,:count).by(0)
          
        end

        

        it "Should show the form again" do 
         post :create, franchise: FactoryGirl.attributes_for(:franchise, renew_date: nil) 
         expect(response).to render_template :new
        end
      end


    end
      
    describe "EDIT" do
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "Get Edit" do 
        it "Should assign a franchise var and auth_users var" do 
          get :edit, { :id => @fran1 }
          expect(assigns(:franchise)).not_to eq(nil)
          expect(assigns(:auth_users)).not_to eq(nil)
        end

        it "Should render the edit template" do
          get :edit, { :id => @fran1 } 
          expect(response).to render_template :edit
        end
      end

      context "Testing PUT update methods" do 
        it "Located and populates the requested franchise" do 
         put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate: 8)
         expect(assigns(:franchise)).to eq(@fran1)
        end

        it "Does change restricted attribute" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, home_address: "12345 some street")
          @fran1.reload
          expect(@fran1.home_address).to eq("12345 some street")
        end

        it "Does not change with invalid attribute" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate:  -1)
          @fran1.reload
          expect(@fran1.home_address).to_not eq(-1)
        end        

        it "Should re-render the edit action" do 
          put :update, id: @fran1, franchise: FactoryGirl.attributes_for(:franchise, advanced_rebate:  -1)
          expect(response).to render_template :edit
        end        
      end
    end  

    describe 'Show' do 
      before :each do
        #Here we are going to test the creation of a few deposits for franchise 1
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context 'Get Show' do
        it "should allow access the show action" do
          get :show, id: @fran1
          expect(response).to render_template :show
        end
      end


    end

end



  
	

end

