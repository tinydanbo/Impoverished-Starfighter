io.stdout:setvbuf("no")

Gamestate = require "lib.hump.gamestate"
loader = require "lib.loader"
titleState = require "states.title"
anim8 = require "lib.anim8"

config = require "game.config"

function love.load()

	config.loadFromFile()

	-- love.window.setMode(config.values.screenWidth, config.values.screenHeight)

	loader.setBaseImageDir('data/img')
	loader.setBaseAudioDir('data/sound')
	loader.init()
	loader.explosionGrid = anim8.newGrid(128, 128, 1024, 1024)

	love.graphics.setDefaultFilter("nearest", "nearest")
	Gamestate.registerEvents{'update', 'quit', 'keyreleased', 'mousepressed', 'mousereleased'}
	Gamestate.switch(titleState)
end

function love.draw()
	Gamestate.draw()
	love.graphics.setColor(255, 255, 255)
	-- love.graphics.printf(tostring(love.timer.getFPS( )).."fps", 0, (love.graphics.getHeight() - 20), (love.graphics.getWidth() - 5), "right")
end