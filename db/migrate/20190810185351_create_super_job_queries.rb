class CreateSuperJobQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :super_job_queries do |t|
      t.string :title
      t.json :query_params
      t.boolean :active
      t.references :config, index: true

      t.timestamps
    end
    add_foreign_key :super_job_queries, :super_job_configs, column: :config_id
  end
end
