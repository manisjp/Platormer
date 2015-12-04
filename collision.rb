require "gosu"

class Collision

	attr_accessor :x, :y

	def initialize x, y
		@x, @y = x, y
	end

	def colliding? object, distance
		Gosu::distance(@x, @y, object.x, object.y) < distance ? true : false
	end
end