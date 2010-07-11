class AddIndices < ActiveRecord::Migration
  def self.up
    # These should be unique identifiers and are frequently used for lookup.
    add_index :permissions, :name, :unique => true
    add_index :roles, :name, :unique => true
    add_index :users, :userid, :unique => true

    # Make has_and_belongs_to_many lookups faster
    add_index :permissions_roles, :permission_id
    add_index :permissions_roles, :role_id
    add_index :roles_users, :role_id
    add_index :roles_users, :user_id
  end

  def self.down
    remove_index :roles_users, :user_id
    remove_index :roles_users, :role_id
    remove_index :permissions_roles, :role_id
    remove_index :permissions_roles, :permission_id
    remove_index :users, :userid
    remove_index :roles, :name
    remove_index :permissions, :name
  end
end
