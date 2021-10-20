class AddFoodNutritionAndHousingColumnToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :order_templates, :food_nutrition, :boolean, null: false, default: false
    add_column :order_templates, :housing, :boolean, null: false, default: false
    add_column :orders, :food_nutrition, :boolean, null: false, default: false
    add_column :orders, :housing, :boolean, null: false, default: false
  end
end
