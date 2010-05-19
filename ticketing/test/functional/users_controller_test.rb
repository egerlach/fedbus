require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => {
        :first_name => 'Test',
        :last_name => 'Tester',
        :student_number => '00000000',
        :student_number_confirmation => '00000000',
        :email => 'test@tester.com'
      }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:one).to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => users(:one).to_param, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).to_param
    end

    assert_redirected_to users_path
  end

  test "login should redirect to CAS if not logged in" do
    get :login
    assert_redirected_to 'https://cas.uwaterloo.ca/cas/login?service=http%3A%2F%2Ftest.host%2Flogin'
  end

  test "login should redirect to root if logged in" do
    get :login, nil, {:cas_user => "test"}
    assert_redirected_to "http://test.host/"
  end

  test "login should redirect to create user if non-existant user" do
    get :login, nil, {:cas_user => "nonexistantuser"}
    assert_redirected_to :new_user
  end
end
