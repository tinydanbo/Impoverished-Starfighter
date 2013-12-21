KamikazeDrone = require("game.enemies.kamikazeDrone")
MediumFrigate = require("game.enemies.mediumFrigate")
SineDrone = require("game.enemies.sineDrone")
LightTurretAsteroid = require("game.enemies.lightTurretAsteroid")
LightDestroyer = require("game.enemies.lightDestroyer")
SwoopInDrone = require("game.enemies.swoopInDrone")
Stage2Boss = require("game.enemies.stage2boss")
Tank = require("game.enemies.tank")
BasicTurret = require("game.enemies.basicTurret")
SuicideDrone = require("game.enemies.suicideDrone")
MediumDestroyer = require("game.enemies.mediumDestroyer")
EntityTypes = require("entities.types")

stage2 = {}

stage2.scenery = {
	{"scenery23", 420, 300},
	{"scenery23", 340, 560},
	{"scenery21", 0, 200},
	{"scenery20", 240, -1000},
	{"scenery19", 50, -1400},
	{"scenery10", 520, -1500},
	{"scenery10", 0, -300},
	{"scenery10", 240, -600},
	{"scenery26", 240, -100},
	{"scenery24", 100, -1400},
	{"scenery15", 100, -700},
	{"scenery10", 100, -1700},
	{"scenery11", 240, -2400},
	{"scenery21", 240, -3600},
	{"scenery25", 240, -3500},
	{"scenery16", 0, -3200},
	{"scenery18", 440, -3600},
	{"scenery18", 340, -3400},
	{"scenery18", 280, -3900},
	{"scenery19", 120, -4300},
	{"scenery21", 240, -4560},
	{"scenery26", 240, -5200},
	{"scenery24", 40, -5500},
	{"scenery7", 600, -6000},
	{"scenery13", 240, -6400},
	{"scenery20", 240, -6800},
	{"scenery27", 240, -8400},
	{"scenery1", 300, -8200},
	{"scenery10", 100, -8800},
	{"scenery10", 240, -9600},
	{"scenery26", 240, -10100},
	{"scenery24", 100, -11400},
	{"scenery15", 100, -12700},
	{"scenery10", 100, -14700},
	{"scenery11", 240, -15400},
	{"scenery21", 240, -15600},
	{"scenery25", 240, -15500},
	{"scenery16", 0, -16200},
	{"scenery18", 440, -16600},
	{"scenery18", 340, -17400},
	{"scenery18", 280, -17900},
	{"scenery19", 120, -17300},
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
	for i = 1,10 do
		local enemy = SuicideDrone(240+math.random(-200, 200), math.random(-400, -100), state)
		state.manager:addEntity(enemy, EntityTypes.ENEMY)
	end
end

local spawnBasicTurret = function(xpos, ypos, state)
	local enemy = BasicTurret(xpos, ypos, state)
	state.manager:addEntity(enemy, EntityTypes.ENEMY)
end

local spawnMediumDestroyerTopLeft = function(state)
	local enemy = MediumDestroyer(-100, 100, 60, 0, state)
	state.manager:addEntity(enemy, EntityTypes.ENEMY)
end

local spawnMediumDestroyerFormationLeft = function(state)
	local enemy = MediumDestroyer(-60, 60, 40, 0, state)
	state.manager:addEntity(enemy, EntityTypes.ENEMY)
	local enemy3 = MediumDestroyer(-180, 180, 40, 0, state)
	state.manager:addEntity(enemy3, EntityTypes.ENEMY)
end

local spawnAsteroidsFromRight = function(state)
	local asteroid1 = LightTurretAsteroid(600, 100, -140, 20, state)
	state.manager:addEntity(asteroid1, EntityTypes.ENEMY)
	local asteroid2 = LightTurretAsteroid(540, 80, -80, 30, state)
	state.manager:addEntity(asteroid2, EntityTypes.ENEMY)
end

local spawnAsteroidsFromLeft = function(state)
	local asteroid1 = LightTurretAsteroid(-100, 100, 140, 20, state)
	state.manager:addEntity(asteroid1, EntityTypes.ENEMY)
	local asteroid2 = LightTurretAsteroid(-60, 80, 80, 30, state)
	state.manager:addEntity(asteroid2, EntityTypes.ENEMY)
end

local spawnRandomAsteroids = function(state)
	for i=0,4 do
		if math.random(-1, 1) > 0 then
			local asteroid1 = LightTurretAsteroid(-60, math.random(60,240), 40+math.random(100), 20, state)
			state.manager:addEntity(asteroid1, EntityTypes.ENEMY)
		else 
			local asteroid1 = LightTurretAsteroid(540, math.random(60,240), -40-math.random(100), 20, state)
			state.manager:addEntity(asteroid1, EntityTypes.ENEMY)
		end
	end
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
stage2.getEvents = function()
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
	events = {
		{1, function(state)
			local boss = Stage1Boss(240, -160, state)
			state.manager:addEntity(boss, EntityTypes.ENEMY)
		end}
	}
	--[[
	events = {
	}
	]]--
	--[[
	events = {
		{1, function(state)
			local boss = Stage2Boss(240, -160, state)
			state.manager:addEntity(boss, EntityTypes.ENEMY)
		end}
	}
	--]]
	events = {
		{3, spawnSwoopWave},
		{5, spawnDualFrigates},
		{8, spawnSineDronesCenter},
		{12, spawnMediumDestroyerTopLeft},
		{15, spawnRightLightDestroyer},
		{16, spawnAsteroidsFromLeft},
		{18, spawnDualFrigates},
		{24, spawnMediumDestroyerFormationLeft},
		{26, spawnKamikazeWave},
		{28, function(state)
			spawnTankConvoy(-100, state)
		end},
		{29, function(state)
			spawnTankConvoy(-100, state)
		end},
		{40, spawnSuicideWave},
		{41, spawnSineDronesCenter},
		{44, spawnLeftLightDestroyer},
		{45, spawnAsteroidsFromRight},
		{47, spawnRightLightDestroyer},
		{48, spawnAsteroidsFromLeft},
		{54, spawnAsteroidsFromBothSides},
		{57, spawnSwoopWave},
		{60, spawnMediumDestroyerFormationLeft},
		{62, spawnKamikazeWave},
		{68, spawnSwoopWave},
		{70, spawnMediumDestroyerTopLeft},
		{71, spawnSineDronesCenter},
		{73, spawnRandomAsteroids},
		{77, spawnRandomAsteroids},
		{82, spawnRandomAsteroids},
		{87, spawnRandomAsteroids},
		{93, spawnSwoopWave},
		{95, spawnDualFrigates},
		{98, spawnSineDronesCenter},
		{102, spawnMediumDestroyerTopLeft},
		{115, spawnRightLightDestroyer},
		{116, spawnAsteroidsFromLeft},
		{120, spawnSuicideWave},
		{121, spawnSineDronesCenter},
		{122, spawnSwoopWave},
		{123, spawnSwoopWave},
		{124, spawnLeftLightDestroyer},
		{125, spawnAsteroidsFromRight},
		{127, spawnRightLightDestroyer},
		{128, spawnAsteroidsFromLeft},
		{134, spawnAsteroidsFromBothSides},
		{137, spawnSwoopWave},
		{140, spawnMediumDestroyerFormationLeft},
		{142, spawnKamikazeWave},
		{148, spawnSwoopWave},
		{150, spawnMediumDestroyerTopLeft},
		{151, spawnSineDronesCenter},
		{153, spawnRandomAsteroids},
		{157, spawnRandomAsteroids},
		{163, spawnRandomAsteroids},
		{167, spawnRandomAsteroids},
		{173, spawnSwoopWave},
		{175, function(state)
			state:fadeStageMusic()
		end},
		{180.5, function(state)
			state:playBossMusic()
		end},
		{181, function(state)
			state:issueBossWarning()
		end},
		{186, function(state)
			state:retractBossWarning()
		end},
		{187, function(state)
			local boss = Stage2Boss(240, -160, state)
			state.manager:addEntity(boss, EntityTypes.ENEMY)
		end}
	}
	return events
end

return stage2