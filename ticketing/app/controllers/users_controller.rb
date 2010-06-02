class UsersController < ApplicationController

  before_filter :login_required, :only => :index

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    unless session[:userid]
      redirect_to :login
    else
      @user = User.new
      @userid = session[:userid]

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.userid = session[:userid]
    @user.student_number = params[:user][:student_number]
    @user.student_number_confirmation = params[:user][:student_number_confirmation]

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    params[:user].delete('userid')

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def login
    # If a path to return to was set (e.g. by a link leading to the login page),
    # use it. This means that the user is correctly redirected, like login_required.
    session[:return_to] = params[:return_to] if params[:return_to]

    CASClient::Frameworks::Rails::Filter.filter(self) unless session[:cas_user]

    if session[:cas_user]
      session[:userid] = session[:cas_user]

      if logged_in?
        redirect_back_or_default(:root)
      else
        login_required
      end
    end
  end

  def logout
    reset_session
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

end
