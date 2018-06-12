require 'faker'

FactoryBot.define do
  #Complete Factory to test validations
  factory :available_service do |r|
    r.user_id 1
    r.service_description "My Custom Service"
    r.service_type 1
    r.custom_service 1
  end
  
  #Factory with minimal set of attributes (as per filled in form)
  factory :available_service_form, class: AvailableService do |b|
    b.user_id 1
    b.service_description "My Custom Service"
    b.service_type 1
    b.custom_service 1
  end    

   
   factory :invalid_service_type, parent: :available_service do |f|
    f.service_type nil
   end


    factory :invalid_service_custom_flag, parent: :available_service do |f|
    f.custom_service nil
    
    end


end


