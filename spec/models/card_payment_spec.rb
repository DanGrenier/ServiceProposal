require 'spec_helper'
require 'pp'

describe CardPayment do

    #Before anything we create at least one franchise for references
	before do
    @franchise = FactoryGirl.create(:franchise, id: 1 , franchise: '001' , lastname: 'Grenier')
    @franchise2 = FactoryGirl.create(:franchise, id: 2 , franchise: '002' , lastname: 'Blain')
		
	end


	
	#Check to see that we have a valid factory to work with
  it "has a valid factory" do 
	  expect(FactoryGirl.create(:card_payment)).to be_valid
  end
  
  #Test validation of missing values that dont allow nil
  it "is invalid without area" do 
    expect(FactoryGirl.build(:card_payment, area: nil )).not_to be_valid
  end

  it "is invalid without master" do 
    expect(FactoryGirl.build(:card_payment, mast: nil )).not_to be_valid
  end
	
  it "is invalid without region" do  
    expect(FactoryGirl.build(:card_payment, region: nil )).not_to be_valid
  end

  it "is invalid without office" do  
    expect(FactoryGirl.build(:card_payment, office: nil )).not_to be_valid
  end

  it "is invalid without franchise" do  
    expect(FactoryGirl.build(:card_payment, fran: nil )).not_to be_valid
  end   

  it "is invalid without franchise id" do  
    expect(FactoryGirl.build(:card_payment, franchise_id: nil )).not_to be_valid
  end   

  it "is invalid without trans_code" do  
    expect(FactoryGirl.build(:card_payment, trans_code: nil )).not_to be_valid
  end   

  it "is invalid without amount" do  
    expect(FactoryGirl.build(:card_payment, amount: nil )).not_to be_valid
  end   

  

  it "is invalid without invoice_payment" do  
    expect(FactoryGirl.build(:card_payment, invoice_payment: nil )).not_to be_valid
  end   

  it "is invalid without invoice_id" do  
    expect(FactoryGirl.build(:card_payment, invoice_id: nil )).not_to be_valid
  end   
  
  it "is invalid if amount is less than zero" do  
    expect(FactoryGirl.build(:card_payment, amount: -1 )).not_to be_valid
  end  


  describe "Testing CallBacks" do
    
    
    it "Should add site notice when created" do
      expect{
        @pmnt = FactoryGirl.create(:card_payment)
        @pmnt.approved = 1
        @pmnt.save}.to change(SiteNotice,:count).by(1)
    end

    

    it "Should add credit card fees to receivables" do 
      @pmnt = FactoryGirl.create(:card_payment)
      @pmnt.approved = 1
      
      expect{
        @pmnt.save}.to change(Receivable, :count).by(1)
     end 
      

  end

  describe "Testing Methods" do
  	before do
  		
  		
  		@payment1 = FactoryGirl.create(:card_payment)
  		@payment2 = FactoryGirl.create(:card_payment, id: 2 , reference_id: "2AF2EQ", amount: 200.00)
  		@payment3 = FactoryGirl.create(:card_payment, id: 3 , reference_id: "rAF2EQ", amount: 200.00, franchise_id: 2 , fran: '002')
  	end

  	it "Returns 2 payments for franchise 1" do
      expect(CardPayment.get_card_payments(1,10)).to contain_exactly(@payment1, @payment2)
  	end

  	it "Returns 1 payment for franchise 2" do
      expect(CardPayment.get_card_payments(2,10)).to contain_exactly(@payment3)
  	end
  end



end
