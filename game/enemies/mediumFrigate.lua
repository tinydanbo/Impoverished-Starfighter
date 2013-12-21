Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

MediumFrigate = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 200
		self.image = love.graphics.newImage("data/img/enemy/medium-frigate/frigate.png")
		self.rotation = 0
		self.phase = 1
		self.burstRate = 1
		self.burstCounter = 0
		self.salvoCount = 0
		self.salvoRate = 0.2
		self.salvoCounter = 0
		self.hitbox = {
			x1 = x - 70,
			x2 = x + 70,
			y1 = y - 70,
			y2 = y + 70
		}
	end,
}

function MediumFrigate:update(dt)
	local player = self.state.player

	local movement = vector(0, 30)
	self:move(movement * dt)

	self.burstCounter = self.burstCounter + dt

	if self.burstCounter > self.burstRate then
		self.burstCounter = self.burstCounter - self.burstRate

		if self.phase == 1 then
			local difference = self.state.player.position - self.position
			local aimAt = difference:normalized()

			local x,y = self.position:unpack()
			for i=-5,5,1 do
				local phi = (20*i) * (math.pi / 180)
				local spreadAimAt = aimAt:rotated(phi)
				local bulletVel = spreadAimAt * 130
				local newBullet = EnemyBullet(x+(spreadAimAt.x * 50), y+(spreadAimAt.y * 50), bulletVel.x, bulletVel.y, self.state)
				self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
			end
			self.phase = 2
		elseif self.phase == 2 then
			self.salvoCount = 5
		end
	end

	if self.salvoCount > 0 then
		self.salvoCounter = self.salvoCounter + dt
		if self.salvoCounter > self.salvoRate then
			self.salvoCounter = self.salvoCounter - self.salvoRate
			self.salvoCount = self.salvoCount - 1

			local difference = self.state.player.position - self.position
			local aimAt = difference:normalized()
			local bulletVel = aimAt * 180
			local x,y = self.position:unpack()
			local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)

			if self.salvoCount == 0 then
				self.phase = 1
			end
		end
	end
end

function MediumFrigate:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 85, 71)

	Entity.draw(self)
end

return MediumFrigate