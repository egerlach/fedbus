class TripsController < ApplicationController

  before_filter permission_required(:trips), :except => [:index, :show]

  # GET /trips
  # GET /trips.xml
  def index
    @trips = Trip.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.xml
  def show
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.xml
  def new
    @trip = Trip.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
  end

  # POST /trips
  # POST /trips.xml
  def create
    # We have to convert the two posted values for each time into a single string
    # If we don't Trip.new can't populate the Trips values based on the post hash
    @trip = Trip.new(parse_post params[:trip])

    respond_to do |format|
      if @trip.save
        flash[:notice] = 'Trip was successfully created.'
        format.html { redirect_to(@trip) }
        format.xml  { render :xml => @trip, :status => :created, :location => @trip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.xml
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(parse_post params[:trip])
        flash[:notice] = 'Trip was successfully updated.'
        format.html { redirect_to(@trip) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.xml
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to(trips_url) }
      format.xml  { head :ok }
    end
  end

  # GET /trips/generate
  def generate
    @trips = Trip.all

    # Create Buses from trips that are within the sales_lead of now
    now = DateTime.now

    day_start = DateTime.strptime(DateTime.now.strftime("%Y-%m-%d") + "T00:00:00", "%FT%T")
    day_end   = DateTime.strptime(DateTime.now.strftime("%Y-%m-%d") + "T23:59:59", "%FT%T")

    # Create Buses if a Trip has no Bus for the current cycle
    @trips.each do |trip|
      # How many buses should exist into the future?
      if trip.weekday - now.wday < 0
        buses = (trip.sales_lead/7).floor + (trip.weekday - now.wday + 7 >= trip.sales_lead ? 1 : 0)
      else
        buses = (trip.sales_lead/7).floor + (trip.weekday - now.wday >= trip.sales_lead ? 1 : 0)
      end

      next if buses < 1

      # Are there buses on each day there need to be?
      # If not create them
      trip_offset = trip.weekday - now.wday
      trip_offset += 7 if trip_offset < 0

      (0..buses-1).each do |week|
        trip_date = Date.strptime((day_start+trip_offset+week*7).strftime("%Y-%m-%d"))
        holiday_offset = Holiday.offset(trip_date)
        reading_offset = ReadingWeek.offset(trip_date)

        # If a holiday and a reading week are both there, choose the one that moves the trip more, though this should never happen.
        exception_offset = if holiday_offset.abs > reading_offset.abs
                             holiday_offset
                           else
                             reading_offset
                           end

        if (trip.buses.select{ |b| day_start + trip_offset + week*7 + exception_offset < b.departure && 
                                day_end   + trip_offset + week*7 + exception_offset > b.departure }).count < 1
          b = Bus.new_from_trip(trip, Date.today + trip_offset + week*7 + exception_offset) 
          trip.buses << b unless Blackout.blackedout?(b.departure) or ReadingWeek.blackedout?(b.departure)
        end
      end
    end

    # Redirect the user back to trips
    respond_to { |format|
      format.html { redirect_to(trips_path) }
      format.xml  { reditect_to(trips_path) } 
    }
  end

  # Helper functions
  # We have to convert the two posted values for each time into a single string
  # If we don't Trip.new and Trip.update_attributes can't populate the Trips
  # values based on the post hash
  def parse_post params
    p = params
    [:departure, :arrival, :return].each { |x|
      # Skip below if the key we want already exists (convenient for testing)
      next if p.key? x

      i_hour = x.to_s + '(4i)'
      i_min  = x.to_s + '(5i)'
      p[x] = p[i_hour].to_s + ':' + p[i_min].to_s
      p.delete(i_hour)
      p.delete(i_min)
    }

    return p
  end

end
