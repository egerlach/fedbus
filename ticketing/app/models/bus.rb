class Bus < ActiveRecord::Base
  STATUSES = [:open, :locked]
  DIRECTIONS = [:both_directions, :to_waterloo, :from_waterloo]

  symbolize :status, :in => STATUSES
  symbolize :direction, :in => DIRECTIONS

  validates_length_of :name, :minimum => 1

  validates_datetime :departure
  validates_datetime :arrival, :on_or_after => :departure
  validates_datetime :return, :on_or_after => :arrival
end
