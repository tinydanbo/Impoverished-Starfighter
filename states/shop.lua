require("lib.loveframes")
Gamestate = require "lib.hump.gamestate"
Decoration = require("entities.decoration")
loader = require "lib.loader"
gameState = require "states.game"
tween = require "lib.tween"

local shop = {}

local screenHeight = love.graphics.getHeight()
local screenWidth = love.graphics.getWidth()

function shop:enter()

	self.cash = 100
	self.ship = {
		vulcanRank = 0,
		plasmaRank = 0,
		missilesRank = 0,
		flamethrowerRank = 0,
		rocketsRank = 0,
		armorRank = 0,
		speedRank = 0,
		generatorRank = 0,
		bombPowerRank = 0,
		bombRadiusRank = 0,
		bombDelayRank = 0,
		bombQuantityRank = 0,
		absorbRank = 0,
		autobombRank = 0,
		deathbombRank = 0,
		hitboxRank = 0,
		analysisRank = 0
	}

	self.vulcanCost = 5
	self.vulcanMax = 3
	self.plasmaCost = 5
	self.plasmaMax = 3
	self.missilesCost = 5
	self.missilesMax = 3
	self.flamethrowerCost = 10
	self.flamethrowerMax = 3
	self.rocketsCost = 10
	self.rocketsMax = 3
	self.armorCost = 10
	self.armorMax = 3
	self.speedCost = 5
	self.speedMax = 3
	self.generatorCost = 10
	self.generatorMax = 3
	self.bombPowerCost = 5
	self.bombPowerMax = 3
	self.bombRadiusCost = 5
	self.bombRadiusMax = 3
	self.bombDelayCost = 5
	self.bombDelayMax = 3
	self.bombQuantityCost = 10
	self.bombQuantityMax = 3
	self.absorbCost = 10
	self.absorbMax = 1
	self.autobombCost = 15
	self.autobombMax = 1
	self.deathbombCost = 10
	self.deathbombMax = 1
	self.hitboxCost = 15
	self.hitboxMax = 1
	self.analysisCost = 5
	self.analysisMax = 1

	self.backgroundImage = love.graphics.newImage("data/img/menu_background.png")
	self.tipFont = love.graphics.newFont("data/font/04B_03__.TTF", 8)

	self.prompt = Decoration("data/img/shop/prompt.png", 240, 45)

	self.cashSnd = love.audio.newSource("data/sound/cash.ogg", "static")
	self.cashSnd:setVolume(0.2)
	self.reverseCashSnd = love.audio.newSource("data/sound/hsac.ogg", "static")
	self.reverseCashSnd:setVolume(0.2)

	self.shopMusic = love.audio.newSource("data/music/choke.ogg", "dynamic")
	self.shopMusic:setLooping(true)
	love.audio.rewind(self.shopMusic)
	love.audio.play(self.shopMusic)

	self.volume = {
		music = 0
	}

	self.blackMask = ScreenMask(0, 0, 0, 255)
	tween(0.4, self.blackMask, {alpha = 0})
	tween(0.4, self.volume, {music = 1})

	self:initGui()
end

function shop:createStaticFrame(name, x, y, w, h)
	local frame = loveframes.Create("frame")
	frame:SetName(name)
	frame:SetPos(x, y)
	frame:SetWidth(w)
	frame:SetHeight(h)
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	return frame
end

