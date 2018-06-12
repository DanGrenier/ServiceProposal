require 'spec_helper'
require 'pp'

describe ProposalTemplateDetail do

 
	#Testing validity of the factory
	it "has a valid factory" do 
	  expect(FactoryBot.create(:proposal_template_detail)).to be_valid
  end
  

end


 