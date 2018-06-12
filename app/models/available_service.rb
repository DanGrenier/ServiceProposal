class AvailableService < ActiveRecord::Base
  
  #t.integer "user_id"
  #t.string  "service_description"
  #t.string  "service_type"
  #t.string  "custom_service"
  
  belongs_to :user
  

  before_destroy :check_for_proposals

  validates_presence_of :user_id
  validates_presence_of :service_description, :message => "Please Enter a Service Description"
  validates_presence_of :service_type, :message => "Please Select a Service Category"
  validates_presence_of :custom_service
  
  #Method that returns all proposal services (standard ones and custom ones for current user)  
  def self.get_proposal_services(user_id)
    AvailableService.where('(user_id = ? AND custom_service = 1) OR (user_id = ? AND custom_service = 0)',user_id, -1)
  end

  #Method that returns description from the internal available service id
  #Building the description in an array for quick access in the views when needed
  def self.get_desc_from_id(r_id)
    #Pre Fill the array to cache the information in order to speed up subsequent calls
    @services_by_id ||= AvailableService.select(:id,:service_description).map {|e| e.attributes.values}.inject({}) {|memo, misc| memo[misc[0]] = misc[1]; memo}
    return @services_by_id[r_id] if @services_by_id[r_id]
    result = AvailableService.select("service_description").where("id = ?", r_id)
    Rails.logger.debug "RESULT: #{result}"
    return @services_by_id[r_id] = (result[0].service_description if result.length > 0) || "Undefined Service" 
  end
  
  #Build a default proposal service for a user
  def build_for_user(user_id)
    self.custom_service = 1
    self.service_type = 1
    self.user_id = user_id
  end

  #Method that returns a description for the service type (which is integer in the database)
  def get_service_type_desc
    case self.service_type
      when 1
        'Both'
      when 2
        'Accounting'
      when 3
        'Tax'
    end
  end

  private 
    def check_for_proposals
      if ProposalDetail.where("service_id = ?", self.id).length > 0
        errors.add(:base,"You can't delete a service once it's been used in a proposal")
        return false
      end
    end



end