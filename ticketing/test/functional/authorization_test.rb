require 'test_helper'

# declare a new controller for testing purposes
class AuthorizationTestController < ApplicationController
  include Authorization::ControllerMixin
  before_filter permission_required(:eat_cake), :only => :delicious_cake

  def delicious_cake
    @cake = :chocolate
    render :nothing => true
  end

  def aperture_science
    @cake = :lie
    render :nothing => true
  end
end

class AuthorizationTest < ActionController::TestCase
  tests AuthorizationTestController
  fixtures :users, :roles, :permissions

  test "unauthenticated user should be forced to login" do
    get :delicious_cake, nil, {}
    assert_redirected_to :login
  end

  test "user without appropriate permissions should be denied" do
    get :delicious_cake, nil, {:userid => users(:tester).userid}
    assert_response :forbidden
    assert_template "errors/authorization_denied"
  end

  test "user with appropriate permissions should be allowed through" do
    roles(:one).permissions << permissions(:eat_cake)
    roles(:one).users << users(:one)
    roles(:one).save!

    get :delicious_cake, nil, {:userid => users(:one).userid}
    assert_equal :chocolate, assigns(:cake)
  end

  test "unprotected actions should be accessible to anonymous users" do
    get :aperture_science, nil, {}
    assert_equal :lie, assigns(:cake)
  end

  test "unprotected actions require no special permissions" do
    get :aperture_science, nil, {:userid => users(:tester).userid}
    assert_equal :lie, assigns(:cake)
  end
end
