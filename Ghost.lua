--[[
	Ghost Class
	
	The ghost is our main sprite! It dives downwards when the space bar is pressed and floats
	upwards otherwise. 
]]

Ghost = Class{}

local FLOTATION = -15

function Ghost:init()
    -- load ghost image from disk and assign its width and height
    self.image = love.graphics.newImage('images/ghost.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position ghost in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

     -- Y velocity; gravity
    self.dy = 0
end

function Ghost:update(dt)
	 -- apply flotation to velocity
    self.dy = self.dy + FLOTATION * dt

    -- ghost dives down if spacebar pressed
    if love.keyboard.wasPressed('space') then
        self.dy = 5
    end

    -- apply current velocity to Y position
    self.y = self.y + self.dy
end

function Ghost:render()
    love.graphics.draw(self.image, self.x, self.y)
end