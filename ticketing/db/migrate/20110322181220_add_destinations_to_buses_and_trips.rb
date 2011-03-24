class AddDestinationsToBusesAndTrips < ActiveRecord::Migration
  def self.up
		add_column "trips", "destination_id", :integer
		add_column "buses", "destination_id", :integer
  end

  def self.down
		remove_column "trips", "destination_id"
		remove_column "buses", "destination_id"
  end
end
