class Holiday < ActiveRecord::Base

  validates_date :date
  validates_numericality_of :trip_offset, :only_integer => true

  def self.offset date
    holiday = Holiday.find_by_date date
    return (holiday ? holiday.trip_offset : 0)
  end

  def to_s
    "Holiday: " + date.to_s + " " + trip_offset.to_s + " " + comment
  end

end
