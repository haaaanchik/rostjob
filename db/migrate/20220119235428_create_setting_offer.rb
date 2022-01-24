class CreateSettingOffer < ActiveRecord::Migration[5.2]
  def change
    create_table :setting_offers do |t|
      t.text :customer_offer
      t.text :contractor_offer

      t.timestamps
    end
  end
end
