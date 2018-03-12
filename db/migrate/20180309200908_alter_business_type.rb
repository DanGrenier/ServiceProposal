class AlterBusinessType < ActiveRecord::Migration
  def change
  	rename_column :business_types, :industry_codes, :industry_code
  end
end
