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
		# death condition
		return if game_over?

		# create platforms and push into an array
		(1..5).each do |i|
			@platforms.push(Platform.new(rand*475, i*200)) if @platforms.length < 5
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
		# draw the score or game over in bottom right
		if game_over?
			@font.draw("GAME OVER", self.width/2, self.height/2, ZOrder::UI, 1.0, 1.0, 0xff_000000)
		else
			@font.draw(@player.score, self.width-75, self.height-75, ZOrder::UI, 1.0, 1.0, 0xff_000000)
		end

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
	
	def game_over?
		true if @player.y > 990
	end

end

# display the window
window = GameWindow.new
window.show
