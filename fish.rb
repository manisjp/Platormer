require "gosu"
require_relative "z_order"

class Fish

	def initialize
		@image = Gosu::Image.new("media/fish.bmp")
		@x = rand*640
		@y = rand*600
		
		@color = Gosu::Color.new(0xff_000000)
		@color.red = rand(256 - 40) + 40
		@color.green = rand(256 - 40) + 40
		@color.blue = rand(256 - 40) + 40
	end

	def draw
		@image.draw(@x, @y, ZOrder::FISH, 0.25, 0.25, @color)
	end

end