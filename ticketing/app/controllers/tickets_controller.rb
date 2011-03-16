class TicketsController < ApplicationController
	before_filter permission_required(:tickets), :except => [:show, :browse, :buy]
	before_filter permission_required(:tickets), :only => [:show],
     	            :unless => lambda { |c| c.logged_in? && 
									           c.current_user == Ticket.find(c.params[:id]).user }
	before_filter :login_required, :only => [:buy]

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
    @ticket = Ticket.new(params[:ticket] )

    respond_to do |format|
      if @ticket.valid?
				if TicketLog.make_log(params[:log], @ticket, current_user)
					@ticket.save
					flash[:notice] = 'Ticket was successfully created.'
					format.html { redirect_to(@ticket) }
					format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
				else
					@ticket.errors.add :log, "entry cannot be blank"
					format.html { render :action => "new" }
					format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
				end
      else
				@ticket.save
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

		@ticket.attributes = params[:ticket]

    respond_to do |format|
      if @ticket.valid?
				if TicketLog.make_log(params[:log], @ticket, current_user)
					@ticket.save
					flash[:notice] = 'Ticket was successfully updated.'
					format.html { redirect_to(@ticket) }
					format.xml  { head :ok }
				else
					@ticket.errors.add :log, "entry cannot be blank"
					format.html { render :action => "edit" }
					format.xml { render :xml => @ticket.errors, :status => :unprocessable_entity }
				end
      else
				@ticket.save
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    #@ticket = Ticket.find(params[:id])
    #@ticket.destroy

    #respond_to do |format|
    #  format.html { redirect_to(tickets_url) }
    #  format.xml  { head :ok }
    #end
		
		redirect_to(tickets_url)
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
		@errors = nil

		@date = 
			if(@direction == Ticket::DIRECTIONS[1]) # :to_waterloo
				@bus.arrival.to_date
			elsif(@direction == Ticket::DIRECTIONS[0]) #:from_waterloo
				@bus.departure.to_date
			end

		@tickets_on_date = current_user.tickets_for_date(@date)
		if(!@tickets_on_date.empty?)
			@errors = "You already have a ticket on " + @date.to_s
			return
		end

		@ticket = Ticket.new

		@ticket.bus = @bus
		@ticket.user = current_user
		@ticket.status = :reserved
		@ticket.direction = @direction
		@ticket.save!

		l = TicketLog.new
		l.ticket = @ticket
		l.log = "Reserved ticket"
		l.save!

	end

	def expire
		@expired = Ticket.expire
	end

	def buy
		@buses = Bus.where ["departure >= ?", Date.today]
		@earliestdate = (@buses.inject { |d1, d2| d1.departure.to_date <= d2.departure.to_date ? d1 : d2 }).departure.to_date
		@forward = @buses.select do |bus| 
			bus.available_tickets :from_waterloo and
			bus.departure.to_date == @earliestdate
		end
		@backward = @buses.select do |bus| 
			bus.available_tickets :to_waterloo and
			bus.departure.to_date != @earliestdate
		end

		@dayto = @forward[0] ? Time::RFC2822_DAY_NAME[@forward[0].departure.wday] : nil
		@dayfrom = @backward[0] ? Time::RFC2822_DAY_NAME[@backward[0].departure.wday] : nil
	end

end
