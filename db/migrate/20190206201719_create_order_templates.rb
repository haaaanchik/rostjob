class CreateOrderTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :order_templates do |t|
      t.string :name
      t.string :title
      t.text :specialization
      t.string :city
      t.integer :salary_from
      t.integer :salary_to
      t.text :description
      t.integer :warranty_period
      t.string :state
      t.references :profile, foreign_key: true
      t.integer :number_of_employees
      t.decimal :customer_price, precision: 10, scale: 2
      t.decimal :contractor_price, precision: 10, scale: 2
      t.integer :position_id
      t.decimal :customer_total, precision: 10, scale: 2
      t.decimal :contractor_total, precision: 10, scale: 2
      t.json :other_info
      t.string :skill
      t.string :experience
      t.string :district
      t.text :schedule
      t.string :work_period
      t.string :urgency
      t.integer :base_customer_price
      t.integer :base_contractor_price

      t.timestamps
    end
  end
end
