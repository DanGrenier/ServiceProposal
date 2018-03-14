class PagesController < ApplicationController
  include StatsHelper  
  def home
    #If a user is signed in?
    if current_user
      #Check if their profile is complete
      @profile_incomplete =  current_user.profile_incomplete?
      #Get the stats specific to that user, total proposals, pending, accepted, dclined and average fee
      @tot_proposals = get_proposals(current_user.id)
      @pending_proposals = get_proposal_with_status(current_user.id, 0)
      @accepted_proposals = get_proposal_with_status(current_user.id, 1)
      @declined_proposals = get_proposal_with_status(current_user.id, 2)
      @average_fee = get_proposal_avg_fee(current_user.id)
      #Show a list of the last few proposals for quick reference
      @recent = Proposal.get_recent_proposals(current_user.id)
    end
  end
end
