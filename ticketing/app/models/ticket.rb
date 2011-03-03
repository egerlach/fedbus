class Ticket < ActiveRecord::Base
  DIRECTIONS = [:to_waterloo, :from_waterloo]

  belongs_to :user
  belongs_to :bus

	validates_presence_of :user_id, :bus_id
  
  symbolize :direction, :in => DIRECTIONS

	validate :direction_must_apply_to_bus
	validate :bus_must_have_seats_in_same_direction_as_ticket, :on => :create

	def direction_must_apply_to_bus
		errors.add(:direction, "must apply to bus' direction") if
			!bus.nil? && bus.direction != direction && bus.direction != Bus::DIRECTIONS[0] 
	end

	def bus_must_have_seats_in_same_direction_as_ticket
		errors.add(:bus, "bus has no available seats in ticket's direction") if
			!bus.nil? && !direction.nil? && bus.available_tickets(direction) <= 0
	end
end
