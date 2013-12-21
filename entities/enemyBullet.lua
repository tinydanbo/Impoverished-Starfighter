Class = require "lib.hump.class"
vector = require "lib.hump.vector"
Entity = require "entity"
loader = require "lib.loader"

EnemyBullet = Class{__includes = Entity,
	init = function(self, x, y, dx, dy, state)
		Entity.init(self, x, y, state)
		self.velocity = vector(dx, dy)
		self.image = loader.Image.projectiles.basicEnemyBullet
		self.hitbox = {
			x1 = x - 4,
			x2 = x + 4,
			y1 = y - 4,
			y2 = y + 4
		}
	end
}

function EnemyBullet:update(dt)
	self:move(self.velocity * dt)

	if not self:isOnScreen() then
		self:destroy()
	end
end

function EnemyBullet:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, 0, 1, 1, 6, 6)

	Entity.draw(self)
end

return EnemyBullet