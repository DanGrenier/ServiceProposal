require 'faker'


FactoryBot.define do

  factory :proposal do |r|
  r.id 1
  r.user_id 1
  r.service_type 1
  r.business_name "John Audio"
  r.address "1234 some street"
  r.address2 "Suite 160"
  r.city "Athens"
  r.state "GA"
  r.zip "30606"
  r.phone "555 555-5555"
  r.contact_first "John"
  r.contact_last "Anderson"
  r.contact_email "janderson@johnaudio.com"
  r.business_type 1
  r.fee_tier1 200.00
  r.fee_tier2 250.00
  r.fee_tier3 300.00
  r.actual_fee 0.00
  r.proposal_text "Thank you for meeting with me. Here is your proposal"
  r.proposal_status 0

  factory :proposal_with_detail do 
    after(:create) do |proposal| 
      create_list(:proposal_detail, 3 , proposal: proposal)
    end
    
  end
end


end

