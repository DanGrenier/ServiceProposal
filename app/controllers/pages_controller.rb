class PagesController < ApplicationController
  decorates_assigned :proposals
  skip_before_action :authenticate_user!, only: [:home]
  def home
    #If a user is signed in?
    if current_user
      #Check if their profile is complete
      @profile_incomplete =  current_user.profile_incomplete?
      #Get the stats specific to that user, total proposals, pending, accepted, dclined and average fee
      @tot_proposals = Proposal.all_proposals(current_user.id).count
      @pending_proposals = Proposal.proposal_with_status(current_user.id, 0).count
      @accepted_proposals = Proposal.proposal_with_status(current_user.id, 1).count
      @declined_proposals = Proposal.proposal_with_status(current_user.id, 2).count
      @average_fee = Proposal.average_fee(current_user.id)
      #Show a list of the last few proposals for quick reference
      @proposals = Proposal.recent_proposals(current_user.id)
    end
  end
end
