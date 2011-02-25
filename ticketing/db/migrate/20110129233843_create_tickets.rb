class CreateTickets < ActiveRecord::Migration
  def self.up
    # Tickets-Users join table
    create_table :tickets_users, :id => false do |t|
      t.integer :ticket_id
      t.integer :user_id
    end

    create_table :tickets do |t|
      t.string :direction
      t.integer :bus_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets_users
    drop_table :tickets
  end
end
