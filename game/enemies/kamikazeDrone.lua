Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

KamikazeDrone = Class{__includes = Enemy,
	init = function(self, x, y, state)
		Enemy.init(self, x, y, state)
		self.health = 10
		self.image = love.graphics.newImage("data/img/enemy/kamikaze/kamikaze.png")
		self.rotation = 0
		self.hitbox = {
			x1 = x - 14,
			x2 = x + 14,
			y1 = y - 14,
			y2 = y + 14
		}
	end,
}

function KamikazeDrone:update(dt)

	local player = self.state.player

	local difference = self.state.player.position - self.position
	local moveAt = difference:normalized()
	local movement = moveAt * 100
	movement.y = 300

	self.rotation = math.atan2(-moveAt.x, moveAt.y)
	self:move(movement * dt)
end

function KamikazeDrone:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 17, 25)

	Entity.draw(self)
end

return KamikazeDrone