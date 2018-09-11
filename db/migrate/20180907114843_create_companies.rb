class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :short_name
      t.string :address
      t.string :mail_address
      t.string :phone
      t.string :fax
      t.string :email
      t.string :inn
      t.string :kpp
      t.string :ogrn
      t.string :director
      t.string :acts_on

      t.timestamps
    end
  end
end
