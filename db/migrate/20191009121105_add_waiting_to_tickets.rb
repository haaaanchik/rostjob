class AddWaitingToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :waiting, :string

    Ticket.all.each do |ticket|
      ticket.update_attribute(:waiting, ticket.user.profile.profile_type)
    end
  end
end
