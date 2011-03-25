require 'test_helper'
require 'logger'

class TripsControllerTest < ActionController::TestCase

	def trip
		{ "name" => "MyString", "destination" => Destination.new, "weekday" => 1, "departure" => "12:19:35", "arrival" => "12:19:35", "return" => "12:19:35", "ticket_price" => 1.5, "sales_lead" => 1, "comment" => "MyText", "return_trip" => 1 }
	end
	def trip2
		{ "name" => "MyString that is different", "destination" => Destination.new, "weekday" => 1, "departure" => "12:19:35", "arrival" => "12:19:35", "return" => "12:19:35", "ticket_price" => 1.5, "sales_lead" => 1, "comment" => "MyText", "return_trip" => 1 }
	end

  test "should get index for an unauthenticated user" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trips)
  end

  test "should get index for an authenticated user" do
    @request.session[:userid] = users(:one).userid
    get :index
    assert_response :success
    assert_not_nil assigns(:trips)
  end


  test "should show trip for an authenticated user" do
    @request.session[:userid] = users(:one).userid
    get :show, :id => trips(:one).to_param
    assert_response :success
  end

  test "should show trip for an unauthenticated user" do
    get :show, :id => trips(:one).to_param
    assert_response :success
  end


  test "should not get new for an unauthenticated user" do
    get :new
    assert_response :redirect
  end

  test "should not get new for an authenticated user without the trips permission" do
    @request.session[:userid] = users(:one).userid
    get :new
    assert_response :forbidden
  end

  test "should get new for an authenticated user with the trips permission" do
    setup_authenticated_user_with_permission :tester, :trips
    get :new
    assert_response :success
  end

  test "should not create trip for an unauthenticated user" do
    post :create, :trip => { "name" => "MyString", "destination" => "MyString", "weekday" => 1, "departure" => "12:19:35", "arrival" => "12:19:35", "return" => "12:19:35", "ticket_price" => 1.5, "sales_lead" => 1, "comment" => "MyText", "return_trip" => 1 }

    assert_response :redirect
  end

  test "should not create trip for an authenticated user without the trips permission" do
    @request.session[:userid] = users(:one).userid
    post :create, :trip => { "name" => "MyString", "destination" => "MyString", "weekday" => 1, "departure" => "12:19:35", "arrival" => "12:19:35", "return" => "12:19:35", "ticket_price" => 1.5, "sales_lead" => 1, "comment" => "MyText", "return_trip" => 1 }

    assert_response :forbidden
  end

  test "should create trip for an authenticated user with the trips permission" do
    setup_authenticated_user_with_permission :tester, :trips
    assert_difference('Trip.count') do
      post :create, :trip => trip
	 end

    assert_redirected_to trip_path(assigns(:trip))
  end


  test "should not get edit for an unauthenticated user" do
    get :edit, :id => trips(:one).to_param
    assert_response :redirect
  end

  test "should not get edit for an authenticated user without the trips permission" do
    @request.session[:userid] = users(:one).userid
    get :edit, :id => trips(:one).to_param
    assert_response :forbidden
  end

  test "should get edit for an authenticated user with the trips permission" do
    setup_authenticated_user_with_permission :tester, :trips
    get :edit, :id => trips(:one).to_param
    assert_response :success
  end


  test "should not update trip for an unauthenticated user" do
    put :update, :id => trips(:one).to_param, :trip => { "name" => "MyString that is different", "destination" => "MyString that is different", "weekday" => 1, "departure" => "12:19:35", "arrival" => "12:19:35", "return" => "12:19:35", "ticket_price" => 1.5, "sales_lead" => 1, "comment" => "MyText", "return_trip" => 1 }
    assert_response :redirect
  end

  test "should not update trip for an authenticated user without the trips permission" do
    @request.session[:userid] = users(:one).userid
    put :update, :id => trips(:one).to_param, :trip => { "name" => "MyString that is different", "destination" => "MyString that is different", "weekday" => 1, "departure" => "12:19:35", "arrival" => "12:19:35", "return" => "12:19:35", "ticket_price" => 1.5, "sales_lead" => 1, "comment" => "MyText", "return_trip" => 1 }
    assert_response :forbidden
  end

  test "should update trip for an authenticated user with the trips permission" do
    setup_authenticated_user_with_permission :tester, :trips
    put :update, :id => trips(:one).to_param, :trip => trip2
    assert_redirected_to trip_path(assigns(:trip))
  end


  test "should not destroy trip for an unauthenticated user" do
    delete :destroy, :id => trips(:one).to_param
    assert_response :redirect
  end

  test "should not destroy trip for an authenticated user without the trips permission" do
    @request.session[:userid] = users(:one).userid
    delete :destroy, :id => trips(:one).to_param
    assert_response :forbidden
  end

  test "should destroy trip for an authenticated user with the trips permission" do
    setup_authenticated_user_with_permission :tester, :trips
    assert_difference('Trip.count', -1) do
      delete :destroy, :id => trips(:one).to_param
    end

    assert_redirected_to trips_path
  end


  test "should not generate buses from trips for an unauthenticated user" do
    get :generate
    assert_response :redirect
  end

  test "should not generate buses from frips for an authenticated user without the trips permission" do
    @request.session[:userid] = users(:one).userid
    get :generate
    assert_response :forbidden
  end

  test "should get generate for an authenticated user with the trips permission" do
    setup_authenticated_user_with_permission :tester, :trips
    get :generate

    assert_response :success
  end

  test "should generate 5 buses from trips fixtures one, friday, sunday and long_trip" do
    setup_authenticated_user_with_permission :tester, :trips

    # Stop any blackouts or holidays from interfering
    Blackout.destroy_all
    Holiday.destroy_all
    ReadingWeek.destroy_all

    # Five buses should have been created
    assert_difference('Bus.count', 5) {
      get :generate
    }
  end

  test "should not generate buses from trips if they already exist" do
    setup_authenticated_user_with_permission :tester, :trips

    # Stop any blackouts or holidays from interfering
    Blackout.destroy_all
    Holiday.destroy_all
    ReadingWeek.destroy_all

    # Five buses should have been created
    assert_difference('Bus.count', 5) {
      get :generate
    }

    # Zero buses should be created when they already exist
    assert_difference('Bus.count', 0) {
      get :generate
    }
  end

  test "should not create buses during a scheduled blackout period" do
    setup_authenticated_user_with_permission :tester, :trips

    # Stop any holidays from interfering
    Holiday.destroy_all
    ReadingWeek.destroy_all
