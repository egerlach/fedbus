require 'date'

class ReadingWeek < ActiveRecord::Base
  validates_date :start_date
  validates_date :end_date, :after => :start_date

  def self.blackedout?(departure_datetime)

    blackedout = false

    ReadingWeek.all.each do |rw|
      departure_date = Date.civil(departure_datetime.year, departure_datetime.month, departure_datetime.day)

      blackedout = true if ((departure_date >= rw.start_date) and (departure_date <= rw.end_date))
    end

    return blackedout
  end
end
