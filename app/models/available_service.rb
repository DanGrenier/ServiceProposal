class AvailableService < ActiveRecord::Base

  #t.integer "user_id"
  #t.string  "service_description"
  #t.string  "service_type"
  #t.string  "custom_service"
  

  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :service_description, :message => "Please enter a service description"
  validates_presence_of :service_type, :message => "Select service category"
    
  def self.get_proposal_services(user_id)
    AvailableService.where('(user_id = ? AND custom_service = 1) OR (user_id = ? AND custom_service = 0)',user_id, -1)
  end

  def self.get_desc_from_id(r_id)
    #Pre Fill the array to cache the information in order to speed up subsequent calls
    @services_by_id ||= AvailableService.select(:id,:service_description).map {|e| e.attributes.values}.inject({}) {|memo, misc| memo[misc[0]] = misc[1]; memo}
    return @services_by_id[r_id] if @services_by_id[r_id]
    result = AvailableService.select("service_description").where("id = ?", r_id)
    return @services_by_id[r_id] = result[0].service_description
  end
  
  def build_for_user(user_id)
    self.custom_service = 1
    self.service_type = 1
    self.user_id = user_id
  end

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


end