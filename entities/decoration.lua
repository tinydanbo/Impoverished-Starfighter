Class = require "lib.hump.class"
Entity = require "entity"

Decoration = Class{__includes = Entity,
	init = function(self, imagePath, x, y, state)
		Entity.init(self, x, y, state)
		self.x = x
		self.y = y
		self.alpha = 255
		self.image = love.graphics.newImage(imagePath)
	end
}

function Decoration:update(dt)

end

function Decoration:draw()
	love.graphics.setColor(255, 255, 255, self.alpha)
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

return Decoration