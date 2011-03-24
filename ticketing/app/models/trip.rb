require 'date'

class Trip < ActiveRecord::Base
  validates_presence_of :name, :departure, :arrival, :return, :destination

  validates_time :departure
  validates_time :arrival
  validates_time :return

  validates_numericality_of :ticket_price, :greater_than_or_equal_to => 0
  validates_numericality_of :weekday,     :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 6
  validates_numericality_of :sales_lead,  :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :return_trip, :only_integer => true, :allow_blank => true

  has_many :buses
	belongs_to :destination

  def to_s
    "Trip: " + name + " " + destination + " " + departure.strftime("%H:%M") + " " + arrival.strftime("%H:%M") + " " + self.return.strftime("%H:%M") + " $" + ticket_price.to_s + " " + weekday.to_s + " " + sales_lead.to_s + " " + return_trip.to_s
  end

  def has_bus? bus
		@buses = self.buses

		buses.each do |b|
			return true if bus.to_s.eql? b.to_s
		end

		return false
  end


end
