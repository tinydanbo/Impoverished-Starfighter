KamikazeDrone = require("game.enemies.kamikazeDrone")
MediumFrigate = require("game.enemies.mediumFrigate")
SineDrone = require("game.enemies.sineDrone")
LightTurretAsteroid = require("game.enemies.lightTurretAsteroid")
LightDestroyer = require("game.enemies.lightDestroyer")
SwoopInDrone = require("game.enemies.swoopInDrone")
Stage1Boss = require("game.enemies.stage1boss")
Tank = require("game.enemies.tank")
BasicTurret = require("game.enemies.basicTurret")
SuicideDrone = require("game.enemies.suicideDrone")
EntityTypes = require("entities.types")

stage1 = {}

stage1.scenery = {
	{"scenery1", 120, 300},
	{"scenery13", 240, 560},
	{"scenery6", 300, 200},
	{"scenery2", 240, -1000},
	{"scenery3", 50, -1400},
	{"scenery4", 520, -1500},
	{"scenery3", 0, -300},
	{"scenery13", 240, -600},
	{"scenery16", 240, -100},
	{"scenery14", 300, -1400},
	{"scenery19", 400, -700},
	{"scenery10", 100, -1700},
	{"scenery11", 240, -2400},
	{"scenery12", 240, -2400},
	{"scenery5", 580, -3000},
	{"scenery15", 0, -3200},
	{"scenery19", 240, -3600},
	{"scenery1", 120, -4300},
	{"scenery13", 240, -4560},
	{"scenery6", 300, -5200},
	{"scenery14", 40, -5500},
	{"scenery14", 140, -5500},
	{"scenery14", 240, -5500},
	{"scenery14", 340, -5500},
	{"scenery14", 440, -5500},
	{"scenery2", 240, -6000},
	{"scenery3", 50, -6400},
	{"scenery4", 520, -6500},
	{"scenery11", 240, -7600},
	{"scenery1", 300, -8200},
	{"scenery10", 100, -8800}
}

local spawnKamikazeWave = function(state)
	for i=1,5,1 do	
		local drone = KamikazeDrone((100 * i), -100+(-10*i), state)
		state.manager:addEntity(drone, EntityTypes.ENEMY)
	end
	for i=-160, 600, 760 do
		local drone = KamikazeDrone(i, 100, state)
		state.manager:addEntity(done, EntityTypes.ENEMY)
	end
end

local spawnLeftLightDestroyer = function(state)
	local destroyer = LightDestroyer(140, -100, state)
	state.manager:addEntity(destroyer, EntityTypes.ENEMY)
end

local spawnRightLightDestroyer = function(state)
	local destroyer = LightDestroyer(480-140, -100, state)
	state.manager:addEntity(destroyer, EntityTypes.ENEMY)
end

local spawnSineDronesCenter = function(state)
	for xpos=240,300,30 do
		for i=1,5 do
			if i % 2 == 0 then
				local enemy = SineDrone(xpos, -100-(50*i), true, state)
				state.manager:addEntity(enemy, EntityTypes.ENEMY)
			else
				local enemy = SineDrone(xpos, -100-(50*i), false, state)
				state.manager:addEntity(enemy, EntityTypes.ENEMY)
			end
		end
	end
end

local spawnSwoopWave = function(state)
	local ypos=-80
	for xpos=10,470,92 do
		local enemy = SwoopInDrone(xpos, ypos, state)
		state.manager:addEntity(enemy, EntityTypes.ENEMY)
		ypos = ypos - 50
	end
end

local spawnTankConvoy = function(ypos, state)
	for i=1,5 do
		local enemy = Tank(0+(i*100), ypos, -20, 80, state)
		state.manager:addEntity(enemy, EntityTypes.ENEMY)
	end
end

local spawnSuicideWave = function(state)
	for i = 1,7 do
		local enemy = SuicideDrone(240+math.random(-200, 200), math.random(-400, -100), state)
		state.manager:addEntity(enemy, EntityTypes.ENEMY)
	end
end

