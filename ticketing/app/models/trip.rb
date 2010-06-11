require 'date'

class Trip < ActiveRecord::Base
  validates_presence_of :name, :destination
#  validates_presence_of :comment, :allow_blank => true, :allow_nil => true

  validates_time :departure, :between => ["00:00", "23:59"]
  validates_time :arrival,   :between => ["00:00", "23:59"]
  validates_time :return,    :between => ["00:00", "23:59"]

  validates_numericality_of :ticket_price, :greater_than_or_equal_to => 0
  validates_numericality_of :weekday,     :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 6
  validates_numericality_of :sales_lead,  :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :return_trip, :only_integer => true, :greater_than_or_equal_to => 0, :allow_blank => true
end
