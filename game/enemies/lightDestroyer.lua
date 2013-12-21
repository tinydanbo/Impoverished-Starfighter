Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

LightDestroyer = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 140
		self.image = love.graphics.newImage("data/img/enemy/light-destroyer/light-destroyer.png")
		self.fireRate = 0.3
		self.fireCounter = 0
		self.hitbox = {
			x1 = x - 30,
			x2 = x + 30,
			y1 = y - 80,
			y2 = y + 80
		}
		self.timeoutCounter = 0
		self.timeOutThreshold = 5
		self.phase = 1
	end,
}

function LightDestroyer:update(dt)
	self.fireCounter = self.fireCounter + dt
	local player = self.state.player

	if self.phase == 1 then
		local movement = vector(0, 70)
		self:move(movement * dt)
		if self.position.y > 120 then
			self.phase = 2
		end
	end
	
	if self.phase == 2 then
		self.timeoutCounter = self.timeoutCounter + dt
		if self.timeoutCounter > self.timeOutThreshold then
			self.phase = 3
		end
	end

	if self.phase == 3 then
		local movement = vector(0, -100)
		self:move(movement * dt)
	end

	if self.phase > 1 then 
		if self.fireCounter > self.fireRate then
			self.fireCounter = 0

			for i=1,2,1 do
				local x,y = self.position:unpack()
				local newBullet = EnemyBullet(x, y+75, math.random(-150, 150), 300, self.state)
				self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
			end
		end
	end
end

function LightDestroyer:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, 0, 1, 1, 93, 80)

	Entity.draw(self)
end

return LightDestroyer