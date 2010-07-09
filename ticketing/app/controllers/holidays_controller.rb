class HolidaysController < ApplicationController

  before_filter permission_required(:holidays), :except => [:index, :show]

  # GET /holidays
  # GET /holidays.xml
  def index
    @holidays = Holiday.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @holidays }
    end
  end

  # GET /holidays/1
  # GET /holidays/1.xml
  def show
    @holiday = Holiday.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @holiday }
    end
  end

  # GET /holidays/new
  # GET /holidays/new.xml
  def new
    @holiday = Holiday.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @holiday }
    end
  end

  # GET /holidays/1/edit
  def edit
    @holiday = Holiday.find(params[:id])
  end

  # POST /holidays
  # POST /holidays.xml
  def create
    @holiday = Holiday.new(params[:holiday])

    respond_to do |format|
      if @holiday.save
        flash[:notice] = 'Holiday was successfully created.'
        format.html { redirect_to(@holiday) }
        format.xml  { render :xml => @holiday, :status => :created, :location => @holiday }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @holiday.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /holidays/1
  # PUT /holidays/1.xml
  def update
    @holiday = Holiday.find(params[:id])

    respond_to do |format|
      if @holiday.update_attributes(params[:holiday])
        flash[:notice] = 'Holiday was successfully updated.'
        format.html { redirect_to(@holiday) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @holiday.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.xml
  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy

    respond_to do |format|
      format.html { redirect_to(holidays_url) }
      format.xml  { head :ok }
    end
  end
end
