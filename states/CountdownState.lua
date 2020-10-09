--[[
    Countdown State
    
    Dispalys 3, 2, 1 right before play state
]]

CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setColor(202, 223, 224, 255)
    love.graphics.setFont(bigFont)
    love.graphics.printf(tostring(self.count), 0, 200, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(readFont)
    love.graphics.printf("Press Space to dive!", 0, 300, VIRTUAL_WIDTH, 'center')
end