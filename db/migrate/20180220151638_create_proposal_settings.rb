class CreateProposalSettings < ActiveRecord::Migration
  def change
    create_table :proposal_settings do |t|
    	t.integer :user_id
    	t.string :return_email
    	t.string :tier1_name
    	t.string :tier2_name
    	t.string :tier3_name
    	t.string :proposal_default_text
    end

    add_index(:proposal_settings, [:user_id], unique:true, name:'proposal_settings_index')
  end
end
