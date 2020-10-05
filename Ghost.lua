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
    if  (self.x + 60) >= (noose.x + 60) and (self.x + 10) <= (noose.x + 75) then
        --if the top edge of ghost < bottom edge of noose and bottom edge of ghost > top of noose
        if (self.y + 5) <= (noose.y + 250) and (self.y + 50) >= (noose.y + 110)then
            return true
        end
    end
    return false
end

function Ghost:collidesgrave(grave)
    --if the right edge of ghost > left edge of grave AND 
    --the left edge of ghost < right edge of grave THEN
    --[[
    if  (self.x + 60) >= (grave.x + 30) and self.x <= (grave.x + 140) then
        --if the bottom edge of ghost > top edge of grave 
        if (self.y + 70) >= grave.y + 20 then
            return true
        end
    end
    ]]

    --section one
    if (self.x + 60) >= (grave.x + 30) and (self.x + 10) <= (grave.x + 105) then
        if (self.y + 55) >= (grave.y + 30) and (self.y + 5) <= (grave.y + 105) then
            return true
        end
    --section two
    elseif (self.x + 60) >= (grave.x + 70) and (self.x + 10) <= (grave.x + 150) then
        if (self.y + 55) >= (grave.y + 80) then
            return true
        end
    end

    return false
end

function Ghost:collidespond(pond)
    --if the right edge of ghost > left edge of pond AND 
    --the left edge of ghost < right edge of pond THEN
    if(self.x + 55) >= (pond.x + 10) and (self.x + 10) <= (pond.x + 350) then
        --if the bottom edge of ghost > top edge of pond
        if (self.y + 50) >= (pond.y + 20) and (self.y + 5) <= (pond.y + 40) then
            return true
        end
    end
    return false
end

function Ghost:collidesskull(skull)
    --if the right edge of ghost > left edge of skull AND 
    --the left edge of ghost < right edge of skull THEN
    if  (self.x + 60) >= (skull.x + 15) and (self.x + 10) <= (skull.x + 65) then
        --if the bottom edge of ghost > top edge of skull and top edge of ghost < bottom edge of skull
        if (self.y + 60) >= (skull.y + 5) and (self.y + 5) <= (skull.y + 55) then
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