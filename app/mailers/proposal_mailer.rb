class ProposalMailer < ActionMailer::Base
#This Mailer generates the Proposal as PDF and attaches it to an email
  def email_proposal_to_prospect(proposal,current_user)
    @proposal = proposal
    @current_user = current_user   
    #Call the generate_site_notices method and store the returned object in an attachment
	  attachments['service_proposal.pdf'] = ProposalDrawer.draw(proposal,current_user)
    #Correction to the mailer so that the email function works
    #even with fake email addresses such as user@example.com
    #The SMTP server used does an email validation prior to sendign
    #Switched to using an ENV variable to host my own email address so that
    #sending the proposal by email (in the staging environment always works)
    #to_addresses = [proposal.contact_email]
    to_addresses = [] 
    to_addresses << ENV["MAIL_RECIPIENT"]
    recipients = to_addresses.join(',')
	  mail(from: current_user.proposal_setting.return_email, to: recipients, subject: "Service Proposal from #{current_user.owner_first} #{current_user.owner_last}")
  end
end