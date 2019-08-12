class AddReferencesToSuperJobConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :super_job_configs, :references, :json
  end
end
