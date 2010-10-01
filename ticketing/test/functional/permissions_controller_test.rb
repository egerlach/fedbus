require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:permissions)
  end

  test "should disallow anonymous or unauthorized viewing of 'new permission' page" do
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

  test "should disallow anonymous or unauthorized permission creation" do
    login_as :anonymous do
      assert_difference('Permission.count', 0) do
        post :create, :permission => {:name => "New Permission"}
      end
    end

    login_as users(:one) do
      assert_difference('Permission.count', 0) do
        post :create, :permission => {:name => "New Permission"}
      end
    end
  end

  test "should create permission" do
    with_permission :manage_access_control do
      assert_difference('Permission.count') do
        post :create, :permission => {:name => "New Permission"}
      end

      assert_redirected_to permission_path(assigns(:permission))
    end
  end

  test "should show permission" do
    get :show, :id => permissions(:one).to_param
    assert_response :success
  end

  test "Should disallow anonymous or unauthorized viewing of permission 'edit' page" do
    login_as :anonymous do
      get :edit, :id => permissions(:one).to_param
      assert_redirected_to login_path
    end

    login_as users(:one) do
      get :edit, :id => permissions(:one).to_param
      assert_response :forbidden
    end
  end

  test "should get edit" do
    with_permission :manage_access_control do
      get :edit, :id => permissions(:one).to_param
      assert_response :success
    end
  end

  test "should disallow anonymous or unauthorized permission updating" do
    login_as :anonymous do
      put :update, :id => permissions(:one).to_param, :role => {:name => "Updated Permission"}
      assert_redirected_to login_path
    end

    login_as users(:one) do
      put :update, :id => permissions(:one).to_param, :role => {:name => "Updated Permission"}
      assert_response :forbidden
    end
  end

  test "should update role" do
    with_permission :manage_access_control do
      put :update, :id => permissions(:one).to_param, :permission => {:name => "Updated Role"}
      assert_redirected_to permission_path(assigns(:permission))
    end
  end

  test "should disallow anonymous or unauthorized permission destruction" do
    login_as :anonymous do
      assert_difference('Permission.count', 0) do
        delete :destroy, :id => permissions(:one).to_param
      end
    end

    login_as users(:one) do
      assert_difference('Permission.count', 0) do
        delete :destroy, :id => permissions(:one).to_param
      end
    end
  end

  test "should destroy permission" do
    with_permission :manage_access_control do
      assert_difference('Permission.count', -1) do
        delete :destroy, :id => permissions(:one).to_param
      end

      assert_redirected_to permissions_path
    end
  end
end
