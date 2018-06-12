require 'spec_helper'
require 'pp'

describe CreditCard do
  it "Has a valid factory" do 
	  expect(FactoryGirl.create(:credit_card)).to be_valid
    end
    #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:credit_card, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:credit_card, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:credit_card, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:credit_card, office: nil )).not_to be_valid
	end

   it "is invalid without franchise" do  
	  expect(FactoryGirl.build(:credit_card, fran: nil )).not_to be_valid
	end   

	it "is invalid without franchise id" do  
	  expect(FactoryGirl.build(:credit_card, franchise_id: nil )).not_to be_valid
	end   

	it "is invalid without card number" do  
	  expect(FactoryGirl.build(:credit_card, cc_number: nil )).not_to be_valid
	end   

	it "is invalid without month" do  
	  expect(FactoryGirl.build(:credit_card, cc_exp_month: nil )).not_to be_valid
	end   

    it "is invalid without year" do  
	  expect(FactoryGirl.build(:credit_card, cc_exp_year: nil )).not_to be_valid
	end   

	 it "is invalid without CreditCard Type" do  
	  expect(FactoryGirl.build(:credit_card, cc_type: nil )).not_to be_valid
	end   

    describe "Testing get_card_type method" do 
    	
    	
      it "Should return Visa" do 
      	@visa = FactoryGirl.create(:credit_card)
      	expect(@visa.get_card_type(@visa.card_type)).to eq("Visa")
      end

      it "Should return MasterCard" do
      	@mc = FactoryGirl.create(:credit_card, cc_number: "5105105105105100", cc_type: 'M')
      	expect(@mc.get_card_type(@mc.card_type)).to eq("MasterCard")
      end

      it "Should return Discover" do
      	@discover = FactoryGirl.create(:credit_card, cc_number: "6011111111111117", cc_type: 'I')
      	expect(@discover.get_card_type(@discover.card_type)).to eq("Discover")
      end

      it "Should return American Express" do 
      	@amex = FactoryGirl.create(:credit_card, cc_number: "371449635398431", cc_type: 'A')
      	expect(@amex.get_card_type(@amex.card_type)).to eq("American Express")
      end

  end

  describe "Testing get_card_icon method" do

  it "Should return card visa" do 
      	@visa = FactoryGirl.create(:credit_card)
      	expect(@visa.get_card_icon(@visa.card_type)).to eq("card visa")
      end

      it "Should return card mastercard" do
      	@mc = FactoryGirl.create(:credit_card, cc_number: "5105105105105100", cc_type: 'M')
      	expect(@mc.get_card_icon(@mc.card_type)).to eq("card mastercard")
      end

      it "Should return card discover" do
      	@discover = FactoryGirl.create(:credit_card, cc_number: "6011111111111117", cc_type: 'I')
      	expect(@discover.get_card_icon(@discover.card_type)).to eq("card discover")
      end

      it "Should return card amex" do 
      	@amex = FactoryGirl.create(:credit_card, cc_number: "371449635398431", cc_type: 'A')
      	expect(@amex.get_card_icon(@amex.card_type)).to eq("card amex")
      end

  end

  describe "Testing check_expiring_card method" do

  	before do
  		@card1 = FactoryGirl.create(:credit_card,  cc_exp_year: "17", cc_exp_month: "03", card_exp_year: 2017 , card_exp_month: 3)
  		@card2 = FactoryGirl.create(:credit_card, cc_number: "5105105105105100", cc_type: 'M', cc_exp_year: "17", cc_exp_month: "12", card_exp_year: 2017 , card_exp_month: 12)
  		@card3 = FactoryGirl.create(:credit_card, cc_number: "371449635398431", cc_type: 'A', cc_exp_year: "17", cc_exp_month: "12", card_exp_year: 2017 , card_exp_month: 12)
  	end

  	it "Should return only card1" do 
  		expect(CreditCard.check_expiring_cards(1, 17,3)).to eq([@card1])
  	end

	  it "Should return card2 and card3" do 
  		expect(CreditCard.check_expiring_cards(1, 17,12)).to eq([@card3,@card2])
  	end  	

  	

    it "Should return card2 2017 year" do
      @card2.retrieveCard(@card2.gms_card_token)
      expect(@card2.cc_exp_year).to eq("2017")
    end

  end




end