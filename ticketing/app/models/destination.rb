class Destination < ActiveRecord::Base
	validates_presence_of :name

	has_many :trips
	has_many :buses
end
