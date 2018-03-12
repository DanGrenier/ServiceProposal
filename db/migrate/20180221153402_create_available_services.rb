class CreateAvailableServices < ActiveRecord::Migration
  def change
    create_table :available_services do |t|
    	t.integer :user_id
    	t.string :service_description
    	t.integer :service_type, :default => 1
    	t.integer :custom_service, :default => 0
    end
  end
end
