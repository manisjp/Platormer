require "gosu"
require_relative "z_order"
require_relative "player"
require_relative "platform"
require_relative "fish"

class GameWindow < Gosu::Window
	
	GRAVITY = 0.5
	
	def initialize
		# create the window
		super 640, 1000
		self.caption = "Penguin Adventure"

		# choose background image and font
		@background_image = Gosu::Image.new("media/background.jpg")
		@font = Gosu::Font.new(50)

		# create the player
		@player = Player.new
		# place player at the bottom middle
		@player.warp(width/2.0, height - 50)

		# create empty arrays for the fishes and platforms
		@platforms = []
		@fishes = []
		 
		# create the starting platform
		@platforms.push(Platform.new(width/2 - 125, 950))
	end

	def update
		# create platforms and push into an array
		if @platforms.size < 5
			@platforms.push(Platform.new)
		end
		# create fish and push into an array
		if @fishes.size < 10
			@fishes.push(Fish.new)
		end

		# allow player to collect fish and count score
		@player.eat(@fishes)

		# player jumps when on platform no matter what
		@player.jump if @player.standing?(@platforms)
		# user input using arrow keys
		@player.left if Gosu::button_down? Gosu::KbLeft
		@player.right if Gosu::button_down? Gosu::KbRight

		# allow player to move
		@player.move
		# accelerate player down if not standing
		gravity
	end

	def draw
		# draw background
		@background_image.draw(0,0,ZOrder::BACKGROUND)
		# draw the score in bottom right
		@font.draw(@player.score, self.width-75, self.height-75, ZOrder::UI, 1.0, 1.0, 0xff_000000)

		# draw player at current position
		@player.draw

		# draw the platforms and fish
		@platforms.each { |platform| platform.draw }
		@fishes.each { |fish| fish.draw }
	end

	# buttons if pressed anywhere
	def button_down id
		close if id == Gosu::KbEscape
	end

	# if standing downwards acceleration stops
	def gravity
		@player.standing?(@platforms) ? @player.vel_y = 0 : @player.vel_y -= GRAVITY
	end

end

# display the window
window = GameWindow.new
window.show
