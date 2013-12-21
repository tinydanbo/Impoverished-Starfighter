Class = require "lib.hump.class"
Entity = require "entity"
vector = require "lib.hump.vector"
EntityTypes = require "entities.types"

Scenery = Class{__includes = Entity,
	init = function(self, imagePath, x, y, state)
		Entity.init(self, x, y, state)
		self.image = love.graphics.newImage(imagePath)
	end,
}

function Scenery:update(dt)
	local movement = vector(0, 80)
	self:move(movement * dt)
end

function Scenery:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)

end

return Scenery