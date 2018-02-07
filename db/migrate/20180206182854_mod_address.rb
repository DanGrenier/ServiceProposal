class ModAddress < ActiveRecord::Migration
  def change
  	rename_column :users, :adress2, :address2
  end
end
