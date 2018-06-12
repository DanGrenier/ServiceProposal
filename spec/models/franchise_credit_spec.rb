require 'spec_helper'
require 'pp'

describe FranchiseCredit do
  it "Has a valid factory" do 
	  expect(FactoryGirl.create(:franchise_credit)).to be_valid
    end
  
  #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:franchise_credit, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:franchise_credit, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:franchise_credit, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:franchise_credit, office: nil )).not_to be_valid
	end

   it "is invalid without franchise" do  
	  expect(FactoryGirl.build(:franchise_credit, fran: nil )).not_to be_valid
	end   

	it "is invalid without franchise id" do  
	  expect(FactoryGirl.build(:franchise_credit, franchise_id: nil )).not_to be_valid
	end   

	it "is invalid without date posted" do  
	  expect(FactoryGirl.build(:franchise_credit, date_posted: nil )).not_to be_valid
	end   

	it "is invalid without trans code" do  
	  expect(FactoryGirl.build(:franchise_credit, trans_code: nil )).not_to be_valid
	end   

  it "is invalid without amount" do  
	  expect(FactoryGirl.build(:franchise_credit, amount: nil )).not_to be_valid
	end   

  it "is invalid with negative amount" do  
    expect(FactoryGirl.build(:franchise_credit, amount: -100 )).not_to be_valid
  end   

	 
   describe "Testing get_franchise_credits method" do 

    	
    	
      it "Should return 2 credits" do 
      	@credit1 = FactoryGirl.create(:franchise_credit)
        @credit2 = FactoryGirl.create(:franchise_credit, amount: 300, description: "Another credit")
        @credit3 = FactoryGirl.create(:franchise_credit, franchise_id: 2)
        @credit4 = FactoryGirl.create(:franchise_credit, franchise_id: 2, amount: 300, description: "Another credit")
      	expect(FranchiseCredit.get_franchise_credits(1)).to contain_exactly(@credit1, @credit2)
      end
  end

      



end