class Ticket < ActiveRecord::Base
  DIRECTIONS = [:to_waterloo, :from_waterloo]

  belongs_to :user
  belongs_to :bus

	validates_presence_of :user_id, :bus_id
  
  symbolize :direction, :in => DIRECTIONS
end
