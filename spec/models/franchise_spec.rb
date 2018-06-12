require 'spec_helper'
require 'pp'

describe Franchise do
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryGirl.create(:franchise)).to be_valid
  end

  #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:franchise, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:franchise, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:franchise, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:franchise, office: nil )).not_to be_valid
	end

  it "is invalid without franchise" do  
    expect(FactoryGirl.build(:franchise, franchise: nil )).not_to be_valid
  end


	it "is invalid without lastname" do  
	  expect(FactoryGirl.build(:franchise, lastname: nil )).not_to be_valid
	end 

	it "is invalid without firstname" do  
	  expect(FactoryGirl.build(:franchise, firstname: nil )).not_to be_valid	
  end
			

	#Test the several validate_presence and numericality 	
	it "is invalid if prior year rebate is less than zero" do
	  expect(FactoryGirl.build(:franchise, prior_year_rebate: -1)).not_to be_valid
	end

	it "is invalid if advanced rebate is less than zero" do
	  expect(FactoryGirl.build(:franchise, advanced_rebate: -1)).not_to be_valid
	end

  it "does not accept duplicate franchise" do 
    FactoryGirl.create(:franchise, franchise: "1")
    expect(FactoryGirl.build(:franchise, franchise: "1")).not_to be_valid
  end
        
    

  describe "test the diffrent methods" do 
    before do
      @fran1 = FactoryGirl.create(:franchise, id: 1 , franchise: '001' , firstname: 'Daniel',  lastname: 'Grenier', email: 'dgrenier@smallbizpros.com')
      @fran2 = FactoryGirl.create(:franchise, id: 2 , franchise: '002' , firstname: 'Brigitte',lastname: 'Blain', email: 'bblain@smallbizpros.com')
      @fran3 = FactoryGirl.create(:franchise, id: 3 , franchise: '003' , firstname: 'Donald',  lastname: 'Trump')
      @fran4 = FactoryGirl.create(:franchise, id: 4 , franchise: '004' , firstname: 'Hilary',  lastname: 'Clinton')
      @fran5 = FactoryGirl.create(:franchise, id: 5 , franchise: '005' , firstname: 'Martin',  lastname: 'Raymond')
    end

    context "Checking total active franchise method" do 
      it "Should return 5" do 
        expect(Franchise.total_active_franchise).to eq(5)
      end
    
    end

	  context "Checking the search function" do 
      it "Should return Grenier" do 
        expect(Franchise.search("Greni")).to contain_exactly(@fran1)
      end
    end

    context "Checking the get rebates method" do
    	it "should return 5 , 1000" do
    		expect(Franchise.get_rebates(@fran1.id).map{|u| [u.advanced_rebate, u.prior_year_rebate]}).to eq([[5.0,1000.0]])
     	end
    end

    context  "Checking Prior Year Balance" do
    	it "Should return 1000" do
     		expect(Franchise.get_prior_year_balance(@fran1.id)).to eq(1000)
     	end
    end

    context "Check Monthly Ranking" do 
      it "should return NA" do
       	expect(Franchise.get_monthly_ranking(@fran1.id,2016,1)).to eq("NA")
      end
    end

    context "Check YTD Ranking" do 
      it "should return NA" do
        expect(Franchise.get_ytd_ranking(@fran1.id,2016)).to eq("NA")
      end
    end

    context "Get Emails" do 
      it "should return dgrenier@smallbizpros.com" do
        expect(Franchise.get_email(@fran1.id)).to eq(@fran1.email)
      end

      it "should return bblain@smallbizpros.com" do
        expect(Franchise.get_email(@fran2.id)).to eq(@fran2.email)
      end
    end

    context "Get Numbers" do 
      it "should return 001" do
        expect(Franchise.get_number(@fran1.id)).to eq("001")
      end

      it "should return 002" do
        expect(Franchise.get_number(@fran2.id)).to eq("002")
      end
    end

    context "Get Last Name" do 
      it "should return Grenier" do
        expect(Franchise.get_lastname(@fran1.id)).to eq(@fran1.lastname)
      end

      it "should return Blain" do
        expect(Franchise.get_lastname(@fran2.id)).to eq(@fran2.lastname)
      end
    end

  end


end