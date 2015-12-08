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

		create_start_platform
	end

	def update
		return if game_over?

		gravity
		control_player
		
		create_objects
		remove_offscreen(@platforms)
		remove_offscreen(@fishes)

		@player.eat(@fishes)
		@player.jump if @player.standing?(@platforms)
		@player.move

		if @player.y < self.height/2
			scroll(@platforms)
			scroll(@fishes)
		end
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

	private
		# buttons if pressed anywhere
		def button_down id
			close if id == Gosu::KbEscape
		end

		# if standing downwards acceleration stops
		def gravity
			@player.standing?(@platforms) ? @player.vel_y = 0 : @player.vel_y -= GRAVITY
		end

		# handles the scrolling of the platforms and the fish
		def scroll objects
			objects.each do |object|
				object.y += @player.vel_y if @player.vel_y > 0
				object.hit_box.y += @player.vel_y if @player.vel_y > 0
			end
		end

		# used to display the end screen and end game
		def game_over?
			true if @player.y > self.height - 5
		end

		def create_start_platform
			@platforms.push(Platform.new(width/2 - 125, 950))
		end

		def create_objects
			(0..3).each do |i|
				@platforms.push(Platform.new(rand*475, i*200 + 300)) if @platforms.length < 5
			end
			@fishes.push(Fish.new) if @fishes.size < 10
		end

		def control_player
			@player.left if Gosu::button_down? Gosu::KbLeft
			@player.right if Gosu::button_down? Gosu::KbRight
		end

		def remove_offscreen objects
			objects.reject! { |object| object.y > 1000}
		end

end

# display the window
window = GameWindow.new
window.show