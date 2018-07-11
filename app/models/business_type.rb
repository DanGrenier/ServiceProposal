class BusinessType < ActiveRecord::Base
  validates_presence_of :industry_code, :description

  #Method that returns a business type description based on the id
  def self.get_desc_from_id(r_id)
    #Pre Fill the array to cache the information in order to speed up subsequent calls
    @code_by_id ||= BusinessType.select(:id,:description).map {|e| e.attributes.values}.inject({}) {|memo, misc| memo[misc[0]] = misc[1]; memo}
    return @code_by_id[r_id] if @code_by_id[r_id]
    result = BusinessType.select("description").where("id = ?", r_id)
    return @code_by_id[r_id] = result[0].description
  end

end


