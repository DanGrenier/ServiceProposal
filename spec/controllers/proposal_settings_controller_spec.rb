require 'spec_helper'
require 'pp'

describe ProposalSettingsController do 
  render_views


  describe "Not Signed In" do 

    describe "GET Edit" do 
      it "Should redirect to sign in" do 
      	get :edit, {:id => 1}
      	expect(response).to redirect_to (new_user_session_path)
      end
    end

    

    

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@setting = FactoryBot.create(:proposal_setting)
    		put :update, id: @setting , proposal_setting: FactoryBot.attributes_for(:proposal_setting)
    		expect(response).to redirect_to (new_user_session_path)
    	end
    end
  end

  describe 'Signed In' do 
    login_user

    
    it "Should have a user_id of 1" do 
    	expect(subject.current_user.id).to eq(1)
    end
   
    describe 'GET edit' do 

      before :each do 
        @setting1 = ProposalSetting.get_proposal_settings(subject.current_user.id)
      end

      context "Edit" do
        it "Should fetch and get proper proposal setting" do 
        
          get :edit, {id: @setting1.id}
          expect(assigns(:proposal_setting)).to_not eq(nil)
          
        end

        it "Should render the edit page" do 
        
          get :edit , {id: @setting1.id}
          expect(response).to render_template(:edit)
        end
      end
       
    end
    

    describe 'Testing PUT update methods' do
      before :each do 
         @setting1 = ProposalSetting.get_proposal_settings(subject.current_user.id)
      end
      context "With valid attributes" do 
        it "Locates and populates the requested @proposal_setting" do 
          put :update, id: @setting1.id , proposal_setting: FactoryBot.attributes_for(:proposal_setting)
          expect(assigns(:proposal_setting)).to eq(@setting1)
        end

        it "Changes the setting attributes" do 
          put :update, id: @setting1.id , proposal_setting: FactoryBot.attributes_for(:proposal_setting, tier1_name: "DIAMOND")
          @setting1.reload
          expect(@setting1.tier1_name).to eq("DIAMOND")
        end

        it "Redirects to the index page" do 
          put :update, id: @setting1 , proposal_setting: FactoryBot.attributes_for(:proposal_setting)
          expect(response).to redirect_to root_path
        end
      end

      context "With invalid attributes" do 
       

        it "Does not change setting attributes" do 
          put :update , id: @setting1, proposal_setting: FactoryBot.attributes_for(:invalid_setting_tier1_name )
          @setting1.reload
          expect(@setting1.tier1_name).to_not eq("DIAMOND")
        end

        it "Re-renders the edit action" do 
          put :update , id: @setting1, proposal_setting: FactoryBot.attributes_for(:invalid_setting_tier1_name )
          expect(response).to render_template :edit
        end
      end
    end

  end

  describe "Testing attempted forgery" do 
    login_user

    before do
     @setting1 = ProposalSetting.get_proposal_settings(subject.current_user.id)
     @setting2 = FactoryBot.create(:proposal_setting, user_id: 2 ) 
    end

    context "Edit settings from another user " do 
      

      it "should redirect to root" do 
        get :edit, id: @setting2
        expect(response).to redirect_to root_path
      end
    end

    context 'Update settings from another user' do 
      
      it "Should redirect to root" do 
        put :update , id: @setting2, proposal_setting: FactoryBot.attributes_for(:proposal_setting, user_id: 2)
        expect(response).to  redirect_to root_path
      end

      
    end

  end  

  end




	