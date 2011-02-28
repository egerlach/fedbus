class Bus < ActiveRecord::Base
  STATUSES = [:open, :locked]
  DIRECTIONS = [:both_directions, :to_waterloo, :from_waterloo]

  symbolize :status, :in => STATUSES
  symbolize :direction, :in => DIRECTIONS

  validates_length_of :name, :minimum => 1

  validates_numericality_of :maximum_seats, :greater_than_or_equal_to => 0
  validates_numericality_of :available_seats, :greater_than_or_equal_to => 0, :less_than_or_equal_to => :maximum_seats

  validates_datetime :departure#, :on_or_after => :today
  validates_datetime :arrival#, :on_or_after => :departure
  validates_datetime :return#, :on_or_after => :arrival

  belongs_to :trip
  has_many :ticket

  def self.new_from_trip trip, dep_date
    b = Bus.new( {
      :status => :open,
      :direction => :both_directions,
      :name => trip.name,
      :maximum_seats => 50,
		:available_seats => 50,
      :departure => cat_date_time(dep_date, trip.departure)
                 }
      )    

    if trip.departure < trip.arrival 
      b.arrival = cat_date_time(dep_date, trip.arrival)
    else 
      dep_date += 1
      b.arrival = cat_date_time(dep_date, trip.arrival)
    end

    if trip.arrival < trip.return
      b.return = cat_date_time(dep_date, trip.return )
    else
      b.return = cat_date_time(dep_date + 1, trip.return )
    end

    return b

    # Make sure that departure < arrival < return
  end

  def date
    Date.civil departure.year, departure.month, departure.day
  end

  def return_date
    return date if self.trip.nil?
    return_datetime = date + trip.return_trip
    Date.civil return_datetime.year, return_datetime.month, return_datetime.day
  end

  def to_s
    "Bus: " + name + " " + status.to_s.humanize + " " + direction.to_s.humanize + " " + maximum_seats.to_s + " " + departure.to_s + " " + arrival.to_s + " " + self.return.to_s
  end

  private

  def self.cat_date_time date, time
    DateTime.strptime(date.to_s + time.strftime("T%H:%M:%S"), "%FT%H:%M:%S")
  end

end
