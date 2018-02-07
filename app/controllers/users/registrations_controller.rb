class Users::RegistrationsController < Devise::RegistrationsController


 #This is the overwritten controller (inheriting) for Devise new registrations
 def new
  super do |resource| 
    #Instead of passing the email account to the new registration as a parameter
    #We use the franchise id to re-query the info from the database
    #This comes from being affraid someone could inject a franchise id and email address
    #and register with erroneous, fraudulous information
    #@fran = Franchise.find(params[:id])
  end
  
 end
 
 

 
 
 
end