--[[
	Skull Class
]]

Skull = Class{}

local SKULL_IMAGE = love.graphics.newImage('images/skull.png')

-- scroll speed: same as foreground
local SKULL_SCROLL = -80


function Skull:init()
    self.x = VIRTUAL_WIDTH

    self.y = VIRTUAL_HEIGHT - SKULL_IMAGE:getHeight() - 10
    
    self.width = SKULL_IMAGE:getWidth()
end

function Skull:update(dt)
    self.x = self.x + SKULL_SCROLL * dt
end

function Skull:render()
    love.graphics.draw(SKULL_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end