require 'spec_helper'
require 'pp'

describe PickProposalTemplatesController do 
  render_views


  describe "Not Signed In" do 

    describe "GET Index" do 
      it "Should redirect to sign in" do 
        get :index 
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
        @template = FactoryBot.create(:proposal_template)
        @template2 = FactoryBot.create(:proposal_template, id:2 , user_id: 2)
      end
      
      it "Should assign the templates variable" do
        get :index
        expect(assigns(:templates)).to_not eq(nil)
      end
      #If the db seed works, it loads 24 standard services, plus the one we just created
      it "Should have 1 template" do
        get :index 
        expect(assigns(:templates).count).to eq(1)
      end

      it "Should have exactly this one template for the first user" do 
        get :index 
        expect(assigns(:templates)).to include(@template)
      end
    end
  end  

  end




	