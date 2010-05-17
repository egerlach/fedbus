class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.String :first_name
      t.String :last_name
      t.String :email
      t.String :student_number_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
