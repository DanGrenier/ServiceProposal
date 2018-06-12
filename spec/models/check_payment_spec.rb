require 'spec_helper'
require 'pp'

describe CheckPayment do

    #Before anything we create at least one franchise for references
	before do
		@franchise = FactoryGirl.create(:franchise)
    @franchise2 = FactoryGirl.create(:franchise, id: 2 , franchise: '002' , lastname: 'Blain')
	end


	
	#Check to see that we have a valid factory to work with
  it "has a valid factory" do 
	  expect(FactoryGirl.create(:check_payment)).to be_valid
  end
  
  #Test validation of missing values that dont allow nil
  it "is invalid without area" do 
    expect(FactoryGirl.build(:check_payment, area: nil )).not_to be_valid
  end

  it "is invalid without master" do 
    expect(FactoryGirl.build(:check_payment, mast: nil )).not_to be_valid
  end
	
  it "is invalid without region" do  
    expect(FactoryGirl.build(:check_payment, region: nil )).not_to be_valid
  end

  it "is invalid without office" do  
    expect(FactoryGirl.build(:check_payment, office: nil )).not_to be_valid
  end

  it "is invalid without franchise" do  
    expect(FactoryGirl.build(:check_payment, fran: nil )).not_to be_valid
  end   

  it "is invalid without franchise id" do  
    expect(FactoryGirl.build(:check_payment, franchise_id: nil )).not_to be_valid
  end   

  it "is invalid without trans_code" do  
    expect(FactoryGirl.build(:check_payment, trans_code: nil )).not_to be_valid
  end   

  it "is invalid without amount" do  
    expect(FactoryGirl.build(:check_payment, amount: nil )).not_to be_valid
  end   

  it "is invalid without check number" do  
    expect(FactoryGirl.build(:check_payment, check_number: nil )).not_to be_valid
  end     

  it "is invalid without invoice_payment" do  
    expect(FactoryGirl.build(:check_payment, invoice_payment: nil )).not_to be_valid
  end   

  it "is invalid without invoice_id" do  
    expect(FactoryGirl.build(:check_payment, invoice_id: nil )).not_to be_valid
  end   
  
  it "is invalid if amount is less than zero" do  
    expect(FactoryGirl.build(:check_payment, amount: -1 )).not_to be_valid
  end  


  describe "Testing CallBacks" do
    
    
    it "Should add site notice when created" do
      expect{
        @pmnt = FactoryGirl.create(:check_payment)
        }.to change(SiteNotice,:count).by(1)
    end

    

    it "Should add site notice when destroyed" do 
      @pmnt = FactoryGirl.create(:check_payment)
           
      expect{
        @pmnt.destroy}.to change(SiteNotice, :count).by(1)
     end 
      

  end

  describe "Testing Methods" do
  	before do
  		  		
  		@payment1 = FactoryGirl.create(:check_payment)
  		@payment2 = FactoryGirl.create(:check_payment, id: 2 , reference_id: "", amount: 200.00)
  		@payment3 = FactoryGirl.create(:check_payment, id: 3 , reference_id: "", amount: 200.00, franchise_id: 2 , fran: '002')
  	end

  	it "Returns 2 payments for franchise 1" do
      expect(CheckPayment.get_check_payments(1,10)).to contain_exactly(@payment1, @payment2)
  	end

  	it "Returns 1 payment for franchise 2" do
      expect(CheckPayment.get_check_payments(2,10)).to contain_exactly(@payment3)
  	end
  end



end
