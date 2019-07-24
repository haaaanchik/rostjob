class CreateTowns < ActiveRecord::Migration[5.2]
  def change
    create_table :towns do |t|
      t.integer :id_region
      t.integer :id_country
      t.string :title
      t.string :title_eng
      t.integer :super_job_id

      t.timestamps
    end
  end
end
