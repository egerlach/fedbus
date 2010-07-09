require 'test_helper'

class HolidaysControllerTest < ActionController::TestCase

  test "should get index for an unauthenticated user" do
    get :index
    assert_response :success
    assert_not_nil assigns(:holidays)
  end

  test "should get index for an authenticated user" do
    @request.session[:userid] = users(:one).userid
    get :index
    assert_response :success
    assert_not_nil assigns(:holidays)
  end


  test "should show holiday for an unauthenticated user" do
    get :show, :id => holidays(:one).to_param
    assert_response :success
  end

  test "should show holiday for an authenticated user" do
    @request.session[:userid] = users(:one).userid
    get :show, :id => holidays(:one).to_param
    assert_response :success
  end


  test "should not get new for an unauthenticated user" do
    get :new
    assert_response :redirect
  end

  test "should not get new for an authenticated user without the holidays permission" do
    @request.session[:userid] = users(:one).userid
    get :new
    assert_response :forbidden
  end

  test "should get new for an authenticated user with holidays permission" do
    setup_authenticated_user_with_permission :tester, :holidays
    get :new
    assert_response :success
  end


  test "should not create holiday for an unauthenticated user" do
    post :create, :holiday => { :date => "2010-07-09", :trip_offset => "-1" }
    assert_response :redirect
  end

  test "should not create holiday for an authenticated user without holidays permission" do
    @request.session[:userid] = users(:one).userid
    post :create, :holiday => { :date => "2010-07-09", :trip_offset => "-1" }
    assert_response :forbidden
  end

  test "should create holiday for authenticated user with the holidays permission" do
    setup_authenticated_user_with_permission :tester, :holidays
    assert_difference('Holiday.count') do
      post :create, :holiday => { :date => "2010-07-09", :trip_offset => "-1" }
    end

    assert_redirected_to holiday_path(assigns(:holiday))
  end


  test "should not get edit for an unauthenticated user" do
    get :edit, :id => holidays(:one).to_param
    assert_response :redirect
  end

  test "should not get edit for an authenticated user without the blakouts permission" do
    @request.session[:userid] = users(:one).userid
    get :edit, :id => holidays(:one).to_param
    assert_response :forbidden
  end

  test "should get edit for an authenticated user with the holidays permission" do
    setup_authenticated_user_with_permission :tester, :holidays
    get :edit, :id => holidays(:one).to_param
    assert_response :success
  end

    
  test "should not update holiday with an unauthenticated user" do
    put :update, :id => holidays(:one).to_param, :holiday => { :date => "2010-07-09", :trip_offset => "-1" }
    assert_response :redirect
  end

  test "should not update holiday with an authenticated user without the holidays permission" do
    @request.session[:userid] = users(:one).userid
    put :update, :id => holidays(:one).to_param, :holiday => { :date => "2010-07-09", :trip_offset => "-1" }
    assert_response :forbidden
  end

  test "should update holiday with an authenticated user with the holidays permission" do
    setup_authenticated_user_with_permission :tester, :holidays
    put :update, :id => holidays(:one).to_param, :holiday => { :date => "2010-07-09", :trip_offset => "-1" }
    assert_redirected_to holiday_path(assigns(:holiday))
  end


  test "should not destroy holiday for an unauthenticated user" do
    delete :destroy, :id => holidays(:one).to_param
    assert_response :redirect
  end

  test "should not destroy holiday for an authenticated user without the holidays permission" do
    @request.session[:userid] = users(:one).userid
    delete :destroy, :id => holidays(:one).to_param
    assert_response :forbidden
  end

  test "should destroy holiday for an authenticated user with the holidays permission" do
    setup_authenticated_user_with_permission :tester, :holidays
    assert_difference('Holiday.count', -1) do
      delete :destroy, :id => holidays(:one).to_param
    end

    assert_redirected_to holidays_path
  end


end
