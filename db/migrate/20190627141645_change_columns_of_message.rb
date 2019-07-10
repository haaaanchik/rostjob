class ChangeColumnsOfMessage < ActiveRecord::Migration[5.2]
  def up
    remove_reference(:messages, :proposal, index: true)
    add_reference(:messages, :ticket, index: true)
  end

  def down
    add_reference(:messages, :proposal, index: true)
    remove_reference(:messages, :ticket, index: true)
  end
end
