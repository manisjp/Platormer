require "gosu"
require_relative "z_order"

class GameWindow < Gosu::Window

	def initialize
		super 640, 1000
		self.caption = "Penguin Adventure"

		@background_image = Gosu::Image.new("media/background.jpg")
	end

	def draw
		@background_image.draw(0,0,ZOrder::BACKGROUND)
	end

	def button_down id
		close if id == Gosu::KbEscape
	end

end

window = GameWindow.new
window.show
