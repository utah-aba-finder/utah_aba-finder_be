class AddRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer, default: 1, null: false

    reversible do |dir|
      dir.up do
        User.update_all(role: 1)
      end
    end
  end
end
