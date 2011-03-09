require 'test_helper'

class TicketLogTest < ActiveSupport::TestCase

  test "fixtures should be valid" do
		assert ticket_logs(:one).valid?, "First ticket log is not valid"
		assert ticket_logs(:two).valid?, "Second ticket log is not valid"
  end
	
	test "logs must have a ticket" do
		l = TicketLog.new
		l.log = "default"
		assert l.invalid?, "Ticket logs must have a ticket"
		l.ticket = tickets(:one)
		assert l.valid?, "Ticket log should be valid with a ticket"
	end

	test "logs must have a log entry" do
		l = TicketLog.new
		l.ticket = tickets(:two)
		assert l.invalid?, "Ticket logs must have a log entry"
		l.log = "default"
		assert l.valid?, "Ticket log should be valid with a log"
	end

	test "logs should only except string as log entry" do
		l = TicketLog.new
		l.ticket = tickets(:two)
		l.log = :notalog
		assert l.invalid?, "Ticket logs should not accept symbols as logs"
		l.log = 2
		assert l.invalid?, "Ticket logs should not accept numbers as logs"
		l.log = "valid"
		assert l.valid?, "Ticket logs should be valid with strings as logs"
	end
end
