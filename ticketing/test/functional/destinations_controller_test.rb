require 'test_helper'

class DestinationsControllerTest < ActionController::TestCase
  setup do
    @destination = destinations(:one)
  end

	test "fixtures should be valid" do
		assert destinations(:one).valid?, "Fixture one is not valid"
		assert destinations(:two).valid?, "Fixture two is not valid"
	end

  test "should not get index for unauthenticated user" do
    get :index
    assert_response :redirect
  end

	test "should not get index for authenticated user without the destinations permission" do
		@request.session[:userid] = users(:one).userid
		get :index
		assert_response :forbidden
	end

	test "should get index for user with destinations permission" do
		with_permission :destinations
			get :index
			assert_response :success
	end

  test "should not get new for unauthenticated user" do
    get :new
    assert_response :redirect
  end

	test "should not get new for authenticated user without the destinations permission" do
		@request.session[:userid] = users(:one).userid
		get :new
		assert_response :forbidden
	end

	test "should get new for user with destinations permission" do
		with_permission :destinations
		get :new
		assert_response :success
	end

  test "should not create destination for unauthenticated user" do
    assert_difference('Destination.count', 0) do
      post :create, :destination => @destination.attributes
    end

    assert_response :redirect
  end

	test "should not create destination for authenticated user without the destinations permission" do
		@request.session[:userid] = users(:one).userid

    assert_difference('Destination.count', 0) do
      post :create, :destination => @destination.attributes
    end

    assert_response :forbidden
  end

	test "should create destination for authenticated user with the destinations permission" do
		with_permission :destinations
		assert_difference('Destination.count') do
			post :create, :destination => @destination.attributes
		end

		assert_redirected_to destination_path(assigns(:destination))
	end

  test "should not show destination for unauthenticated user" do
    get :show, :id => @destination.to_param
    assert_response :redirect
  end

	test "should not show destination for authenticated user without the destinations permission" do
		@request.session[:userid] = users(:one).userid
		get :show, :id => @destination.to_param
		assert_response :forbidden
	end

	test "should show destionation for user with destinations permission" do
		with_permission :destinations
		get :show, :id => @destination.to_param
		assert_response :success
	end

  test "should not get edit for unauthenticated user" do
    get :edit, :id => @destination.to_param
    assert_response :redirect
  end

	test "should not get edit for authenticated user without the destinations permission" do
		@request.session[:userid] = users(:one).userid
		get :edit, :id => @destination.to_param
		assert_response :forbidden
	end

	test "should get edit for user with the destinations permission" do
		with_permission :destinations
		get :edit, :id => @destination.to_param
		assert_response :success
	end

  test "should not update destination for unauthenticated user" do
    put :update, :id => @destination.to_param, :destination => @destination.attributes
    assert_response :redirect
  end

	test "should not update destination for user without the destinations permission" do
		@request.session[:userid] = users(:one).userid
		put :update, :id => @destination.to_param, :destination => @destination.attributes
		assert_response :forbidden
	end

	test "should updated destination for user with the destinations permission" do
		with_permission :destinations
		put :update, :id => @destination.to_param, :destination => @destination.attributes
		assert_redirected_to destination_path(assigns(:destination))
	end

  test "should not destroy destination for unauthenticated user" do
		assert_difference('Destination.count', 0) do
			delete :destroy, :id => @destination.to_param
		end

		assert_response :redirect
  end

	test "should not destroy destination for authenticated user without the destinations permission" do
		@request.session[:userid] = users(:one).userid

		assert_difference('Destination.count', 0) do
			delete :destroy, :id => @destination.to_param
		end

		assert_response :forbidden
	end

	test "should destroy destination for user with the destinations permission" do
		with_permission :destinations

		assert_difference('Destination.count', -1) do
			delete :destroy, :id => @destination.to_param
		end

		assert_redirected_to destinations_path
	end

end
