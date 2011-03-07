class Ticket < ActiveRecord::Base
  DIRECTIONS = [:to_waterloo, :from_waterloo]
	STATUSES = [:reserved, :paid, :void, :expired]

  belongs_to :user
  belongs_to :bus

	validates_presence_of :user_id, :bus_id, :direction, :status
  
  symbolize :direction, :in => DIRECTIONS
	symbolize :status, :in => STATUSES

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

	# valid = true returns tickets whose status is either paid or reserved
	# valid = false returns tickets whose status is either void or expired
	def status_valid? valid = true
		if valid
			Ticket::STATUSES[0..1].include? status
		else
			Ticket::STATUSES[2..-1].include? status
		end
	end

	def self.expire
		@ticketz = Ticket.where ["created_at <= ? and STATUS = ?", Time.now - 15.minutes, :reserved]
		
		@ticketz.each do |t|
			t.status = :expired
			t.save!
		end
	end

end
