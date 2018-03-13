class ProposalMailer < ActionMailer::Base
#This Mailer generates the Proposal as PDF and attaches it to an email
  def email_proposal_to_prospect(proposal,current_user)
    Rails.logger.debug "BEFORE CALLING THE MAIL FUNCTION 2"
    @proposal = proposal
    @current_user = current_user   
    #Call the generate_site_notices method and store the returned object in an attachment
	attachments['service_proposal.pdf'] = ProposalDrawer.draw(proposal,current_user)
    Rails.logger.debug "BEFORE CALLING THE MAIL FUNCTION 3"
    #Mail it
    to_addresses = [proposal.contact_email]
    recipients = to_addresses.join(',')
    Rails.logger.debug "BEFORE CALLING THE MAIL FUNCTION"
	mail(from: current_user.proposal_setting.return_email, to: recipients, subject: 'Service Proposal' )
  end

end