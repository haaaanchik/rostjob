class CreateWithdrawalMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :withdrawal_methods do |t|
      t.string :type
      t.references :profile, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
