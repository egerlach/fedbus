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

    t1 = DateTime.strptime(DateTime.now.strftime("%Y-%m-%d") + "T00:00:00", "%FT%T")
    t2 = DateTime.strptime(DateTime.now.strftime("%Y-%m-%d") + "T23:59:59", "%FT%T")

    # Create Buses if a Trip has no Bus for the current cycle
    @trips.each { |t|
      # How many buses should exist into the future?
      if t.weekday - now.wday < 0
        n = (t.sales_lead/7).floor + (t.weekday - now.wday + 7 >= t.sales_lead ? 1 : 0)
      else
        n = (t.sales_lead/7).floor + (t.weekday - now.wday >= t.sales_lead ? 1 : 0)
      end

      next if n < 1

      # Are there buses on each day there need to be?
      # If not create them
      d = t.weekday - now.wday
      d += 7 if d < 0

      (0..n-1).each { |n|
        if (t.buses.select{ |b| t1+d+n*7 < b.departure && t2+d+n*7 > b.departure }).count < 1
          b = Bus.new_from_trip(t, Date.today+d+7*n) 
          t.buses << b if !Blackout.blackedout?(b.departure)
        end
      }
    }

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
