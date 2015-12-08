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

		# create platforms and fish and push them into arrays
		(1...1000).each do |i|
			@platforms.push(Platform.new(rand*475, i*200 + 100)) if @platforms.length < 5
		end
		@fishes.push(Fish.new) if @fishes.size < 10

		@platforms.reject! { |platform| platform.y > 1000}
		@fishes.reject! { |fish| fish.y > 1000}

		# allow player to collect fish and count score
		@player.eat(@fishes)

		# player jumps when on platform no matter what
		@player.jump if @player.standing?(@platforms)
		# user input using arrow keys
		@player.left if Gosu::button_down?(Gosu::KbLeft)
		@player.right if Gosu::button_down?(Gosu::KbRight)

		# allow player to move
		@player.move
		# accelerate player down if not standing
		gravity
		scroll if @player.y < 500
	end

	def draw
		# draw background
		@background_image.draw(0,0,ZOrder::BACKGROUND)
		# draw the score or game over in bottom right
		if game_over?
			Gosu::draw_rect(0, 0, 640, 1000, 0xff_000000, ZOrder::UI)
			@font.draw("Score: #{@player.score}", self.width/2 - 100, self.height/3 + 150, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
			@font.draw("GAME OVER", 50, self.height/3, ZOrder::UI, 2.0, 2.0, 0xff_ffffff)
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

	# handles the scrolling of the platforms and the fish
	def scroll
		@platforms.each do |platform|
			platform.y += @player.vel_y if @player.vel_y > 0
			platform.hit_box.y += @player.vel_y if @player.vel_y > 0
		end
		@fishes.each do |fish|
			fish.y += @player.vel_y if @player.vel_y > 0
			fish.hit_box.y += @player.vel_y if @player.vel_y > 0
		end
	end

	# used to display the end screen and end game
	def game_over?
		true if @player.y > 990
	end

end

# display the window
window = GameWindow.new
window.show