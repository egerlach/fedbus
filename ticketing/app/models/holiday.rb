class Holiday < ActiveRecord::Base

  validates_date :date, :offset_date

  def self.offset date
    holiday = Holiday.find_by_date date
    return (holiday ? holiday.trip_offset : 0)
  end

	def trip_offset
		(self[:ofset_date] - self[:date]).to_i
	end

  def to_s
    "Holiday: " + date.to_s + " " + trip_offset.to_s + " " + comment
  end

end
