require 'test_helper'

class ReadingWeeksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reading_weeks)
  end

  test "should not get new for unauthenticated user" do
    get :new
    assert_response :redirect
  end

  test "should not get new for authenticated user without permission" do
    @request.session[:userid] = users(:one).userid
    get :new
    assert_response :forbidden
  end

  test "should get new for authenticated user with permission" do
    setup_authenticated_user_with_permission :tester, :reading_weeks
    get :new
    assert_response :success
  end

  test "should not create reading_week for an unauthenticated user" do
    assert_difference('ReadingWeek.count', 0) do
      post :create, :reading_week => { :start_date => "2010-03-04", :normal_return_date => "2010-03-06", :end_date => "2010-03-10" }
    end

    assert_response :redirect
  end

  test "should not create reading_week for an authenticated user without permission" do
    @request.session[:userid] = users(:one).userid
    assert_difference('ReadingWeek.count', 0) do
      post :create, :reading_week => { :start_date => "2010-03-04", :normal_return_date => "2010-03-06", :end_date => "2010-03-10" }
    end

    assert_response :forbidden
  end

  test "should create reading_week for authenticated user" do
    setup_authenticated_user_with_permission :tester, :reading_weeks

    assert_difference('ReadingWeek.count') do
      post :create, :reading_week => { :start_date => "2010-03-04", :normal_return_date => "2010-03-06", :end_date => "2010-03-10" }
    end

    assert_redirected_to reading_week_path(assigns(:reading_week))
  end

  test "should show reading_week" do
    get :show, :id => reading_weeks(:one).to_param
    assert_response :success
  end

  test "should not get edit for unauthenticated user" do
    get :edit, :id => reading_weeks(:one).to_param
    assert_response :redirect
  end

  test "should not get edit for authenticated user withour permission" do
    @request.session[:userid] = users(:one).userid
    get :edit, :id => reading_weeks(:one).to_param
    assert_response :forbidden
  end

  test "should get edit for authenticated user with permission" do
    setup_authenticated_user_with_permission :tester, :reading_weeks

    get :edit, :id => reading_weeks(:one).to_param
    assert_response :success
  end

  test "should not update reading_week for unauthenticated user" do
    put :update, :id => reading_weeks(:one).to_param, :reading_week => { }
    assert_response :redirect
  end

  test "should not update reading_week for authenticated user without permission" do
    @request.session[:userid] = users(:one).userid
    put :update, :id => reading_weeks(:one).to_param, :reading_week => { }
    assert_response :forbidden
  end

  test "should update reading_week for authenticated user with permission" do
    setup_authenticated_user_with_permission :tester, :reading_weeks

    put :update, :id => reading_weeks(:one).to_param, :reading_week => { }
    assert_redirected_to reading_week_path(assigns(:reading_week))
  end

  test "should not destroy reading_week for unauthenticated user" do
    assert_difference('ReadingWeek.count', 0) do
      delete :destroy, :id => reading_weeks(:one).to_param
    end

    assert_response :redirect
  end

  test "should not destroy reading_week for authenticated user without permission" do
    @request.session[:userid] = users(:one).userid
    assert_difference('ReadingWeek.count', 0) do
      delete :destroy, :id => reading_weeks(:one).to_param
    end

    assert_response :forbidden
  end

  test "should destroy reading_week for authenticated user with permission" do
    setup_authenticated_user_with_permission :tester, :reading_weeks

    assert_difference('ReadingWeek.count', -1) do
      delete :destroy, :id => reading_weeks(:one).to_param
    end

    assert_redirected_to reading_weeks_path
  end
end
