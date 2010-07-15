module Authorization::TestHelper
  # Log in as a user in the simulated session. If given a block, will undo its changes
  # (including changing the session and creating temporary roles) after yielding.
  #
  # <tt>user</tt>:: A User object specifying the user to be logged in as, or the symbol <tt>:anonymous</tt>
  # <tt>options</tt>:: Currently, only <tt>:permissions => [:list, :of, :permissions]</tt> is supported.
  #
  # Sample usage:
  #
  #  class MyTestCase < ActionController::TestCase
  #    test "should deny anonymous access" do
  #      login_as :anonymous do
  #        get :index
  #        assert_response :forbidden
  #      end
  #    end
  #  
  #    test "should redirect random user" do
  #      login_as users(:one) do
  #        get :index
  #        assert_redirected_to root_path
  #      end
  #    end
  #  
  #    test "should allow authorized user" do
  #      login_as users(:one), :permissions => [:access_index] do
  #        get :index
  #        assert_response :success
  #      end
  #    end
  #  end
  def login_as(user, options = {})
    previous_userid = session[:userid] if block_given?

    case user
    when nil, :anonymous
      session[:userid] = nil
    when User
      session[:userid] = user.userid
    end

    if options[:permissions]
      role = user.roles.create(
        :name => "TemporaryRole-#{ActiveSupport::SecureRandom.hex}",
        :permissions => options[:permissions].map { |perm| permissions(perm) }
      )
    else
      role = nil
    end

    if block_given?
      yield
      session[:userid] = previous_userid
      role.destroy unless role.nil?
    end
  end

  # Log in as an unspecified user with a given permission.
  # Sample usage:
  #
  #  class MyTestCase < ActionController::TestCase
  #    test "should allow authorized user" do
  #      with_permission :access_index do
  #        get :index
  #        assert_response :success
  #      end
  #    end
  #  end
  def with_permission(permission, &block)
    login_as users(:limited), :permissions => [permission], &block
  end
end