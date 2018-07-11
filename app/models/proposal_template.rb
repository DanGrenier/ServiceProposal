class ProposalTemplate < ActiveRecord::Base
  #t.integer "user_id"
  #t.integer "service_type"
  #t.string  "template_description"
  belongs_to :user
  has_many :proposal_template_details, :dependent => :destroy
  #Accepts attributes for the detail so we can have everything on the same form
  accepts_nested_attributes_for :proposal_template_details, :allow_destroy => :true
  validates_associated :proposal_template_details, :message => "There was an Issue Saving the Template Detail"
  #Make sure required fields have values
  validates_presence_of :service_type, :message => "Please Enter a Template Type"
  validates_presence_of :template_description, :message => "Please Provide a Template Description"

  def build_detail_for_user(user_id)
  	services = AvailableService.get_proposal_services(user_id)
    services.each do |srv|
      self.proposal_template_details.build(:service_id => srv.id)
    end
  end

  def service_type_desc
  	case self.service_type
  	  when 1 
  	  	'Full Service'
  	  when 2
  	    'Accounting'	
  	  when 3 
  	    'Tax'  
    end
  end
end