local spawnBasicTurret = function(xpos, ypos, state)
	local enemy = BasicTurret(xpos, ypos, state)
	state.manager:addEntity(enemy, EntityTypes.ENEMY)
end

local spawnAsteroidsFromRight = function(state)
	local asteroid1 = LightTurretAsteroid(600, 100, -140, 20, state)
	state.manager:addEntity(asteroid1, EntityTypes.ENEMY)
	local asteroid2 = LightTurretAsteroid(540, 80, -80, 30, state)
	state.manager:addEntity(asteroid2, EntityTypes.ENEMY)
end

local spawnDualFrigates = function(state)
	local frigate = MediumFrigate(380, -200, state)
	state.manager:addEntity(frigate, EntityTypes.ENEMY)
	local frigate2 = MediumFrigate(100, -200, state)
	state.manager:addEntity(frigate2, EntityTypes.ENEMY)
end

local spawnAsteroidsFromBothSides = function(state)
	local asteroid1 = LightTurretAsteroid(-60, 100, 80, 30, state)
	state.manager:addEntity(asteroid1, EntityTypes.ENEMY)
	local asteroid2 = LightTurretAsteroid(730, 100, -80, 60, state)
	state.manager:addEntity(asteroid2, EntityTypes.ENEMY)
	local asteroid3 = LightTurretAsteroid(600, 100, -140, -20, state)
	state.manager:addEntity(asteroid3, EntityTypes.ENEMY)
end

-- offset stuff by -20
stage1.getEvents = function()
	local events = {
		{1, spawnSwoopWave},
		{3, spawnKamikazeWave},
		{5, spawnSineDronesCenter},
		{6, spawnDualFrigates},
		{7, spawnSineDronesCenter},
		{9, spawnSineDronesCenter},
		{16.5, function(state)
			spawnBasicTurret(50, -100, state)
		end},
		{20, spawnKamikazeWave},
		{22, spawnAsteroidsFromRight},
		{23, spawnSwoopWave},
		{28, spawnKamikazeWave},
		{29, function(state)
			spawnTankConvoy(-100, state)
		end},
		{35, spawnSwoopWave},
		{37, spawnSwoopWave},
		{39, spawnSwoopWave},
		{45, spawnLeftLightDestroyer},
		{46, spawnKamikazeWave},
		{48, spawnAsteroidsFromRight},
		{52, spawnDualFrigates},
		{54, spawnSuicideWave},
		{55, spawnSuicideWave},
		{56, function(state)
			spawnBasicTurret(50, -80, state)
			spawnBasicTurret(140, -90, state)
			spawnBasicTurret(220, -100, state)
			spawnBasicTurret(280, -70, state)
			spawnBasicTurret(340, -100, state)
			spawnBasicTurret(400, -110, state)
		end},
		{62, spawnSwoopWave},
		{64, spawnKamikazeWave},
		{66, spawnSineDronesCenter},
		{67, spawnDualFrigates},
		{72, spawnSineDronesCenter},
		{78, spawnSineDronesCenter},
		{80, spawnSwoopWave},
		{82, spawnAsteroidsFromBothSides},
		{84, spawnLeftLightDestroyer},
		{85, spawnRightLightDestroyer},
		{92, spawnAsteroidsFromBothSides},
		{95, spawnAsteroidsFromBothSides},
		{96, spawnSuicideWave},
		{100, spawnSuicideWave},
		{102, spawnLeftLightDestroyer},
		{105, spawnKamikazeWave},
		{108, spawnAsteroidsFromRight},
		{115, spawnSwoopWave},
		{115, function(state)
			state:fadeStageMusic()
		end},
		{120.5, function(state)
			state:playBossMusic()
		end},
		{121, function(state)
			state:issueBossWarning()
		end},
		{126, function(state)
			state:retractBossWarning()
		end},
		{127, function(state)
			local boss = Stage1Boss(240, -160, state)
			state.manager:addEntity(boss, EntityTypes.ENEMY)
		end}
	}
	return events
end

return stage1