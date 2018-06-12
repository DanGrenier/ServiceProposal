require 'spec_helper'
require 'pp'

describe Receivable do
  it "Has a valid factory" do 
	  expect(FactoryGirl.create(:receivable)).to be_valid
    end
  
  #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:receivable, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:receivable, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:receivable, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:receivable, office: nil )).not_to be_valid
	end

   it "is invalid without franchise" do  
	  expect(FactoryGirl.build(:receivable, fran: nil )).not_to be_valid
	end   

	it "is invalid without franchise id" do  
	  expect(FactoryGirl.build(:receivable, franchise_id: nil )).not_to be_valid
	end   

	it "is invalid without date posted" do  
	  expect(FactoryGirl.build(:receivable, date_posted: nil )).not_to be_valid
	end   

	it "is invalid without trans code" do  
	  expect(FactoryGirl.build(:receivable, trans_code: nil )).not_to be_valid
	end   

  it "is invalid without amount" do  
	  expect(FactoryGirl.build(:receivable, amount: nil )).not_to be_valid
	end   

  it "is invalid with negative amount" do  
    expect(FactoryGirl.build(:receivable, amount: -100 )).not_to be_valid
  end   

	 
   describe "Testing methods method" do 

    	
    	
      it "get_franchise_receivables should return 2 receivables" do 
      	@rec1 = FactoryGirl.create(:receivable)
        @rec2 = FactoryGirl.create(:receivable, amount: 300, description: "Another receivable")
        @rec3 = FactoryGirl.create(:receivable, franchise_id: 2)
        @rec4 = FactoryGirl.create(:receivable, franchise_id: 2, amount: 300, description: "Another receivable")
      	expect(Receivable.get_franchise_receivables(1)).to contain_exactly(@rec2, @rec1)
      end

       it "get_receivabless should return 4 receivables" do 
      	@rec1 = FactoryGirl.create(:receivable)
        @rec2 = FactoryGirl.create(:receivable, amount: 300, description: "Another receivable")
        @rec3 = FactoryGirl.create(:receivable, franchise_id: 2)
        @rec4 = FactoryGirl.create(:receivable, franchise_id: 2, amount: 300, description: "Another receivable")
      	expect(Receivable.get_receivables()).to contain_exactly(@rec4, @rec3, @rec2 , @rec1)
      end
  end

      



end
