require 'spec_helper'
require 'pp'

describe PagesController do 
  #First lets test the homepage with an invalid login 
  describe "tests with an invalid login" do 

    it "should not return a correct user" do 
      expect(subject.current_user).to eq(nil) 
    end
    
    describe "GET Home view" do 
      it "should not assign a recent trans variable" do 
        @frans = FactoryGirl.create(:franchise, id: 1)
        @frans1 = FactoryGirl.create(:franchise, id: 2)
        @frans2 = FactoryGirl.create(:franchise, id: 3)
        

        remit1 = FactoryGirl.create(:remittance, fran: @frans.franchise, franchise_id: @frans.id, posted: 1, accept_flag: 1)
        remit2 = FactoryGirl.create(:remittance, fran: @frans.franchise,franchise_id: @frans.id, month: 2, id:2, posted: 1, accept_flag: 1)
        remit3 = FactoryGirl.create(:remittance, fran: @frans.franchise,franchise_id: @frans.id, month:3, id:3, posted: 1, accept_flag: 1)
        remit4 = FactoryGirl.create(:remittance, fran: @frans1.franchise,franchise_id: @frans1.id, month:3, id:4, posted: 1, accept_flag: 1)
        
         get :home

        expect(assigns(:activities)).to eq(nil)
      end

      it "But should render the home page nonetheless" do 
        get :home
        expect(response).to render_template :home
      end

    end

      
  end

  #Here we will test the home page with a good user login
  describe "tests with a good user login" do 
    login_user

    it "should return a correct user" do 
      expect(subject.current_user).to_not eq(nil)	
    end


    describe "GET Home view" do 
      it "should assign a recent trans variable" do 
      	@frans = FactoryGirl.create(:franchise, id: 1)
        @frans1 = FactoryGirl.create(:franchise, id: 2)
        @frans2 = FactoryGirl.create(:franchise, id: 3)
        

      	remit1 = FactoryGirl.create(:remittance, fran: @frans.franchise, franchise_id: @frans.id, posted: 1, accept_flag: 1)
        remit2 = FactoryGirl.create(:remittance, fran: @frans.franchise,franchise_id: @frans.id, month: 2, id:2, posted: 1, accept_flag: 1)
        remit3 = FactoryGirl.create(:remittance, fran: @frans.franchise,franchise_id: @frans.id, month:3, id:3, posted: 1, accept_flag: 1)
        remit4 = FactoryGirl.create(:remittance, fran: @frans1.franchise,franchise_id: @frans1.id, month:3, id:4, posted: 1, accept_flag: 1)

        get :home
        expect(assigns[:activities]).to_not eq(nil)
        expect(assigns[:activities].size).to eq(3)
   

      end

      it "should render the home page" do 
      	get :home
      	expect(response).to render_template :home
      end

      
      
    	
    end
  end
 
 #Here we will test the home page with a good admin login
 describe "tests with a admin login" do 
    login_admin

    it "should return a correct user" do 
      expect(subject.current_user).to_not eq(nil) 
    end


    describe "GET Home view" do 
      it "should assign a recent trans variable" do 
        @frans = FactoryGirl.create(:franchise, id: 1)
        @frans1 = FactoryGirl.create(:franchise, id: 2)
        @frans2 = FactoryGirl.create(:franchise, id: 3)
        

        remit1 = FactoryGirl.create(:remittance, fran: @frans.franchise, franchise_id: @frans.id, posted: 1, accept_flag: 1)
        remit2 = FactoryGirl.create(:remittance, fran: @frans.franchise,franchise_id: @frans.id, month: 2, id:2, posted: 1, accept_flag: 1)
        remit3 = FactoryGirl.create(:remittance, fran: @frans.franchise,franchise_id: @frans.id, month:3, id:3, posted: 1, accept_flag: 1)
        remit4 = FactoryGirl.create(:remittance, fran: @frans1.franchise,franchise_id: @frans1.id, month:3, id:4, posted: 1, accept_flag: 1)

        get :home
        expect(assigns[:activities]).to_not eq(nil)
        expect(assigns[:activities].size).to eq(4)
   

      end

      it "should render the home page" do 
        get :home
        expect(response).to render_template :home
      end

      
      
      
    end
  end


	
end

