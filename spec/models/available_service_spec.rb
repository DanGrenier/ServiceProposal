require 'spec_helper'
require 'pp'

describe AvailableService do

  #Check to see that we have a valid factory to work with
  it "has a valid factory" do 
	  expect(FactoryBot.create(:available_service)).to be_valid
  end
  

  it "is invalid without a user id" do 
    expect(FactoryBot.build(:available_service, user_id: nil )).not_to be_valid
  end

  #Test validation of missing values that dont allow nil
  it "is invalid without a description" do 
    expect(FactoryBot.build(:available_service, service_description: nil )).not_to be_valid
  end

  it "is invalid without service type" do 
    expect(FactoryBot.build(:available_service, service_type: nil )).not_to be_valid
  end
	
  it "is invalid without custom service flag" do  
    expect(FactoryBot.build(:available_service, custom_service: nil )).not_to be_valid
  end


  describe "Testing get_proposal_services method" do 
    before do
    @count = AvailableService.count
    #Create bank account with the valid factory 
    @new_service = FactoryBot.create(:available_service)
    end
    

    it "should return a list" do
      @new_service = FactoryBot.create(:available_service) 
      #Make sure that the account type returns checking as it should
      expect(AvailableService.get_proposal_services(@new_service.user_id)).to_not be_empty
    end

    it "should return the proper number of items" do 
      expect(AvailableService.get_proposal_services(@new_service.user_id).count).to eq(@count+1)
    end

  end

  describe "Testing get_desc_from_id method" do 
    
  	it "Should return the proper description for existing service" do
  	  @service = AvailableService.find(1)
      expect(AvailableService.get_desc_from_id(@service.id)).to eq(@service.service_description)
    end

    it "Should return the proper description for newly created service" do
  	  @new_service = FactoryBot.create(:available_service)
  	  expect(AvailableService.get_desc_from_id(@new_service.id)).to eq(@new_service.service_description)
    end
    
  end

  describe "Testing the get_service_type_desc method" do
    before do
    @service1 = FactoryBot.create(:available_service, service_type: 1)
    @service2 = FactoryBot.create(:available_service, service_type: 2)
    @service3 = FactoryBot.create(:available_service, service_type: 3)
  end
    it "Should return Both" do
      expect(@service1.get_service_type_desc).to eq("Both")
    end

    it "Should return Accounting" do
      expect(@service2.get_service_type_desc).to eq("Accounting")
    end

    it "Should return Tax" do
      expect(@service3.get_service_type_desc).to eq("Tax")
    end

  end

end

