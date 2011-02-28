class AddAvailableSeatsToBus < ActiveRecord::Migration
  def self.up
	  add_column :buses, :available_seats, :integer
  end

  def self.down
	  remove_column :buses, :available_seats
  end
end
