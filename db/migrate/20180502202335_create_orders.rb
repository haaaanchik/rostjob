class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :title
      t.text :specialization
      t.string :sity
      t.integer :salary_from
      t.integer :salary_to
      t.text :description
      t.string :commission
      t.string :payment_type
      t.integer :warranty_period
      t.integer :number_of_recruiters
      t.boolean :enterpreneurs_only
      t.text :requirements_for_recruiters
      t.text :stop_list
      t.boolean :accepted
      t.string :visibility
      t.string :state
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
