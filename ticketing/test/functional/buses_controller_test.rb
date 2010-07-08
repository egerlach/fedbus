require 'test_helper'

class BusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bus" do
    assert_difference('Bus.count') do
      post :create, :bus => { 
        :name => 'Something',
        :status => :open,
        :departure => Time.now,
        :arrival => Time.now,
        :return => Time.now,
        :direction => :both_directions
      }
    end

    assert_redirected_to bus_path(assigns(:bus))
  end

  test "should show bus" do
    get :show, :id => buses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => buses(:one).to_param
    assert_response :success
  end

  test "should update bus" do
    put :update, :id => buses(:one).to_param, :bus => { :status => :locked }
    assert_redirected_to bus_path(assigns(:bus))
  end

  test "should destroy bus" do
    assert_difference('Bus.count', -1) do
      delete :destroy, :id => buses(:one).to_param
    end

    assert_redirected_to buses_path
  end
end
