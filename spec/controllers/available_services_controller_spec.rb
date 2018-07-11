require 'spec_helper'
require 'pp'

describe AvailableServicesController do 
  render_views


  describe "Not Signed In" do 

    describe "GET Index" do 
      it "Should redirect to sign in" do 
        get :index 
        expect(response).to redirect_to (new_user_session_path)
      end
    end

    describe "GET New" do 
      it "Should redirect to sign in" do 
        get :new 
        expect(response).to redirect_to (new_user_session_path)
      end
    end

    describe "POST create" do 
      it "Should redirect to sign in" do 
        
        post :create , available_service: FactoryBot.attributes_for(:available_service)
        expect(response).to redirect_to (new_user_session_path)
      end
    end

    describe "GET Edit" do 
      it "Should redirect to sign in" do 
      	get :edit, {:id => 1}
      	expect(response).to redirect_to (new_user_session_path)
      end
    end

    

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@service = FactoryBot.create(:available_service)
    		put :update, id: @service , available_service: FactoryBot.attributes_for(:available_service)
    		expect(response).to redirect_to (new_user_session_path)
    	end
    end
  end

  describe 'Signed In' do 
    login_user

    
    it "Should have a user_id of 1" do 
    	expect(subject.current_user.id).to eq(1)
    end
    
    describe 'GET Index' do 
      before :each do 
        @service = FactoryBot.create(:available_service)
      end
      
      it "Should assign the templates variable" do
        get :index
        expect(assigns(:services)).to_not eq(nil)
      end
      #If the db seed works, it loads 24 standard services, plus the one we just created
      it "Should have 25 services" do
        get :index 
        expect(assigns(:services).count).to eq(25)
      end

    end

    describe 'GET new' do 
      before :each do 
        @service = FactoryBot.create(:available_service)
      end

      it "Should assign a new proposal template variable" do 
        get :new
        expect(assigns(:service)).to_not eq(nil)
      end

      it "Should assign the current user id to the new service" do 
        get :new
        expect(assigns(:service).user_id).to eq(subject.current_user.id)
      end


      it "Should render the new template" do 
        get :new 
        expect(response).to render_template :new
      end

    end

    describe 'Testing POST create methods' do 
      
      context "With valid attributes" do 
        it "Creates a new service" do 
          expect{
            post :create, available_service: FactoryBot.attributes_for(:available_service)}.to change(AvailableService, :count).by(1)
        end          

        it "Should also redirect to index" do  
         post :create, available_service: FactoryBot.attributes_for(:available_service)
         expect(response).to redirect_to available_services_path
        end
      end

      context "With Invalid Attributes" do 
        it "Does not create a new service" do 
          expect{
            post :create, available_service: FactoryBot.attributes_for(:available_service, service_type: nil)}.to_not change(AvailableService, :count)
        end

        it "Should re-render the new service" do 
          post :create, available_service: FactoryBot.attributes_for(:available_service, service_type: nil)
          expect(response).to render_template :new
        end
      end
    end
    

    describe 'GET edit' do 
      before :each do 
        @service = FactoryBot.create(:available_service)
      end

      context "Edit" do
        it "Should fetch and get proper proposal setting" do 
        
          get :edit, {id: @service.id}
          expect(assigns(:service)).to_not eq(nil)
          
        end

        it "Should render the edit page" do 
        
          get :edit , {id: @service.id}
          expect(response).to render_template(:edit)
        end
      end
       
    end
    

    describe 'Testing PUT update methods' do
      before :each do 
         @service = FactoryBot.create(:available_service)
      end

      context "With valid attributes" do 
        it "Locates and populates the requested @service" do 
          put :update, id: @service.id , available_service: FactoryBot.attributes_for(:available_service)
          expect(assigns(:service)).to eq(@service)
        end

        it "Changes the template attributes" do 
          put :update, id: @service.id , available_service: FactoryBot.attributes_for(:available_service, service_description: "Modified Description")
          @service.reload
          expect(@service.service_description).to eq("Modified Description")
        end

        it "Redirects to the index page" do 
          put :update, id: @service.id , available_service: FactoryBot.attributes_for(:available_service)
          expect(response).to redirect_to available_services_path
        end
      end

      context "With invalid attributes" do 
       

        it "Does not change template attributes" do 
          put :update , id: @service, available_service: FactoryBot.attributes_for(:available_service, service_description: nil, service_type: 2)
          @service.reload
          expect(@service.service_type).to_not eq(2)
        end

        it "Re-renders the edit action" do 
          put :update , id: @service, available_service: FactoryBot.attributes_for(:available_service, service_description: nil, service_type: 1 )
          expect(response).to render_template :edit
        end
      end
    end

     describe 'Destroying an Available Service' do 
      before :each do 
         @service = FactoryBot.create(:available_service)
      end

      it "Should alter the number of AvailableService by -1" do 
        expect{delete :destroy, id: @service}.to change(AvailableService, :count).by(-1)
      end
    end

  end

  describe "Testing attempted forgery" do 
    login_user

    before do
     @service = FactoryBot.create(:available_service, user_id: 1)
     @service2 = FactoryBot.create(:available_service, user_id: 2)
    end

    context "Edit settings from another user " do 
      it "should redirect to root" do 
        get :edit, id: @service2
        expect(response).to redirect_to root_path
      end
    end

    context 'Update settings from another user' do 
      
      it "Should redirect to root" do 
        put :update , id: @service2, available_service: FactoryBot.attributes_for(:available_service, service_description: "blablabla")
        expect(response).to  redirect_to root_path
      end
      
    end

    context 'Trying to edit a standard code' do 
      it "Should redirect to root" do 
        @customSrv = AvailableService.first
        get :edit, {id: @customSrv.id}
        expect(response).to redirect_to root_path
      end
    end

  end  

  end




	