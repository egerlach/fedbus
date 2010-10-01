require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  fixtures :users, :roles

  test "should disallow anonymous user listing" do
    login_as :anonymous do
      get :index
      assert_redirected_to login_path
    end
  end

  test "should disallow unauthorized user listing" do
    login_as users(:one) do
      get :index
      assert_response :forbidden
    end
  end

  test "should get index" do
    with_permission :manage_access_control do
      get :index
      assert_response :success
      assert_not_nil assigns(:users)
    end
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

  test "should disallow anonymous user display" do
    login_as :anonymous do
      get :show, :id => users(:one).to_param
      assert_redirected_to login_path
    end
  end

  test "should disallow unauthorized user display" do
    login_as users(:two) do
      get :show, :id => users(:one).to_param
      assert_response :forbidden
    end
  end

  test "should allow display of own user" do
    login_as users(:one) do
      get :show, :id => users(:one).to_param
      assert_response :success
    end
  end

  test "should allow authorized user display" do
    with_permission :manage_access_control do
      get :show, :id => users(:one).to_param
      assert_response :success
    end
  end

  test "should disallow anonymous user editing" do
    login_as :anonymous do
      get :edit, :id => users(:one).to_param
      assert_redirected_to login_path
    end
  end

  test "should disallow unauthorized user editing" do
    login_as users(:two) do
      get :edit, :id => users(:one).to_param
      assert_response :forbidden
    end
  end

  test "should allow editing of own user" do
    login_as users(:one) do
      get :edit, :id => users(:one).to_param
      assert_response :success
    end
  end

  test "should allow authorized user editing" do
    with_permission :manage_access_control do
      get :edit, :id => users(:one).to_param
      assert_response :success
    end
  end

  test "should disallow anonymous user updates" do
    login_as :anonymous do
      put :update, :id => users(:one).to_param, :user => { }
      assert_redirected_to login_path
    end
  end

  test "should disallow unauthorized user updates" do
    login_as users(:two) do
      put :update, :id => users(:one).to_param, :user => { }
      assert_response :forbidden
    end
  end

  test "should allow updating of own user" do
    login_as users(:one) do
      put :update, :id => users(:one).to_param, :user => { }
      assert_redirected_to user_path(assigns(:user))
    end
  end

  test "should allow authorized user updates" do
    with_permission :manage_access_control do
      put :update, :id => users(:one).to_param, :user => { }
      assert_redirected_to user_path(assigns(:user))
    end
  end

  test "should disallow anonymous user destruction" do
    login_as :anonymous do
      assert_difference('User.count', 0) do
        delete :destroy, :id => users(:one).to_param
      end
    end
  end

  test "should disallow unauthorized user destruction" do
    login_as users(:two) do
      assert_difference('User.count', 0) do
        delete :destroy, :id => users(:one).to_param
      end
    end
  end

  test "should allow user self-destruction" do
    login_as users(:one) do
      assert_difference('User.count', -1) do
        delete :destroy, :id => users(:one).to_param
      end
    end
  end

  test "should allow authorized user destruction" do
    with_permission :manage_access_control do
      assert_difference('User.count', -1) do
        delete :destroy, :id => users(:two).to_param
      end
    end
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

  test "should not assign roles to self without authorization" do
    login_as users(:one) do
      assert_difference('users(:one).roles.count', 0) do
        put :update, :id => users(:one).to_param, :user => {:role_ids => [roles(:one).id]}
      end
    end
  end

  test "should assign roles with authorization" do
    with_permission :manage_access_control do
      assert_difference('users(:one).roles.count', 1) do
        put :update, :id => users(:one).to_param, :user => {:role_ids => [roles(:one).id]}
      end
    end
  end
end
