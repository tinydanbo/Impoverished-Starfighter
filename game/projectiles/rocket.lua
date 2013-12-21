Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
EntityTypes = require "entities.types"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"
RocketSplash = require "game.projectiles.rocketSplash"

Rocket = Class{__includes = Entity,
	init = function(self, x, y, dx, dy, rank, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.damageOnHit = 6+(rank*3)
		self.image = love.graphics.newImage("data/img/weapons/missile.png")
		self.rank = rank
		self.hitbox = {
			x1 = x - 14,
			x2 = x + 14,
			y1 = y - 14,
			y2 = y + 14
		}
		self.rotation = math.atan2(dx, -dy)
	end
}

function Rocket:onCollide()
	local rocketSplash = RocketSplash(self.position.x, self.position.y, self.rank, self.state)
	self.state.manager:addEntity(rocketSplash, EntityTypes.PLAYER_BULLET)
end

function Rocket:update(dt)
	self:move(self.velocity * dt)

	if not self:isOnScreen() then
		self:destroy()
	end

	local particle = Particle(self.position.x, self.position.y, -self.velocity.x/10+math.random(-2, 2), -self.velocity.y/10+math.random(-2, 2), 240, 180, 20, 160, 500, self.state)
	self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
end

function Rocket:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)

	Entity.draw(self)
end

return Rocket