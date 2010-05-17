require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "Setting User student number stores the hash" do
    u = User.new
    u.student_number = '00000000'
    assert(u.student_number_hash == '7e071fd9b023ed8f18458a73613a0834f6220bd5cc50357ba3493c6040a9ea8c')
  end

  test "Valid email address accepted" do
    u = User.new
    u.email = 'testing@uwaterloo.ca'
    assert(u.save, "User rejects a valid email address")
  end

  test "Invalid email address rejected" do
    u = User.new
    u.email = 'notavalidemail@something'
    assert(!u.save, "User accepts an invalid email address")
  end
end
