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
		# declares player characteristics
		@x = @y = @vel_x = @vel_y = @angle = @score = 0
		@image = Gosu::Image.new("media/penguin.bmp")
		
		# creates seperate hit boxes at feet and mouth of player
		@feet_box = Collision.new(@x, @y + @image.height/2)
		@mouth_box = Collision.new(@x, @y - @image.height/2)
	end

	def draw
		@image.draw_rot(@x,@y,ZOrder::PLAYER, @angle, 0.5, 1, 0.5, 0.5)
	end
	# places player at bottom middle
	def warp x, y
		@x, @y = x, y	
	end

	# accelerates player upwards
	def jump
		@vel_y += JUMP_POWER
	end
	# accelerates player left and turns player slightly left
	def left
		@vel_x -= ACCELERATION
		@angle -= TURN_ANGLE if @angle > -15
	end
	# accelerates player right and turns player slightly right
	def right
		@vel_x += ACCELERATION
		@angle += TURN_ANGLE if @angle < 15
	end

	# moves player and hit boxes and normalizes player when no buttons are pressed
	def move
		@x += @vel_x
		@y -= @vel_y

		move_mouth_box
		move_feet_box

		normalize
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
		# moves mouth hit box with player
		def move_mouth_box
			@mouth_box.x = @x
			@mouth_box.y = @y - @image.height/2
		end
		# moves feet hit box with player
		def move_feet_box
			@feet_box.x = @x
			@feet_box.y = @y
		end
		# normalizes the player movement when no buttons are pressed
		def normalize
			@x %= GameWindow::WIDTH
			@y %= GameWindow::HEIGHT

			@vel_x *= NORMALIZE_RATE
			@vel_y *= NORMALIZE_RATE
		end

end