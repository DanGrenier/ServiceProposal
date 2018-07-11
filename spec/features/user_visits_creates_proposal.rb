require 'spec_helper'
require 'pp'
RSpec.feature "User visits & creates proposal ", :js=>true do 
  before do 
    @user = create_logged_in_user
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
  
	end

  scenario "Should show the one template created" do 
  	visit root_path
    click_link "Proposals"
    click_link "New Proposal"
    expect(page.all("tbody tr").count).to eq(1)
    
  end

  scenario "Allows user to create from that template" do 
    visit root_path
    click_link "Proposals"
    click_link "New Proposal"
    first(:button, "Use This Template").click
    expect(page).to have_field('proposal_proposal_details_attributes_0_tier1_applicable', checked: true)
    expect(page).to have_field('proposal_proposal_details_attributes_0_tier2_applicable', checked: true)
    expect(page).to have_field('proposal_proposal_details_attributes_0_tier3_applicable', checked: true)
    expect(page).to have_field('proposal_proposal_details_attributes_2_tier1_applicable', checked: true)
    expect(page).to have_field('proposal_proposal_details_attributes_2_tier2_applicable', checked: true)
    expect(page).to have_field('proposal_proposal_details_attributes_2_tier3_applicable', checked: true)
    expect(page).to have_field('proposal_proposal_details_attributes_1_tier1_applicable', checked: false)
  end

  scenario "User can create and save Proposal from a template" do 
    visit root_path
    click_link "Proposals"
    click_link "New Proposal"
    first(:button, "Use This Template").click
    fill_in "proposal_business_name", :with => "My Business"
    fill_in "proposal_address", :with => "1234 some street"
    fill_in "proposal_city", :with => "Athens"
    fill_in "proposal_state", :with => "GA"
    fill_in "proposal_zip", :with => "30606"
    fill_in "proposal_contact_first", :with => "Joe"
    fill_in "proposal_contact_last", :with => "Smith"
    fill_in "proposal_contact_email", :with => "jsmith@mybusiness.com"
    select("Farming", :from => "proposal_business_type")
    fill_in "proposal_fee_tier1", :with => "100"
    fill_in "proposal_fee_tier2", :with => "200"
    fill_in "proposal_fee_tier3", :with => "300"
    click_button "Save"
    click_link "Proposals"
    click_link "Proposal History"
    expect(page.find(:xpath, './/table/tbody/tr[1]/td[3]').text).to eq("My Business")
    expect(page.find(:xpath, './/table/tbody/tr[1]/td[4]').text).to eq("Farming")
    expect(page.find(:xpath, './/table/tbody/tr[1]/td[5]').text).to eq("100.00 / 200.00 / 300.00")
        
    
  end

  
end

