class CopyDataToNewFields < ActiveRecord::Migration[5.2]
  def up
    BestHr::Application.load_tasks
    Rake::Task['best_hr:fix:employee_cv_ext_data'].invoke
  end

  def down; end
end
