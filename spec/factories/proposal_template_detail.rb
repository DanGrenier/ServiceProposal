require 'faker'

FactoryBot.define do
  factory :proposal_template_detail do |r|
    r.proposal_template_id 1
    r.service_id 1
    r.tier1_applicable 1
    r.tier2_applicable 1
    r.tier3_applicable 1
  end

  factory :proposal_template_detail_form, class: ProposalTemplateDetail do |c|
    c.service_id 1
    c.tier1_applicable 1
    c.tier2_applicable 1
    c.tier3_applicable 1
  end
  

  
end