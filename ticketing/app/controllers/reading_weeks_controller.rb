class ReadingWeeksController < ApplicationController

  before_filter permission_required(:reading_weeks), :except => [:index, :show]

  # GET /reading_weeks
  # GET /reading_weeks.xml
  def index
    @reading_weeks = ReadingWeek.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reading_weeks }
    end
  end

  # GET /reading_weeks/1
  # GET /reading_weeks/1.xml
  def show
    @reading_week = ReadingWeek.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reading_week }
    end
  end

  # GET /reading_weeks/new
  # GET /reading_weeks/new.xml
  def new
    @reading_week = ReadingWeek.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reading_week }
    end
  end

  # GET /reading_weeks/1/edit
  def edit
    @reading_week = ReadingWeek.find(params[:id])
  end

  # POST /reading_weeks
  # POST /reading_weeks.xml
  def create
    @reading_week = ReadingWeek.new(params[:reading_week])

    respond_to do |format|
      if @reading_week.save
        flash[:notice] = 'ReadingWeek was successfully created.'
        format.html { redirect_to(@reading_week) }
        format.xml  { render :xml => @reading_week, :status => :created, :location => @reading_week }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reading_week.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reading_weeks/1
  # PUT /reading_weeks/1.xml
  def update
    @reading_week = ReadingWeek.find(params[:id])

    respond_to do |format|
      if @reading_week.update_attributes(params[:reading_week])
        flash[:notice] = 'ReadingWeek was successfully updated.'
        format.html { redirect_to(@reading_week) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reading_week.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reading_weeks/1
  # DELETE /reading_weeks/1.xml
  def destroy
    @reading_week = ReadingWeek.find(params[:id])
    @reading_week.destroy

    respond_to do |format|
      format.html { redirect_to(reading_weeks_url) }
      format.xml  { head :ok }
    end
  end
end
