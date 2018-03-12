class ProposalDrawer

def self.draw(proposal, current_user)
  report = Thinreports::Report.new layout: File.join(Rails.root,'app','reports','service_proposal.tlf')
  
  
  report.start_new_page do |page|  
    page.item(:business_name).value(proposal.business_name)
    page.item(:contact_name).value(proposal.contact_first+" "+proposal.contact_last)
    page.item(:address).value(proposal.address)
    if proposal.address2.blank?
      page.item(:address2).value(proposal.city + ","+proposal.state+", "+proposal.zip)
    else
      page.item(:address2).value(proposal.address2)
      page.item(:city_state_zip).value(proposal.city + ","+proposal.state+", "+proposal.zip)
    end
    page.item(:proposal_text).value(proposal.proposal_text)

    page.item(:office_owner).value(current_user.owner_first + " "+current_user.owner_last)
    page.item(:office_address).value(current_user.address)
    if !current_user.address2.blank?
      page.item(:office_address2).value(current_user.address2)
      page.item(:office_city_state_zip).value(current_user.city+", "+  current_user.state+", "+ current_user.zip_code)
    else
      page.item(:office_address2).value(current_user.city+", "+  current_user.state+", "+ current_user.zip_code)
      page.item(:office_city_state_zip).value("")
    end
    page.item(:office_phone).value(current_user.phone)
    page.item(:office_email).value(current_user.email)
    page.item(:tier1_name).value(current_user.proposal_setting.tier1_name)
    page.item(:tier2_name).value(current_user.proposal_setting.tier2_name)
    page.item(:tier3_name).value(current_user.proposal_setting.tier3_name)

    page.item(:fee_tier1).value(ActiveSupport::NumberHelper.number_to_currency(proposal.fee_tier1, precision: 2))
    page.item(:fee_tier2).value(ActiveSupport::NumberHelper.number_to_currency(proposal.fee_tier2, precision: 2))
    page.item(:fee_tier3).value(ActiveSupport::NumberHelper.number_to_currency(proposal.fee_tier3, precision: 2))
    proposal.proposal_details.where('tier1_applicable = 1').each do |t1|
      report.page.list(:tier1_list).add_row do |row|
        row.values tier1_service: AvailableService.get_desc_from_id(t1.service_id)
      end
    end
      
    proposal.proposal_details.where('tier2_applicable = 1').each do |t2|
      report.page.list(:tier2_list).add_row do |row|
        row.values tier2_service: AvailableService.get_desc_from_id(t2.service_id)
      end
    end

    proposal.proposal_details.where('tier3_applicable =1').each do |t3|
      report.page.list(:tier3_list).add_row do |row|
        row.values tier3_service: AvailableService.get_desc_from_id(t3.service_id)
      end
    end
  end
  

  
  report.generate

end


end
