require "gosu"
require_relative "z_order"
require_relative "player"
require_relative "platform"
require_relative "fish"

class GameWindow < Gosu::Window
	
	GRAVITY = 0.5
	WIDTH = 640
	HEIGHT = 1000
	
	def initialize
		super WIDTH, HEIGHT
		self.caption = "Penguin Adventure"

		@background_image = Gosu::Image.new("media/background.jpg")
		@font = Gosu::Font.new(50)

		@player = Player.new
		@platforms = []
		@fishes = []

		create_start_platform
		@player.warp(width/2, height - 50)
	end

	def update
		return if game_over?
		gravity
		
		create_objects
		remove_offscreen(@platforms)
		remove_offscreen(@fishes)

		# allows collection of fish
		@player.eat(@fishes)
		# makes player jump non-stop
		@player.jump if @player.standing?(@platforms)
		@player.move

		# scrolls objects if player is above halfway point
		scrolling?
	end

	def draw
		game_play_screen
		game_over_screen if game_over?

		@player.draw
		@platforms.each { |platform| platform.draw }
		@fishes.each { |fish| fish.draw }
	end
	
	# detects keyboard button presses
	def button_down id
		close if id == Gosu::KbEscape
		# restart game if dead
		initialize if id == Gosu::KbSpace && game_over?
	end

	private
		def gravity
			@player.standing?(@platforms) ? @player.vel_y = 0 : @player.vel_y -= GRAVITY
		end

		def game_over?
			true if @player.y > height - 10
		end	
		def game_play_screen
			@background_image.draw(0,0,ZOrder::BACKGROUND)
			@font.draw(@player.score, width-75, height-75, ZOrder::UI, 1.0, 1.0, 0xff_000000)
		end		
		def game_over_screen
			Gosu::draw_rect(0, 0, width, height, 0xff_000000, ZOrder::UI)
			@font.draw("Score: #{@player.score}", width/2 - 100, height/3 + 150, ZOrder::UI, 1.0, 1.0, 0xff_ffffff)
			@font.draw("GAME OVER", 50, height/3, ZOrder::UI, 2.0, 2.0, 0xff_ffffff)
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

		def scrolling?
			if @player.y < height/2
				scroll(@platforms)
				scroll(@fishes)
			end
		end
		def scroll objects
			objects.each do |object|
				object.y += @player.vel_y if @player.vel_y > 0
				object.hit_box.y += @player.vel_y if @player.vel_y > 0
			end
		end
		def remove_offscreen objects
			objects.reject! { |object| object.y > height}
		end
end
window = GameWindow.new
window.show