Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

Tank = Class{__includes = Enemy,
	init = function(self, x, y, dx, dy, state)
		Enemy.init(self, x, y, state)
		self.health = 80
		self.velocity = vector(dx, dy)
		self.bodyImage = love.graphics.newImage("data/img/enemy/tank/tankbody.png")
		self.turretImage = love.graphics.newImage("data/img/enemy/tank/tankturret.png")
		self.rotation = 0
		self.hitbox = {
			x1 = x - 40,
			x2 = x + 40,
			y1 = y - 20,
			y2 = y + 20
		}
		self.groundEnemy = true
	end,
	burstCounter = 0,
	burstRate = 2,
	fireShots = 0,
	fireCounter = 0,
	fireRate = 0.2
}

function Tank:update(dt)
	self.burstCounter = self.burstCounter + dt

	self:move(self.velocity * dt)

	while self.burstCounter > self.burstRate do
		self.burstCounter = self.burstCounter - self.burstRate
		self.fireShots = 8
	end

	if self.fireShots > 0 then
		self.fireCounter = self.fireCounter + dt

		while self.fireCounter > self.fireRate do
			self.fireCounter = self.fireCounter - self.fireRate
			self.fireShots = self.fireShots - 1
			local x,y = self.position:unpack()
			for i=-1,1,2 do
				local newBullet1 = EnemyBullet(x+(10*i), y+20, 0, 150, self.state)
				self.state.manager:addEntity(newBullet1, EntityTypes.ENEMY_BULLET)
			end
		end
	end


end

function Tank:draw()
	local x,y = self.position:unpack()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.bodyImage, x, y, 0, 1, 1, 40, 22)
	love.graphics.draw(self.turretImage, x, y, self.rotation, 1, 1, 14, 19)

	Entity.draw(self)
end

return Tank