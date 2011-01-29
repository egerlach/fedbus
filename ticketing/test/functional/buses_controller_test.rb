require 'test_helper'

class BusesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buses)
  end

  test "should not get new for unauthenticated user and redirect to login" do
    get :new
    assert_response :redirect
  end

  test "should not get new for authenticated user without busses permission" do
    @request.session[:userid] = users(:one).userid
    get :new
    assert_response :forbidden
  end

  test "should get new for user with buses permission" do
    setup_authenticated_user_with_permission :tester, :buses
    get :new
    assert_response :success
  end

  test "should not create bus for unauthenticated user and redirect to login" do
    assert_difference('Bus.count', 0) do
      post :create, :bus => buses(:one)
    end
    assert_response :redirect
  end

  test "should not create new for authenticated user without buses permission" do
    assert_difference('Bus.count', 0) do
      post :create, :bus => buses(:one)
    end
    assert_response :redirect
  end

  test "should create bus for user with buses permission" do
    setup_authenticated_user_with_permission :tester, :buses
    assert_difference('Bus.count') do
      post :create, :bus => { 
        :name => 'Something',
        :status => :open,
        :departure => Time.now,
        :arrival => Time.now,
        :return => Time.now,
        :direction => :both_directions,
        :maximum_seats => 48
      }
    end

    assert_redirected_to bus_path(assigns(:bus))
  end

  test "should show bus for an unauthenticated user" do
    get :show, :id => buses(:one).to_param
    assert_response :success
  end

  test "should show bus for authenticated user without buses permission" do
    @request.session[:userid] = users(:one).userid
    get :show, :id => buses(:one).to_param
    assert_response :success
  end

  test "should show bus for authenticated user with buses permission" do
    setup_authenticated_user_with_permission :tester, :buses
    get :show, :id => buses(:one).to_param
    assert_response :success
  end

  test "should not get edit for unauthenticated user and redirect to login" do
    get :edit, :id => buses(:one).to_param
    assert_response :redirect
  end
    
  test "should not get edit for authenticated user without buses permission" do
    @request.session[:userid] = users(:one).userid
    get :edit, :id => buses(:one).to_param
    assert_response :forbidden
  end

  test "should get edit for user with buses permission" do
    setup_authenticated_user_with_permission :tester, :buses
    get :edit, :id => buses(:one).to_param
    assert_response :success
  end

  test "should not update bus for unauthenticated user and redirect to login" do
    put :update, :id => buses(:one).to_param, :bus => { :status => :locked }
    assert_response :redirect
  end

  test "should not update bus for authenticated user without buses permission" do
    @request.session[:userid] = users(:one).userid
    put :update, :id => buses(:one).to_param, :bus => { :status => :locked }
    assert_response :forbidden
  end

  test "should update bus for user with buses permission" do
    setup_authenticated_user_with_permission :tester, :buses
    put :update, :id => buses(:one).to_param, :bus => { :status => :locked }
    assert_redirected_to bus_path(assigns(:bus))
  end

  test "should not delete bus for unauthenticated user and redirect to login" do
    assert_difference('Bus.count', 0) do
      delete :destroy, :id => buses(:one).to_param
    end
    assert_response :redirect
  end

  test "should not delete bus for authenticated user without buses permission" do
    assert_difference('Bus.count', 0) do
      delete :destroy, :id => buses(:one).to_param
    end
    assert_response :redirect
  end

  test "should destroy bus for authenticated user with buses permission" do
    setup_authenticated_user_with_permission :tester, :buses
    assert_difference('Bus.count', -1) do
      delete :destroy, :id => buses(:one).to_param
    end
    assert_redirected_to buses_path
  end
end
