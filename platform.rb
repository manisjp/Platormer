require "gosu"
require_relative "z_order"
require_relative "collision"

class Platform

	attr_accessor :hit_box

	def initialize x = rand*640, y = rand*850
		@image = Gosu::Image.new("media/platform.bmp")
		@scale_x = 0.5
		@scale_y = 0.25
		
		@x = x
		@y = y

		@hit_box = Collision.new(@x + @image.width/4, @y)
	end

	def draw
		@image.draw(@x, @y, ZOrder::PLATFORMS, @scale_x, @scale_y)
	end

	# def self.image_width
	# 	@image.width		
	# end

end