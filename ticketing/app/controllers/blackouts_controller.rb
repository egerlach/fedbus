class BlackoutsController < ApplicationController

  before_filter permission_required(:blackouts), :except => [ :index, :show ]

  # GET /blackouts
  # GET /blackouts.xml
  def index
    @blackouts = Blackout.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blackouts }
    end
  end

  # GET /blackouts/1
  # GET /blackouts/1.xml
  def show
    @blackout = Blackout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blackout }
    end
  end

  # GET /blackouts/new
  # GET /blackouts/new.xml
  def new
    @blackout = Blackout.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blackout }
    end
  end

  # GET /blackouts/1/edit
  def edit
    @blackout = Blackout.find(params[:id])
  end

  # POST /blackouts
  # POST /blackouts.xml
  def create
    @blackout = Blackout.new(params[:blackout])

    respond_to do |format|
      if @blackout.save
        flash[:notice] = 'Blackout was successfully created.'
        format.html { redirect_to(@blackout) }
        format.xml  { render :xml => @blackout, :status => :created, :location => @blackout }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blackout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blackouts/1
  # PUT /blackouts/1.xml
  def update
    @blackout = Blackout.find(params[:id])

    respond_to do |format|
      if @blackout.update_attributes(params[:blackout])
        flash[:notice] = 'Blackout was successfully updated.'
        format.html { redirect_to(@blackout) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blackout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blackouts/1
  # DELETE /blackouts/1.xml
  def destroy
    @blackout = Blackout.find(params[:id])
    @blackout.destroy

    respond_to do |format|
      format.html { redirect_to(blackouts_url) }
      format.xml  { head :ok }
    end
  end
end
