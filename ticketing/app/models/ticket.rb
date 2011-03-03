class Ticket < ActiveRecord::Base
  DIRECTIONS = [:to_waterloo, :from_waterloo]

  belongs_to :user
  belongs_to :bus

	validates_presence_of :user_id, :bus_id
  
  symbolize :direction, :in => DIRECTIONS

	validate :direction_must_apply_to_bus

	def direction_must_apply_to_bus
		errors.add(:direction, "must apply to bus' direction") if
			!bus.nil? && bus.direction != direction && bus.direction != Bus::DIRECTIONS[0] 
	end
end
