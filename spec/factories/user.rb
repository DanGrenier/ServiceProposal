require 'faker'

FactoryBot.define do
  factory :user do |f|
   f.email  {Faker::Internet.safe_email}
	 f.encrypted_password  {Faker::Internet.password}
	 f.business_name "My Accounting Firm"
   f.owner_first "Daniel"
   f.owner_last "Grenier"
   f.address "1243 some street"
   f.address2 "Suite 100"
   f.city "Athens"
   f.state "GA"
   f.zip_code "30606"
   f.phone "555 555-5555"
   f.website "https://www.myfirm.com"

  end
    
end
