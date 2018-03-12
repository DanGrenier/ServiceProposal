class CreateBusinessTypes < ActiveRecord::Migration
  def change
    create_table :business_types do |t|
      t.string :industry_codes
      t.string :description	
    end
  end
end
