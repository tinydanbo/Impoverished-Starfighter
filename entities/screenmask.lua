Class = require "lib.hump.class"

ScreenMask = Class{
	init = function(self, red, green, blue, alpha)
		self.red = red
		self.green = green
		self.blue = blue
		self.alpha = alpha
	end
}

function ScreenMask:update(dt)

end

function ScreenMask:draw()
	love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
	love.graphics.rectangle("fill", 0, 0, 480, 640)
end

return ScreenMask