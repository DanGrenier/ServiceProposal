require 'faker'

FactoryBot.define do
  factory :proposal_template do |r|
    r.id 1
    r.user_id 1
    r.service_type 1
    r.template_description "All Around Template"
    
    factory :proposal_template_with_detail do 
      after(:create) do |proposal_template|
        create_list(:proposal_template_detail, 3, proposal_template: proposal_template)
      end
    
    end
  end

  


  factory :invalid_template, parent: :proposal_template do |f|
    f.service_type nil
  end

  factory :invalid_template_desc, parent: :proposal_template do |f|
    f.template_description nil
  end

  
    
    
  
end