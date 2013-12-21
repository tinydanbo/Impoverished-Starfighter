Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

Boss2Drone = Class{__includes = Enemy,
	init = function(self, x, y, dx, dy, state)
		Enemy.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.health = 10
		self.image = love.graphics.newImage("data/img/enemy/boss2drone/spinny.png")
		self.rotation = 0
		self.rotationIncrease = 100
		self.accel = 100
		self.hitbox = {
			x1 = x - 40,
			x2 = x + 40,
			y1 = y - 40,
			y2 = y + 40
		}
	end,
}

function Boss2Drone:update(dt)
	local player = self.state.player

	self.rotation = self.rotation + (self.rotationIncrease * dt)

	if self.state.player.position.x > self.position.x then
		self.velocity.x = self.velocity.x + (self.accel * dt)
	else if self.state.player.position.x < self.position.y then
		self.velocity.x = self.velocity.x - (self.accel * dt)
	end
end

	self:move(self.velocity * dt)
end

function Boss2Drone:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, (self.rotation % 360) * (math.pi / 180), 1, 1, 47, 47)

	Entity.draw(self)
end

return Boss2Drone