Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

MediumDestroyer = Class{__includes = Enemy,
	init = function(self, x, y, dx, dy, state)
		Enemy.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.health = 230
		self.image = love.graphics.newImage("data/img/enemy/medium-destroyer/medium-destroyer.png")
		self.fireCounter = 0
		self.fireRate = 0.2
		self.hitbox = {
			x1 = x - 65,
			x2 = x + 65,
			y1 = y - 50,
			y2 = y + 50
		}
	end,
}

function MediumDestroyer:update(dt)
	self:move(self.velocity * dt)

	self.fireCounter = self.fireCounter + dt
	if self.fireCounter > self.fireRate then
		self.fireCounter = 0
		for i=1,2,1 do
			local x,y = self.position:unpack()
			local newBullet = EnemyBullet(x+35, y+35, math.random(-150, 150), 300, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
			local newBullet2 = EnemyBullet(x-35, y+35, math.random(-150, 150), 300, self.state)
			self.state.manager:addEntity(newBullet2, EntityTypes.ENEMY_BULLET)
		end
	end
end

function MediumDestroyer:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, 0, 1, 1, 66, 49)

	Entity.draw(self)
end

return MediumDestroyer