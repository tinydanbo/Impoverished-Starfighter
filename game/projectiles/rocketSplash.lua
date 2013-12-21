Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
EntityTypes = require "entities.types"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"

RocketSplash = Class{__includes = Entity,
	init = function(self, x, y, rank, state)
		Entity.init(self, x, y, state)
		self.damageOnHit = 1.5
		self.destroyOnCollide = false
		self.alpha = 160
		self.hitbox = {
			x1 = x - 30 + (10 * rank),
			x2 = x + 30 + (10 * rank),
			y1 = y - 30 + (10 * rank),
			y2 = y + 30 + (10 * rank)
		}
		self.duration = 100
		self.decay = 1000 - (rank*200)
	end
}

function RocketSplash:onCollide()
	self.isDestroyed = false
end

function RocketSplash:update(dt)
	self.duration = self.duration - (self.decay * dt)

	if self.duration < 0 then
		self:destroy()
	end

	if not self:isOnScreen() then
		self:destroy()
	end
end

function RocketSplash:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255, self.duration+10)
	love.graphics.rectangle("fill", x-30, y-30, 60, 60)

	Entity.draw(self)
end

return RocketSplash