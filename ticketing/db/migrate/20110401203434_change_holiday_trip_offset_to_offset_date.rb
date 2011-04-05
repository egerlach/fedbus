class ChangeHolidayTripOffsetToOffsetDate < ActiveRecord::Migration
  def self.up
		remove_column :holidays, :trip_offset
		add_column :holidays, :offset_date, :date
  end

  def self.down
		add_column :holidays, :trip_offset, :integer
		remove_column :holidays, :offset_date
  end
end
