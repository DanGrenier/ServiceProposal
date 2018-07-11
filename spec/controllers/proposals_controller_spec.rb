require 'spec_helper'
require 'pp'

describe ProposalsController do 
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
        
        post :create , proposal: FactoryBot.attributes_for(:proposal)
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
    		@proposal = FactoryBot.create(:proposal)
    		put :update, id: @proposal , proposal: FactoryBot.attributes_for(:proposal)
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
        @proposal = FactoryBot.create(:proposal)
        @proposal2= FactoryBot.create(:proposal, id: 2)
      end
      
      it "Should assign the proposal variable" do
        get :index
        expect(assigns(:proposals)).to_not eq(nil)
      end

      it "Should have 2 proposals" do
        get :index 
        expect(assigns(:proposals).count).to eq(2)
      end

      it "Should have exactly those 2 proposals" do 
        get :index
        expect(assigns(:proposals)).to eq([@proposal2, @proposal])
      end


    end

    describe 'GET new' do 
      before :each do 
        @proposal = FactoryBot.create(:proposal)
      end

      it "Should assign a new proposal variable" do 
        get :new
        expect(assigns(:proposal)).to_not eq(nil)
      end

      it "Should render the new proposal" do 
        get :new 
        expect(response).to render_template :new
      end

    end

    describe 'Testing POST create methods' do 
      
      context "With valid attributes" do 
        it "Creates a new proposal" do 
          expect{
            post :create, proposal: FactoryBot.attributes_for(:proposal)}.to change(Proposal, :count).by(1)
        end          

        it "Should also redirect to index" do  
         post :create, proposal: FactoryBot.attributes_for(:proposal)
         expect(response).to redirect_to proposals_path
        end
      end

      context "With Invalid Attributes" do 
        it "Does not create a new proposal" do 
          expect{
            post :create, proposal: FactoryBot.attributes_for(:proposal, service_type: nil)}.to_not change(Proposal, :count)
        end

        it "Should re-render the new template" do 
          post :create, proposal: FactoryBot.attributes_for(:proposal, service_type: nil)
          expect(response).to render_template :new
        end
      end
    end
    

    describe 'GET edit' do 
      before :each do 
        @proposal = FactoryBot.create(:proposal)
      end

      context "Edit" do
        it "Should fetch and get proper proposal" do 
        
          get :edit, {id: @proposal.id}
          expect(assigns(:proposal)).to_not eq(nil)
          
        end

        it "Should render the edit page" do 
        
          get :edit , {id: @proposal.id}
          expect(response).to render_template(:edit)
        end
      end
       
    end
    

    describe 'Testing PUT update methods' do
      before :each do 
         @proposal = FactoryBot.create(:proposal)
      end

      context "With valid attributes" do 
        it "Locates and populates the requested @proposal" do 
          put :update, id: @proposal.id , proposal: FactoryBot.attributes_for(:proposal)
          expect(assigns(:proposal)).to eq(@proposal)
        end

        it "Changes the proposal attributes" do 
          put :update, id: @proposal.id , proposal: FactoryBot.attributes_for(:proposal, contact_first: "Jon Smith")
          @proposal.reload
          expect(@proposal.contact_first).to eq("Jon Smith")
        end

        it "Redirects to the index page" do 
          put :update, id: @proposal.id , proposal: FactoryBot.attributes_for(:proposal)
          expect(response).to redirect_to proposals_path
        end
      end

      context "With invalid attributes" do 
       

        it "Does not change proposal attributes" do 
          put :update , id: @proposal, proposal: FactoryBot.attributes_for(:proposal, contact_first: nil, business_name: "New Business Name" )
          @proposal.reload
          expect(@proposal.business_name).to_not eq("New Business Name")
        end

        it "Re-renders the edit action" do 
          put :update , id: @proposal, proposal: FactoryBot.attributes_for(:proposal, contact_first: nil, business_name: "New Business Name" )
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Destroying a Proposal' do 
      before :each do 
         @proposal = FactoryBot.create(:proposal)
      end

      it "Should alter the number of Proposals by -1" do 
        expect{delete :destroy, id: @proposal}.to change(Proposal, :count).by(-1)
      end
    end

  end

  describe "Testing attempted forgery" do 
    login_user

    before do
     @proposal1 = FactoryBot.create(:proposal, id: 1,  user_id: 1)
     @proposal2 = FactoryBot.create(:proposal, id: 2, user_id: 2)
    end

    context "Edit settings from another user " do 
      

      it "should redirect to root" do 
        get :edit, id: @proposal2
        expect(response).to redirect_to root_path
      end
    end

    context 'Update settings from another user' do 
      
      it "Should redirect to root" do 
        put :update , id: @proposal2, proposal: FactoryBot.attributes_for(:proposal, contact_first: "blablabla")
        expect(response).to  redirect_to root_path
      end

      
    end

  end  

  end




	