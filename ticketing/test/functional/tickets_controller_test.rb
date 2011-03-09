require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "should not get index for unauthenticated user" do
    get :index
    assert_response :redirect
  end

	test "should not get index for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :index
		assert_response :forbidden
	end

	test "should get index for user with tickets permission" do
		with_permission :tickets
			get :index
			assert_response :success
	end

  test "should not get new for unauthenticated user" do
    get :new
    assert_response :redirect
  end

	test "should not get new for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :new
		assert_response :forbidden
	end

	test "should get new for user with tickets permission" do
		with_permission :tickets
		get :new
		assert_response :success
	end

  test "should not create ticket for unauthenticated user" do
		assert_difference('Ticket.count', 0) do
      post :create, :ticket => { :direction => :to_waterloo, :user => users(:one), :bus => buses(:one) }
		end

		assert_response :redirect
	end

	test "should not create ticket for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid

		assert_difference('Ticket.count', 0) do
			post :create, :ticket => { :direction => :to_waterloo, :user => users(:one), :bus => buses(:one) }
		end

		assert_response :forbidden
	end

	test "should create ticket for user with tickets permission" do
		with_permission :tickets
		assert_difference('Ticket.count', 1) do
			post :create, :ticket => { :direction => :from_waterloo, :user => users(:one), :bus => buses(:one), :status => :paid }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

  test "should not show ticket for unauthenticated user" do
    get :show, :id => tickets(:one).to_param
    assert_response :redirect
  end

	test "should not show ticket for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :show, :id => tickets(:one).to_param
		assert_response :forbidden
	end

	test "should show ticket for user with tickets permission" do
		with_permission :tickets
		get :show, :id => tickets(:one).to_param
		assert_response :success
	end

	test "should show own ticket" do
		@request.session[:userid] = users(:one).userid
		get :show, :id => tickets(:three).to_param
		assert_response :success
	end

	test "should not show other's ticket" do
		@request.session[:userid] = users(:two).userid
		get :show, :id => tickets(:three).to_param
		assert_response :forbidden
	end

  test "should not get edit for unauthenticated user" do
    get :edit, :id => tickets(:one).to_param
    assert_response :redirect
  end

	test "should not get edit for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :edit, :id => tickets(:one).to_param
		assert_response :forbidden
	end

	test "should get edit for user with the tickets permission" do
		with_permission :tickets
		get :edit, :id => tickets(:one).to_param
		assert_response :success
	end

  test "should not update ticket for unauthenticated user" do
    put :update, :id => tickets(:one).id, :ticket => { :direction => :from_waterloo, :bus_id => 1, :user_id => 1 }
		assert Ticket.find(tickets(:one).id).direction == tickets(:one).direction
    assert_response :redirect
  end

	test "should not update ticket for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		put :update, :id => tickets(:one).to_param, :ticket => { }
		assert_response :forbidden
	end

	test "should update ticket for user with tickets permission" do
		with_permission :tickets
		put :update, :id => tickets(:one).to_param, :ticket => tickets(:two)
		assert_redirected_to ticket_path(assigns(:ticket))
	end

  test "should not destroy ticket for unauthenticated user" do
		assert_difference('Ticket.count', 0) do
			delete :destroy, :id => tickets(:one).to_param
		end

		assert_response :redirect
  end

	test "should not destroy ticket for authenticated user without the tickets permission" do
		@request.session[:userid] = users(:one).userid

		assert_difference('Ticket.count', 0) do
			delete :destroy, :id => tickets(:one).to_param
		end

		assert_response :forbidden
	end

	test "should not destroy ticket for user with the tickets permission" do
		with_permission :tickets

		assert_difference('Ticket.count', 0) do
			delete :destroy, :id => tickets(:one).to_param
		end

		assert_redirected_to tickets_path
	end

	test "should not do expire action for unauthenticated user" do
		get :expire

		assert_response :redirect
	end

	test "should not do expire action for authenticated user without tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :expire

		assert_response :forbidden
	end

	test "should expire tickets for authenticated users with tickets permission" do
		with_permission :tickets
		get :expire

		assert_response :success
	end

end
