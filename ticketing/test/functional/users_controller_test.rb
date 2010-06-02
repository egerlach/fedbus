require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  fixtures :users

  test "should get index" do
    get :index, nil, {:userid => 'test'}
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new, nil, {:userid => 'test'}
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, {:user => {
        :first_name => 'Test',
        :last_name => 'Tester',
        :student_number => '00000000',
        :student_number_confirmation => '00000000',
        :email => 'test@tester.com'
      }}, {:userid => 'thetester'}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "cannot create user with different id than the session" do
    post :create, {:user => {
      :first_name => 'Test',
      :last_name => 'Tester',
      :student_number => '00000000',
      :student_number_confirmation => '00000000',
      :email => 'test@tester.com',
      :userid => 'evil'
    }}, {:userid => 'thetester'}

    assert_redirected_to user_path(assigns(:user))

    # Make sure it created the user with the userid from the session
    assert User.find_by_userid('thetester')
    # Not from the post
    assert User.find_by_userid('evil').nil?
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

  test "login should store return_to parameter" do
    session[:return_to] = nil
    get :login, {:return_to => "/previous/page"}
    assert_equal "/previous/page", session[:return_to]
  end

  test "logout should reset session" do
    session[:cas_user] = "jlpicard"
    session[:userid] = "jlpicard"

    assert_not_nil session[:cas_user]
    assert_not_nil session[:userid]

    get :logout

    assert_nil session[:cas_user]
    assert_nil session[:userid]
  end

  test "logout should redirect to CAS" do
    session[:cas_user] = "jlpicard"
    session[:userid] = "jlpicard"

    get :logout

    assert_redirected_to "https://cas.uwaterloo.ca/cas/logout"
  end
end
