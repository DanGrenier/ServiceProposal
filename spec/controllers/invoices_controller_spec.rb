require 'spec_helper'
require 'pp'

describe InvoicesController do 


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
    	  post :create, invoice: FactoryGirl.attributes_for(:invoice)
    	  expect(response).to redirect_to (new_user_session_path)	
         end
     end

    describe "POST Destroy"  do 
    	it "Should redirect to sign in" do 
    		@invoice = FactoryGirl.create(:invoice)
    	  delete :destroy, id: @invoice	
    	  expect(response).to redirect_to (new_user_session_path)

    	end
    end

    describe "POST Update" do 
    	it "Should redirect to sign in" do 
    		@invoice = FactoryGirl.create(:invoice)
    		put :update, id: @invoice , invocie: FactoryGirl.attributes_for(:invoice)
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
      before :each do
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @invoice1 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:1,:invoice_items => [FactoryGirl.build(:invoice_item_form)])
        @invoice2 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:2,:invoice_items => [FactoryGirl.build(:invoice_item_form, amount: 500)])
        @invoice3 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:3,:invoice_items => [FactoryGirl.build(:invoice_item_form, amount: 600)])
        @invoice4 = FactoryGirl.create(:invoice, fran: 2, franchise_id: 2, id:4,:invoice_items => [FactoryGirl.build(:invoice_item_form, amount: 700)])
        @invoice5 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:5, posted: 1 , date_posted: Date.today, :invoice_items => [FactoryGirl.build(:invoice_item_form, amount: 800)])
        @invoice6 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:6, posted: 1 , date_posted: Date.today, :invoice_items => [FactoryGirl.build(:invoice_item_form, amount: 900)])
        @invoice7 = FactoryGirl.create(:invoice, fran: 2, franchise_id: 2, id:7, posted: 1 , date_posted: Date.today, :invoice_items => [FactoryGirl.build(:invoice_item_form, amount: 1000)])
        get :index
      end

      context "Pending" do
        it "populates the proper array of pending invoices" do
          expect(assigns(:pending)).to eq([@invoice3, @invoice2 , @invoice1])
        end

        it "should populate the array with invoice from franchise 2" do
          expect(assigns(:pending)).to_not include(@invoice4)
        end
      end

      context "Posted" do
        it "populates the proper array of posted invoices" do
          expect(assigns(:recent)).to eq([@invoice6 , @invoice5])
        end

        it "should not populate the array with invoices from franchise 2" do
          expect(assigns(:recent)).to_not include([@invoice7])
        end
      end

      context "Rendering" do 
        it "Should render the index page" do 
          expect(response).to render_template :index
        end
      end
    end

    describe 'GET new' do 
      before do
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "New" do
        it "Should asign a new invoice variable" do 
          get :new
          expect(assigns(:invoice)).to_not eq(nil)
        end

        it "Should render the new page" do 
          get :new
          expect(response).to render_template :new
        end
      end
    end

    describe 'Testing POST / Create method' do 
      before do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      end

      context "With valid attributes" do 
        it "Creates a new invoice" do 
          expect{
            post :create, invoice: FactoryGirl.attributes_for(:invoice, :invoice_items => [FactoryGirl.build(:invoice_item_form)])
          }.to change(Invoice, :count).by(1)
          
        end

        it "Should redirect to index" do 
          post :create, invoice: FactoryGirl.attributes_for(:invoice, :invoice_items => [FactoryGirl.build(:invoice_item_form)])
          expect(response).to redirect_to invoices_path
        end
      end

      context "With missing/invalid attributes" do
        it "Does not create a new invoice if missing something" do 
          expect{
            post :create, invoice: FactoryGirl.attributes_for(:invalid_invoice, :invoice_items => [FactoryGirl.build(:invoice_item_form)])
          }.to change(Invoice, :count).by(0)
        end

        it "Should re-render the new templace" do
          post :create, invoice: FactoryGirl.attributes_for(:invalid_invoice, :invoice_items => [FactoryGirl.build(:invoice_item_form)])
          expect(response).to render_template :new
        end
      end
    end

    describe "Testing PUT/Update method" do
      before do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @invoice1 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:1,:invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 400)])
        @items = @invoice1.invoice_items
        @invoice2 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:2,:invoice_items=>[FactoryGirl.build(:invoice_item_form, amount: 500)])
      end

      context "With valid attributes" do 
        it "Locates and populates the requested invoice" do 
          @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items[0].id , invoice_code: @items[0].invoice_code, amount: 444.44))
          put :update, id: @invoice1, invoice: @invattrs
          expect(assigns(:invoice)).to eq(@invoice1)
        end

        it "Changes the invoice attribute" do
          @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items[0].id , invoice_code: @items[0].invoice_code, amount: 444.44))
          put :update, id: @invoice1, invoice: @invattrs
          @invoice1.reload
          expect(@invoice1.total).to eq(444.44)
        end

        it "Should redirect to index" do 
          @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items[0].id , invoice_code: @items[0].invoice_code, amount: 444.44))
          put :update, id: @invoice1, invoice: @invattrs
          expect(response).to redirect_to invoices_path
        end
      end

      context "With invalid attributes" do
        it "Locates the requested invoice" do 
          @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items[0].id , invoice_code: @items[0].invoice_code, amount: nil))
          put :update, id: @invoice1, invoice: @invattrs
          expect(assigns(:invoice)).to eq(@invoice1)
        end

        it "Does not change the invoice attributes" do 
          @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items[0].id , invoice_code: @items[0].invoice_code, amount: nil))
          put :update, id: @invoice1, invoice: @invattrs
          @invoice1.reload
          expect(@invoice1.total).to_not eq(444.44)
        end

        it "Re renders the edit template" do 
          @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items[0].id , invoice_code: @items[0].invoice_code, amount: nil))
          put :update, id: @invoice1, invoice: @invattrs
          expect(response).to render_template :edit
        end
      end
         
    end

    describe "Testing DELETE/Destroy method" do 
      before :each do 
        @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
        @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
        @invoice1 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:1,:invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 400)])
        @invoice2 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:2, posted: 1 , date_posted: Date.today, :invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 800)])
        @invoice3 = FactoryGirl.create(:invoice, fran: 2, franchise_id: 2, id:3, posted: 1 , date_posted: Date.today, :invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 550)])
      end    

      it "Deletes the pending invoice" do 
        expect{delete :destroy, id: @invoice1
          }.to change(Invoice,:count).by(-1)
      end

      it "Redirects to index page" do 
        delete :destroy, id: @invoice1 
        expect(response).to redirect_to invoices_path
      end

      it "Does NOT delete a posted invoice" do 
        expect{delete :destroy, id: @invoice2
          }.to_not change(Invoice,:count)
      end

    end

  end

  describe "Testing attempted forgery" do 
    login_user
    before do 
      @fran1 = FactoryGirl.create(:franchise, franchise: 1 , id:1) 
      @fran2 = FactoryGirl.create(:franchise, franchise: 2 , id:2) 
      @invoice1 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:1,:invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 400)])
      @items1 = @invoice1.invoice_items
      @invoice2 = FactoryGirl.create(:invoice, fran: 1, franchise_id: 1, id:2, posted: 1 , date_posted: Date.today, :invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 800)])
      @invoice3 = FactoryGirl.create(:invoice, fran: 2, franchise_id: 2, id:3, posted: 1 , date_posted: Date.today, :invoice_items=> [FactoryGirl.build(:invoice_item_form, amount: 550)])
      @items3 = @invoice3.invoice_items
    end

    context "Edit invoice from another user" do 
      it "should redirect to root" do 
        get :edit, id: @invoice3
        expect(response).to redirect_to root_path
      end
    end

    context "Update invoice from another user" do 
      it "should redirect to root" do 
        @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items3[0].id , invoice_code: @items3[0].invoice_code, amount: 444.44))
        put :update, id: @invoice3, invoice: @invattrs
        expect(response).to redirect_to root_path
      end

      it "should process the update from the proper user" do 
        @invattrs = FactoryGirl.attributes_for(:invoice, :invoice_items_attributes =>  FactoryGirl.attributes_for(:invoice_item, id: @items1[0].id , invoice_code: @items1[0].invoice_code, amount: 444.44))
        put :update, id: @invoice1, invoice: @invattrs
        expect(response).to redirect_to invoices_path
      end

    end

    context "Deleting invoice from another user" do 
      it "should redirect to root" do 
        delete :destroy, id: @invoice3 
        expect(response).to redirect_to root_path

      end
    end
  end
  
end

	