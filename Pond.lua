--[[
	Pond Class
]]

Pond = Class{}

local POND_IMAGE = love.graphics.newImage('images/pond.png')

-- scroll speed: same as foreground
local POND_SCROLL = -80

function Pond:init()
    self.x = VIRTUAL_WIDTH

    self.y = VIRTUAL_HEIGHT - POND_IMAGE:getHeight() - 10

    self.width = POND_IMAGE:getWidth()
end

function Pond:update(dt)
    self.x = self.x + POND_SCROLL * dt
end

function Pond:render()
    love.graphics.draw(POND_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end