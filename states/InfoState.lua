--[[
    InfoState Class
]]

InfoState = Class{__includes = BaseState}

function InfoState:init()
    self.image = love.graphics.newImage('images/info.png')
end


function InfoState:update(dt)
    --if mouse pressed back
    if love.mouse.wasPressed(1) then
        if love.mouse.getX() >= 50 and love.mouse.getX() <= 110 then
            if love.mouse.getY() >= 60 and love.mouse.getY() <= 120 then
               sounds['click']:play()
               gStateMachine:change('title')
            end
        end
    end

    if love.keyboard.wasPressed('backspace') then
        gStateMachine:change('title')
    end
end

function InfoState:render()
    love.graphics.draw(self.image, 10, 0)
end