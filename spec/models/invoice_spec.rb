require 'spec_helper'
require 'pp'

describe Invoice do

  before do 
    @franchise = FactoryGirl.create(:franchise)
  end
    
  
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryGirl.create(:invoice)).to be_valid
  end

    #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:invoice, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:invoice, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:invoice, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:invoice, office: nil )).not_to be_valid
	end

	it "is invalid without month" do  
	  expect(FactoryGirl.build(:invoice, month: nil )).not_to be_valid
	end 

	it "is invalid without year" do  
	  expect(FactoryGirl.build(:invoice, year: nil )).not_to be_valid	
    end
		
	it "is invalid without posted" do  
	  expect(FactoryGirl.build(:invoice, posted: nil )).not_to be_valid	
    end
	
	it "is invalid without date entered" do 
	  expect(FactoryGirl.build(:invoice, date_entered: nil )).not_to be_valid	
    end
  
  it "is invalid without invoice note" do 
    expect(FactoryGirl.build(:invoice, invoice_note: nil )).not_to be_valid 
    end

  #Test the remittance model methods
  describe "test the diffrent model methods" do 
    before :each do
      @invoice1 = FactoryGirl.create(:invoice, id:1)
      @invoice2 = FactoryGirl.create(:invoice,id: 2, invoice_note: 'Second invoice')
      @invoice3 = FactoryGirl.create(:invoice,id: 3, invoice_note: 'Third invoice', franchise_id: 2)
      @invoice4 = FactoryGirl.create(:invoice,id: 4, posted: 1 ,invoice_note: 'Fourth invoice')
      @invoice5 = FactoryGirl.create(:invoice,id: 5, posted: 1 ,invoice_note: 'Fifth invoice')
      @invoice6 = FactoryGirl.create(:invoice,id: 6, posted: 1 ,invoice_note: 'Sixth invoice', franchise_id: 2)
    end

    context "All Posted Invoices" do
      it "Should return 3" do
        expect(Invoice.get_all_posted(2016)).to include(@invoice4, @invoice5 , @invoice6)
      end

      it "Should return 0" do
        expect(Invoice.get_all_posted(2015)).to eq([])
      end
    end

    context 'Pending Invoices ' do
      it "Should return 2" do
        expect(Invoice.get_pending(1)).to include(@invoice1,@invoice2)
      end
        
      it "Should return 0" do
        expect(Invoice.get_pending(3)).to eq([])
      end
    end
      
    context 'Get Recent' do
      it "should return 2" do
        expect(Invoice.get_recent(1)).to include(@invoice4,@invoice5)
      end

      it "should return 1" do
        expect(Invoice.get_recent(2)).to include(@invoice6)
      end

      it "should return 0" do
        expect(Invoice.get_recent(3)).to eq([])
      end        
    end  
            
 
  end

end


 