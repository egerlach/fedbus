require 'test_helper'

class BlackoutsControllerTest < ActionController::TestCase

  test "should get index for an unauthenticated user" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blackouts)
  end

  test "should get index for an authenticated user" do
    @request.session[:userid] = users(:one).userid
    get :index
    assert_response :success
    assert_not_nil assigns(:blackouts)
  end


  test "should show blackout for an unauthenticated user" do
    get :show, :id => blackouts(:one).to_param
    assert_response :success
  end

  test "should show blackout for an authenticated user" do
    @request.session[:userid] = users(:one).userid
    get :show, :id => blackouts(:one).to_param
    assert_response :success
  end


  test "should not get new for an unauthenticated user" do
    get :new
    assert_response :redirect
  end

  test "should not get new for an authenticated user without the blackouts permission" do
    @request.session[:userid] = users(:one).userid
    get :new
    assert_response :forbidden
  end

  test "should get new for an authenticated user with blackouts permission" do
    setup_authenticated_user_with_permission :tester, :blackouts
    get :new
    assert_response :success
  end


  test "should not create blackout for an unauthenticated user" do
    post :create, :blackout => { :start => "2010-07-08 17:48", :expiry => "2010-08-04 00:00" }
    assert_response :redirect
  end

  test "should not create blackout for an authenticated user without blackouts permission" do
    @request.session[:userid] = users(:one).userid
    post :create, :blackout => { :start => "2010-07-08 17:48", :expiry => "2010-08-04 00:00" }
    assert_response :forbidden
  end

  test "should create blackout for authenticated user with the blackouts permission" do
    setup_authenticated_user_with_permission :tester, :blackouts
    assert_difference('Blackout.count') do
     # post :create, :blackout => { :start => "2010-07-08 17:48", :expiry => "2010-08-04 00:00" } # Date must be on or after today
		 post :create, :blackout => { :start => Date.today, :expiry => Date.today }
    end

    assert_redirected_to blackout_path(assigns(:blackout))
  end


  test "should not get edit for an unauthenticated user" do
    get :edit, :id => blackouts(:one).to_param
    assert_response :redirect
  end

  test "should not get edit for an authenticated user without the blakouts permission" do
    @request.session[:userid] = users(:one).userid
    get :edit, :id => blackouts(:one).to_param
    assert_response :forbidden
  end

  test "should get edit for an authenticated user with the blackouts permission" do
    setup_authenticated_user_with_permission :tester, :blackouts
    get :edit, :id => blackouts(:one).to_param
    assert_response :success
  end

    
  test "should not update blackout with an unauthenticated user" do
    put :update, :id => blackouts(:one).to_param, :blackout => { :start => "2010-07-09 12:45", :expiry => "2010-07-09 17:00" }
    assert_response :redirect
  end

  test "should not update blackout with an authenticated user without the blackouts permission" do
    @request.session[:userid] = users(:one).userid
    put :update, :id => blackouts(:one).to_param, :blackout => { :start => "2010-07-09 12:45", :expiry => "2010-07-09 17:00" }
    assert_response :forbidden
  end

  test "should update blackout with an authenticated user with the blackouts permission" do
    setup_authenticated_user_with_permission :tester, :blackouts
	 #post :create, :id => blackouts(:one).to_param, :blackout => { :start => "2010-06-09 12:45", :expiry => "2010-07-09 17:00" }
    #put :update, :id => blackouts(:one).to_param, :blackout => { :start => "2010-07-09 12:45", :expiry => "2010-07-09 17:00" } # Must be on or after today
	 put :update, :id => blackouts(:one).to_param, :blackout => { :start => Date.today, :expiry => Date.today }
    assert_redirected_to blackout_path(assigns(:blackout))
  end


  test "should not destroy blackout for an unauthenticated user" do
    delete :destroy, :id => blackouts(:one).to_param
    assert_response :redirect
  end

  test "should not destroy blackout for an authenticated user without the blackouts permission" do
    @request.session[:userid] = users(:one).userid
    delete :destroy, :id => blackouts(:one).to_param
    assert_response :forbidden
  end

  test "should destroy blackout for an authenticated user with the blackouts permission" do
    setup_authenticated_user_with_permission :tester, :blackouts
    assert_difference('Blackout.count', -1) do
      delete :destroy, :id => blackouts(:one).to_param
    end

    assert_redirected_to blackouts_path
  end


end
