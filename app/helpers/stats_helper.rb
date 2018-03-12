module StatsHelper
  def get_proposals(user_id)
    Proposal.where('user_id = ?', user_id).count
  end

  def get_proposal_with_status(user_id, status)
    Proposal.where('user_id = ? and proposal_status = ?' , user_id, status).count
  end

  def get_proposal_avg_fee(user_id)
    Proposal.where('user_id = ? and proposal_status = ?',user_id, 1).average(:actual_fee) || 0.00
  end
    
end
