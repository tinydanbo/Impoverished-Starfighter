Class = require "lib.hump.class"
Entity = require "entity"
Particle = require "game.particles.particle"
EntityTypes = require "entities.types"
loader = require "lib.loader"

Enemy = Class{__includes = Entity,
	init = function(self, x, y, state)
		Entity.init(self, x, y, state)
		self.health = 10
		self.hitbox = {
			x1 = x - 10,
			x2 = x + 10,
			y1 = y - 10,
			y2 = y + 10
		}
		self.destroySound = loader.Audio.Static.explosion
		self.groundEnemy = false
		self.destroySound:setVolume(0.2)
	end
}

function Enemy:update(dt)

end

function Enemy:draw()

end

function Enemy:onDestroy()

	if self.state.player.regainEnergyOnKill then
		self.state.player.energy = self.state.player.energy + 0.5
	end

	local x,y = self.position:unpack()

	for i=1,50 do
		local particle = Particle(x, y, math.random(-200, 200), math.random(-200, 200), 150+math.random(0, 100), math.random(0,160), 0, 140, 200+math.random(0, 200), self.state)
		self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
	end

	for i=1,20 do
		local particle = Particle(x, y, math.random(-100, 100), math.random(-100, 100), 150+math.random(0, 100), math.random(100,160), 60, 160, 160+math.random(0, 200), self.state)
		self.state.manager:addEntity(particle, EntityTypes.PARTICLE)
	end

	love.audio.rewind(self.destroySound)
	love.audio.play(self.destroySound)
end

function Enemy:onHit(entity)
	if entity.damageOnHit then
		self.health = self.health - entity.damageOnHit
		if self.health <= 0 then
			self:onDestroy()
			self.isDestroyed = true
		end
	end
end

return Enemy