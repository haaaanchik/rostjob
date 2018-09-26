class AddLegalFormToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :legal_form, :string
  end
end
