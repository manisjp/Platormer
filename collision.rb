require "gosu"

class Collision

	# allows for collision detection between multiple objects
	attr_accessor :x, :y

	def initialize x, y
		@x, @y = x, y
	end

	def colliding? object, type = ""
		if type.eql?("stand")
			Gosu::distance(@x, @y, object.x, @y) < 125 &&
			Gosu::distance(@x, @y, @x, object.y) < 5 ? true : false
		else
			Gosu::distance(@x, @y, object.x, object.y) < 50 ? true : false
		end
	end
end