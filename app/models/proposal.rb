class Proposal < ActiveRecord::Base
  #t.integer  "user_id"
  #t.integer  "service_type"
  #t.string   "business_name"
  #t.string   "address"
  #t.string   "address2"
  #t.string   "city"
  #t.string   "state"
  #t.string   "zip"
  #t.string   "phone"
  #t.string   "contact_first"
  #t.string   "contact_last"
  #t.string   "contact_email"
  #t.integer  "business_type"
  #t.decimal  "fee_tier1"
  #t.decimal  "fee_tier2"
  #t.decimal  "fee_tier3"
  #t.decimal  "actual_fee"
  #t.text     "proposal_text"
  #t.integer  "proposal_status"
  #t.datetime "created_at"
  #t.datetime "updated_at"

  belongs_to :user
  has_many :proposal_details, :dependent => :destroy
  #Make sure required fields are filled
  validates_presence_of :service_type, :message => "Please Choose a Proposal Type"
  validates_presence_of :business_name, :message => "Please Enter the Business Name"
  validates_presence_of :address, :message => "The Address Can't be Left Blank"
  validates_presence_of :city, :message => "Please Enter the City"
  validates_presence_of :state, :message => "Please Enter the State"
  validates_presence_of :proposal_status, :message => "Please Select a Proposal Status"
  validates_presence_of :contact_first, :message => "Please Enter the Contact First Name"
  validates_presence_of :business_type, :message => "Please Enter a Business Type For Statistical Purposes"
  validates_presence_of :fee_tier1, :message => "Please Enter Pricing for Tier 1"
  validates_presence_of :fee_tier2, :message => "Please Enter Pricing for Tier 2"
  validates_presence_of :fee_tier3, :message => "Please Enter Pricing for Tier 3"
  validates_numericality_of :fee_tier1, :message => "Please Enter a Valid Amount for Tier 1 Pricing"
  validates_numericality_of :fee_tier2, :message => "Please Enter a Valid Amount for Tier 2 Pricing"
  validates_numericality_of :fee_tier3, :message => "Please Enter a Valid Amount for Tier 3 Pricing"
  #Validates contact email with the proper RegEx
  validates :contact_email, :format => {:with => /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i ,:allow_blank => true, :message => 'must be a valid email'}
  #Validates the detail before we save the master
  validates_associated :proposal_details, :message => "There is an Issue in Proposal Detail"
  #Accepts attributes for the proposal detail so that everything can be submitted on the same form
  accepts_nested_attributes_for :proposal_details, :allow_destroy => :true
  
  #Return The Proposal Status Description 
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
      "Full Service"
    when 2 
      "Accounting"
    when 3
      "Tax"
    end
  end
  
  
  #Method that search through the proposals from the list view
  def self.search(search, user_id)
    if search
      where('user_id = ? and (lower(business_name) LIKE ?)',user_id, "%#{search.downcase}%")
    else
      where('user_id = ?',user_id)
    end
  end

  #Method that gets the last 5 proposals to show on the main page
  def self.get_recent_proposals(user_id)
    Proposal.where('user_id = ?',user_id).order('created_at DESC').limit(5)
  end

  #Method that builds a proposal detail based on a selected template
  def build_from_template(template_id)
    template_detail = ProposalTemplateDetail.get_detail(template_id)
    if template_detail.length > 0
      template_detail.each do |trans| 
        self.proposal_details.build(:service_id => trans.service_id, :tier1_applicable => trans.tier1_applicable , :tier2_applicable => trans.tier2_applicable, :tier3_applicable => trans.tier3_applicable)
      end
    end
  end
  
  #Method that builds a proposal detail from scratch
  def build_from_scratch(user_id)
    services = AvailableService.get_proposal_services(user_id)
    services.each do |srv|
      self.proposal_details.build(:service_id => srv.id)
    end
  end
end