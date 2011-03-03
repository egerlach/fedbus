require 'test_helper'

class TicketTest < ActiveSupport::TestCase

  test "fixtures should be valid" do
   assert tickets(:one).valid?, "First ticket not valid"
	 assert tickets(:two).valid?, "Second ticket not valid"
	 assert tickets(:three).valid?, "Third ticket not valid"
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

	test "should not create ticket with direction not applicable to bus" do
		t = Ticket.new
		t.direction = :to_waterloo
		t.user_id = 1
		t.bus = buses(:one)
		assert t.invalid?, "Ticket needs a direction applicable to bus"
	end

	test "should not create ticket if bus has no tickets available for that direction" do
		t = Ticket.new
		t.direction = :to_waterloo
		t.user_id = 1
		t.bus = buses(:null_bus)
		assert t.invalid?, "Ticket should not be created for bus with no seats"
	end
end
