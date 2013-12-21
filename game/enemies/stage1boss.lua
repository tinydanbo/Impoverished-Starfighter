Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
Explosion = require "game.particles.explosion"
EntityTypes = require "entities.types"

Stage1Boss = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 6000
		self.image = love.graphics.newImage("data/img/enemy/stage1boss/stage1boss.png")
		self.energyBarFront = love.graphics.newImage("data/img/hud/energy-front.png")
		self.energyBar = love.graphics.newImage("data/img/hud/boss-bar.png")
		self.energyBarBack = love.graphics.newImage("data/img/hud/energy-back.png")
		self.phase = 1
		self.tick = 0
		self.desiredPosition = vector(240, 160)
		self.hitbox = {
			x1 = x - 120,
			x2 = x + 120,
			y1 = y - 100,
			y2 = y + 80
		}
		self.phaseTick = 0
		self.schedule = {}

		self:startPhase1()
	end,
}

function Stage1Boss:update(dt)
	self.tick = self.tick + dt
	self.phaseTick = self.phaseTick + dt
	local i = 1
	for i,v in ipairs(self.schedule) do
		local callback = self.schedule[i]
		if callback[1] < self.phaseTick and callback[3] == false then
			callback[3] = true
			self[callback[2]](self)
		else
			i = i + 1
		end
	end

	-- move to desired position
	local difference = self.desiredPosition - self.position

	if difference:len() > 10 then
		local movement = difference:normalized() * 160
		self:move(movement * dt)
	end
end

