require 'spec_helper'
require 'pp'
RSpec.feature "User visits Proposal Settings", :js=>true do 
  before do 
    @user = create_logged_in_user
  
	end

  scenario "Should display the default values from initial creation" do 
  	visit root_path
    click_link "Proposals"
    click_link "Settings"
    expect(find_field('proposal_setting_return_email').value).to eq @user.email
    expect(find_field('proposal_setting_tier1_name').value).to eq "BRONZE"
    expect(find_field('proposal_setting_tier2_name').value).to eq "SILVER"
    expect(find_field('proposal_setting_tier3_name').value).to eq "GOLD"
  end

  scenario "Should allow for a changes in proposal settings" do
    visit root_path
    click_link "Proposals"
    click_link "Settings"
    fill_in "proposal_setting_tier1_name", :with => "GOLD"
    fill_in "proposal_setting_tier2_name", :with => "PLATINIUM"
    fill_in "proposal_setting_tier3_name", :with => "DIAMOND"
    fill_in "proposal_setting_proposal_default_text", :with => "New Text"
    
    click_button "Save Changes"
    click_link "Proposals"
    click_link "Settings"
    expect(find_field('proposal_setting_tier1_name').value).to eq 'GOLD'
    expect(find_field('proposal_setting_tier2_name').value).to eq 'PLATINIUM'
    expect(find_field('proposal_setting_tier3_name').value).to eq 'DIAMOND'
    expect(find_field('proposal_setting_proposal_default_text').value).to eq 'New Text'
  end
end