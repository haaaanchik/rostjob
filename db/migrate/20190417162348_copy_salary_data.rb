class CopySalaryData < ActiveRecord::Migration[5.2]
  def up
    Order.find_each do |o|
      o.update_attribute(:salary, "#{o.salary_from} - #{o.salary_to}") unless o.salary
    end

    OrderTemplate.find_each do |ot|
      ot.update_attribute(:salary, "#{ot.salary_from} - #{ot.salary_to}") unless ot.salary
    end
  end

  def down; end
end
