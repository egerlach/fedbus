class TicketsController < ApplicationController
	before_filter permission_required(:tickets), :except => [:show, :browse]
	before_filter permission_required(:tickets), :only => [:show],
     	            :unless => lambda { |c| c.logged_in? && 
									           c.current_user == Ticket.find(c.params[:id]).user }
  # GET /tickets
  # GET /tickets.xml
  def index
    @tickets = Ticket.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
		#permission_required(:tickets) unless  logged_in? && 
		#							           current_user == Ticket.find(params[:id]).user 

    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    @ticket = Ticket.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    @ticket = Ticket.new(params[:ticket])

    respond_to do |format|
      if @ticket.save
        flash[:notice] = 'Ticket was successfully created.'
        format.html { redirect_to(@ticket) }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to(@ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end

	def browse
		@buses = Bus.all

		respond_to do |format|
			format.html
		end
	end

	def reserve
		@bus = Bus.find(params[:bus_id])
		@direction = params[:bus]["direction"].to_sym

		@dirs = []
		if(@direction != Bus::DIRECTIONS[0])
			@dirs << @direction
		else
			@dirs = Ticket::DIRECTIONS
		end

		@ticket = [] << Ticket.new
		@ticket << Ticket.new if(@direction == Bus::DIRECTIONS[0])

		@ticket.each do |t|
			t.direction = @dirs[0]
			@dirs = @dirs[1..-1]
			t.bus = @bus
			t.user = current_user
			t.save!
		end

		respond_to do |format|
			format.html
		end
	end

end
