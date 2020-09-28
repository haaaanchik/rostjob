class CreateCrmColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :crm_columns do |t|
      t.string     :name
      t.references :user

      t.timestamps
    end

    create_table :crm_columns_employee_cvs do |t|
      t.references :crm_column, index: true
      t.references :employee_cv, index: true

      t.timestamps
    end

    add_index :crm_columns_employee_cvs, [:crm_column_id, :employee_cv_id], unique: true, name: 'crm_column_and_employee_cv'
  end
end
