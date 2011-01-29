require 'test_helper'

class UserTest < ActiveSupport::TestCase

  fixtures :users, :roles, :permissions

  test "Setting User student number stores the hash" do
    u = users(:tester)
    u.student_number = '00000000'
    assert_equal u.student_number_hash, '7e071fd9b023ed8f18458a73613a0834f6220bd5cc50357ba3493c6040a9ea8c'
  end

  test "Valid email address accepted" do
    u = users(:tester)
    u.email = 'testing@uwaterloo.ca'
    assert u.save, "User rejects a valid email address: " + u.errors.full_messages.inspect
  end

  test "Invalid email address rejected" do
    u = users(:tester)
    u.email = 'notavalidemail@something'
    assert !u.save, "User accepts an invalid email address: " + u.errors.full_messages.inspect
    assert u.errors[:email].any?
  end

  test "User requires first name" do
    u = users(:tester)
    u.first_name = nil
    assert !u.save, "User accepts an entry without first name: " + u.errors.full_messages.inspect
    assert u.errors[:first_name].any?
  end

  test "User requires last name" do
    u = users(:tester)
    u.last_name = nil
    assert !u.save, "User accepts an entry without last name: " + u.errors.full_messages.inspect
    assert u.errors[:last_name].any?
  end

  test "User requires email" do
    u = users(:tester)
    u.email = nil
    assert !u.save, "User accepts an entry without email: " + u.errors.full_messages.inspect
    assert u.errors[:email].any?
  end

  test "Setting student_number requires confirmation" do
    u = users(:tester)
    u.student_number = '00000000'
    assert !u.save, "User.student_number can be set without confirmation: " + u.errors.full_messages.inspect
    assert u.errors[:student_number_confirmation].any?

    u = users(:tester)
    u.student_number = '00000000'
    u.student_number_confirmation = '11111111'
    assert !u.save, "User.student_number can be set with invalid confirmation: " + u.errors.full_messages.inspect
    assert u.errors[:student_number].any?

    u = users(:tester)
    u.student_number = '12345678'
    u.student_number_confirmation = '12345678'
    assert u.save, "User.student_number cannot be set with valid confirmation: " + u.errors.full_messages.inspect
  end

  test "Userid is required" do
    u = users(:tester)
    u.userid = nil
    assert !u.save, "User accepts an entry without userid: " + u.errors.full_messages.inspect
    assert u.errors[:userid].any?
  end

  test "has_permission? should accept symbols" do
    user = users(:tester)
    role = roles(:one)
    perm = permissions(:eat_cake)

    assert !user.has_permission?(:eat_cake), "User should not have permission unless given an appropriate role."

    role.permissions << perm
    role.users << user
    role.save!
    user.reload

    assert user.has_permission?(:eat_cake), "User should have permission once given an appropriate role."
  end

  test "has_permission? should accept strings" do
    user = users(:tester)
    role = roles(:one)
    perm = permissions(:eat_cake)

    assert !user.has_permission?("Eat cake"), "User should not have permission unless given an appropriate role."

    role.permissions << perm
    role.users << user
    role.save!
    user.reload

    assert user.has_permission?("Eat cake"), "User should have permission once given an appropriate role."
  end

  test "has_permission? should accept IDs" do
    user = users(:tester)
    role = roles(:one)
    perm = permissions(:eat_cake)

    assert !user.has_permission?(perm.id), "User should not have permission unless given an appropriate role."

    role.permissions << perm
    role.users << user
    role.save!
    user.reload

    assert user.has_permission?(perm.id), "User should have permission once given an appropriate role."
  end

  test "has_permission? should accept Permission models" do
    user = users(:tester)
    role = roles(:one)
    perm = permissions(:eat_cake)

    assert !user.has_permission?(perm), "User should not have permission unless given an appropriate role."

    role.permissions << perm
    role.users << user
    role.save!
    user.reload

    assert user.has_permission?(perm), "User should have permission once given an appropriate role."
  end
end
