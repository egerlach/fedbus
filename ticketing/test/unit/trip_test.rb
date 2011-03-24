require 'test_helper'

class TripTest < ActiveSupport::TestCase

    valid_times = ["00:00", "00:59", "13:00:59", "8:45pm", Time.now]
  invalid_times = ["25:00:00", "00:60", "13:00pm", "", nil, "sdfaw", "5 o'clock"]

  test "Fixtures should be valid" do
	  assert trips(:one).valid?, "Fixture one is not valid"
	  assert trips(:friday).valid?, "Fixture friday is not valid"
	  assert trips(:sunday).valid?, "Fixture sunday is not valid"
	  assert trips(:long_trip).valid?, "Fixture long_trip is not valid"
  end

  test "A trip must have a name" do
    assert assign_valid_value(trips(:one), :name, "Aperture Science"), "A trip name should accept a non-enpty string."
 
    [nil, ""].each { |x|
      assert assign_invalid_value(trips(:one), :name, x), "A trip name should not accept an empty string."
    }
  end

  test "A trip must have a destination" do
		t1 = trips(:one)
    t1.destination = nil
		assert t1.invalid?, "Trip is valid without destination"
  end

  test "A trip must be on a day of the week" do
    (0..6).each { |x|
      assert   assign_valid_value(trips(:one), :weekday, x), "A valid day of " + x.to_s + " should be assignable as a weekday"
    }

    [-1, 7, 5.5].each { |x|
      assert assign_invalid_value(trips(:one), :weekday, x), "An invalid day of " + x.to_s + " should not be assignable as a weekday"
    }
  end

  test "A trip's sales lead time must be a positive number of days before the trip departure day" do
    [0, 1, 5, 8, 1000, 99999].each { |x|
      assert   assign_valid_value(trips(:one), :sales_lead, x), "A valid day of " + x.to_s + " should be assignable as a sales_lead"
    }

    [-1, -7, 5.5, -4.5].each { |x|
      assert assign_invalid_value(trips(:one), :sales_lead, x), "An invalid day of " + x.to_s + " should not be assignable as a sales_lead"
    }
  end

  test "A trip must have a return trip that is an integer number of days or none at all" do
    [0, 1, 5, 100000000, "", -1, -5].each { |x|
      assert assign_valid_value(trips(:one), :return_trip, x), "A valid relative date of " + x.to_s + " should be assignable as a return_trip."
    }

    [1.2, 5.5, -3.14159].each { |x|
      assert assign_invalid_value(trips(:one), :return_trip, x), "An invalid relative date of " + x.to_s + " should not be assignable as a return_trip."
    }
  end

  test "A trip must have a valid time of departure" do
    valid_times.each { |x|
      assert   assign_valid_value(trips(:one), :departure, x), "A valid time of " + x.to_s + " should be assignable to a departure time"
    }

    invalid_times.each { |x|
      assert assign_invalid_value(trips(:one), :departure, x), "An invalid time of " + x.to_s + " should not be assignable as a departure time. Actual time: "
    }
  end

  test "A trip must have a valid time of arrival" do
    valid_times.each { |x|
      assert   assign_valid_value(trips(:one), :arrival, x), "A valid time of " + x.to_s + " should be assignable to a arrival time"
    }

    invalid_times.each { |x|
      assert assign_invalid_value(trips(:one), :arrival, x), "An invalid time of " + x.to_s + " should not be assignable as a arrival time"
    }
  end

  test "A trip must have a valid time of return" do
    valid_times.each { |x|
      assert   assign_valid_value(trips(:one), :return, x), "A valid time of " + x.to_s + " should be assignable to a return time"
    }

    invalid_times.each { |x|
      assert assign_invalid_value(trips(:one), :return, x), "An invalid time of " + x.to_s + " should not be assignable as a return time"
    }
  end

  test "A trip comment can have any string including an empty one as a value" do
    ["delicious cake party bus", nil, ""].each { |x|
      assert assign_valid_value(trips(:one), :comment, x), "A trip comment should accept " + x.to_s + " as a valid value."
    }
  end

  test "A ticket price must be any number greater than or equal to 0" do
    [0, 0.5, 1000000000000].each { |x|
      assert   assign_valid_value(trips(:one), :ticket_price, x), "A ticket price should be able to accept a valid value of: " + x.to_s
    }

    [-1, -0.25, -10000000000].each { |x|
      assert assign_invalid_value(trips(:one), :ticket_price, x), "A ticket price should not accept an invalid value of: " + x.to_s
    }
  end

end
