class AddQueryParamsToOauth < ActiveRecord::Migration[5.2]
  def change
    add_column :oauths, :query_params, :json
  end
end
