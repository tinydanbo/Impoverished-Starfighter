Entity = require("entity")
Decoration = require("entities.decoration")
ScreenMask = require("entities.screenmask")
tween = require("lib.tween")
Gamestate = require("lib.hump.gamestate")

local ending = {}

function ending:enter()
	local endingObj = self

	self.music = love.audio.newSource("data/music/2UNLIMIT.ogg", "dynamic")
	self.music:setLooping(true)

	self.message = Decoration("data/img/ending/great.png", 240, 320)

	self.blackMask = ScreenMask(0, 0, 0, 255)
	tween(4, self.blackMask, {alpha = 0}, 'inQuad', function()
		endingObj.active = true
	end)

	self.volume = {
		music = 0
	}

	tween(4, self.volume, {music = 1})

	love.audio.play(self.music)
	print("hi")
	self.active = false
end

function ending:draw()
	self.message:draw()
	self.blackMask:draw()
end

function ending:update(dt)
	tween.update(dt)

	self.music:setVolume(self.volume.music)
end

function ending:keyreleased(key)
	if self.active then
		tween(3, self.blackMask, {alpha = 255}, 'outQuad', function()
			love.audio.stop()
			Gamestate.pop()
		end)
		tween(3, self.volume, {music = 0})
	end
end

return ending