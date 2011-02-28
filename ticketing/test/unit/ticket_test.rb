require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "fixtures should be valid" do
   assert tickets(:one).valid?, "First ticket not valid"
	 assert tickets(:two).valid?, "Second ticket not valid"
  end

	test "ticket should not accept invalid direction" do
		assert assign_invalid_value(tickets(:one), :direction, :foogle),
			"Should not accept foogle as direction"
	end

	test "should not create ticket without user" do
		t = Ticket.new
		t.direction = :to_waterloo
		t.bus_id = 1
		assert t.invalid?, "Ticket should not be created without user"
	end

	test "should not create ticket without bus" do
		t = Ticket.new
		t.direction = :to_waterloo
		t.user_id = 1
		assert t.invalid?, "Ticket should not be created without bus"
	end
end