#Rails.logger.info "should not create buses during a scheduled blackout period"
    assert_difference('Bus.count', 1) {
      get :generate
    }
  end

  test "should not create buses from a trip that falls on a holiday but should instead create them on the offset day" do
    setup_authenticated_user_with_permission :tester, :trips

    # Stop and blackouts from interfering
    Blackout.destroy_all
    ReadingWeek.destroy_all
    assert_difference('Bus.count', 5) {
      get :generate
    }

    # Were they created on the correct offset?
    assert Bus.find_by_name("Sunday Bus").departure.strftime("%F") == (Date.today + 2).strftime("%F"), Bus.find_by_name("Sunday Bus").departure.strftime("%F") 
    assert Bus.find_by_name("Uber Trip" ).departure.strftime("%F") == (Date.today + 1).strftime("%F"), Bus.find_by_name("Uber Trip").departure.strftime("%F")

    # Should not create buses that already exist
    assert_difference('Bus.count', 0) {
      get :generate
    }
  end

  test "should not create buses during a reading week" do
    setup_authenticated_user_with_permission :tester, :trips

    # Stop Holidays and blackouts from interfering
    Blackout.destroy_all
    Holiday.destroy_all
#Rails.logger.info "should not create buses during a reading week"
    assert_difference('Bus.count', 2) {
      get :generate
    } # Should create bus "One" 5 days from now, and "Uber Trip" 7 days ahead
  end

end
