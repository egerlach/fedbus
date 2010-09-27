class AddTripIdToBusAndTripsBusesJoinTable < ActiveRecord::Migration
  def self.up
    add_column :buses, :trip_id, :integer

    create_table :trips_buses, :id => false do |t|
      t.integer :trip_id
      t.integer :bus_id
    end
  end

  def self.down
    remove_column :buses, :trip_id

    drop_table :trips_buses
  end
end
