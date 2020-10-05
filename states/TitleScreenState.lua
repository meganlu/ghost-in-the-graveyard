--[[
    TitleScreenState Class

    Main starting screen shown on startup. Displays "play" and "info"
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
	 self.image = love.graphics.newImage('images/title.png')
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
        sounds['music']:stop()
        sounds['wind']:setLooping(true)
        sounds['wind']:play()
        sounds['forest']:setVolume(1)
    end
end

function TitleScreenState:render()
    love.graphics.draw(self.image, 80, 0)
end