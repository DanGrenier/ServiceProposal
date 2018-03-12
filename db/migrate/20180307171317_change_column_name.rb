class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :proposal_template_details, :available_service_id, :service_id
  end
end
