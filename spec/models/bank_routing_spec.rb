require 'spec_helper'
require 'pp'

describe BankRouting do
  
  #Check to see that we have a valid factory to work with
  it "has a valid factory" do 
	  expect(FactoryGirl.create(:bank_routing_tnbg)).to be_valid
  end
  
  
  describe "Testing get_name_from_routing" do 
    
    it "should return TNBG" do 
      #Make sure that the bank name is the correct one
       @bank_name = BankRouting.get_name_from_routing('061119888')
       expect(@bank_name[0].name).to eq("NATIONAL BANK OF GEORGIA")
    end

    

  end 

  
end

