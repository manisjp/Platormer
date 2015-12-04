require "gosu"
require_relative "z_order"
require_relative "collision"

class Fish

	attr_accessor :hit_box

	def initialize
		@image = Gosu::Image.new("media/fish.bmp")
		@x = rand*560 + 40
		@y = rand*600
		
		@color = Gosu::Color.new(0xff_000000)
		@color.red = rand(256 - 40) + 40
		@color.green = rand(256 - 40) + 40
		@color.blue = rand(256 - 40) + 40

		@hit_box = Collision.new(@x, @y)
	end

	def draw
		@image.draw(@x, @y, ZOrder::FISH, 0.25, 0.25, @color)
	end

end