class TicketLog < ActiveRecord::Base
  belongs_to :ticket
	belongs_to :user

	validates_presence_of :log, :ticket

	validate :log_must_be_string

	def log_must_be_string
		errors.add(:log, "must be a string") unless log.is_a? String
	end

	def self.make_log log_message, ticket, user = nil
		l = TicketLog.new
		l.log = log_message
		l.ticket = ticket
		l.user = user

		l.save
	end

end
