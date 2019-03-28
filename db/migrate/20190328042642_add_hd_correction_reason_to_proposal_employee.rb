class AddHdCorrectionReasonToProposalEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :hd_correction_reason, :text
  end
end
