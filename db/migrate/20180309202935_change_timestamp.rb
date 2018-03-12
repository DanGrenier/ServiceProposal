class ChangeTimestamp < ActiveRecord::Migration
  def change
  	rename_column :proposals, :udated_at, :updated_at
  end
end
