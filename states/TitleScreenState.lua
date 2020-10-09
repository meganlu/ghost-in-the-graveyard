--[[
    TitleScreenState Class

    Main starting screen shown on startup. Displays "play" and "info"
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
	 self.image = love.graphics.newImage('images/title.png')
end

function TitleScreenState:update(dt)
    --if mouse pressed play
    if love.mouse.wasPressed(1) then
        if love.mouse.getX() >= 730 and love.mouse.getX() <= 930 then
            if love.mouse.getY() >= 210 and love.mouse.getY() <= 280 then
                gStateMachine:change('countdown')
                sounds['music']:stop()
                sounds['wind']:setLooping(true)
                sounds['wind']:play()
                sounds['forest']:setVolume(1)
            end
        end
    end

    --if mouse pressed info
    if love.mouse.wasPressed(1) then
        if love.mouse.getX() >= 730 and love.mouse.getX() <= 930 then
            if love.mouse.getY() >= 330 and love.mouse.getY() <= 400 then
               gStateMachine:change('info')
            end
        end
    end


    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        gStateMachine:change('countdown')
        sounds['music']:stop()
        sounds['wind']:setLooping(true)
        sounds['wind']:play()
        sounds['forest']:setVolume(1)
    end

    if love.keyboard.wasPressed('i') then
        gStateMachine:change('info')
    end
end

function TitleScreenState:render()
    love.graphics.draw(self.image, 80, 0)
end