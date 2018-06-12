require 'spec_helper'
require 'pp'

describe BankAccount do
  
  #Check to see that we have a valid factory to work with
  it "has a valid factory" do 
	  expect(FactoryGirl.create(:bank_account)).to be_valid
  end
  
  #Test validation of missing values that dont allow nil
  it "is invalid without area" do 
    expect(FactoryGirl.build(:bank_account, area: nil )).not_to be_valid
  end

  it "is invalid without master" do 
    expect(FactoryGirl.build(:bank_account, mast: nil )).not_to be_valid
  end
	
  it "is invalid without region" do  
    expect(FactoryGirl.build(:bank_account, region: nil )).not_to be_valid
  end

  it "is invalid without office" do  
    expect(FactoryGirl.build(:bank_account, office: nil )).not_to be_valid
  end

  it "is invalid without franchise" do  
    expect(FactoryGirl.build(:bank_account, fran: nil )).not_to be_valid
  end   

  it "is invalid without franchise id" do  
    expect(FactoryGirl.build(:bank_account, franchise_id: nil )).not_to be_valid
  end   
  
  it "is invalid without Account Type" do  
    expect(FactoryGirl.build(:bank_account, bank_account_type: nil )).not_to be_valid
  end   

  it "should return a token upon creation" do 
    @account = FactoryGirl.create(:bank_account_form) 
    expect(@account.gms_bank_token).not_to eq(nil)
  end

  it "should return the proper bank name from routing upon creation" do 
    @account = FactoryGirl.create(:bank_account_form) 
    expect(@account.bank_name).to eq("NATIONAL BANK OF GEORGIA")
  end

  it "should return the proper last 4 digits upon creation" do 
    @account = FactoryGirl.create(:bank_account_form) 
    expect(@account.last_four).to eq("8899")
  end

  it "should return the proper account type upon creation" do 
    @account = FactoryGirl.create(:bank_account_form) 
    expect(@account.account_type).to eq("C")
  end

  describe "Testing get_account_type method" do 
    it "should return checking" do 
      #Create bank account with the valid factory	
      @account = FactoryGirl.create(:bank_account)
      #Make sure that the account type returns checking as it should
      expect(@account.get_account_type).to eq("Checking")
    end

    it "Should return Savings" do
      #Create a Bank Account with default factory but override account type	
      @account = FactoryGirl.create(:bank_account, bank_account_type: 'S')
      #Make sure that the account type returns Savings as it should
      expect(@account.get_account_type).to eq("Savings")
    end

  end

  describe "Testing get_accounts method" do 
  	it "Should return 2 bank accounts for Franchise 1" do
  	  @account1 = FactoryGirl.create(:bank_account)
  	  @account2 = FactoryGirl.create(:bank_account_boa)
  	  @account3 = FactoryGirl.create(:bank_account_boa2)
  	  expect(BankAccount.get_accounts(1)).to contain_exactly(@account1, @account2)
    end

    it "Should return 1 bank accounts for Franchise 2" do
  	  @account1 = FactoryGirl.create(:bank_account)
  	  @account2 = FactoryGirl.create(:bank_account_boa)
  	  @account3 = FactoryGirl.create(:bank_account_boa2)
  	  expect(BankAccount.get_accounts(2)).to contain_exactly(@account3)
    end
  end

  

end