function Stage1Boss:fireClumpCircle()
	local player = self.state.player
	local difference = player.position - self.position
	local aimAt = difference:normalized()

	local x,y = self.position:unpack()
	for i=-5,5,1 do
		local phi = (36*i) * (math.pi / 180)
		for j=-2,2,1 do
			local spreadAimAt = aimAt:rotated(phi+(j*0.05))
			local bulletVel = spreadAimAt * 130
			local newBullet = EnemyBullet(x+(spreadAimAt.x * 50), y+(spreadAimAt.y * 50), bulletVel.x, bulletVel.y, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
		end
	end
end

function Stage1Boss:fireAimedSpread()
	local player = self.state.player
	local difference = player.position - self.position
	local aimAt = difference:normalized()

	local x,y = self.position:unpack()
	for i=-1,1,2 do
		local phi = (5*i) * (math.pi / 180)
		local spreadAimAt = aimAt:rotated(phi)
		local bulletVel = spreadAimAt * 460
		local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage1Boss:fireAimedArc()
	local player = self.state.player
	local difference = player.position - self.position
	local aimAt = difference:normalized()

	local x,y = self.position:unpack()
	local offset = math.random(-3, 3)
	for i=-3+offset,3+offset,1 do
		local phi = (i) * (math.pi / 180)
		local spreadAimAt = aimAt:rotated(phi)
		local bulletVel = spreadAimAt * 260
		local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage1Boss:fireEnclosingBullets()
	local player = self.state.player
	local difference = player.position - self.position
	local aimAt = difference:normalized()

	local x,y = self.position:unpack()
	for i=-1,1,2 do
		local phi = (20*i) * (math.pi / 180)
		local spreadAimAt = aimAt:rotated(phi)
		local bulletVel = spreadAimAt * 360
		local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage1Boss:fireRandom()
	local x,y = self.position:unpack()
	for i=1,4,1 do
		local newBullet = EnemyBullet(x, y, math.random(-400, 400), 220+math.random(140), self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage1Boss:moveToNeutral()
	self.desiredPosition.x = 240
	self.desiredPosition.y = 160
end

function Stage1Boss:moveToLowerNeutral()
	self.desiredPosition.x = 240
	self.desiredPosition.y = 280
end

function Stage1Boss:explode()
	local expl = Explosion(self.position.x + math.random(-113, 113), self.position.y + math.random(-104, 104), 0, 0, 1.4)
	self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
end

function Stage1Boss:die()
	self:onDestroy()
	self.isDestroyed = true
	for i=1,20 do
		local expl = Explosion(self.position.x + math.random(-113, 113), self.position.y + math.random(-104, 104), 0, 0, 1.4)
		self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
	end
	self.state:stageComplete()
end

function Stage1Boss:moveToTopLeft()
	self.desiredPosition.x = 60
	self.desiredPosition.y = 60
end

function Stage1Boss:moveToTopRight()
	self.desiredPosition.x = 480-60
	self.desiredPosition.y = 60
end

function Stage1Boss:startPhase1()
	self.schedule = {
		{0, "moveToNeutral", false},
		{1, "startPhase2", false}
	}
	self.phaseTick = 0
end

function Stage1Boss:startPhase2()
	self.schedule = {
		{0.5, "fireClumpCircle", false},
		{1.5, "fireClumpCircle", false},
		{1.80, "fireAimedSpread", false},
		{1.81, "fireAimedSpread", false},
		{1.82, "fireAimedSpread", false},
		{1.83, "fireAimedSpread", false},
		{1.84, "fireAimedSpread", false},
		{1.85, "fireAimedSpread", false},
		{1.86, "fireAimedSpread", false},
		{1.87, "fireAimedSpread", false},
		{1.88, "fireAimedSpread", false},
		{1.89, "fireAimedSpread", false},
		{2, "fireClumpCircle", false},
		{3, "checkPhase2", false}
	}
	self.phaseTick = 0
end

function Stage1Boss:startPhase3()
	self.schedule = {
		{0.05, "moveToTopLeft", false},
		{0.1, "fireRandom", false},
		{0.2, "fireRandom", false},
		{0.3, "fireRandom", false},
		{0.4, "fireRandom", false},
		{0.5, "fireRandom", false},
		{0.6, "fireRandom", false},
		{0.7, "fireRandom", false},
		{0.8, "fireRandom", false},
		{0.9, "fireRandom", false},
		{1.0, "fireRandom", false},
		{1.1, "fireRandom", false},
		{1.2, "fireRandom", false},
		{1.3, "fireRandom", false},
		{1.4, "fireRandom", false},
		{1.5, "fireRandom", false},
		{1.6, "fireRandom", false},
		{1.7, "fireRandom", false},
		{1.8, "fireRandom", false},
		{1.9, "fireRandom", false},
		{2.0, "fireRandom", false},
		{2.1, "moveToTopRight", false},
		{2.1, "fireRandom", false},
		{2.2, "fireRandom", false},
		{2.3, "fireRandom", false},
		{2.4, "fireRandom", false},
		{2.5, "fireRandom", false},
		{2.6, "fireRandom", false},
		{2.7, "fireRandom", false},
		{2.8, "fireRandom", false},
		{2.9, "fireRandom", false},
		{3.0, "fireRandom", false},
		{3.1, "fireRandom", false},
		{3.2, "fireRandom", false},
		{3.3, "fireRandom", false},
		{3.4, "fireRandom", false},
		{3.5, "fireRandom", false},
		{3.6, "fireRandom", false},
		{3.7, "fireRandom", false},
		{3.8, "fireRandom", false},
		{3.9, "fireRandom", false},
		{4.0, "fireRandom", false},
		{4.1, "checkPhase3", false},
	}
	self.phaseTick = 0
end

function Stage1Boss:startPhase4()
	self.schedule = {
		{0, "fireEnclosingBullets", false},
		{0, "fireRandom", false},
		{0.05, "moveToNeutral", false},
		{0.05, "fireEnclosingBullets", false},
		{0.10, "fireEnclosingBullets", false},
		{0.10, "fireAimedArc", false},
		{0.15, "fireEnclosingBullets", false},
		{0.20, "fireEnclosingBullets", false},
		{0.20, "fireRandom", false},
		{0.25, "fireEnclosingBullets", false},
		{0.30, "fireEnclosingBullets", false},
		{0.35, "fireEnclosingBullets", false},
		{0.40, "fireEnclosingBullets", false},
		{0.40, "fireRandom", false},
		{0.45, "fireEnclosingBullets", false},
		{0.50, "fireEnclosingBullets", false},
		{0.55, "fireEnclosingBullets", false},
		{0.60, "fireEnclosingBullets", false},
		{0.60, "fireRandom", false},
		{0.65, "fireEnclosingBullets", false},
		{0.70, "fireEnclosingBullets", false},
		{0.75, "fireEnclosingBullets", false},
		{0.80, "fireEnclosingBullets", false},
		{0.80, "fireRandom", false},
		{0.85, "fireEnclosingBullets", false},
		{0.90, "fireEnclosingBullets", false},
		{0.95, "fireEnclosingBullets", false},
		{1.00, "fireEnclosingBullets", false},
		{1.00, "fireRandom", false},
		{1.05, "fireEnclosingBullets", false},
		{1.10, "fireEnclosingBullets", false},
		{1.15, "fireEnclosingBullets", false},
		{1.20, "fireEnclosingBullets", false},
		{1.20, "fireRandom", false},
		{1.35, "fireEnclosingBullets", false},
		{1.40, "fireEnclosingBullets", false},
		{1.45, "fireEnclosingBullets", false},
		{1.50, "fireEnclosingBullets", false},
		{1.50, "fireRandom", false},
		{1.55, "fireEnclosingBullets", false},
		{1.60, "fireEnclosingBullets", false},
		{1.65, "fireEnclosingBullets", false},
		{1.70, "fireEnclosingBullets", false},
		{1.70, "fireRandom", false},
		{1.75, "fireEnclosingBullets", false},
		{1.8, "resetCurrentPhase", false}
	}
	self.phaseTick = 0
end

function Stage1Boss:startPhase5()
	self.schedule = {
		{0, "moveToLowerNeutral", false},
		{0, "explode", false},
		{0.1, "explode", false},
		{0.2, "explode", false},
		{0.3, "explode", false},
		{0.4, "explode", false},
		{0.5, "explode", false},
		{0.6, "explode", false},
		{0.7, "explode", false},
		{0.8, "explode", false},
		{0.9, "explode", false},
		{1.0, "die", false}
	}
	self.phaseTick = 0
end

function Stage1Boss:checkPhase2()
	if self.health > 4000 then
		self:resetCurrentPhase()
	else
		self:startPhase3()
	end
end

function Stage1Boss:checkPhase3()
	if self.health > 2000 then
		self:resetCurrentPhase()
	else
		self:startPhase4()
	end
end

function Stage1Boss:resetCurrentPhase()
	for i,v in ipairs(self.schedule) do
		v[3] = false
	end
	self.phaseTick = 0
end

function Stage1Boss:onHit(entity)
	if entity.damageOnHit then
		self.health = self.health - entity.damageOnHit
		if self.health <= 0 then
			self:startPhase5()
			self.state:fadeBossMusic()
			self.state.manager:clearBullets()
			self.health = 0
		end
	end
end

function Stage1Boss:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 113, 104)

	Entity.draw(self)

	if self.state.player.viewBossHealth then
		love.graphics.draw(self.energyBarBack, 120, 10)
		love.graphics.draw(self.energyBar, 120, 10, 0, (self.health / 6000), 1)
		love.graphics.draw(self.energyBarFront, 120, 10)
	end
end

return Stage1Boss