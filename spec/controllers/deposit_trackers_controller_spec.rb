require 'spec_helper'
require 'pp'

describe DepositTrackersController do 


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
    	  post :create, deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker)
    	  expect(response).to redirect_to (new_user_session_path)	
         end
     end

    describe "POST Destroy"  do 
    	it "Should redirect to sign in" do 
    		@deposit = FactoryGirl.create(:deposit_tracker)
    	  delete :destroy, id: @deposit	
    	  expect(response).to redirect_to (new_user_session_path)

    	end
    end

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@deposit = FactoryGirl.create(:deposit_tracker)
    		put :update, id: @deposit , deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker)
    		expect(response).to redirect_to (new_user_session_path)
    	end
    end
  end

  describe 'Signed In' do 
    login_user
  
    
    
    it "Should have a franchise_id of 1" do 
    	expect(subject.current_user.franchise_id).to eq(1)
    end
   
    describe 'GET INDEX' do 
   	  before do
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @deposit1 = FactoryGirl.create(:deposit_tracker, fran: 1, accounting: 100 )
        @deposit2 = FactoryGirl.create(:deposit_tracker, fran: 1, tax_prep: 300, date_received: (DateTime.now + 1.days), deposit_date: (Date.today + 1.days), id:2 )
        @deposit3 = FactoryGirl.create(:deposit_tracker, fran: 1, backwork: 100, date_received: (DateTime.now + 2.days),deposit_date: (Date.today + 2.days), id:3 )
        @deposit4 = FactoryGirl.create(:deposit_tracker, fran: 1, consulting: 100,date_received: DateTime.now + 3.days,deposit_date: (Date.today + 3.days), id:4 )
        @deposit5 = FactoryGirl.create(:deposit_tracker, fran: 1, month: 6 , payroll: 100, date_received: DateTime.now + 30.days,deposit_date: (Date.today + 30.days), id: 5 )
        @deposit6 = FactoryGirl.create(:deposit_tracker, fran: 2, franchise_id: 2, accounting: 100, id: 6)
        @deposit7 = FactoryGirl.create(:deposit_tracker, fran: 2, franchise_id: 2,backwork: 100,date_received: DateTime.now + 1.days,deposit_date: (Date.today + 1.days), id: 7 )
        @deposit8 = FactoryGirl.create(:deposit_tracker, fran: 2, franchise_id: 2,backwork: 100,date_received: DateTime.now + 2.days, deposit_date: (Date.today + 2.days),id: 8 )
        
        get :index
      end
  	   
  	  context "Recent" do  	
  	    it "Populates the proper array of recent deposits for the current month" do 
  	       expect(assigns(:recent)).to eq([@deposit4, @deposit3, @deposit2, @deposit1])
        end

        it "Should not populate array of recent deposits from fran2" do 
          expect(assigns(:recent)).to_not include(@deposit7)
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
        it "Should assign a new deposit variable" do 
        
          get :new
          expect(assigns(:deposit)).to_not eq(nil)
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
        it "Creates a new deposit" do
          expect{
          post :create, deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker, "desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )}.to change(DepositTracker,:count).by(1)
          
        end

        

        it "Should redirect to index" do 
         post :create, deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker, "desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 ) 
         expect(response).to redirect_to deposit_trackers_path    
        end
      end

      context "With invalid attributes" do
        it "Does not create a new deposit" do 
          expect{
          post :create, deposit_tracker: FactoryGirl.attributes_for(:invalid_deposit_tracker, "desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )}.to_not change(DepositTracker,:count)
          
        end

        it "Should re-render the new template" do 
          post :create, deposit_tracker: FactoryGirl.attributes_for(:invalid_deposit_tracker, "desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          expect(response).to render_template :new
        end
      end
    end

    describe 'Testing PUT update methods' do
      before :each do 
         @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @deposit = FactoryGirl.create(:deposit_tracker, accounting: 300, tax_prep: 100) 
      end
      context "With valid attributes" do 
        it "Locates and populates the requested @deposit" do 
          put :update, id: @deposit , deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker, "desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          expect(assigns(:deposit)).to eq(@deposit)
        end

        it "Changes the deposit attributes" do 
          put :update, id: @deposit , deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker, accounting: 400, tax_prep: 0, "desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          @deposit.reload
          expect(@deposit.accounting).to eq(400)
        end

        it "Redirects to the index page" do 
          put :update, id: @deposit , deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker,"desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          expect(response).to redirect_to deposit_trackers_path
        end
      end

      context "With invalid attributes" do 
       

        it "Does not change deposit attributes" do 
          put :update , id: @deposit, deposit_tracker: FactoryGirl.attributes_for(:invalid_deposit_tracker, accounting: 400, tax_prep: 0,"desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          @deposit.reload
          expect(@deposit.accounting).to_not eq(400)
        end

        it "Re-renders the edit action" do 
          put :update , id: @deposit, deposit_tracker: FactoryGirl.attributes_for(:invalid_deposit_tracker,"desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Testing DELETE destroy method' do 
      before :each do 
        @deposit = FactoryGirl.create(:deposit_tracker)
      end

      it "Deletes the deposit" do 
        expect{
          delete :destroy, id: @deposit  
        }.to change(DepositTracker,:count).by(-1)   
      end

      it "Redirects to index page" do 
        delete :destroy, id: @deposit 
        expect(response).to redirect_to deposit_trackers_path
      end

    end

  end

  describe "Testing attempted forgery" do 
    login_user

    before do
     @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @deposit1 = FactoryGirl.create(:deposit_tracker, fran: 1, accounting: 100 )
        @deposit2 = FactoryGirl.create(:deposit_tracker, fran: 1, tax_prep: 300, date_received: (DateTime.now + 1.days), deposit_date: (Date.today + 1.days), id:2 )
        @deposit3 = FactoryGirl.create(:deposit_tracker, fran: 1, backwork: 100, date_received: (DateTime.now + 2.days), deposit_date: (Date.today + 2.days),id:3 )
        @deposit4 = FactoryGirl.create(:deposit_tracker, fran: 1, consulting: 100,date_received: DateTime.now + 3.days, deposit_date: (Date.today + 3.days),id:4 )
        @deposit5 = FactoryGirl.create(:deposit_tracker, fran: 1, month: 5 , payroll: 100, date_received: DateTime.now + 15.days,deposit_date: (Date.today + 15.days), id: 5 )
        @deposit6 = FactoryGirl.create(:deposit_tracker, fran: 2, franchise_id: 2, accounting: 100, id: 6)
        @deposit7 = FactoryGirl.create(:deposit_tracker, fran: 2, franchise_id: 2,backwork: 100,date_received: DateTime.now + 1.days,deposit_date: (Date.today + 1.days), id: 7 )
        @deposit8 = FactoryGirl.create(:deposit_tracker, fran: 2, franchise_id: 2, backwork: 100,date_received: DateTime.now + 2.days,deposit_date: (Date.today + 2.days), id: 8 )
        
    end

    context "Edit deposit from another user " do 
      

      it "should redirect to root" do 
        get :edit, id: @deposit8
        expect(response).to redirect_to root_path
      end
    end

    context 'Update deposit from another user' do 
      
      it "Should redirect to root" do 
        put :update , id: @deposit8, deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker, franchise_id: 2,"desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
        expect(response).to  redirect_to root_path
      end

      it "Should process the update from the same user though" do 
          put :update, id: @deposit4 , deposit_tracker: FactoryGirl.attributes_for(:deposit_tracker, payroll: 200, tax_prep: 200 ,"desposit_date(1i)": 2016 , "deposit_date(2i)": 4 , "deposit_date(3i)": 27 )
          expect(response).to redirect_to deposit_trackers_path
      end
    end

    context "Delete deposit from another user" do 
      it "should not delete the deposit" do 
        expect{
          delete :destroy, id: @deposit8  
        }.to_not change(DepositTracker,:count)
      end

      it "Redirects to index page" do 
        delete :destroy, id: @deposit8 
        expect(response).to redirect_to root_path
      end

    end

  end  

  end




	