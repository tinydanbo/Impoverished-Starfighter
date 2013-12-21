Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
Explosion = require "game.particles.explosion"
Boss2Drone = require "game.enemies.boss2drone"
EntityTypes = require "entities.types"

Stage2Boss = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 4500
		self.image = love.graphics.newImage("data/img/enemy/stage2boss/stage2boss.png")
		self.energyBarFront = love.graphics.newImage("data/img/hud/energy-front.png")
		self.energyBar = love.graphics.newImage("data/img/hud/boss-bar.png")
		self.energyBarBack = love.graphics.newImage("data/img/hud/energy-back.png")
		self.phase = 1
		self.tick = 0
		self.desiredPosition = vector(240, 160)
		self.hitbox = {
			x1 = x - 180,
			x2 = x + 180,
			y1 = y - 120,
			y2 = y + 80
		}
		self.phaseTick = 0
		self.schedule = {}

		self:startPhase1()
		self.fireRotation = 0
		self.fireRotationIncrease = 180
	end,
}

function Stage2Boss:update(dt)
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

	self.fireRotation = self.fireRotation + (self.fireRotationIncrease * dt)

	-- move to desired position
	local difference = self.desiredPosition - self.position

	if difference:len() > 10 then
		local movement = difference:normalized() * 160
		self:move(movement * dt)
	end
end

function Stage2Boss:fireClumpCircle()
	local player = self.state.player
	local difference = player.position - self.position
	local aimAt = difference:normalized()

	local x,y = self.position:unpack()
	for i=-10,10,1 do
		local phi = (16*i)+math.random(-8, 8) * (math.pi / 180)
		for j=-1,1,1 do
			local spreadAimAt = aimAt:rotated(phi+(j*0.01))
			local bulletVel = spreadAimAt * 130
			local newBullet = EnemyBullet(x+(spreadAimAt.x * 50), y+(spreadAimAt.y * 50), bulletVel.x, bulletVel.y, self.state)
			self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
		end
	end
end

function Stage2Boss:fireAimedSpread()
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

