Class = require "lib.hump.class"
vector = require "lib.hump.vector"
anim8 = require "lib.anim8"
Entity = require "entity"
loader = require "lib.loader"

Explosion = Class{__includes = Entity,
	init = function(self, x, y, dx, dy, scale, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.scale = scale
		self.image = loader.Image.particles.explosion
		self.animation = anim8.newAnimation(Explosion.explosionGrid('1-8', ('2-8')), 0.01, 'pauseAtEnd')
	end,
	explosionGrid = anim8.newGrid(128, 128, 1024, 1024)
}

function Explosion:update(dt)
	self:move(self.velocity * dt)
	self.animation:update(dt)

	if self.animation.status == "paused" then
		self:destroy()
	end

	if not self:isOnScreen() then
		self:destroy()
	end
end

function Explosion:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255, 255)
	self.animation:draw(self.image, x, y, 0, self.scale, self.scale, 64, 96)

	Entity.draw(self)
end

return Explosion