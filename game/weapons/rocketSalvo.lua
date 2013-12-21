Class = require "lib.hump.class"
vector = require "lib.hump.vector"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"
Rocket = require "game.projectiles.rocket"

RocketSalvo = Class {
	init = function(self, rank, state)
		self.state = state
		self.rank = rank
		self.cost = 120 - (self.rank * 20)
	end,
	heat = 0,
}

function RocketSalvo:update(dt)

end

function RocketSalvo:fire()
	local player = self.state.player

	if player.energy > self.cost then
		player.energy = player.energy - self.cost

		local x,y = player.position:unpack()
		for i=-16,16,1 do
			local phi = (5*i) * (math.pi / 180)
			local spreadAimAt = vector(0,-1):rotated(phi)
			local bulletVel = spreadAimAt * 380
			local newBullet = Rocket(x+(spreadAimAt.x * 2), y+(spreadAimAt.y * 2), bulletVel.x, bulletVel.y, 2, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.PLAYER_BULLET)
		end

	end
end

return RocketSalvo