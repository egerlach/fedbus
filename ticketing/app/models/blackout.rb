class Blackout < ActiveRecord::Base

  validates_datetime :start
  validates_datetime :expiry, :on_or_after => :start

  def self.blackedout? datetime
    Blackout.all.each { |b|
      return true if datetime > b.start && datetime < b.expiry
    }

    return false
  end

  def to_s
    "Blackout: " + start.to_s + " " + expiry.to_s
  end

end
