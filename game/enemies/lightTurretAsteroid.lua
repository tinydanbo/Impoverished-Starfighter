Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

LightTurretAsteroid = Class{__includes = Enemy,
	init = function(self, x, y, dx, dy, state)
		Enemy.init(self, x, y, state)
		self.health = 100
		self.velocity = vector(dx, dy)
		self.asteroidImage = love.graphics.newImage("data/img/enemy/asteroid/small_asteroid.png")
		self.turretImage = love.graphics.newImage("data/img/enemy/turret/3way-turret.png")
		self.rotation = 0
		self.hitbox = {
			x1 = x - 20,
			x2 = x + 20,
			y1 = y - 20,
			y2 = y + 20
		}
	end,
	fireCounter = 0,
	fireRate = 1.5
}

function LightTurretAsteroid:update(dt)
	self.fireCounter = self.fireCounter + dt

	self:move(self.velocity * dt)

	local difference = self.state.player.position - self.position
	local aimAt = difference:normalized()

	self.rotation = math.atan2(-aimAt.x, aimAt.y)

	while self.fireCounter > self.fireRate and self.position.y < 400 do
		self.fireCounter = self.fireCounter - self.fireRate
		local x,y = self.position:unpack()
		for i=-2,2,1 do
			local phi = (10*i) * (math.pi / 180)
			local spreadAimAt = aimAt:rotated(phi)
			local bulletVel = spreadAimAt * 200
			local newBullet = EnemyBullet(x+(spreadAimAt.x * 5), y+(spreadAimAt.y * 5), bulletVel.x, bulletVel.y, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
		end
	end

end

function LightTurretAsteroid:draw()
	local x,y = self.position:unpack()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.asteroidImage, x, y, 0, 1, 1, 22, 20)
	love.graphics.draw(self.turretImage, x, y, self.rotation, 0.7, 0.7, 24, 22)

	Entity.draw(self)
end

return LightTurretAsteroid