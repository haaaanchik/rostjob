class CreateJoinTableSpecializationPosition < ActiveRecord::Migration[5.2]
  def change
    create_join_table :specializations, :positions do |t|
      t.index :specialization_id
      t.index :position_id
    end
  end
end
