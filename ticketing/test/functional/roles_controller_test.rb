require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test "should disallow anonymous or unauthorized viewing of 'new role' page" do
    login_as :anonymous do
      get :new
      assert_redirected_to login_path
    end

    login_as users(:one) do
      get :new
      assert_response :forbidden
    end
  end

  test "should get new" do
    with_permission :manage_access_control do
      get :new
      assert_response :success
    end
  end

  test "should disallow anonymous or unauthorized role creation" do
    login_as :anonymous do
      assert_difference('Role.count', 0) do
        post :create, :role => {:name => "New Role"}
      end
    end

    login_as users(:one) do
      assert_difference('Role.count', 0) do
        post :create, :role => {:name => "New Role"}
      end
    end
  end

  test "should create role" do
    with_permission :manage_access_control do
      assert_difference('Role.count') do
        post :create, :role => {:name => "New Role"}
      end

      assert_redirected_to role_path(assigns(:role))
    end
  end

  test "should show role" do
    get :show, :id => roles(:one).to_param
    assert_response :success
  end

  test "Should disallow anonymous or unauthorized viewing of role 'edit' page" do
    login_as :anonymous do
      get :edit, :id => roles(:one).to_param
      assert_redirected_to login_path
    end

    login_as users(:one) do
      get :edit, :id => roles(:one).to_param
      assert_response :forbidden
    end
  end

  test "should get edit" do
    with_permission :manage_access_control do
      get :edit, :id => roles(:one).to_param
      assert_response :success
    end
  end

  test "should disallow anonymous or unauthorized role updating" do
    login_as :anonymous do
      put :update, :id => roles(:one).to_param, :role => {:name => "Updated Role"}
      assert_redirected_to login_path
    end

    login_as users(:one) do
      put :update, :id => roles(:one).to_param, :role => {:name => "Updated Role"}
      assert_response :forbidden
    end
  end

  test "should update role" do
    with_permission :manage_access_control do
      put :update, :id => roles(:one).to_param, :role => {:name => "Updated Role"}
      assert_redirected_to role_path(assigns(:role))
    end
  end

  test "should disallow anonymous or unauthorized role destruction" do
    login_as :anonymous do
      assert_difference('Role.count', 0) do
        delete :destroy, :id => roles(:one).to_param
      end
    end

    login_as users(:one) do
      assert_difference('Role.count', 0) do
        delete :destroy, :id => roles(:one).to_param
      end
    end
  end

  test "should destroy role" do
    with_permission :manage_access_control do
      assert_difference('Role.count', -1) do
        delete :destroy, :id => roles(:one).to_param
      end

      assert_redirected_to roles_path
    end
  end
end
