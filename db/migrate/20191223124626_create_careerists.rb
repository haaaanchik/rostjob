class CreateCareerists < ActiveRecord::Migration[5.2]
  def change
    create_table :careerists do |t|
      t.string  :title
      t.json    :query_params
      t.boolean :active

      t.timestamps
    end

    add_column :employee_cvs, :careerist_job, :boolean, default: false
  end
end
