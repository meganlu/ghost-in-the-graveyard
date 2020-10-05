--[[
	Grave Class
]]

Grave = Class{}

local GRAVE_IMAGE = love.graphics.newImage('images/grave.png')

-- scroll speed: same as foreground
local GRAVE_SCROLL = -100

function Grave:init()
    self.x = VIRTUAL_WIDTH

    self.y = VIRTUAL_HEIGHT - GRAVE_IMAGE:getHeight() - 10

    self.width = GRAVE_IMAGE:getWidth()
end

function Grave:update(dt)
    self.x = self.x + GRAVE_SCROLL * dt
end

function Grave:render()
    love.graphics.draw(GRAVE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end