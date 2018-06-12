require 'faker'


FactoryBot.define do


  factory :proposal_detail do |r|
    r.proposal_id 1
    r.service_id 1
    r.tier1_applicable 1
    r.tier2_applicable 1
    r.tier3_applicable 1
  end

end

