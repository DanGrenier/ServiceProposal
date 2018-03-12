class AddDefaultToProposalDetail < ActiveRecord::Migration
  def change
  	change_column :proposal_details, :tier1_applicable, :integer, :defauilt=>0
  	change_column :proposal_details, :tier2_applicable, :integer, :defauilt=>0
  	change_column :proposal_details, :tier3_applicable, :integer, :defauilt=>0
  end
end
