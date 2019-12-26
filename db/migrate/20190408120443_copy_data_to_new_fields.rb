class CopyDataToNewFields < ActiveRecord::Migration[5.2]
  def up
    JobnyRu::Application.load_tasks
    Rake::Task['jobny_ru:fix:employee_cv_ext_data'].invoke
  end

  def down; end
end
