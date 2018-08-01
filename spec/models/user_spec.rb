require 'spec_helper'


describe User  do 
  it "has a valid factory" do 
  	expect(FactoryBot.create(:user)). to be_valid
  end
  it "is invalid without email" do 
  	expect(FactoryBot.build(:user, email: nil)).not_to be_valid
  end

  
  it "does not allow a duplicate email" do 
    FactoryBot.create(:user, email: "brigitte@sbp.com" , password: "patate")
    expect(FactoryBot.build(:user, email: "brigitte@sbp.com", password: "patate")).not_to be_valid
  end

	
end
