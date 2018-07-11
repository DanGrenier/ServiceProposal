require 'spec_helper'
require 'pp'

describe ProposalTemplatesController do 
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
        
        post :create , proposal_template: FactoryBot.attributes_for(:proposal_template)
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
    		@template = FactoryBot.create(:proposal_template)
    		put :update, id: @template , proposal_template: FactoryBot.attributes_for(:proposal_template)
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
        @template1 = FactoryBot.create(:proposal_template)
        @template2 = FactoryBot.create(:proposal_template, id: 2)
      end
      
      it "Should assign the templates variable" do
        get :index
        expect(assigns(:templates)).to_not eq(nil)
      end

      it "Should have 2 templates" do
        get :index 
        expect(assigns(:templates).count).to eq(2)
      end

      it "Should have exactly those 2 templates" do 
        get :index
        expect(assigns(:templates)).to eq([@template1, @template2])
      end


    end

    describe 'GET new' do 
      before :each do 
        @template1 = FactoryBot.create(:proposal_template)
      end

      it "Should assign a new proposal template variable" do 
        get :new
        expect(assigns(:template)).to_not eq(nil)
      end

      it "Should render the new template" do 
        get :new 
        expect(response).to render_template :new
      end

    end

    describe 'Testing POST create methods' do 
      
      context "With valid attributes" do 
        it "Creates a new template" do 
          expect{
            post :create, proposal_template: FactoryBot.attributes_for(:proposal_template)}.to change(ProposalTemplate, :count).by(1)
        end          

        it "Should also redirect to index" do  
         post :create, proposal_template: FactoryBot.attributes_for(:proposal_template)
         expect(response).to redirect_to proposal_templates_path
        end
      end

      context "With Invalid Attributes" do 
        it "Does not create a new template" do 
          expect{
            post :create, proposal_template: FactoryBot.attributes_for(:proposal_template, service_type: nil)}.to_not change(ProposalTemplate, :count)
        end

        it "Should re-render the new template" do 
          post :create, proposal_template: FactoryBot.attributes_for(:proposal_template, service_type: nil)
          expect(response).to render_template :new
        end
      end
    end
    

    describe 'GET edit' do 
      before :each do 
        @template = FactoryBot.create(:proposal_template)
      end

      context "Edit" do
        it "Should fetch and get proper proposal setting" do 
        
          get :edit, {id: @template.id}
          expect(assigns(:template)).to_not eq(nil)
          
        end

        it "Should render the edit page" do 
        
          get :edit , {id: @template.id}
          expect(response).to render_template(:edit)
        end
      end
       
    end
    

    describe 'Testing PUT update methods' do
      before :each do 
         @template = FactoryBot.create(:proposal_template)
      end

      context "With valid attributes" do 
        it "Locates and populates the requested @template" do 
          put :update, id: @template.id , proposal_template: FactoryBot.attributes_for(:proposal_template)
          expect(assigns(:template)).to eq(@template)
        end

        it "Changes the template attributes" do 
          put :update, id: @template.id , proposal_template: FactoryBot.attributes_for(:proposal_template, template_description: "Modified Template")
          @template.reload
          expect(@template.template_description).to eq("Modified Template")
        end

        it "Redirects to the index page" do 
          put :update, id: @template.id , proposal_template: FactoryBot.attributes_for(:proposal_template)
          expect(response).to redirect_to proposal_templates_path
        end
      end

      context "With invalid attributes" do 
       

        it "Does not change template attributes" do 
          put :update , id: @template, proposal_template: FactoryBot.attributes_for(:proposal_template, template_description: nil, service_type: 2)
          @template.reload
          expect(@template.service_type).to_not eq(2)
        end

        it "Re-renders the edit action" do 
          put :update , id: @template, proposal_template: FactoryBot.attributes_for(:proposal_template, template_description: nil, service_type: 1 )
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Destroying a Proposal Template' do 
      before :each do 
         @template = FactoryBot.create(:proposal_template)
      end

      it "Should alter the number of ProposalTemplate by -1" do 
        expect{delete :destroy, id: @template}.to change(ProposalTemplate, :count).by(-1)
      end
    end

  end

  describe "Testing attempted forgery" do 
    login_user

    before do
     @template1 = FactoryBot.create(:proposal_template, id: 1,  user_id: 1)
     @template2 = FactoryBot.create(:proposal_template, id: 2, user_id: 2)
    end

    context "Edit settings from another user " do 
      

      it "should redirect to root" do 
        get :edit, id: @template2
        expect(response).to redirect_to root_path
      end
    end

    context 'Update settings from another user' do 
      
      it "Should redirect to root" do 
        put :update , id: @template2, proposal_template: FactoryBot.attributes_for(:proposal_template, template_description: "blablabla")
        expect(response).to  redirect_to root_path
      end

      
    end

  end  

  end




	