function shop:createBuyable(imagePath, frame, x, y, name, description)
	local menuObj = self

	local imgButton = loveframes.Create("imagebutton", frame)
	imgButton:SetImage(imagePath)
	imgButton:SetPos(x, y)
	imgButton:SizeToImage()
	imgButton:SetText("Lv.0")
	imgButton.OnClick = function(object, x, y, button)
		if not love.keyboard.isDown("lshift", "rshift") then
			if menuObj.ship[name .. "Rank"] < menuObj[name .. "Max"] and menuObj.cash >= menuObj[name .. "Cost"] then
				menuObj.cash = menuObj.cash - menuObj[name .. "Cost"]
				menuObj.ship[name .. "Rank"] = menuObj.ship[name .. "Rank"] + 1
				love.audio.rewind(self.cashSnd)
				love.audio.play(self.cashSnd)
			else

			end
		else
			if menuObj.ship[name .. "Rank"] > 0 then
				menuObj.cash = menuObj.cash + menuObj[name .. "Cost"]
				menuObj.ship[name .. "Rank"] = menuObj.ship[name .. "Rank"] - 1
				love.audio.rewind(self.reverseCashSnd)
				love.audio.play(self.reverseCashSnd)
			else

			end
		end
		imgButton:SetText("Lv." .. menuObj.ship[name .. "Rank"])
	end

	local ttpTooltip = loveframes.Create("tooltip")
	ttpTooltip:SetObject(imgButton)
	ttpTooltip:SetPadding(0)
	ttpTooltip:SetFont(self.tipFont)
	ttpTooltip:SetText(description)
	if (frame.x + x) > 240 then
		ttpTooltip:SetOffsets(-100, -10)
	end
end

