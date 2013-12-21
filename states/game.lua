Entity = require("entity")
EntityManager = require("entityManager")
Player = require("entities.player")
EntityTypes = require("entities.types")
Hud = require("game.hud")
Scenery = require("entities.scenery")
Decoration = require("entities.decoration")
tween = require("lib.tween")
endingState = require("states.ending")
Gamestate = require("lib.hump.gamestate")

local game = {}

function game:enter(previousState, shopShipObj)
	self.manager = EntityManager()

	self.player = Player(240, 500, shopShipObj, self)
	self.manager:addEntity(self.player, EntityTypes.PLAYER)

	self.warningFont = love.graphics.newFont("data/font/04B_03__.TTF", 8)
	

	self.hud = Hud(self)

	self.bossWarningDecoration = Decoration("data/img/boss_warning.png", 340, -200, self)
	self.gameOverDecoration = Decoration("data/img/gameOver.png", 600, 340, self)

	self.bossWarning = false

	self.flashRed = 0
	self.flashGreen = 0
	self.flashBlue = 0
	self.flashAlpha = 0

	self.blackMask = ScreenMask(0, 0, 0, 255)
	
	self.bossAlarm = love.audio.newSource("data/sound/alarm.ogg", "static")
	self.bossAlarm:setVolume(0.3)
	self.bossMusic = love.audio.newSource("data/music/kitrock.ogg", "dynamic")
	self.bossMusic:setLooping(true)

	self.volume = {
		boss = 1,
		stage = 0
	}

	self.stage = 1
	self:setupStage(self.stage)
end

function game:setupStage(stageNum)
	self.stage = stageNum
	local stageObj = require("game.stages.stage" .. stageNum)

	self.stageMusic = love.audio.newSource("data/music/stage" .. stageNum .. ".ogg", "dynamic")
	tween(1, self.volume, {stage = 1})
	love.audio.play(self.stageMusic)

	self.tick = 0
	self.gameOver = false
	self.gameOverAt = 9999999999
	self.gameOverTransitionAt = 9999999999

	self.stageTransitionAt = 999999999

	self.manager:resetForNewStage()

	for i,v in ipairs(stageObj.scenery) do
		local scenery = Scenery("data/img/scenery/" .. v[1] .. ".png", v[2], v[3])
		self.manager:addEntity(scenery, EntityTypes.SCENERY)
	end

	self.events = stageObj.getEvents()

	self.backgroundImage = love.graphics.newImage("data/img/stage" .. stageNum .. "stars.png")
	self.imageOffset = (self.backgroundImage:getHeight() - love.graphics.getHeight()) * -1
	self.scrollRate = 50

	tween(1, self.blackMask, {alpha = 0})
end

function game:update(dt)
	self.tick = self.tick + dt

	if not self.gameOver then
		self.manager:update(dt)

		self.imageOffset = self.imageOffset + (self.scrollRate * dt)
		if self.imageOffset > -1280 then
			self.imageOffset = (self.backgroundImage:getHeight() - love.graphics.getHeight()) * -1
		end
	end

	if self.gameOverAt < self.tick then
		-- set game over, tween message
		if not self.gameOver then
			tween(3, self.blackMask, {alpha = 255})
			tween(0.3, self.gameOverDecoration, {x = 240})
		end
		self.gameOver = true
		self.player.invisible = true
		if self.gameOverTransitionAt < self.tick then
			love.audio.stop()
			Gamestate.pop()
		end
	end

	if self.stageTransitionAt < self.tick then
		self:nextStage()
	end

	local i = 1
	while i <= #self.events do
		local event = self.events[i]
		if event[1] < self.tick then
			table.remove(self.events, i)
			event[2](self)
		else
			i = i + 1
		end
	end

	if self.flashAlpha > 0 then
		self.flashAlpha = self.flashAlpha - (700 * dt)
	end

	self.bossMusic:setVolume(self.volume.boss)
	self.stageMusic:setVolume(self.volume.stage)

	tween.update(dt)
end

function game:nextStage()
	local gameObj = self
	self.stageTransitionAt = 999999999
	
	if self.stage == 2 then
		self.manager:resetForNewStage()
		love.audio.stop()
		Gamestate.switch(endingState)
	end
	
	if self.stage == 1 then
		self.stage = 2
		tween(1, self.blackMask, {alpha = 255}, 'linear', function()
			gameObj:setupStage(2)
		end)
	end
end

function game:screenFlash(red, green, blue)
	self.flashRed = red
	self.flashGreen = green
	self.flashBlue = blue
	self.flashAlpha = 200
end

function game:startGameOver()
	self.gameOverAt = self.tick + 1
	self.gameOverTransitionAt = self.tick + 5
end

function game:stageComplete()
	self.stageTransitionAt = self.tick + 3
end

function game:fadeStageMusic()
	tween(1, self.volume, {stage = 0})
end

function game:playBossMusic()
	self.volume.boss = 1
	love.audio.rewind(self.bossMusic)
	love.audio.play(self.bossMusic)
end

function game:fadeBossMusic()
	local gameObj = self

	tween(2, self.volume, {boss = 0}, 'linear', function()
		love.audio.stop(gameObj.bossMusic)
	end)
end
function game:issueBossWarning()
	local stateObj = self
	love.audio.play(self.bossAlarm)
	self.bossWarning = true
	self.bossWarningDecoration.x = 340
	tween(0.2, self.bossWarningDecoration, {y = 300}, 'outQuad', function()
		tween(4.8, stateObj.bossWarningDecoration, {x = 0, y = 370})
	end)
end

function game:retractBossWarning()
	local stateObj = self
	tween(0.5, self.bossWarningDecoration, {y = -200}, 'outQuad', function()
		stateObj.bossWarning = false
	end)
end

function game:draw()
	love.graphics.draw(self.backgroundImage, 0, self.imageOffset)

	if self.flashAlpha > 0 then
		love.graphics.setColor(self.flashRed, self.flashGreen, self.flashBlue, self.flashAlpha)
		love.graphics.rectangle("fill", 0, 0, 480, 640)
	end

	love.graphics.setColor(255, 255, 255)

	self.manager:draw()

	self.hud:draw()

	if self.bossWarning then
		love.graphics.setFont(self.warningFont)
		love.graphics.setColor(255, 255, 255, 60)
		love.graphics.printf("The enemy is sending in a boss-class machine with the intent of shooting you down. There is no way out. Focus is expected. Skill is required. Death is mandatory.", 480-160-5, 572, 160, "right")
		self.bossWarningDecoration:draw()
	end

	self.blackMask:draw()
	self.gameOverDecoration:draw()

	-- love.graphics.print("Entities : " .. tostring(self.manager:getCount()), 10, 10)
end

function game:keyreleased(key, code)
	self.player:keyreleased(key)
end

return game