require 'date'

class ReadingWeek < ActiveRecord::Base
  validates_date :start_date
  validates_date :normal_return_date, :after => :start_date
  validates_date :end_date, :after => :normal_return_date

  def self.blackedout?(departure_datetime)

		departure_date = departure_datetime.to_date

    ReadingWeek.all.each do |rw|

      return true if ((departure_date >= rw.start_date) and (departure_date <= rw.end_date))
    end

    false
  end

  def self.offset(date)
    rw = ReadingWeek.find_by_normal_return_date(date)

    return (rw ? (rw.end_date - rw.normal_return_date) : 0)
  end

end
