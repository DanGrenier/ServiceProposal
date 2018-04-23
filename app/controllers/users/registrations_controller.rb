class Users::RegistrationsController < Devise::RegistrationsController


 #This is the overwritten controller (inheriting) for Devise new registrations
 def new
  super do |resource| 
    
  end
  
 end
 
 
end