Class = require "lib.hump.class"
vector = require "lib.hump.vector"
PlayerBullet = require "entities.playerBullet"
Rocket = require "game.projectiles.rocket"

MissileLauncher = Class {
	init = function(self, rank, state)
		self.state = state
		self.rank = rank
		self.fireRate = 0.6 - (rank*0.05)
	end,
	fireCounter = 0,
}

function MissileLauncher:update(dt)
	self.fireCounter = self.fireCounter + dt
end

function MissileLauncher:fire()
	local player = self.state.player

	if self.fireCounter > self.fireRate then
		self.fireCounter = 0
		local centerMissile = Rocket(player.position.x-30+math.random(-2, 2), player.position.y - 20, math.random(-5, 5), -210, self.rank, self.state)
		self.state.manager:addEntity(centerMissile, EntityTypes.PLAYER_BULLET)
		local centerMissile2 = Rocket(player.position.x+30+math.random(-2, 2), player.position.y - 20, math.random(-5, 5), -210, self.rank, self.state)
		self.state.manager:addEntity(centerMissile2, EntityTypes.PLAYER_BULLET)
	end
end

return MissileLauncher