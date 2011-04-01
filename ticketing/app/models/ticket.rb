class Ticket < ActiveRecord::Base
  DIRECTIONS = [:from_waterloo, :to_waterloo]
	STATUSES = [:reserved, :paid, :void, :expired]

  belongs_to :user
  belongs_to :bus

	has_many :ticket_logs

	validates_presence_of :user_id, :bus_id, :direction, :status
  
  symbolize :direction, :in => DIRECTIONS
	symbolize :status, :in => STATUSES

	validate :direction_must_apply_to_bus
	validate :bus_must_have_seats_in_same_direction_as_ticket, :on => :create
	#, :if => lambda {|t| t.errors[:direction].nil? }

	def direction_must_apply_to_bus
		errors.add(:direction, "must apply to bus' directions") if
			!bus.nil? && bus.direction != direction && bus.direction != Bus::DIRECTIONS[0] 
	end

	def bus_must_have_seats_in_same_direction_as_ticket
		errors.add(:bus, "has no available seats in ticket's direction") unless
			!bus.nil? && !direction.nil? && bus.available_tickets(direction) > 0
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

	def date
		if(direction == DIRECTIONS[0]) # :from_waterloo
			bus.departure.to_date
		else
			bus.arrival.to_date
		end
	end


	def self.expire
		ticketz = Ticket.where ["created_at <= ? and STATUS = ?", Time.now - 15.minutes, :reserved]
		i = 0
		
		ticketz.each do |t|
			t.status = :expired
			t.save!

			l = TicketLog.new
			l.ticket = t
			l.log = "Expired by default"
			l.save!
			i += 1
		end
		i
	end

end
