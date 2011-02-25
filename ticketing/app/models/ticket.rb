class Ticket < ActiveRecord::Base
  DIRECTIONS = [:to_waterloo, :from_waterloo]

  belongs_to :user
  belongs_to :bus
  
  symbolize :direction, :in => DIRECTIONS
end
