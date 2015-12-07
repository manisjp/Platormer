require "gosu"
require_relative "z_order"
require_relative "player"
require_relative "platform"
require_relative "fish"

class GameWindow < Gosu::Window
	
	GRAVITY = 0.5
	
	def initialize
		super 640, 1000
		self.caption = "Penguin Adventure"

		@background_image = Gosu::Image.new("media/background.jpg")
		@font = Gosu::Font.new(50)

		@player = Player.new
		@player.warp(width/2.0, height - 50)

		@platforms = []
		@platforms.push(Platform.new(width/2 - 125, 950))
		@fish = []
	end

	def update
		if @platforms.size < 6
			@platforms.push(Platform.new)
		end
		if @fish.size < 11
			@fish.push(Fish.new)
		end

		@player.eat(@fish)

		@player.jump if @player.standing?(@platforms)
		@player.left if Gosu::button_down? Gosu::KbLeft
		@player.right if Gosu::button_down? Gosu::KbRight

		@player.move
		gravity
	end

	def draw
		@background_image.draw(0,0,ZOrder::BACKGROUND)
		@font.draw(@player.score, self.width-75, self.height-75, ZOrder::UI, 1.0, 1.0, 0xff_000000)

		@player.draw

		@platforms.each { |platform| platform.draw }
		@fish.each { |fish| fish.draw }
	end

	def button_down id
		close if id == Gosu::KbEscape
	end

	def gravity
		@player.standing?(@platforms) ? @player.vel_y = 0 : @player.vel_y -= GRAVITY
	end

end

window = GameWindow.new
window.show
