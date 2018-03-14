class ProposalTemplateDetail < ActiveRecord::Base
  belongs_to :proposal_template

  def self.get_detail(template_id)    
  	where('proposal_template_id = ?', template_id)
  end

end