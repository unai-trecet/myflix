class AddCostumerTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :costumer_token, :string
  end
end
