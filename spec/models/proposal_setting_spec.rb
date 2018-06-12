require 'spec_helper'
require 'pp'

describe ProposalSetting do

  
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryBot.create(:proposal_setting)).to be_valid
  end

  
	it "is invalid without user_id" do 
	  expect(FactoryBot.build(:proposal_setting, user_id: nil )).not_to be_valid
	end

  it "is invalid without return email" do 
    expect(FactoryBot.build(:proposal_setting, return_email: nil )).not_to be_valid
  end

	it "is invalid if email is not proper format" do 
	  expect(FactoryBot.build(:proposal_setting, return_email: "potato.potato" )).not_to be_valid
	end
	
	it "is invalid without tier1_name" do  
	  expect(FactoryBot.build(:proposal_setting, tier1_name: nil )).not_to be_valid
	end

  it "is invalid without tier2_name" do  
    expect(FactoryBot.build(:proposal_setting, tier2_name: nil )).not_to be_valid
  end

  it "is invalid without tier3_name" do  
    expect(FactoryBot.build(:proposal_setting, tier3_name: nil )).not_to be_valid
  end

	
  #Test the remittance model methods
  describe "test model methods" do 
    before :each do
      @setting = FactoryBot.create(:proposal_setting)
    end

    context "get_proposal_settings" do
      it "Should return the proper one" do
        expect(ProposalSetting.get_proposal_settings(@setting.user_id)).to eq(@setting)
      end

      it "Should not return one with an unknown user id" do 
        expect(ProposalSetting.get_proposal_settings(-1)).to be_nil
      end
      
    end
 
  end

end


 