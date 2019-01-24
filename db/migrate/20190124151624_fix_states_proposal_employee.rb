class FixStatesProposalEmployee < ActiveRecord::Migration[5.2]
  def change
    ProposalEmployee.where(state: 'applyed').each { |i| i.update_attribute(:state, 'inbox') }
    ProposalEmployee.where(state: 'denied').each { |i| i.update_attribute(:state, 'deleted') }
  end
end