function Stage2Boss:fireAimedArc()
	local player = self.state.player
	local difference = player.position - self.position
	local aimAt = difference:normalized()

	local x,y = self.position:unpack()
	local offset = math.random(-10, 10)
	for i=-10+offset,10+offset,1 do
		local phi = (i*6) * (math.pi / 180)
		local spreadAimAt = aimAt:rotated(phi)
		local bulletVel = spreadAimAt * 260
		local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage2Boss:fireSpinShot()
	local x,y = self.position:unpack()

	for i=0,3,1 do
		local phi = ((self.fireRotation+(i*90)) % 360) * (math.pi / 180)
		local aimAt = vector(0,1):rotated(phi)
		local bulletVel = aimAt * 300
		local newBullet = EnemyBullet(x, y+40, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage2Boss:fireEnclosingBullets()
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

function Stage2Boss:fireVertical()
	local x,y = self.position:unpack()
	local newBullet = EnemyBullet(x+90, y+110, 0, 300, self.state)
	self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	local newBullet2 = EnemyBullet(x-90, y+110, 0, 300, self.state)
	self.state.manager:addEntity(newBullet2, EntityTypes.ENEMY_BULLET)
	local newBullet3 = EnemyBullet(x+90, y+140, 0, 300, self.state)
	self.state.manager:addEntity(newBullet3, EntityTypes.ENEMY_BULLET)
	local newBullet4 = EnemyBullet(x-90, y+140, 0, 300, self.state)
	self.state.manager:addEntity(newBullet4, EntityTypes.ENEMY_BULLET)
end

function Stage2Boss:spawnDrones()
	local x,y = self.position:unpack()
	local drone = Boss2Drone(x-100, y, -200, 200, self.state)
	self.state.manager:addEntity(drone, EntityTypes.ENEMY)
	local drone = Boss2Drone(x+100, y, 200, 200, self.state)
	self.state.manager:addEntity(drone, EntityTypes.ENEMY)
end

function Stage2Boss:fireRandom()
	local x,y = self.position:unpack()
	for i=1,4,1 do
		local newBullet = EnemyBullet(x, y, math.random(-400, 400), 220+math.random(140), self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function Stage2Boss:moveToNeutral()
	self.desiredPosition.x = 240
	self.desiredPosition.y = 160
end

function Stage2Boss:moveToLowerNeutral()
	self.desiredPosition.x = 240
	self.desiredPosition.y = 280
end

function Stage2Boss:explode()
	local expl = Explosion(self.position.x + math.random(-113, 113), self.position.y + math.random(-104, 104), 0, 0, 1.4)
	self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
end

function Stage2Boss:die()
	self:onDestroy()
	self.isDestroyed = true
	for i=1,20 do
		local expl = Explosion(self.position.x + math.random(-113, 113), self.position.y + math.random(-104, 104), 0, 0, 1.4)
		self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
	end
	self.state:stageComplete()
end

function Stage2Boss:moveToTopLeft()
	self.desiredPosition.x = 60
	self.desiredPosition.y = 60
end

function Stage2Boss:moveToLow()
	self.desiredPosition.x = self.state.player.position.x
	self.desiredPosition.y = 240
end

function Stage2Boss:moveToHigh()
	self.desiredPosition.x = self.state.player.position.x
	self.desiredPosition.y = 100
end

function Stage2Boss:moveToTopRight()
	self.desiredPosition.x = 480-60
	self.desiredPosition.y = 60
end

function Stage2Boss:startPhase1()
	self.schedule = {
		{0, "moveToNeutral", false},
		{1, "startPhase2", false}
	}
	self.phaseTick = 0
end

function Stage2Boss:startPhase2()
	self.schedule = {
		{0, "fireVertical", false},
		{0.1, "fireRandom", false},
		{0.1, "fireVertical", false},
		{0.2, "fireRandom", false},
		{0.2, "fireVertical", false},
		{0.3, "fireRandom", false},
		{0.3, "fireVertical", false},
		{0.4, "fireRandom", false},
		{0.4, "fireVertical", false},
		{0.5, "fireRandom", false},
		{0.5, "fireVertical", false},
		{0.6, "fireRandom", false},
		{0.6, "fireVertical", false},
		{0.7, "fireRandom", false},
		{0.7, "fireVertical", false},
		{0.8, "fireRandom", false},
		{0.8, "fireVertical", false},
		{0.9, "fireRandom", false},
		{0.9, "fireVertical", false},
		{1.0, "fireRandom", false},
		{1.1, "fireVertical", false},
		{1.1, "fireRandom", false},
		{1.2, "fireVertical", false},
		{1.2, "fireRandom", false},
		{1.3, "fireVertical", false},
		{1.3, "fireRandom", false},
		{1.4, "fireVertical", false},
		{1.4, "checkPhase2", false}
	}
	self.phaseTick = 0
end

function Stage2Boss:startPhase3()
	self.schedule = {
		{0.1, "moveToLow", false},
		{0.3, "fireAimedArc", false},
		{0.5, "spawnDrones", false},
		{0.7, "fireAimedArc", false},
		{1, "spawnDrones", false},
		{1, "moveToHigh", false},
		{1.3, "fireAimedArc", false},
		{1.5, "spawnDrones", false},
		{1.7, "fireAimedArc", false},
		{2, "spawnDrones", false},
		{2.3, "checkPhase3", false}
	}
	self.phaseTick = 0
end

function Stage2Boss:startPhase4()
	self.schedule = {
		{0, "moveToNeutral", false},
		{0, "fireSpinShot", false},
		{0.05, "fireSpinShot", false},
		{0.1, "fireSpinShot", false},
		{0.125, "fireClumpCircle", false},
		{0.15, "fireSpinShot", false},
		{0.2, "resetCurrentPhase", false}
	}
	self.phaseTick = 0
end

function Stage2Boss:startPhase5()
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

function Stage2Boss:checkPhase2()
	if self.health > 3000 then
		self:resetCurrentPhase()
	else
		self:startPhase3()
	end
end

function Stage2Boss:checkPhase3()
	if self.health > 1500 then
		self:resetCurrentPhase()
	else
		self:startPhase4()
	end
end

function Stage2Boss:resetCurrentPhase()
	for i,v in ipairs(self.schedule) do
		v[3] = false
	end
	self.phaseTick = 0
end

function Stage2Boss:onHit(entity)
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

function Stage2Boss:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 181, 124)

	Entity.draw(self)

	if self.state.player.viewBossHealth then
		love.graphics.draw(self.energyBarBack, 120, 10)
		love.graphics.draw(self.energyBar, 120, 10, 0, (self.health / 4500), 1)
		love.graphics.draw(self.energyBarFront, 120, 10)
	end
end

return Stage2Boss