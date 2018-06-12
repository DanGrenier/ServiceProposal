require 'spec_helper'
require 'pp'

describe InvoiceItem do
	it "has a valid factory" do 
	  expect(FactoryGirl.create(:invoice_item)).to be_valid
    end

    it "has an invalid factory" do 
	  expect(FactoryGirl.build(:invalid_invoice_item)).not_to be_valid
    end

    #Test validation of missing values that dont allow null
	it "is invalid without invoice code" do 
	  expect(FactoryGirl.build(:invoice_item, invoice_code: nil )).not_to be_valid
	end

	it "is invalid without amount" do 
	  expect(FactoryGirl.build(:invoice_item, amount: nil )).not_to be_valid
	end
	

end