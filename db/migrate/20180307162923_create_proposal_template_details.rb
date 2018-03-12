class CreateProposalTemplateDetails < ActiveRecord::Migration
  def change
    create_table :proposal_template_details do |t|
    	t.integer :proposal_template_id
    	t.integer :available_service_id
    	t.integer :tier1_applicable, :default => 0
    	t.integer :tier2_applicable, :default => 0
    	t.integer :tier3_applicable, :default => 0

    end
  end
end
