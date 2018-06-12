require 'spec_helper'
require 'pp'

describe PaymentsController do 


  describe "Not Signed In" do 

    before do 
      @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
      @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      @bank_payment = FactoryGirl.create(:bank_payment)
      @card_payment = FactoryGirl.create(:card_payment)
      @check_payment = FactoryGirl.create(:check_payment)
    end


  	describe "GET Index" do 
  		it "Should redirect to sign in" do 
  		  get :index 
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
        @bank_payment = FactoryGirl.create(:bank_payment)
        @card_payment = FactoryGirl.create(:card_payment)
        @check_payment = FactoryGirl.create(:check_payment)
        
      end 

      it "Should redirect to root because user is not admin" do
        get :index
        expect(response).to render_template :index
      end

      it "Should populate a list of payments" do
        get :index
        expect(assigns(:payments)).to_not eq(nil)

      end

      
    end  

    
    
    
  end

  

  

end




	