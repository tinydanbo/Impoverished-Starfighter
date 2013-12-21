Class = require "lib.hump.class"
vector = require "lib.hump.vector"
PlayerBullet = require "entities.playerBullet"
Particle = require "game.particles.particle"
FlamethrowerProjectile = require "game.projectiles.flamethrowerProjectile"

Flamethrower = Class {
	init = function(self, rank, state)
		self.state = state
		self.rank = rank
		self.cost = 0.4
	end,
	heat = 0,
}

function Flamethrower:update(dt)
	if self.heat > 0 then
		self.heat = self.heat - (60 * dt)
		if self.heat < 0 then
			self.heat = 0
		end
	end
end

function Flamethrower:fire()
	local player = self.state.player

	if player.energy > self.cost then
		self.heat = self.heat + (self.rank*2)
		if self.heat > 100 then
			self.heat = 100
		end
		player.energy = player.energy - self.cost
		for i=1,5 do
			local particle = Particle(player.position.x, player.position.y+20, math.random(-200, 200), 100, 255, 150+math.random(0, 70), 64, 200, 450, self.state)
			self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
		end
		for i=1,1+(self.heat/20) do
			local projectile = FlamethrowerProjectile(player.position.x, player.position.y, math.random(-180, 180), -100-(self.heat*2.5), self.state)
			self.state.manager:addEntity(projectile, EntityTypes.PLAYER_BULLET)
		end
	end
end

return Flamethrower