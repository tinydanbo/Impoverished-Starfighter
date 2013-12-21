Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

SwoopInDrone = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 15
		self.image = love.graphics.newImage("data/img/enemy/swoop-in/swoop-drone.png")
		self.rotation = 0
		self.hitbox = {
			x1 = x - 37,
			x2 = x + 37,
			y1 = y - 28,
			y2 = y + 28
		}
		self.phase = 1
		self.xvelocity = math.random(-10, 10)
		self.fireCounter = 0
		self.fireRate = 0.8
		self.flyAwayCounter = 0
		self.flyAwayTime = 3.4
	end,
}

function SwoopInDrone:update(dt)

	local difference = self.state.player.position - self.position
	local aimAt = difference:normalized()

	if self.phase == 1 then
		local movement = vector(self.xvelocity, 300)
		self:move(movement * dt)
		if self.position.y > 140 then
			self.phase = 2
		end
	elseif self.phase == 2 then
		self.flyAwayCounter = self.flyAwayCounter + dt
		if self.flyAwayCounter > self.flyAwayTime then
			self.phase = 3
		end
	elseif self.phase == 3 then
		local movement = vector(-self.xvelocity, -140)
		self:move(movement * dt)
		if self.position.y < -200 then
			self:destroy()
		end
	end

	if self.phase > 1 then
		self.fireCounter = self.fireCounter + dt
		if self.fireCounter > self.fireRate then
			self.fireCounter = 0
			local x,y = self.position:unpack()
			local bulletVel = aimAt * 300
			local newBullet = EnemyBullet(x+(aimAt.x * 5), y+(aimAt.y * 5), bulletVel.x, bulletVel.y, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
			for i=1,2,1 do
				local newBullet2 = EnemyBullet(x+(aimAt.x * 5), y+(aimAt.y * 5), bulletVel.x+math.random(-50, 50), bulletVel.y+math.random(-50, 50), self.state)
				self.state.manager:addEntity(newBullet2, EntityTypes.ENEMY_BULLET)
			end
		end
	end

	self.rotation = math.atan2(-aimAt.x, aimAt.y)
end

function SwoopInDrone:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 37, 28)

	Entity.draw(self)
end

return SwoopInDrone