class CopyUrgencyLevelData < ActiveRecord::Migration[5.2]
  def up
    Order.find_each do |o|
      o.update_attribute(:urgency_level, o.urgency) unless o.urgency_level
    end

    OrderTemplate.find_each do |ot|
      ot.update_attribute(:urgency_level, ot.urgency) unless ot.urgency_level
    end
  end

  def down; end
end
