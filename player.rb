require "gosu"
require_relative "z_order"

class Player

	def initialize
		@x = @y = @vel_x = @vel_y = @angle = 0
		@score = 0
		@image = Gosu::Image.new("media/penguin.bmp")
	end

	def warp x, y
		@x, @y = x, y	
	end

	def draw
		@image.draw_rot(@x,@y,ZOrder::PLAYER, @angle,
						0.5, 1, 0.5, 0.5)
	end

end