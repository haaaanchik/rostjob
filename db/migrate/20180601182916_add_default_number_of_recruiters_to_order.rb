class AddDefaultNumberOfRecruitersToOrder < ActiveRecord::Migration[5.2]
  def change
    change_column_default :orders, :number_of_recruiters, 1
  end
end
