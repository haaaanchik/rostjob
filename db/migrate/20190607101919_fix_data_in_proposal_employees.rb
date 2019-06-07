class FixDataInProposalEmployees < ActiveRecord::Migration[5.2]
  def up
    ProposalEmployee.where(id: [246, 247, 248, 249]).update_all(arrival_date: Date.parse('2019-04-19'))
  end

  def down; end
end
