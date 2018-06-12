require 'spec_helper'
require 'pp'

describe Remittance do


  before do 
    @fran1 = FactoryGirl.create(:franchise, id: 1 , franchise: '001' , lastname: 'Grenier')
         @fran2 = FactoryGirl.create(:franchise, id: 2 , franchise: '002' , lastname: 'Blain')
         @fran3 = FactoryGirl.create(:franchise, id: 3 , franchise: '003' , lastname: 'Trump')
         @fran4 = FactoryGirl.create(:franchise, id: 4 , franchise: '004' , lastname: 'Clinton')
         @fran5 = FactoryGirl.create(:franchise, id: 5 , franchise: '005' , lastname: 'Raymond')
  end
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryGirl.create(:remittance)).to be_valid
    end

    #Test validation of missing values that dont allow null
	it "is invalid without area" do 
	  expect(FactoryGirl.build(:remittance, area: nil )).not_to be_valid
	end

	it "is invalid without master" do 
	  expect(FactoryGirl.build(:remittance, mast: nil )).not_to be_valid
	end
	
	it "is invalid without region" do  
	  expect(FactoryGirl.build(:remittance, region: nil )).not_to be_valid
	end

	it "is invalid without office" do  
	  expect(FactoryGirl.build(:remittance, office: nil )).not_to be_valid
	end

	it "is invalid without month" do  
	  expect(FactoryGirl.build(:remittance, month: nil )).not_to be_valid
	end 

	it "is invalid without year" do  
	  expect(FactoryGirl.build(:remittance, year: nil )).not_to be_valid	
    end
		
	it "is invalid without posted" do  
	  expect(FactoryGirl.build(:remittance, posted: nil )).not_to be_valid	
    end
	
	it "is invalid without date received" do 
	  expect(FactoryGirl.build(:remittance, date_received: nil )).not_to be_valid	
    end

	it "is valid if not posted and checkbox not checked" do 
    expect(FactoryGirl.build(:remittance, posted: 0 , accept_flag: 0)).to be_valid
  end

  it "is invalid if posted and checkbox not checked" do 
    expect(FactoryGirl.build(:remittance, posted: 1 , accept_flag: 0)).not_to be_valid
  end

  it "is valid if posted and checkbox checked" do 
    expect(FactoryGirl.build(:remittance, posted: 1 , accept_flag: 1)).to be_valid
  end

	#Test the several validate_presence and numericality 	
	it "is invalid if credit 1 entered but no credit 1 desc" do
	  expect(FactoryGirl.build(:remittance, credit1: 100 , credit1_desc: 0)).not_to be_valid
	end	

  it "is invalid if credit 1 entered and credit 1 desc is 99" do 
    expect(FactoryGirl.build(:remittance, credit1: 100 , credit1_desc: 99)).not_to be_valid
  end

  it "is valid if credit 1 entered and credit 1 desc is 98" do 
    expect(FactoryGirl.build(:remittance, credit1: 100 , credit1_desc: 98)).to be_valid
  end

	it "is valid if credit 1 entered and credit 1 desc is zero or more" do 
  	  expect(FactoryGirl.build(:remittance, credit1: 100 , credit1_desc: 1)).to be_valid
	end
	
    it "is invalid if credit 2 entered but no credit 2 desc" do
	  expect(FactoryGirl.build(:remittance, credit2: 100 , credit2_desc: 0)).not_to be_valid
	end	

	it "is valid if credit 2 entered and credit 2 desc is zero or more" do 
  	  expect(FactoryGirl.build(:remittance, credit2: 100 , credit2_desc: 1)).to be_valid
	end

	it "is invalid if credit 3 entered but no credit 3 desc" do
	  expect(FactoryGirl.build(:remittance, credit3: 100 , credit3_desc: 0)).not_to be_valid
	end	

	it "is valid if credit 3 entered and credit 3 desc is zero or more" do 
  	  expect(FactoryGirl.build(:remittance, credit3: 100 , credit3_desc: 1)).to be_valid
	end

    it "is invalid if credit 4 entered but no credit 4 desc" do
	  expect(FactoryGirl.build(:remittance, credit4: 100 , credit4_desc: nil)).not_to be_valid
	end	

	it "is valid if credit 4 entered and credit 4 desc is filled ine" do 
  	  expect(FactoryGirl.build(:remittance, credit4: 100 , credit4_desc: 'test')).to be_valid
	end

  it "is invalid if a credit is used more than once" do 
     expect(FactoryGirl.build(:remittance, credit1_desc: 1 , credit2_desc: 1)).not_to be_valid
  end

	

  it "does not accept duplicate year, month for the same franchise id" do 
    FactoryGirl.create(:remittance)
    expect(FactoryGirl.build(:remittance , id: 2)).not_to be_valid
  end

  it "is invalid if the prior year rebate amount is bigger than what is available" do 
    
    expect(FactoryGirl.build(:remittance, franchise_id: 1, credit1_desc: 2 , credit1: 5000, posted: 1, date_posted: DateTime.now)).not_to be_valid
  end

  it "is valid if the prior year rebate amount is smaller or equal than what is available" do 
    
    expect(FactoryGirl.build(:remittance, franchise_id: 1, credit1_desc: 2 , credit1: 1000)).to be_valid
  end

  it "Is invalid if the same credit is used more than once" do
    
    expect(FactoryGirl.build(:remittance, credit1: 100 , credit1_desc: 1, credit2: 100, credit2_desc: 1)).not_to be_valid
  end


   #Test the remittance model methods
    describe "test the diffrent list methods" do 
      before do
        @january = FactoryGirl.create(:remittance, franchise_id: @fran1.id , fran: @fran1.franchise,  posted: 1, accounting: 100 , backwork: 200, accept_flag: 1, date_posted: DateTime.now)
        @february = FactoryGirl.create(:remittance,franchise_id: @fran1.id , fran: @fran1.franchise,  month: 2, id:2, posted: 1, date_posted: DateTime.now, credit1: 200 , credit1_desc: 1 ,  credit2:100 , credit2_desc: 2, accept_flag: 1)
        @march = FactoryGirl.create(:remittance, franchise_id: @fran1.id , fran: @fran1.franchise,month:3, id:3, posted: 1,date_posted: DateTime.now, accept_flag: 1, late_flag: 1 , late_fees: 200)
        @april = FactoryGirl.create(:remittance, franchise_id: @fran1.id , fran: @fran1.franchise,month:4, id:4, posted: 0)
        @may = FactoryGirl.create(:remittance, franchise_id: @fran1.id , fran: @fran1.franchise,month:5, id:5, posted: 0,credit1: 200 , credit1_desc: 1 ,  credit2:100 , credit2_desc: 2)
        @june = FactoryGirl.create(:remittance, franchise_id: @fran2.id , fran: @fran2.franchise, month:6, id:6, posted: 1,date_posted: DateTime.now, accept_flag: 1)
        @july = FactoryGirl.create(:remittance, franchise_id: @fran2.id , fran: @fran2.franchise,month:7, id:7, posted: 0)
        @august = FactoryGirl.create(:remittance, franchise_id: @fran3.id , fran: @fran3.franchise, month:8, id:8, posted: 1, date_posted: DateTime.now,accept_flag: 1)
        @sept = FactoryGirl.create(:remittance, franchise_id: @fran3.id , fran: @fran3.franchise, month:9, id:9, posted: 1, date_posted: DateTime.now,accept_flag: 1)
        @oct = FactoryGirl.create(:remittance, franchise_id: @fran4.id , fran: @fran4.franchise,month:10, id:10, posted: 0)
        @nov = FactoryGirl.create(:remittance, franchise_id: @fran4.id , fran: @fran4.franchise, month:11, id:11, posted: 0)
        @dec = FactoryGirl.create(:remittance, franchise_id: @fran1.id , fran: @fran1.franchise,month:12, id:12, posted: 1,date_posted: DateTime.now, accept_flag: 1)
      end



        context "Checking total remittance method" do 
          it "Should return 300" do 
            expect(@january.get_total_collect).to eq(300)
          end
        end

        context "Checking Credit total method" do 
          it "Should return 300" do 
            expect(@february.get_total_credits).to eq(300)
          end
        end

        context "Checking fees total method" do 
          it "Should return 200" do
            expect(@march.get_total_charges).to eq(200)
          end
        end

        

        context "Pending Remittances" do
            it "should return 2 pending" do 
              expect(Remittance.get_pending(@fran1)).to include(@april, @may)
            end
                       
        
            it "should return 0 pending because franchise 2 has none" do
              
              expect(Remittance.get_pending(@fran3)).to eq([])
            end
         end
        

        context "Confirmed Remittances" do 
            it "Should return 3 confirmed" do  
              expect(Remittance.get_recent(@fran1)).to include(@january, @february, @march, @dec)
            end
        
        
            it "Should return 0 confirmed" do
              expect(Remittance.get_recent(@fran4)).to eq([])
            end
        end

        context "Latest Remittances (confirmed or not)" do 
            it "Should return 5 remittances" do 
              expect(Remittance.get_latest(@fran1,10)).to include(@january,@february,@march,@april,@may,@dec) 
            end  
        
        
            it "Should return 2 remittances" do 
              expect(Remittance.get_latest(@fran3,10)).to include(@august, @sept)    
                
            end
        end

        context "History of Remittances" do
          it "Should return the proper result of year and months" do 
            expect(Remittance.get_history(@fran1).map {|u| [u.year,u.month]}).to eq([[2017,1], [2017,2],[2017,3],[2017,4],[2017,5],[2017,12]]) 
            
          end
        end

        context "Should add rows to the receivable and franchise credit tables" do
          it "Should add 1 to Receivable" do
            expect{
              @may.posted = 1
              @may.accept_flag = 1
              @may.date_posted = DateTime.now
              @may.save}.to change(Receivable, :count).by(1)
          end

          it "Should add 2 to franchise credits" do
            expect{
              @may.posted = 1
              @may.accept_flag = 1
              @may.date_posted = DateTime.now
              @may.save}.to change(FranchiseCredit, :count).by(2)
          end

          it "Should log remittance in the site_notice table" do 
             expect{
              @may.posted = 1
              @may.accept_flag = 1
              @may.date_posted = DateTime.now
              @may.save}.to change(SiteNotice, :count).by(1)
          end

            
          
        end
        
    
    end




    

end