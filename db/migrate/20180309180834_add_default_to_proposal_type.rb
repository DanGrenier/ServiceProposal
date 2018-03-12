class AddDefaultToProposalType < ActiveRecord::Migration
  def change
  	change_column :proposals , :service_type, :integer, :default => 1
  end
end
