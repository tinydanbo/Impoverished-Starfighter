require "lib.Tserial"

local config = {}

config.values = {
	up = "w",
	down = "s",
	left = "a",
	right = "d",
	screenWidth = 480,
	screenHeight = 640,
	screenScaling = 1
}

config.loadFromFile = function()
	if love.filesystem.exists("config.lua") then
		local configString = love.filesystem.read("config.lua")
		local configTable = Tserial.unpack(configString, "true")
		config.values = configTable
	end
end

config.saveToFile = function()
	local configString = Tserial.pack(config.values, 0, true)
	love.filesystem.write("config.lua", configString)
end

return config