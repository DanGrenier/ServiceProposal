class CreateProposalTemplates < ActiveRecord::Migration
  def change
    create_table :proposal_templates do |t|
    	t.integer :user_id
    	t.integer :service_type , default: 1
    	t.string :template_description
    end
  end
end
