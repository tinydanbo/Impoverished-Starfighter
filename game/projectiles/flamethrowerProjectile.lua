Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
EntityTypes = require "entities.types"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"

FlamethrowerProjectile = Class{__includes = Entity,
	init = function(self, x, y, dx, dy, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.damageOnHit = 2
		self.alpha = 160
		self.hitbox = {
			x1 = x - 2,
			x2 = x + 2,
			y1 = y - 2,
			y2 = y + 2
		}
		self.decay = 300 + math.random(-200, 200)
	end
}

function FlamethrowerProjectile:update(dt)
	self:move(self.velocity * dt)

	self.alpha = self.alpha - (self.decay * dt)
	self.damageOnHit = 0.5 + ((self.alpha / 160) * 1.5)
	if self.alpha < 0 then
		self:destroy()
	end

	if not self:isOnScreen() then
		self:destroy()
	end
end

function FlamethrowerProjectile:onCollide()
	for i=-1,1,1 do
		local particle = Particle(self.position.x, self.position.y, i*50, 50, 170, 160, 150, 255, 500, self.state)
		self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
	end
end

function FlamethrowerProjectile:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, self.alpha, 0, self.alpha)
	love.graphics.rectangle("fill", x-7, y-7, 14, 14)

	Entity.draw(self)
end

return FlamethrowerProjectile