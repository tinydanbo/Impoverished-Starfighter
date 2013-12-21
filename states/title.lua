Entity = require("entity")
Decoration = require("entities.decoration")
ScreenMask = require("entities.screenmask")
tween = require("lib.tween")

shopState = require("states.shop")

local title = {}

function title:enter()

	self.beepSnd = love.audio.newSource("data/sound/beep-07.ogg", "static")

	self.background = Decoration("data/img/title/stars.png", 240, 300)
	tween(15, self.background, {y = 400}, 'outQuad')

	self.title1 = Decoration("data/img/title/impoverished.png", -240, 285)
	self.title2 = Decoration("data/img/title/starfighter.png", 720, 324)

	self.devinfo = Decoration("data/img/title/devinfo.png", 340, 355)
	self.devinfo.alpha = 0

	self.aboutInfo = Decoration("data/img/title/about-info.png", 900, 320)

	self.planet = Decoration("data/img/title/planet.png", 480 - (329 / 2), 780)
	tween(15, self.planet, {y = 550}, 'outQuad')

	self.rocks = Decoration("data/img/title/rocks.png", 284 / 2, 100)
	tween(15, self.rocks, {y = 300}, 'outQuad')

	self.opt1 = Decoration("data/img/title/start.png", 80, 500)
	self.opt1.alpha = 0
	self.opt2 = Decoration("data/img/title/about.png", 80, 536)
	self.opt2.alpha = 0
	self.opt3 = Decoration("data/img/title/quit.png", 80, 572)
	self.opt3.alpha = 0

	self.options = {self.opt1, self.opt2, self.opt3}

	self.blackMask = ScreenMask(0, 0, 0, 255)
	tween(0.4, self.blackMask, {alpha = 0})

	self.activated = false
	self.locked = false
	self.choice = 1
	self.about = false
end

function title:draw()
	self.background:draw()
	self.planet:draw()
	self.rocks:draw()

	self.title2:draw()
	self.title1:draw()
	self.devinfo:draw()

	self.opt1:draw()
	self.opt2:draw()
	self.opt3:draw()

	self.aboutInfo:draw()

	love.graphics.print("v0.5", 5, 625)

	self.blackMask:draw()
end

function title:update(dt)
	tween.update(dt)

	if self.activated then
		for i=1,3 do
			if i == self.choice then
				self.options[i].alpha = 255
			else
				self.options[i].alpha = 100
			end
		end
	end
end

function title:startGame()
	self.locked = false
	Gamestate.push(shopState)
	self.blackMask = ScreenMask(0, 0, 0, 0)
end

function title:quitGame()
	love.event.quit()
end

function title:enterAbout()
	tween(0.2, self.title1, {x = -300})
	tween(0.2, self.title2, {x = -240})
	tween(0.2, self.devinfo, {x = -240})
	tween(0.2, self.opt1, {x = -100})
	tween(0.2, self.opt2, {x = -100})
	tween(0.2, self.opt3, {x = -100})
	tween(0.2, self.aboutInfo, {x = 250})
	self.about = true
end

function title:exitAbout()
	tween(0.2, self.title1, {x = 180})
	tween(0.2, self.title2, {x = 240})
	tween(0.2, self.devinfo, {x = 340})
	tween(0.2, self.opt1, {x = 80})
	tween(0.2, self.opt2, {x = 80})
	tween(0.2, self.opt3, {x = 80})
	tween(0.2, self.aboutInfo, {x = 900})
	self.about = false
end

function title:keyreleased(key)
	
	if self.about then
		self:exitAbout()
		return
	end

	if self.activated and not self.locked then
		if (key == "down" or key == "s") and self.choice < 3 then
			self.choice = self.choice + 1
			love.audio.play(self.beepSnd)
		elseif (key == "up" or key == "w") and self.choice > 1 then
			self.choice = self.choice - 1
			love.audio.play(self.beepSnd)
		end

		if (key == "z" or key == "j") then
			if self.choice == 1 then
				self.locked = true
				tween(0.4, self.blackMask, {alpha = 255}, 'linear', self.startGame, self)
			elseif self.choice == 2 then
				self:enterAbout()
			elseif self.choice == 3 then
				self.locked = true
				tween(0.4, self.blackMask, {alpha = 255}, 'linear', self.quitGame, self)
			end
		end
	else
		tween(0.2, self.title1, {x = 180})
		tween(0.2, self.title2, {x = 240})
		tween(0.4, self.devinfo, {alpha = 255})
		tween(0.4, self.opt1, {alpha = 255})
		tween(0.4, self.opt2, {alpha = 255})
		tween(0.4, self.opt3, {alpha = 255})
		self.activated = true
	end
end

return title