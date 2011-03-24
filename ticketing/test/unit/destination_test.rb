require 'test_helper'

class DestinationTest < ActiveSupport::TestCase
  test "should not create destination without name" do
		d = Destination.new
		assert d.invalid?
		d.name = "name"
		assert d.valid?
	end
end
