require "gosu"

class Collision

	attr_accessor :x, :y

	def initialize x, y
		@x, @y = x, y
	end

	def colliding? object, type = ""
		if type.eql?("stand")
			Gosu::distance(@x, @y, object.x, @y) < 100 &&
			Gosu::distance(@x, @y, @x, object.y) < 4 ? true : false
		else
			Gosu::distance(@x, @y, object.x, object.y) < 50 ? true : false
		end
	end
end