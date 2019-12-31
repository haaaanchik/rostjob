class CopyDataToNewFields < ActiveRecord::Migration[5.2]
  def up
    RostJob::Application.load_tasks
    Rake::Task['rostjob:fix:employee_cv_ext_data'].invoke
  end

  def down; end
end
