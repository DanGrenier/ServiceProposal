require 'spec_helper'
require 'pp'

describe Proposal do

  
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryBot.create(:proposal)).to be_valid
  end

  
	it "is invalid without proposal type" do 
	  expect(FactoryBot.build(:proposal, service_type: nil )).not_to be_valid
	end

  it "is invalid without a business name" do 
    expect(FactoryBot.build(:proposal, business_name: nil )).not_to be_valid
  end

  it "is invalid without a address" do 
    expect(FactoryBot.build(:proposal, address: nil )).not_to be_valid
  end

  it "is invalid without a city" do 
    expect(FactoryBot.build(:proposal, city: nil )).not_to be_valid
  end

  it "is invalid without a state" do 
    expect(FactoryBot.build(:proposal, state: nil )).not_to be_valid
  end

  it "is invalid without a status" do 
    expect(FactoryBot.build(:proposal, proposal_status: nil )).not_to be_valid
  end

  it "is invalid without a contact name" do 
    expect(FactoryBot.build(:proposal, contact_first: nil )).not_to be_valid
  end

  it "is invalid without a business type" do 
    expect(FactoryBot.build(:proposal, business_type: nil )).not_to be_valid
  end

  it "is invalid without a fee for tier1" do 
    expect(FactoryBot.build(:proposal, fee_tier1: nil )).not_to be_valid
  end

  it "is invalid without a fee for tier2" do 
    expect(FactoryBot.build(:proposal, fee_tier1: nil )).not_to be_valid
  end

  it "is invalid without a fee for tier3" do 
    expect(FactoryBot.build(:proposal, fee_tier1: nil )).not_to be_valid
  end

  it "is invalid without a valid fee for tier1" do 
    expect(FactoryBot.build(:proposal, fee_tier1: 'ABC' )).not_to be_valid
  end

  it "is invalid without a valid fee for tier2" do 
    expect(FactoryBot.build(:proposal, fee_tier1: 'DEF' )).not_to be_valid
  end

  it "is invalid without a valid fee for tier3" do 
    expect(FactoryBot.build(:proposal, fee_tier1: 'GHI' )).not_to be_valid
  end

  it "is invalid without a valid email" do 
    expect(FactoryBot.build(:proposal, contact_email: 'maurice.navet' )).not_to be_valid
  end
  

	
	
  #Test the remittance model methods
  describe "test model methods" do 
    before :each do
      @proposal1 = FactoryBot.create(:proposal, proposal_status: 0)
      @proposal2 = FactoryBot.create(:proposal, service_type: 2, proposal_status: 1, id: 2)
      @proposal3 = FactoryBot.create(:proposal, service_type: 3, proposal_status: 2, id: 3)
    end

    context "service_type_desc" do
      it "Should return Full Service" do
        expect(@proposal1.service_type_desc).to eq("Full Service")
      end

      it "Should return Accounting" do 
        expect(@proposal2.service_type_desc).to eq("Accounting")
      end

      it "Should return Tax" do 
        expect(@proposal3.service_type_desc).to eq("Tax")
      end
      
    end

    context "status_desc" do
      it "Should return Pending" do
        expect(@proposal1.status_desc).to eq("Pending")
      end

      it "Should return Accepted" do 
        expect(@proposal2.status_desc).to eq("Accepted")
      end

      it "Should return Declined" do 
        expect(@proposal3.status_desc).to eq("Declined")
      end
      
    end

    context "recent_proposals scope" do 
      it "should return 3 proposals" do
        props = Proposal.recent_proposals(@proposal1.user_id)  
        expect(props.length).to eq(3)
      end

      it "should return the 3 proposals we created" do
        expect( Proposal.recent_proposals(@proposal1.user_id)).to contain_exactly(@proposal1,@proposal2,@proposal3)
      end
    end

    context "proposal_with_status scope" do 
      it "should return 1 proposal pending" do 
        props = Proposal.proposal_with_status(@proposal1.user_id,0)
        expect(props.length).to eq(1)
      end

      it "should return the proper proposal pending" do 
       expect(Proposal.proposal_with_status(@proposal1.user_id,0)).to contain_exactly(@proposal1)
      end

      it "should return 1 proposal approved" do 
        props = Proposal.proposal_with_status(@proposal1.user_id,1)
        expect(props.length).to eq(1)
      end

      it "should return the proper proposal approved" do 
       expect(Proposal.proposal_with_status(@proposal1.user_id,1)).to contain_exactly(@proposal2)
      end

      it "should return 1 proposal declined" do 
        props = Proposal.proposal_with_status(@proposal1.user_id,2)
        expect(props.length).to eq(1)
      end

      it "should return the proper proposal declined" do 
       expect(Proposal.proposal_with_status(@proposal1.user_id,2)).to contain_exactly(@proposal3)
      end


    end
 
  end

end


 