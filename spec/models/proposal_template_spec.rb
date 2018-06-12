require 'spec_helper'
require 'pp'

describe ProposalTemplate do

  
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryBot.create(:proposal_template)).to be_valid
  end

  
	it "is invalid without service_type" do 
	  expect(FactoryBot.build(:proposal_template, service_type: nil )).not_to be_valid
	end

  it "is invalid without a description" do 
    expect(FactoryBot.build(:proposal_template, template_description: nil )).not_to be_valid
  end

	
	
  #Test the remittance model methods
  describe "test model methods" do 
    before :each do
      @template1 = FactoryBot.create(:proposal_template)
      @template2 = FactoryBot.create(:proposal_template, service_type: 2)
      @template3 = FactoryBot.create(:proposal_template, service_type: 3)
    end

    context "service_type_desc" do
      it "Should return Full Service" do
        expect(@template1.service_type_desc).to eq("Full Service")
      end

      it "Should return Accounting" do 
        expect(@template2.service_type_desc).to eq("Accounting")
      end

      it "Should return Tax" do 
        expect(@template3.service_type_desc).to eq("Tax")
      end
      
    end
 
  end

end


 