Class = require "lib.hump.class"
vector = require "lib.hump.vector"

Hud = Class {
	init = function(self, state)
		self.state = state
		self.energyBarFront = love.graphics.newImage("data/img/hud/energy-front.png")
		self.energyBar = love.graphics.newImage("data/img/hud/energy-bar.png")
		self.energyBarBack = love.graphics.newImage("data/img/hud/energy-back.png")
		self.pipGraphic = love.graphics.newImage("data/img/hud/life-pip.png")
		self.bombGraphic = love.graphics.newImage("data/img/hud/bomb.png")
	end,
}

function Hud:update(dt)

end

function Hud:draw()
	local player = self.state.player

	for i=0,4 do
		if i >= player.maxLives then
			love.graphics.setColor(100, 100, 100)
		elseif i >= player.lives then
			love.graphics.setColor(0, 0, 0)
		else
			love.graphics.setColor(40, 60, 200)
		end
		love.graphics.rectangle("fill", i*48, 640-24, 48, 24)
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.pipGraphic, i*48, 640-24)
	end

	love.graphics.draw(self.energyBarBack, 240, 640-24)
	love.graphics.draw(self.energyBar, 240, 640-24, 0, (player.energy / 100), 1)
	love.graphics.draw(self.energyBarFront, 240, 640-24)

	if self.state.player.bombs > 0 then
		for i=1,self.state.player.bombs do
			love.graphics.draw(self.bombGraphic, 10+((i-1)*20), 600, 0, 1, 1, 11, 13)
		end
	end
end

return Hud