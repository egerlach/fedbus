require 'test_helper'

class TicketLogsControllerTest < ActionController::TestCase
  setup do
    @ticket_log = ticket_logs(:one)
  end

  test "should not get index for unauthenticated user" do
    get :index
    assert_response :redirect
    assert_nil assigns(:ticket_logs)
  end

	test "should not get index for user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :index
		assert_response :forbidden
	end

	test "should get index for user with tickets permission" do
		with_permission :tickets
		get :index
		assert_response :success
	end

  test "should not have new action" do
    assert !TicketLogsController.instance_methods(false).include?(:new), "Ticket logs should not have a \"new\" action"
			
			#TicketLogsController.instance_methods(false).inject("") { |result, element| result + " " + element.to_s }
  end

  test "should not have create action" do
    assert !TicketLogsController.instance_methods(false).include?(:create), "Ticket logs should not have a \"create\" action"
  end

  test "should not show ticket_log for unauthenticated user" do
    get :show, :id => @ticket_log.to_param
    assert_response :redirect
  end

	test "should not show ticket_log for user without the tickets permission" do
		@request.session[:userid] = users(:one).userid
		get :show, :id => @ticket_log.to_param
		assert_response :forbidden
	end

	test "should show ticket_log for user with tickets permission" do
		with_permission :tickets
		get :show, :id => @ticket_log.to_param
		assert_response :success
	end

  test "should not have edit action" do
		assert !TicketLogsController.instance_methods(false).include?(:edit), "Ticket logs should not have an \"edit\" action"
  end

  test "should not have update action" do
    assert !TicketLogsController.instance_methods(false).include?(:update), "Ticket logs should not have an \"update\" action"
  end

  test "should not have destroy action" do
    assert !TicketLogsController.instance_methods(false).include?(:destroy), "Ticket logs should not have a \"destroy\" action"
  end
end
