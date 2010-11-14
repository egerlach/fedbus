xml.instruct!
xml.buses do
  @buses.each do |bus|
    xml.bus do
      xml.id bus.id
      xml.destination bus.trip.name unless bus.trip.nil?
      xml.seats bus.maximum_seats
      xml.time bus.departure
    end
  end
end