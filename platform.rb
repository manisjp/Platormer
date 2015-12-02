require "gosu"
require_relative "z_order"

class Platform

	def initialize
		@image = Gosu::Image.new("media/platform.bmp")
		@x = rand*640
		@y = rand*1000
	end

	def draw
		@image.draw(@x, @y, ZOrder::PLATFORMS, 0.5, 0.5)
	end

end