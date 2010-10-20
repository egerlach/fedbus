require 'test_helper'

class ReadingWeekTest < ActiveSupport::TestCase
  test "start_date should be a valid date" do
    rw = reading_weeks(:one)
    rw.start_date = "2010-09-04"
    rw.end_date = "2010-09-05"
    assert rw.valid?, "start_date does not accept a valid date"

    rw.start_date = "this is an invalid date"
    assert rw.invalid?, "start_date accepts an invalid date"
  end

  test "end_date should be a valid date" do
    rw = reading_weeks(:one)
    rw.start_date = "2010-09-03"
    rw.end_date = "2010-09-04"
    assert rw.valid?, "end_date does not accept a valid date"

    rw.end_date = "this is an invalid date"
    assert rw.invalid?, "end_date accepts an invalid date"
  end

  test "start_date should be before end_date" do
    rw = reading_weeks(:one)
    rw.start_date = "2010-03-03"
    rw.end_date = "2010-03-04"
    assert rw.valid?, "end_date should be accepted if it's before start_date"

    rw.end_date = "2010-03-02"
    assert rw.invalid?, "end_date should not be accepted if it's before start_date"
  end
end
