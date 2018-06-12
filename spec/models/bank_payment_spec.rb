require 'spec_helper'
require 'pp'

describe BankPayment do

    #Before anything we create at least one franchise for references
	before do
		@franchise = FactoryGirl.create(:franchise)
    @franchise2 = FactoryGirl.create(:franchise, id: 2 , franchise: '002' , lastname: 'Blain')
    
	end


	
	#Check to see that we have a valid factory to work with
  it "has a valid factory" do 
	  expect(FactoryGirl.create(:bank_payment)).to be_valid
  end
  
  #Test validation of missing values that dont allow nil
  it "is invalid without area" do 
    expect(FactoryGirl.build(:bank_payment, area: nil )).not_to be_valid
  end

  it "is invalid without a payment date" do 
    expect(FactoryGirl.build(:bank_payment, payment_date: nil )).not_to be_valid
  end
  it "is invalid without master" do 
    expect(FactoryGirl.build(:bank_payment, mast: nil )).not_to be_valid
  end
	
  it "is invalid without region" do  
    expect(FactoryGirl.build(:bank_payment, region: nil )).not_to be_valid
  end

  it "is invalid without office" do  
    expect(FactoryGirl.build(:bank_payment, office: nil )).not_to be_valid
  end

  it "is invalid without franchise" do  
    expect(FactoryGirl.build(:bank_payment, fran: nil )).not_to be_valid
  end   

  it "is invalid without franchise id" do  
    expect(FactoryGirl.build(:bank_payment, franchise_id: nil )).not_to be_valid
  end   

  it "is invalid without trans_code" do  
    expect(FactoryGirl.build(:bank_payment, trans_code: nil )).not_to be_valid
  end   

  it "is invalid without amount" do  
    expect(FactoryGirl.build(:bank_payment, amount: nil )).not_to be_valid
  end   

  it "is invalid without gms_bank_token" do  
    expect(FactoryGirl.build(:bank_payment, gms_bank_token: nil )).not_to be_valid
  end   

  it "is invalid without invoice_payment" do  
    expect(FactoryGirl.build(:bank_payment, invoice_payment: nil )).not_to be_valid
  end   

  it "is invalid without invoice_id" do  
    expect(FactoryGirl.build(:bank_payment, invoice_id: nil )).not_to be_valid
  end   
  
  it "is invalid if amount is less than zero" do  
    expect(FactoryGirl.build(:bank_payment, amount: -1 )).not_to be_valid
  end  


  describe "Testing CallBacks" do
    
    
    it "Should add site notice when created" do
      expect{
        FactoryGirl.create(:bank_payment)}.to change(SiteNotice,:count).by(1)
    end

    it "Should add site notice when destroyed" do 
      @pmnt = FactoryGirl.create(:bank_payment)
      expect{@pmnt.destroy}.to change(SiteNotice,:count).by(1)
    end

    it "Should add site notices when created than destroyed" do 
      
      expect{
        @pmnt = FactoryGirl.create(:bank_payment)
        @pmnt.destroy}.to change(SiteNotice,:count).by(2)
    end

  end

  describe "Testing Methods" do
  	before do
  		
      
  		
  		@payment1 = FactoryGirl.create(:bank_payment)
  		@payment2 = FactoryGirl.create(:bank_payment, id: 2 , reference_id: "2AF2EQ", amount: 200.00)
  		@payment3 = FactoryGirl.create(:bank_payment, id: 3 , reference_id: "rAF2EQ", amount: 200.00, franchise_id: @franchise2.id , fran: @franchise2.franchise)
  	end

  	it "Returns 2 payments for franchise 1" do
      expect(BankPayment.get_bank_payments(@franchise.id,10)).to contain_exactly(@payment1, @payment2)
  	end

  	it "Returns 1 payment for franchise 2" do
      expect(BankPayment.get_bank_payments(@franchise2.id,10)).to contain_exactly(@payment3)
  	end
  end



end
