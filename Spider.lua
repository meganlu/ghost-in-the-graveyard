--[[
	Spider Class
]]

Spider = Class{}

local SPIDER_IMAGE = love.graphics.newImage('images/spider.png')

-- scroll speed: same as foreground
local SPIDER_SCROLL = -100

function Spider:init()
    self.x = VIRTUAL_WIDTH

    self.y = math.random(-210, 0)

    self.width = SPIDER_IMAGE:getWidth()
    self.height = SPIDER_IMAGE:getHeight()
end

function Spider:update(dt)
    self.x = self.x + SPIDER_SCROLL * dt
end

function Spider:render()
    love.graphics.draw(SPIDER_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end