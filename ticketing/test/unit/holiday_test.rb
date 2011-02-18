require 'test_helper'

class HolidayTest < ActiveSupport::TestCase

  test "a holiday must be on a valid date" do
    ["2010-07-09", "2000/01/01", "2010.12.31", "30.1.10"].each { |x|
      assert assign_valid_value(holidays(:one), :date, x), "A holiday should accept a valid date."
    }

    ["2010-02-29", "", nil].each { |x|
      assert assign_invalid_value(holidays(:one), :date, x), "A holiday should not accept an invalid date string: " + x.to_s
    }
  end

  test "a holiday must have an associated trip offset" do
    [0, 1, 10000, -1, -10000].each { |x|
      assert assign_valid_value(holidays(:one), :trip_offset, x), "A holiday should accept a valid trip offset value."
    }

    [0.5, -0.5, nil, "", "cake", "infinity", "one"].each { |x|
      assert assign_invalid_value(holidays(:one), :trip_offset, x), "A holiday should not accept an invalid trip offset value."
    }
  end

  test "A holiday should not accept an invalid object as a date" do
    [0, "one", "1", Time, "2010-09-31"].each { |x|
      assert assign_invalid_value(holidays(:one), :date, x), "A holiday should not accept an invalid object as a date: " + x.to_s
    }
  end

end
