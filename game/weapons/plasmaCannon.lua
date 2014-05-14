Class = require "lib.hump.class"
vector = require "lib.hump.vector"
PlayerBullet = require "entities.playerBullet"
loader = require "lib.loader"

PlasmaCannon = Class {
	init = function(self, rank, state)
		self.state = state
		self.rank = rank
		self.fireRate = 0.14 - (rank*0.03)
		self.fireSound = loader.Audio.Static.plasma
		self.fireSound:setVolume(0.2)
	end,
	fireCounter = 0,
	barrel = 0
}

function PlasmaCannon:update(dt)
	self.fireCounter = self.fireCounter + dt
end

function PlasmaCannon:fire()
	local player = self.state.player

	if self.fireCounter > self.fireRate then
		self.fireCounter = 0
		love.audio.rewind(self.fireSound)
		love.audio.play(self.fireSound)
		if self.barrel == 0 then
			local wave1 = PlayerBullet(player.position.x, player.position.y-5, loader.Image.weapons.plasma0, 1, math.random(-20, 20), -300+math.random(-20, 20), self.state)
			self.state.manager:addEntity(wave1, EntityTypes.PLAYER_BULLET)
			local wave2 = PlayerBullet(player.position.x-10, player.position.y-5, loader.Image.weapons.plasma45l, 1, -200+math.random(-20, 20), -300+math.random(-20, 20), self.state)
			self.state.manager:addEntity(wave2, EntityTypes.PLAYER_BULLET)
			local wave3 = PlayerBullet(player.position.x+10, player.position.y-5, loader.Image.weapons.plasma45r, 1, 200+math.random(-20, 20), -300+math.random(-20, 20), self.state)
			self.state.manager:addEntity(wave3, EntityTypes.PLAYER_BULLET)
			self.barrel = 1
		else 
			if self.rank > 1 then
				local wave1 = PlayerBullet(player.position.x+5, player.position.y-5, loader.Image.weapons.plasma20r, 1, 100+math.random(-20, 20), -300+math.random(-20, 20), self.state)
				self.state.manager:addEntity(wave1, EntityTypes.PLAYER_BULLET)
				local wave2 = PlayerBullet(player.position.x-5, player.position.y-5, loader.Image.weapons.plasma20l, 1, -100+math.random(-20, 20), -300+math.random(-20, 20), self.state)
				self.state.manager:addEntity(wave2, EntityTypes.PLAYER_BULLET)
			end
			self.barrel = 0
		end
	end
end

return PlasmaCannon