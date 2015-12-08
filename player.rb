require "gosu"
require_relative "z_order"
require_relative "collision"

class Player

	JUMP_POWER = 25
	ACCELERATION = 1
	TURN_ANGLE = 5

	attr_accessor :y, :vel_y, :score

	# create player
	def initialize
		@x = @y = @vel_x = @vel_y = @angle = @score = 0
		# image used for player
		@image = Gosu::Image.new("media/penguin.bmp")
		
		# create seperate hit boxes at feet and mouth of player
		@feet_box = Collision.new(@x, @y + @image.height/2)
		@mouth_box = Collision.new(@x, @y - @image.height/2)
	end

	# used to place player at bottom middle
	def warp x, y
		@x, @y = x, y	
	end

	def draw
		@image.draw_rot(@x,@y,ZOrder::PLAYER, @angle, 0.5, 1, 0.5, 0.5)
	end

	# accelerate player upwards
	def jump
		@vel_y += JUMP_POWER
	end

	# accelerate player left
	def left
		@vel_x -= ACCELERATION
		@angle -= TURN_ANGLE if @angle > -15
	end

	# accelerate player right
	def right
		@vel_x += ACCELERATION
		@angle += TURN_ANGLE if @angle < 15
	end

	# move player and hit boxes and decelerate player if no buttons pressed
	def move
		@x += @vel_x
		@y -= @vel_y

		@mouth_box.x = @x
		@mouth_box.y = @y - @image.height/2

		@feet_box.x = @x
		@feet_box.y = @y

		@x %= 640
		@y %= 1000

		@vel_x *= 0.95
		@vel_y *= 0.95
	end

	# remove any fish and increase score if colliding with player mouth
	def eat fishes
		if fishes.reject! { |fish| @mouth_box.colliding?(fish.hit_box) }
			@score += 1
		end
	end

	# detect if feet are colliding with any platform
	def standing? platforms
		platforms.any? { |platform| @feet_box.colliding?(platform.hit_box, "stand") }
	end
end