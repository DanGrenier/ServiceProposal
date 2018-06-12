require 'faker'


FactoryBot.define do
	factory :proposal_setting do |r|
    r.user_id "1"
    r.return_email "dgrenier@smallbizpros.com"
    r.tier1_name "SILVER"
    r.tier2_name "GOLD"
    r.tier3_name "PLATINIUM"
    r.proposal_default_text "Thank you for meeting with me"
    
    end


   factory :invalid_setting_tier1_name, parent: :proposal_setting do |f|
    f.tier1_name nil
   end

   factory :invalid_setting_tier2_name, parent: :proposal_setting do |f|
    f.tier2_name nil
   end

   factory :invalid_setting_tier3_name, parent: :proposal_setting do |f|
    f.tier3_name nil
   end

   factory :invalid_email, parent: :proposal_setting do |f|
    f.return_email = "potatoe.potato"
   end




end


