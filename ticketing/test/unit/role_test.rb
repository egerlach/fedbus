require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  fixtures :roles

  test "Role requires name" do
    role = roles(:one)

    role.name = nil
    assert !role.valid?, "Role should not be valid without a name."
    assert role.errors[:name].any?, "Role should have an error on name when none is provided."

    role.name = "Role One"
    assert role.valid?, "Role should be valid with a name."
    assert !role.errors[:name].any?, "Role should not have an error on name when one is provided."
  end
end
