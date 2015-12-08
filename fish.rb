require "gosu"
require_relative "z_order"
require_relative "collision"

class Fish

	attr_accessor :y, :hit_box

	def initialize
		@image = Gosu::Image.new("media/fish.bmp")
		
		# randomizes position
		@x, @y = rand*560 + 40, rand*600
		
		# randomizes color not too dark
		@color = Gosu::Color.new(0xff_000000)
		@color.red = rand(256 - 40) + 40
		@color.green = rand(256 - 40) + 40
		@color.blue = rand(256 - 40) + 40

		# creates hit box
		@hit_box = Collision.new(@x, @y)
	end

	def draw
		@image.draw(@x, @y, ZOrder::FISH, 0.25, 0.25, @color)
	end

end