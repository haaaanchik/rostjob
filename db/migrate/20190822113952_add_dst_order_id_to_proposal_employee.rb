class AddDstOrderIdToProposalEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :proposal_employees, :dst_order_id, :bigint
  end
end
