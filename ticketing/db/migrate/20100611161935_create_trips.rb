class CreateTrips < ActiveRecord::Migration
  def self.up
    create_table :trips do |t|
      t.string :name
      t.string :destination
      t.integer :weekday
      t.time :departure
      t.time :arrival
      t.time :return
      t.decimal :ticket_price
      t.integer :sales_lead
      t.text :comment
      t.integer :return_trip

      t.timestamps
    end
  end

  def self.down
    drop_table :trips
  end
end
