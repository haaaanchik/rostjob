class AddHiringDateCorrectedToProposalEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :hiring_date_corrected, :boolean
  end
end
