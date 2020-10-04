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

function Ghost:collidesnoose(noose)
    --if the right edge of ghost > left edge of noose AND 
    --the left edge of ghost < right edge of noose THEN
    if  (self.x + 60) >= (noose.x + 60) and self.x <= (noose.x + 75) then
        --if the top edge of ghost < bottom edge of noose 
        if (self.y + 5) <= noose.height - 5 then
            return true
        end
    end
    return false
end

function Ghost:collidesgrave(grave)
    --if the right edge of ghost > left edge of grave AND 
    --the left edge of ghost < right edge of grave THEN
    if  (self.x + 60) >= (grave.x + 30) and self.x <= (grave.x + 140) then
        --if the bottom edge of ghost > top edge of grave 
        if (self.y + 70) >= grave.y + 20 then
            return true
        end
    end
    return false
end

function Ghost:collidespond(pond)
    --if the right edge of ghost > left edge of pond AND 
    --the left edge of ghost < right edge of pond THEN
    if  (self.x + 60) >= (pond.x + 10) and self.x <= pond.width then
        --if the bottom edge of ghost > top edge of pond
        if (self.y + 70) >= pond.y + 20 then
            return true
        end
    end
    return false
end

function Ghost:collidesskull(skull)
    --if the right edge of ghost > left edge of skull AND 
    --the left edge of ghost < right edge of skull THEN
    if  (self.x + 60) >= (skull.x + 20) and self.x <= skull.width - 10 then
        --if the bottom edge of ghost > top edge of skull
        if (self.y + 70) >= skull.y + 10 then
            return true
        end
    end
    return false
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