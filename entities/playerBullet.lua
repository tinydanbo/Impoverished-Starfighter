Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
ParticleTypes = require "entities.types"
Particle = require "game.particles.particle"

PlayerBullet = Class{__includes = Entity,
	init = function(self, x, y, image, damageOnHit, dx, dy, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.image = image
		self.damageOnHit = damageOnHit
		self.hitbox = {
			x1 = x - 5,
			x2 = x + 5,
			y1 = y - 5,
			y2 = y + 5
		}
	end
}

function PlayerBullet:update(dt)
	self:move(self.velocity * dt)

	if not self:isOnScreen() then
		self:destroy()
	end
end

function PlayerBullet:onCollide()
	for i=-4,4,1 do
		local particle = Particle(self.position.x, self.position.y, math.random(-200, 200), math.random(70, 300), 255, 170, 0, 140, 400, self.state)
		self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
	end
end

function PlayerBullet:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.draw(self.image, x, y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)

	Entity.draw(self)
end

return PlayerBullet