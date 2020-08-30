class CreateExternalAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :external_auths do |t|
      t.text   :code
      t.string :provider
      t.json   :values

      t.timestamps
    end
  end
end
