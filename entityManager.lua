Class = require "lib.hump.class"
vector = require "lib.hump.vector"
EntityTypes = require "entities.types"

EntityManager = Class {
	init = function(self)
		self.player = {}
		self.enemies = {}
		self.enemyBullets = {}
		self.playerBullets = {}
		self.items = {}
		self.scenery = {}
		self.particles = {}
		self.size = 0
	end
}

function EntityManager:addEntity(entity, type)
	if type == EntityTypes.PLAYER then
		self.player = entity
	elseif type == EntityTypes.ENEMY then
		table.insert(self.enemies, entity)
	elseif type == EntityTypes.ENEMY_BULLET then
		table.insert(self.enemyBullets, entity)
	elseif type == EntityTypes.PLAYER_BULLET then
		table.insert(self.playerBullets, entity)
	elseif type == EntityTypes.ITEM then
		table.insert(self.items, entity)
	elseif type == EntityTypes.SCENERY then
		table.insert(self.scenery, entity)
	elseif type == EntityTypes.PARTICLE then
		table.insert(self.particles, entity)
	end
	self.size = self.size + 1
end

function EntityManager:getCount()
	return self.size
end

function EntityManager:updateTable(entityTable, dt)
	local i = 1
	while i <= #entityTable do
		entityTable[i]:update(dt)
		if entityTable[i].isDestroyed then
			table.remove(entityTable, i)
			self.size = self.size - 1
		else
			i = i + 1
		end
	end
end

function EntityManager:update(dt)
	if self.player then
		self.player:update(dt)
	end
	self:updateTable(self.enemies, dt)
	self:updateTable(self.enemyBullets, dt)
	self:updateTable(self.playerBullets, dt)
	self:updateTable(self.items, dt)
	self:updateTable(self.scenery, dt)
	self:updateTable(self.particles, dt)

	for i,v in ipairs(self.enemies) do
		for j,v2 in ipairs(self.playerBullets) do
			if v:collide(v2) then
				v2.isDestroyed = true
				v2:onCollide()
				v:onHit(v2)
			end
		end
	end

	for i,v in ipairs(self.enemyBullets) do
		if v:collide(self.player) then
			v.isDestroyed = true
			self.player:onHit()
		end
	end

	for i,v in ipairs(self.enemies) do
		if v:collide(self.player) and not v.groundEnemy then
			self.player:onHit()
		end
	end
end

function EntityManager:drawTable(entityTable)
	for i,v in ipairs(entityTable) do v:draw() end
end

function EntityManager:draw()
	self:drawTable(self.scenery)
	self:drawTable(self.enemies)
	self:drawTable(self.particles)
	self:drawTable(self.playerBullets)
	self:drawTable(self.items)
	self:drawTable(self.enemyBullets)
	self.player:draw()
end

function EntityManager:clearBullets()
	for i,v in ipairs(self.enemyBullets) do
		v.isDestroyed = true
	end
end

function EntityManager:resetForNewStage()
	self.enemies = {}
	self.enemyBullets = {}
	self.playerBullets = {}
	self.items = {}
	self.scenery = {}
	self.particles = {}
	self.size = 0
end

return EntityManager