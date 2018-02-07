class AddZipToUser < ActiveRecord::Migration
  def change
  	add_column :users, :zip_code, :string, default: "", null: false
  end
end
