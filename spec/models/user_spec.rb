require 'spec_helper'


describe User  do 
  it "has a valid factory" do 
  	expect(FactoryGirl.create(:user)). to be_valid
  end
  it "is invalid without email" do 
  	expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
  end

  it "is invalid without password" do 
  	expect(FactoryGirl.build(:user, password: nil)).not_to be_valid
  end
  
  it "does not allow a duplicate email" do 
    FactoryGirl.create(:user, email: "brigitte@sbp.com" , password: "patate")
    expect(FactoryGirl.build(:user, email: "brigitte@sbp.com", password: "patate")).not_to be_valid
  end

	
end