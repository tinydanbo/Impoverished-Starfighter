Gamestate = require "lib.hump.gamestate"
loader = require "lib.loader"
titleState = require "states.title"
anim8 = require "lib.anim8"

function love.load()
	loader.setBaseImageDir('data/img')
	loader.setBaseAudioDir('data/sound')
	loader.init()
	loader.explosionGrid = anim8.newGrid(128, 128, 1024, 1024)

	love.graphics.setDefaultImageFilter("nearest", "nearest")
	love.graphics.setIcon(love.graphics.newImage("data/img/icon.png"))
	Gamestate.registerEvents{'update', 'quit', 'keyreleased', 'mousepressed', 'mousereleased'}
	Gamestate.switch(titleState)
end

function love.draw()
	Gamestate.draw()
	love.graphics.setColor(255, 255, 255)
	-- love.graphics.printf(tostring(love.timer.getFPS( )).."fps", 0, (love.graphics.getHeight() - 20), (love.graphics.getWidth() - 5), "right")
end