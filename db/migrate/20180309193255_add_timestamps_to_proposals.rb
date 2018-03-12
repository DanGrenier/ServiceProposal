class AddTimestampsToProposals < ActiveRecord::Migration
  def change
  	add_column :proposals, :created_at, :datetime, null: false
  	add_column :proposals, :udated_at, :datetime, null: false
  end
end
