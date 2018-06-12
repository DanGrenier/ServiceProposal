require 'spec_helper'
require 'pp'

describe DepositTracker do

  

	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryGirl.create(:deposit_tracker)).to be_valid
  end

    #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:deposit_tracker, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:deposit_tracker, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:deposit_tracker, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:deposit_tracker, office: nil )).not_to be_valid
	end

	it "is invalid without fran" do  
	  expect(FactoryGirl.build(:deposit_tracker, fran: nil )).not_to be_valid
	end 

  it "is invalid without year" do  
    expect(FactoryGirl.build(:deposit_tracker, year: nil )).not_to be_valid
  end 

  it "is invalid without month" do  
    expect(FactoryGirl.build(:deposit_tracker, month: nil )).not_to be_valid
  end 

  it "is invalid without deposit_date" do  
    expect(FactoryGirl.build(:deposit_tracker, deposit_date: nil )).not_to be_valid
  end 

	it "is invalid without date received" do 
	  expect(FactoryGirl.build(:deposit_tracker, date_received: nil )).not_to be_valid	
  end
	
  it "is invalid if an amount is negative" do 
    expect(FactoryGirl.build(:deposit_tracker, accounting: -1)).not_to be_valid
  end

it "is invalid if total deposit does not match sum of breakdown" do 
    expect(FactoryGirl.build(:deposit_tracker, accounting: 500)).not_to be_valid
  end


  #Test the remittance model methods
  describe "test the different list methods" do 
    before  do
      @frans = FactoryGirl.create_list(:franchise, 10)

      @one = FactoryGirl.create(:deposit_tracker, fran: @frans[0].franchise, accounting: 100, tax_prep: 300 )
      @two = FactoryGirl.create(:deposit_tracker, fran: @frans[0].franchise, tax_prep: 300, date_received: (DateTime.now + 1.days),deposit_date: (Date.today + 1.days), id:2, month: (Date.today.month))
      @three = FactoryGirl.create(:deposit_tracker, fran: @frans[0].franchise, tax_prep: 300, backwork: 100, date_received: (DateTime.now + 2.days),deposit_date: (Date.today + 2.days), id:3, month: (Date.today.month) )
      @four = FactoryGirl.create(:deposit_tracker, fran: @frans[0].franchise, tax_prep: 300,consulting: 100,date_received: (DateTime.now + 3.days),deposit_date: (Date.today + 3.days), id:4 , month:(Date.today.month))
      @five = FactoryGirl.create(:deposit_tracker, fran: @frans[0].franchise, tax_prep: 300, payroll: 100, date_received: (DateTime.now + 4.days),deposit_date: (Date.today + 4.days), id: 5 , month:(Date.today.month))
      @six = FactoryGirl.create(:deposit_tracker, fran: @frans[1].franchise, franchise_id: @frans[1].id, accounting: 100, id: 6)
      @seven = FactoryGirl.create(:deposit_tracker, fran: @frans[1].franchise, franchise_id: @frans[1].id,backwork: 100,date_received: DateTime.now + 1.days,deposit_date: (Date.today + 1.days), id: 7 , month:(Date.today.month))
    end

    context "Checking get latest method" do 
      it "should return a list of 5" do 
        expect(DepositTracker.get_latest(@frans[0].id,Date.today.year,Date.today.month)).to contain_exactly(@five, @four, @three, @two, @one)
      end
                       
        
      it "should return 0 pending because franchise 2 has none" do
        expect(DepositTracker.get_latest(@frans[2].id,Date.today.year,Date.today.month)).to eq([])
      end
    end

    context "Checking get_sum_by_category method" do 

      it "should return 1500 for tax_prep" do
        @res = DepositTracker.get_sum_by_category(@frans[0].id,Date.today.year,Date.today.month) 
        
        expect(@res[0].tax_prep).to eq(1500)
      end

    
    end
  end 
end