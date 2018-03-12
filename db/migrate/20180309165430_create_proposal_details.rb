class CreateProposalDetails < ActiveRecord::Migration
  def change
    create_table :proposal_details do |t|
      t.integer :proposal_id 
      t.integer :service_id
      t.integer :tier1_applicable
      t.integer :tier2_applicable
      t.integer :tier3_applicable
    end
  end
end
