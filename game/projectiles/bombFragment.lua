Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
EntityTypes = require "entities.types"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"
Explosion = require "game.particles.explosion"

BombFragment = Class{__includes = Entity,
	init = function(self, x, y, dx, dy, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.damageOnHit = 0.5 + (state.player.bombPowerRank * 0.8) 
		self.destroyOnCollide = false
		self.alpha = 160
		self.hitbox = {
			x1 = x - 20,
			x2 = x + 20,
			y1 = y - 20,
			y2 = y + 20
		}
		self.duration = 100
		self.decay = 200 - (state.player.bombRadiusRank * 40)
		self.counter = 0
		self.explodeRate = 0.1
	end
}

function BombFragment:onCollide()
	self.isDestroyed = false
end

function BombFragment:update(dt)
	self:move(self.velocity * dt)
	self.duration = self.duration - (self.decay * dt)

	self.counter = self.counter + dt
	if self.counter > self.explodeRate then
		self.counter = 0
		local expl = Explosion(self.position.x, self.position.y, 0, 0, 1, self.state)
		self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
	end

	if self.duration < 0 then
		self:destroy()
	end

	if not self:isOnScreen() then
		self:destroy()
	end
end

function BombFragment:draw()
	local x,y = self.position:unpack()
	Entity.draw(self)
end

return BombFragment