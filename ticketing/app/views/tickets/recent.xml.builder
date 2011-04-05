xml.instruct!
xml.tickets do
  @recent.each do |t|
    xml.t do
      xml.ticket_id 					t.id
      xml.status 							t.status.to_s
      xml.bus_id 							t.bus.id
      xml.student_number_hash t.user.student_number_hash 
    end
  end
end
