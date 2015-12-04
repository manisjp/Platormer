require "gosu"
require_relative "z_order"
require_relative "collision"

class Player

	ACCELERATION = 1
	TURN_ANGLE = 5

	attr_accessor :x, :y, :vel_x, :vel_y, :feet_box, :mouth_box, :image

	def initialize
		@x = @y = @vel_x = @vel_y = @angle = 0
		@score = 0
		@image = Gosu::Image.new("media/penguin.bmp")
		
		@feet_box = Collision.new(@x, @y)
		@mouth_box = Collision.new(@x, @y)
	end

	def warp x, y
		@x, @y = x, y	
	end

	def draw
		@image.draw_rot(@x,@y,ZOrder::PLAYER, @angle, 0.5, 1, 0.5, 0.5)
	end

	def jump
		@vel_y += ACCELERATION
	end

	def left
		@vel_x -= ACCELERATION
		@angle -= TURN_ANGLE if @angle > -15
	end

	def right
		@vel_x += ACCELERATION
		@angle += TURN_ANGLE if @angle < 15
	end

	def move
		@x += @vel_x
		@y -= @vel_y

		@mouth_box.x = @x
		@mouth_box.y = @y - @image.height/2

		@feet_box.x = @x
		@feet_box.y = @y + @image.height/2

		@x %= 640
		@y %= 1000

		@vel_x *= 0.95
		@vel_y *= 0.95
	end

	def eat fishes
		fishes.reject! { |fish| @mouth_box.colliding?(fish.hit_box) }
	end

	def standing? platforms
		platforms.each { |platform| @feet_box.colliding?(platform.hit_box) }
	end
end