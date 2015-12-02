require "gosu"
require_relative "z_order"
require_relative "player"
require_relative "platform"
require_relative "fish"

class GameWindow < Gosu::Window

	def initialize
		super 640, 1000
		self.caption = "Penguin Adventure"

		@background_image = Gosu::Image.new("media/background.jpg")
		
		@player = Player.new
		@player.warp(width/2.0, height)

		@platforms = []
		@fish = []
	end

	def update
		if @platforms.size < 6
			@platforms.push(Platform.new)
		end
		if @fish.size < 11
			@fish.push(Fish.new)
		end
	end

	def draw
		@background_image.draw(0,0,ZOrder::BACKGROUND)
		@player.draw
		@platforms.each { |platform| platform.draw }
		@fish.each { |fish| fish.draw }
	end

	def button_down id
		close if id == Gosu::KbEscape
	end

end

window = GameWindow.new
window.show
