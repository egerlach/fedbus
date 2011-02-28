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
end
