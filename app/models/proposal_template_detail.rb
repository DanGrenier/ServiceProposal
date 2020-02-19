class ProposalTemplateDetail < ActiveRecord::Base
  belongs_to :proposal_template
  scope :from_template, -> (template_id) {where('proposal_template_id = ?', template_id)}

end