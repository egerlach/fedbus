require 'test_helper'

class BlackoutTest < ActiveSupport::TestCase

  test "a blackout period expiry must be on or after it's start" do
    b = blackouts(:one)

    [b.start, b.start + 1, b.start + 100000].each { |x|
      assert assign_valid_value b, :expiry, x
    }

    [b.start - 1, b.start - 100000].each { |x|
      assert assign_invalid_value b, :expiry, x
    }

  end

  test "a blackout period start must be on or before it's expiry" do
    b = blackouts(:one)

    [b.expiry, b.expiry - 1, b.expiry - 100000].each { |x|
      assert assign_valid_value b, :start, x
    }

    [b.expiry + 1, b.expiry + 100000].each { |x|
      assert assign_invalid_value b, :start, x
    }

  end

  test "an invalid value must not be assigned to the start or expiry value of a blackout" do
    b = blackouts(:one)

    ["1", "two", 0, 34534, 0.456, -5.6, -1, "Sept 5, 2000"].each { |x|
      assert assign_invalid_value b, :start, x
      assert assign_invalid_value b, :expiry, x
    }

  end

end
