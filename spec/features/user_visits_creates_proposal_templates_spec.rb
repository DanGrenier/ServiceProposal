require 'spec_helper'
require 'pp'
RSpec.feature "User visits Proposal Templates", :js=>true do 
  before do 
    @user = create_logged_in_user
  
	end

  scenario "Should show no templates by default" do 
  	visit root_path
    click_link "Proposals"
    click_link "Proposal Templates"
    expect(page.all("tbody tr").count).to eq(0)
    
    
  end

  scenario "Allows user to enter their own template" do 
    visit root_path
    click_link "Proposals"
    click_link "Proposal Templates"
    click_button "Create Template"
    fill_in "proposal_template_template_description", :with => "My Custom Template"
    find('label[for=proposal_template_proposal_template_details_attributes_0_tier1_applicable]').click
    find('label[for=proposal_template_proposal_template_details_attributes_0_tier2_applicable]').click
    find('label[for=proposal_template_proposal_template_details_attributes_0_tier3_applicable]').click
    find('label[for=proposal_template_proposal_template_details_attributes_2_tier1_applicable]').click
    find('label[for=proposal_template_proposal_template_details_attributes_2_tier2_applicable]').click
    find('label[for=proposal_template_proposal_template_details_attributes_2_tier3_applicable]').click
    click_button "Save"
    click_link "Proposals"
    click_link "Proposal Templates"
    expect(page.all("tbody tr").count).to eq(1)
        
    
  end

  
end