namespace :fedbus do
	desc "Expires tickets that are 15+ minutes old and only reserved"
	task :expire_tickets => :environment do
		puts "Tickets expired: " + Ticket.expire.to_s
	end
end
