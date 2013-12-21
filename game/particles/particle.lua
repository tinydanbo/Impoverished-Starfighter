Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"

Particle = Class{__includes = Entity,
	init = function(self, x, y, dx, dy, red, green, blue, alpha, decay, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.red = red
		self.green = green
		self.blue = blue
		self.alpha = alpha
		self.decay = decay
	end
}

function Particle:update(dt)
	self:move(self.velocity * dt)

	if self.alpha > 0 then
		self.alpha = self.alpha - (self.decay * dt)
	end

	if self.alpha < 0 then
		self:destroy()
	end

	if not self:isOnScreen() then
		self:destroy()
	end
end

function Particle:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
	love.graphics.rectangle("fill", x, y, 4, 4)

	Entity.draw(self)
end

return Particle