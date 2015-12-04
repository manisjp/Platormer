require "gosu"

class Collision

	COLLISION_DISTANCE = 50	

	attr_accessor :x, :y

	def initialize x, y
		@x, @y = x, y
	end

	def colliding? object
		Gosu::distance(@x, @y, object.x, object.y) < COLLISION_DISTANCE
	end
end