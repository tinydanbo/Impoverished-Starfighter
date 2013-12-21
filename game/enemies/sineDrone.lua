Class = require "lib.hump.class"
Enemy = require "entities.enemy"
vector = require "lib.hump.vector"
EnemyBullet = require "entities.enemyBullet"
EntityTypes = require "entities.types"

SineDrone = Class{__includes = Enemy,
	init = function(self, x, y, invert, state)
		Enemy.init(self, x, y, state)
		self.health = 10
		self.image = love.graphics.newImage("data/img/enemy/sine/sine-drone.png")
		self.rotation = 0
		self.hitbox = {
			x1 = x - 18,
			x2 = x + 18,
			y1 = y - 18,
			y2 = y + 18
		}
		self.tick = 0
		self.invert = invert
	end,
}

function SineDrone:update(dt)
	self.tick = self.tick + dt
	if self.invert then
		local movement = vector(math.sin((self.tick*6)+90)*300, 160)
		self:move(movement * dt)
	else
		local movement = vector(math.sin((self.tick*6)-90)*300, 160)
		self:move(movement * dt)
	end
end

function SineDrone:draw()
	local x,y = self.position:unpack()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, x, y, self.rotation, 1, 1, 16, 18)

	Entity.draw(self)
end

return SineDrone