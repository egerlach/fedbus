class TicketLogsController < ApplicationController
	before_filter permission_required(:tickets)

  # GET /ticket_logs
  # GET /ticket_logs.xml
  def index
    @ticket_logs = TicketLog.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ticket_logs }
    end
  end

  # GET /ticket_logs/1
  # GET /ticket_logs/1.xml
  def show
    @ticket_log = TicketLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket_log }
    end
  end

end
