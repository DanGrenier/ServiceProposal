class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
    	t.integer :user_id
    	t.integer :service_type
    	t.string :business_name
    	t.string :address
    	t.string :address2
    	t.string :city
    	t.string :state
    	t.string :zip
    	t.string :phone
    	t.string :contact_first
    	t.string :contact_last
    	t.string :contact_email
    	t.integer :business_type
    	t.decimal :fee_tier1 , :precision => 8 , :scale => 2, :default => 0.00
    	t.decimal :fee_tier2 , :precision => 8 , :scale => 2, :default => 0.00
    	t.decimal :fee_tier3 , :precision => 8 , :scale => 2, :default => 0.00
    	t.decimal :actual_fee, :precision => 8 , :scale => 2, :default => 0.00
    	t.text :proposal_text
    	t.integer :proposal_status
    end
  end
end
