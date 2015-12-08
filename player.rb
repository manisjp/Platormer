require "gosu"
require_relative "z_order"
require_relative "collision"

class Player

	JUMP_POWER = 25
	ACCELERATION = 1
	TURN_ANGLE = 5
	NORMALIZE_RATE = 0.95

	attr_accessor :y, :vel_y, :score
	
	def initialize
		@x = @y = @vel_x = @vel_y = @angle = @score = 0
		@image = Gosu::Image.new("media/penguin.bmp")
		
		# creates seperate hit boxes at feet and mouth of player
		@feet_box = Collision.new(@x, @y + @image.height/2)
		@mouth_box = Collision.new(@x, @y - @image.height/2)
	end

	def draw
		@image.draw_rot(@x,@y,ZOrder::PLAYER, @angle, 0.5, 1, 0.5, 0.5)
	end
	def warp x, y
		@x, @y = x, y	
	end
	
	def move
		control_player
		
		@x += @vel_x
		@y -= @vel_y

		move_mouth_box
		move_feet_box

		normalize
	end
	def control_player
			left if Gosu::button_down?(Gosu::KbLeft)
			right if Gosu::button_down?(Gosu::KbRight)
	end
	def jump
		@vel_y += JUMP_POWER
	end
	def left
		@vel_x -= ACCELERATION
		@angle -= TURN_ANGLE if @angle > -15
	end
	def right
		@vel_x += ACCELERATION
		@angle += TURN_ANGLE if @angle < 15
	end

	# remove any fish and increase score if colliding with player mouth
	def eat fishes
		if fishes.reject! { |fish| @mouth_box.colliding?(fish.hit_box) }
			@score += 1
		end
	end
	# detect if feet are colliding with any platform
	def standing? platforms
		platforms.any? { |platform| @feet_box.colliding?(platform.hit_box, "stand") && @vel_y < 0 }
	end

	private
		def move_mouth_box
			@mouth_box.x = @x
			@mouth_box.y = @y - @image.height/2
		end
		def move_feet_box
			@feet_box.x = @x
			@feet_box.y = @y
		end

		# slows player left/right movement when no buttons are pressed
		def normalize
			@x %= GameWindow::WIDTH
			@y %= GameWindow::HEIGHT

			@vel_x *= NORMALIZE_RATE
			@vel_y *= NORMALIZE_RATE
		end

end