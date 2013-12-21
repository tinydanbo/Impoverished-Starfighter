Class = require "lib.hump.class"
vector = require "lib.hump.vector"

Entity = Class {
	init = function(self, x, y, state)
		self.position = vector(x, y)
		self.state = state
	end,
	isDestroyed = false
}

function Entity:update(dt)

end

function Entity:draw()
	--[[
	if self.hitbox then
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("line", self.hitbox.x1, self.hitbox.y1, self.hitbox.x2 - self.hitbox.x1, self.hitbox.y2 - self.hitbox.y1)
	end
	]]--
end

function Entity:move(v)
	self.position = self.position + v
	if self.hitbox then
		self.hitbox.x1 = self.hitbox.x1 + v.x
		self.hitbox.x2 = self.hitbox.x2 + v.x
		self.hitbox.y1 = self.hitbox.y1 + v.y
		self.hitbox.y2 = self.hitbox.y2 + v.y
	end
end

function Entity:isOnScreen()
	if self.position.x > 480 then
		return false
	elseif self.position.x < 0 then
		return false
	elseif self.position.y > 640 then
		return false
	elseif self.position.y < 0 then
		return false
	end

	return true
end

function Entity:destroy()
	self.isDestroyed = true
end

function Entity:collide(otherEntity)
	if self.hitbox and otherEntity.hitbox then
		return not (
			otherEntity.hitbox.x1 > self.hitbox.x2 or
			otherEntity.hitbox.x2 < self.hitbox.x1 or
			otherEntity.hitbox.y1 > self.hitbox.y2 or
			otherEntity.hitbox.y2 < self.hitbox.y1)
	else
		return false
	end
end

return Entity