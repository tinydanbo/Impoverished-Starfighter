Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"
Explosion = require "game.particles.explosion"
loader = require "lib.loader"

BasicTurret = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.gunImage = loader.Image.enemy.lightTurret.lightTurretGun
		self.destroyedGunImage = loader.Image.enemy.lightTurret.lightTurretDestroyed
		self.baseImage = loader.Image.enemy.lightTurret.lightTurretBase
		self.destroySound = loader.Audio.Static.explosion
		self.health = 200
		self.hitbox = {
			x1 = x - 25,
			x2 = x + 25,
			y1 = y - 25,
			y2 = y + 25
		}
		self.appearDestroyed = false
		self.groundEnemy = true
		self.destroySound:setVolume(0.2)
	end,
	fireCounter = 0,
	fireRate = 0.3
}

function BasicTurret:update(dt)
	self.fireCounter = self.fireCounter + dt

	self:move(vector(0, 80*dt))

	if not self.appearDestroyed then
		local difference = self.state.player.position - self.position
		local aimAt = difference:normalized()
		local bulletVel = aimAt * 200

		while self.fireCounter > self.fireRate and difference:len() > 200 and self.position.y < 350 do
			self.fireCounter = self.fireCounter - self.fireRate
			local x,y = self.position:unpack()
			local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
		end

		self.rotation = math.atan2(-aimAt.x, aimAt.y)
	end

	if self.health < 100 and not self.appearDestroyed then
		self.appearDestroyed = true
		local expl = Explosion(self.position.x, self.position.y, 0, 80, 1, self.state)
		self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
		love.audio.rewind(self.destroySound)
		love.audio.play(self.destroySound)
	end

	if self.position.y >= 700 then
		self:destroy()
	end
end

function BasicTurret:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.baseImage, x, y, 0, 1, 1, 23, 27)
	if self.appearDestroyed then
		love.graphics.draw(self.destroyedGunImage, x, y, self.rotation, 1, 1, 18, 23)
	else
		love.graphics.draw(self.gunImage, x, y, self.rotation, 1, 1, 18, 23)
	end

	Entity.draw(self)
end

return BasicTurret