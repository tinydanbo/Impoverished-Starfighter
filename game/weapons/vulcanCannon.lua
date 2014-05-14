Class = require "lib.hump.class"
vector = require "lib.hump.vector"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"
loader = require "lib.loader"

VulcanCannon = Class {
	init = function(self, rank, state)
		self.state = state
		self.rank = rank
		self.fireSound = loader.Audio.Static.vulcan
		self.fireSound:setVolume(0.2)
		self.fireRate = 0.1 - (rank*0.02)
	end,
	fireCounter = 0,
	barrel = 0
}

function VulcanCannon:update(dt)
	self.fireCounter = self.fireCounter + dt
end

function VulcanCannon:fire()
	local player = self.state.player

	if self.fireCounter > self.fireRate then
		self.fireCounter = 0
		love.audio.rewind(self.fireSound)
		love.audio.play(self.fireSound)
		if self.barrel == 0 then
			local newBullet = PlayerBullet(player.position.x-10, player.position.y-5, loader.Image.weapons.vulcanShot, 3, math.random(-70+(self.rank*10), 40-(self.rank*10)), -550, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.PLAYER_BULLET)
			local particle = Particle(player.position.x-10, player.position.y-5, -20, -20, 100, 100, 100, 255, 450, self.state.manager)
			self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
			self.barrel = 1
		else 
			local newBullet2 = PlayerBullet(player.position.x+10, player.position.y-5, loader.Image.weapons.vulcanShot, 3, math.random(-70+(self.rank*10), 40-(self.rank*10)), -550, self.state)
			self.state.manager:addEntity(newBullet2, EntityTypes.PLAYER_BULLET)
			local particle = Particle(player.position.x+10, player.position.y-5, 20, -20, 100, 100, 100, 255, 450, self.state.manager)
			self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
			self.barrel = 0
		end
	end
end

return VulcanCannon