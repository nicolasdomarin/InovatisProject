class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin , :boolean , :default => false
    add_column :users , :reseller , :boolean , :default => false
   end
end
