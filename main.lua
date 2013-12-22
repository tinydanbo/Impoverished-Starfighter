io.stdout:setvbuf("no")

Gamestate = require "lib.hump.gamestate"
loader = require "lib.loader"
titleState = require "states.title"
anim8 = require "lib.anim8"

config = require "game.config"

function love.load()

	config.loadFromFile()

	love.window.setMode(config.values.screenWidth, config.values.screenHeight)
	canvas = love.graphics.newCanvas(480, 640)

	loader.setBaseImageDir('data/img')
	loader.setBaseAudioDir('data/sound')
	loader.init()

	love.graphics.setDefaultFilter("nearest", "nearest")
	Gamestate.registerEvents{'update', 'quit', 'keyreleased', 'mousepressed', 'mousereleased'}
	Gamestate.switch(titleState)
end

function love.draw()
	love.graphics.setCanvas(canvas)
		canvas:clear()
		Gamestate.draw()
		love.graphics.setColor(255, 255, 255)
	love.graphics.setCanvas()

	love.graphics.draw(
		canvas, 
		config.values.screenWidth / 2, 
		config.values.screenHeight / 2, 
		0, 
		config.values.screenScaling, 
		config.values.screenScaling, 
		canvas:getWidth() / 2,
		canvas:getHeight() / 2
	)
end