function shop:initGui()

	local menuObj = self

	local btnConfirm = loveframes.Create("button")
	btnConfirm:SetText("Confirm")
	btnConfirm:SetPos(screenWidth - btnConfirm:GetWidth() - 10, screenHeight - btnConfirm:GetHeight() - 10)
	btnConfirm.OnClick = function(object, x, y)
		tween(0.4, menuObj.volume, {music = 0})
		tween(0.4, menuObj.blackMask, {alpha = 255}, 'linear', function()
			love.audio.stop()
			Gamestate.switch(gameState, menuObj.ship)
		end)
	end

	-- FRAMES

	local frmPrimaryWeapons = self:createStaticFrame("Primary Weapons", 46+10, 80+10, 214, 100)
	local frmSecondaryWeapons = self:createStaticFrame("Secondary Weapons", 10+46+214+10, 80+10, 144, 100)
	local frmShipStats = self:createStaticFrame("Ship Stats", 133, 80+120, 214, 100)
	local frmBombs = self:createStaticFrame("Smart Bomb", 98, 80+230, 284, 100)
	local frmModules = self:createStaticFrame("Modules", 63, 80+340, 354, 100)

	local vulcanCannonDescription =
	[[ 
	Vulcan cannon 
	A powerful, narrow-firing vulcan 
	cannon. High rate of fire. 

	Higher ranks increase the rate 
	of fire and spread. 
	$0.05 
	]]
	self:createBuyable("data/img/shop/vulcan.png", frmPrimaryWeapons, 5, 30, "vulcan", vulcanCannonDescription)

	local plasmaGunDescription =
	[[ 
	Plasma wave gun 
	Weak, but produces lots of 
	projectiles. Impossible to 
	miss with. 

	Higher ranks increase the 
	rate of fire. 
	$0.05 
	]]
	self:createBuyable("data/img/shop/plasma.png", frmPrimaryWeapons, 5+64+5, 30, "plasma", plasmaGunDescription)

	local missilesDescription =
	[[ 
	Missile launcher 
	Fires 2 slow-moving missiles 
	at a time. Slow rate of fire, 
	but highly damaging. 

	Higher ranks increase splash 
	damage.   
	$0.05 
	]]
	self:createBuyable("data/img/shop/missiles.png", frmPrimaryWeapons, 5+64+5+64+5, 30, "missiles", missilesDescription)

	local flamethrowerDescription =
	[[ 
	Flamethrower 
	Conventional flamethrowers 
	don't work in space. This one 
	does. 

	Higher ranks increase potency. 
	$0.10 
	]]
	self:createBuyable("data/img/shop/flamethrower.png", frmSecondaryWeapons, 5, 30, "flamethrower", flamethrowerDescription)

	local rocketSalvoDescription =
	[[ 
	Rocket salvo 
	Fires a large arc of rockets. 
	Wide coverage, high power, 
	long recharge times. 

	Higher ranks decrease energy 
	cost. 
	$0.10 
	]]
	self:createBuyable("data/img/shop/rockets.png", frmSecondaryWeapons, 5+64+5, 30, "rockets", rocketSalvoDescription)

	local armorDescription =
	[[ 
	Armor 
	The amount of hits you can 
	take before you're shot 
	down. 

	Base is 3. 
	$0.10 
	]]
	self:createBuyable("data/img/shop/armor.png", frmShipStats, 5, 30, "armor", armorDescription)

	local speedDescription =
	[[ 
	Speed 
	How fast your ship moves. 
	$0.05 
	]]
	self:createBuyable("data/img/shop/speed.png", frmShipStats, 5+64+5, 30, "speed", speedDescription)

	local generatorDescription =
	[[ 
	Generator 
	Increases the speed of 
	secondary weapon energy 
	replenishment. 
	$0.10 
	]]
	self:createBuyable("data/img/shop/generator.png", frmShipStats, 5+64+5+64+5, 30, "generator", generatorDescription)

	local bombPowerDescription =
	[[ 
	Bomb Power 
	Increases the amount of 
	damage done to enemies 
	by a smart bomb.  
	$0.05 
	]]
	self:createBuyable("data/img/shop/bombPower.png", frmBombs, 5, 30, "bombPower", bombPowerDescription)

	local bombRadiusDescription =
	[[ 
	Bomb Radius 
	Extends the radius of the 
	bomb, allowing it to 
	neutralize more enemies.   
	$0.05 
	]]
	self:createBuyable("data/img/shop/bombRadius.png", frmBombs, 5+64+5, 30, "bombRadius", bombRadiusDescription)

	local bombDelayDescription =
	[[ 
	Bomb Protection 
	Increases the invulnerability 
	after firing a bomb.  
	$0.05 
	]]
	self:createBuyable("data/img/shop/bombDelay.png", frmBombs, 5+64+5+64+5, 30, "bombDelay", bombDelayDescription)

	local bombQuantityDescription =
	[[ 
	Bomb Quantity 
	Gives you more bombs to 
	use. The base number is 2.    
	$0.10 
	]]
	self:createBuyable("data/img/shop/bombQuantity.png", frmBombs, 5+64+5+64+5+64+5, 30, "bombQuantity", bombQuantityDescription)

	local absorbDescription =
	[[ 
	Energy Absorption 
	Destroying enemies slightly 
	replenishes secondary weapon 
	energy. 
	$0.10 
	]]
	self:createBuyable("data/img/shop/absorption.png", frmModules, 5, 30, "absorb", absorbDescription)

	local autobombDescription =
	[[ 
	Autobomb 
	If you have 2 or more bombs 
	in stock and get hit, you 
	will be saved - but lose 
	all bombs. 
	$0.15 
	]]
	self:createBuyable("data/img/shop/autobomb.png", frmModules, 5+64+5, 30, "autobomb", autobombDescription)

	local deathbombDescription =
	[[ 
	"Blissful Death" 
	Deal heavy damage to nearby 
	enemies when you get hit. 
	$0.10 
	]]
	self:createBuyable("data/img/shop/suicide.png", frmModules, 5+64+5+64+5, 30, "deathbomb", deathbombDescription)

	local hitboxDescription =
	[[ 
	Low-profile cockpit 
	The hitbox for your ship 
	is slightly smaller.    
	$0.15 
	]]
	self:createBuyable("data/img/shop/hitbox.png", frmModules, 5+64+5+64+5+64+5, 30, "hitbox", hitboxDescription)

	local analysisDescription =
	[[ 
	Analysis 
	View the remaining health of 
	bosses.    
	$0.05 
	]]
	self:createBuyable("data/img/shop/analysis.png", frmModules, 5+64+5+64+5+64+5+64+5, 30, "analysis", analysisDescription)
end

function shop:draw()
	love.graphics.draw(self.backgroundImage, 0, 0)
	self.prompt:draw()
	loveframes.draw()
	love.graphics.printf("$" .. string.format("%4.2f", self.cash/100), 0, 610, 480, "center")
	self.blackMask:draw()
end

function shop:update(dt)
	loveframes.update(dt)
	self.shopMusic:setVolume(self.volume.music)
	tween.update(dt)
end

function shop:keyreleased(key, code)
	loveframes.keyreleased(key, code)
end

function shop:keypressed(key, code)
	loveframes.keypressed(key, code)
end

function shop:mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function shop:mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

return shop