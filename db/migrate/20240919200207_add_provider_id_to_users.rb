class AddProviderIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider_id, :integer
  end
end
