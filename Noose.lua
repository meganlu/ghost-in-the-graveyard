--[[
	Noose Class
]]

Noose = Class{}

local NOOSE_IMAGE = love.graphics.newImage('images/noose.png')

-- scroll speed: same as foreground
local NOOSE_SCROLL = -80

function Noose:init()
    self.x = VIRTUAL_WIDTH

    self.y = 0

    self.width = NOOSE_IMAGE:getWidth()
    self.height = NOOSE_IMAGE:getHeight()
end

function Noose:update(dt)
    self.x = self.x + NOOSE_SCROLL * dt
end

function Noose:render()
    love.graphics.draw(NOOSE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end