class ChangeOrders < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :orders do |t|
        dir.up do
          t.remove :requirements_for_recruiters
          t.remove :stop_list
          t.change_default :warranty_period, 10
          t.json :other_info
          t.string :skill
          t.string :experience
          t.string :district
          t.text :schedule
          t.string :work_period
        end

        dir.down do
          t.text :requirements_for_recruiters
          t.text :stop_list
          t.change_default :warranty_period, nil
          t.remove :other_info
          t.remove :skill
          t.remove :experience
          t.remove :district
          t.remove :schedule
          t.remove :work_period
        end
      end
    end
  end
end
