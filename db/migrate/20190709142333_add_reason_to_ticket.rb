class AddReasonToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :reason, :string
  end
end
