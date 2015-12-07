require "gosu"
require_relative "z_order"
require_relative "collision"

class Platform

	attr_accessor :hit_box

	# create platform with a random position
	# TODO: insure platforms are within jumping distance of at least one other
	def initialize x = rand*640, y = rand*850
		@image = Gosu::Image.new("media/platform.bmp")
		
		# scale image
		@scale_x, @scale_y = 0.5, 0.25
		
		@x, @y = x, y

		# create a hitbox 
		@hit_box = Collision.new(@x + @image.width/4, @y)
	end

	def draw
		@image.draw(@x, @y, ZOrder::PLATFORMS, @scale_x, @scale_y)
	end

end