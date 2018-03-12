class BusinessType < ActiveRecord::Base


validates_presence_of :industry_code, :description

def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      BusinessType.create(row.to_hash)
    end
end

#Method that returns a misc charge description based on ID
def self.get_desc_from_id(r_id)
	#Pre Fill the array to cache the information in order to speed up subsequent calls
	@code_by_id ||= BusinessType.select(:id,:description).map {|e| e.attributes.values}.inject({}) {|memo, misc| memo[misc[0]] = misc[1]; memo}
	return @code_by_id[r_id] if @code_by_id[r_id]
	result = BusinessType.select("description").where("id = ?", r_id)
	return @code_by_id[r_id] = result[0].description
end





end


