Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
PlayerBullet = require "entities.playerBullet"
EntityTypes = require "entities.types"
VulcanCannon = require "game.weapons.vulcanCannon"
PlasmaCannon = require "game.weapons.plasmaCannon"
MissileLauncher = require "game.weapons.missileLauncher"
Flamethrower = require "game.weapons.flamethrower"
RocketSalvo = require "game.weapons.rocketSalvo"
Explosion = require "game.particles.explosion"
BombFragment = require "game.projectiles.bombFragment"

Player = Class{__includes = Entity,
	init = function(self, x, y, shopShipObj, state)
		Entity.init(self, x, y, state)

		self.forwardImage = love.graphics.newImage("data/img/player/forward.png")
		self.leftImage = love.graphics.newImage("data/img/player/left.png")
		self.rightImage = love.graphics.newImage("data/img/player/right.png")
		self.hitbox = {
			x1 = x - 4,
			x2 = x + 4,
			y1 = y - 4,
			y2 = y + 4
		}

		self.bombSound = love.audio.newSource("data/sound/bomb.ogg", "static")

		self.weapons = {}
		self.secondaryWeapons = {}

		self:setUpShip(shopShipObj)
	end,
	speed = 220,
	tick = 0,
	energy = 100,
	lives = 2,
	invuln = true,
	endInvulnAt = 1,
	maxLives = 2,
	generatorRank = 0,
	explosionCounter = 0,
	explosionRate = 0.2,
	bombs = 2,
	shotDown = false,
	invisible = false,
	regainEnergyOnKill = false,
	autoBomb = false,
	deathBomb = false,
	viewBossHealth = false
}

function Player:setUpShip(shopShipObj)
	if shopShipObj.vulcanRank > 0 then
		table.insert(self.weapons, VulcanCannon(shopShipObj.vulcanRank, self.state))
	end
	if shopShipObj.plasmaRank > 0 then
		table.insert(self.weapons, PlasmaCannon(shopShipObj.plasmaRank, self.state))
	end
	if shopShipObj.missilesRank > 0 then
		table.insert(self.weapons, MissileLauncher(shopShipObj.missilesRank, self.state))
	end
	if shopShipObj.rocketsRank > 0 then
		table.insert(self.secondaryWeapons, RocketSalvo(shopShipObj.rocketsRank, self.state))
	end
	if shopShipObj.flamethrowerRank > 0 then
		table.insert(self.secondaryWeapons, Flamethrower(shopShipObj.flamethrowerRank, self.state))
	end

	self.lives = 2 + shopShipObj.armorRank
	self.maxLives = self.lives

	self.speed = 200 + (shopShipObj.speedRank * 40)

	self.generatorRank = shopShipObj.generatorRank

	self.bombPowerRank = shopShipObj.bombPowerRank
	self.bombRadiusRank = shopShipObj.bombRadiusRank
	self.bombDelayRank = shopShipObj.bombDelayRank
	self.bombs = 2 + shopShipObj.bombQuantityRank
	self.bombQuantityRank = shopShipObj.bombQuantityRank

	if shopShipObj.absorbRank > 0 then
		self.regainEnergyOnKill = true
	end

	if shopShipObj.autobombRank > 0 then
		self.autoBomb = true
	end

	if shopShipObj.deathbombRank > 0 then
		self.deathBomb = true
	end

	if shopShipObj.hitboxRank > 0 then
		self.hitbox = {
			x1 = self.position.x - 2,
			x2 = self.position.x + 2,
			y1 = self.position.y - 2,
			y2 = self.position.y + 2
		}
	end

	if shopShipObj.analysisRank > 0 then
		self.viewBossHealth = true
	end
end

