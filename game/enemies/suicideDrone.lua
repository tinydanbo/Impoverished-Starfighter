Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

SuicideDrone = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 3
		self.image = love.graphics.newImage("data/img/enemy/suicide/suicide-drone.png")
		self.rotation = 0
		self.hitbox = {
			x1 = x - 7,
			x2 = x + 7,
			y1 = y - 7,
			y2 = y + 7
		}
	end,
}

function SuicideDrone:update(dt)
	local player = self.state.player

	local movement = vector(0, 200)

	self:move(movement * dt)
end

function SuicideDrone:onDestroy()
	local x,y = self.position:unpack()
	local shots = 20
	for i=0,shots do
		local phi = ((360/shots) * i) * (math.pi / 180)
		local spreadAimAt = vector(0,1):rotated(phi)
		local bulletVel = spreadAimAt * 200
		local newBullet = EnemyBullet(x, y, bulletVel.x, bulletVel.y, self.state)
		self.state.manager:addEntity(newBullet, EntityTypes.ENEMY_BULLET)
	end
end

function SuicideDrone:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 15, 27)

	Entity.draw(self)
end

return SuicideDrone