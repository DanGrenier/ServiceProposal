class Proposal < ActiveRecord::Base
  belongs_to :user
  has_many :proposal_details, :dependent => :destroy
  validates_presence_of :service_type, :message => "Proposal Type can't be blank"
  validates_presence_of :business_name, :message => "Business Name can't be blank"
  validates_presence_of :address, :message => "Address can't be blank"
  validates_presence_of :city, :message => "City can't be blank"
  validates_presence_of :state, :message => "State can't be blank"
  validates_presence_of :proposal_status, :message => "Select the proposal status"
  validates_presence_of :contact_first, :message => "Contact First Name can't be blank"
  validates_presence_of :business_type, :message => "Business Type can't be blank"
  validates_presence_of :fee_tier1, :message => "Please enter Tier 1 Pricing"
  validates_presence_of :fee_tier2, :message => "Please enter Tier 2 Pricing"
  validates_presence_of :fee_tier3, :message => "Please enter Tier 3 Pricing"
  validates_numericality_of :fee_tier1, :message => "Invalid amount in Tier 1 pricing"
  validates_numericality_of :fee_tier2, :message => "Invalid amount in Tier 2 pricing"
  validates_numericality_of :fee_tier3, :message => "Invalid amount in Tier 3 pricing"
  validates_associated :proposal_details, :message => "Detail is invalid"
  
  accepts_nested_attributes_for :proposal_details, :allow_destroy => :true
  

  def status_desc
    case self.proposal_status
    when 0
      'Pending'
    when 1
      'Accepted'
    when 2
      'Declined'
    end
  end
  
  def service_type_desc
    case self.service_type
      when 1 
        'Full service'
      when 2
        'Accounting'  
      when 3 
        'Tax'  
    end
  end

  #Method that search through the proposals
  def self.search(search, user_id)
    if search
      where('user_id = ? and (lower(business_name) LIKE ?)',user_id, "%#{search.downcase}%")
    else
      where('user_id = ?',user_id)
    end
  end

  def self.get_recent_proposals(user_id)
    Proposal.where('user_id = ?',user_id).order('created_at DESC').limit(5)
  end


  def build_from_template(template_id)
    template_detail = ProposalTemplateDetail.get_detail(template_id)
    if template_detail.length > 0
      template_detail.each do |trans| 
        self.proposal_details.build(:service_id => trans.service_id, :tier1_applicable => trans.tier1_applicable , :tier2_applicable => trans.tier2_applicable, :tier3_applicable => trans.tier3_applicable)
      end
    end
  end

  def build_from_scratch(user_id)
    services = AvailableService.get_proposal_services(user_id)
    services.each do |srv|
      self.proposal_details.build(:service_id => srv.id)
    end
  end
end