function Player:update(dt)

	self.tick = self.tick + dt

	self.endInvulnAt = self.endInvulnAt - dt

	if self.invuln and self.endInvulnAt < 0 then
		self.invuln = false
	end

	if self.shotDown and not self.invisible then
		self.speed = 60
		self.explosionCounter = self.explosionCounter + dt
		if self.explosionCounter > self.explosionRate then
			self.explosionCounter = 0
			local expl = Explosion(self.position.x+math.random(-16, 16), self.position.y+math.random(16, 16), 0, 0, 1)
			self.state.manager:addEntity(expl, EntityTypes.PARTICLE)
		end
	end

	local delta = vector(0,0)
	if love.keyboard.isDown("w", "up") then
		delta.y = -1
	elseif love.keyboard.isDown("s", "down") then
		delta.y = 1
	end

	if love.keyboard.isDown("a", "left") then
		delta.x = -1
	elseif love.keyboard.isDown("d", "right") then
		delta.x = 1
	end

	for i,v in ipairs(self.weapons) do
		v:update(dt)
	end
	for i,v in ipairs(self.secondaryWeapons) do
		v:update(dt)
	end

	if love.keyboard.isDown("j", "z") then
		self.tick = 0
		for i,v in ipairs(self.weapons) do
			v:fire()
		end
	end

	if love.keyboard.isDown("k", "x") then
		for i,v in ipairs(self.secondaryWeapons) do
			v:fire()
		end
	else
		self.energy = self.energy + ((2+(self.generatorRank*2)) * dt)
	end

	if self.energy > 100 then
		self.energy = 100
	end

	if self.energy < 0 then
		self.energy = 0
	end

	self:move(delta * (self.speed * dt))

	if self.position.x > 475 then
		self:move(vector(475 - self.position.x, 0))
	elseif self.position.x < 5 then
		self:move(vector(5 - self.position.x, 0))
	end

	if self.position.y > 595 then
		self:move(vector(0, 595 - self.position.y))
	elseif self.position.y < 5 then
		self:move(vector(0, 5 - self.position.y))
	end

end

function Player:fireBomb()
	self.state:screenFlash(220, 220, 220)
	love.audio.rewind(self.bombSound)
	love.audio.play(self.bombSound)
	self.state.manager:clearBullets()
	local x,y = self.position:unpack()
	for i=-16,16,1 do
		local phi = (10*i)+math.random(-3, 3) * (math.pi / 180)
		local spreadAimAt = vector(0,-1):rotated(phi)
		local bulletVel = spreadAimAt * 280
		local newBullet = BombFragment(x, y, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.PLAYER_BULLET)
	end
end

function Player:onHit()
	if not self.invuln and not self.shotDown then
		if self.autoBomb and self.bombs > 1 then
			self:fireBomb()
			self.bombs = 0
		else
			self.lives = self.lives - 1
			if self.deathBomb then
				-- lol
				self:fireBomb()
				self:fireBomb()
				self:fireBomb()
			end
			self.state:screenFlash(255, 0, 0)
			self.energy = 100
			self.state.manager:clearBullets()
			if not self.invuln then
				self.invuln = true
				self.endInvulnAt = 3
			end
			self.bombs = self.bombs + 1 + math.floor(self.bombQuantityRank / 2)
		end
	end

	if self.lives < 0 then
		if not self.shotDown then
			self.state:startGameOver()
		end
		self.shotDown = true
	end
end

function Player:draw()
	local x,y = self.position:unpack()

	if self.invuln then
		love.graphics.setColor(180, 180, 255)
	else if self.shotDown then
		love.graphics.setColor(100, 100, 100)
	else
		love.graphics.setColor(255, 255, 255)
	end
	end

	if not self.invisible then
		if love.keyboard.isDown("a", "left") then
			love.graphics.draw(self.leftImage, x, y, 0, 1, 1, 18, 25)
		elseif love.keyboard.isDown("d", "right") then
			love.graphics.draw(self.rightImage, x, y, 0, 1, 1, 18, 25)
		else
			love.graphics.draw(self.forwardImage, x, y, 0, 1, 1, 22, 25)
		end
	end

	Entity.draw(self)
end

function Player:keyreleased(key)
	if key == "l" or key == "c" then
		if self.bombs > 0 and not self.shotDown then
			self:fireBomb()
			self.bombs = self.bombs - 1
		end
	end
end

return Player