require "gosu"
require_relative "z_order"
require_relative "collision"

class Player

	ACCELERATION = 1
	

	attr_accessor :x, :y, :vel_x, :vel_y

	def initialize
		@x = @y = @vel_x = @vel_y = @angle = 0
		@score = 0
		@image = Gosu::Image.new("media/penguin.bmp")
		@feet_box = Collision.new(@x - @image.width, @x + @image.width, @image.height)
		@feet_box = Collision.new(@x - 50, @x + 50, @y - @image.height, @image.height + 50)
	end

	def warp x, y
		@x, @y = x, y	
	end

	def draw
		@image.draw_rot(@x,@y,ZOrder::PLAYER, @angle,
						0.5, 1, 0.5, 0.5)
	end

	def jump
		@vel_y += ACCELERATION
	end

	def move
		@x += @vel_x
		@y -= @vel_y

		@x %= 640
		@y %= 1000

		@vel_x *= 0.95
		@vel_y *= 0.95
	end
end