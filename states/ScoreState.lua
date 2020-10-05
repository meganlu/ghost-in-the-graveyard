--[[
    ScoreState Class
    
    Displays the player's score after colliding with an obstacle. Goes back to play state
    or title state
]]

ScoreState = Class{__includes = BaseState}


    --receive the score and reason for death from the play state
function ScoreState:enter(params)
    self.score = params.score
    self.death = params.death
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        sounds['rope']:stop()
        sounds['music']:stop()
        sounds['wind']:play()
        sounds['forest']:setVolume(1)
        gStateMachine:change('play')
    end
    -- go back to title if p is pressed
    if love.keyboard.wasPressed('t') then
        sounds['rope']:stop()
        sounds['music']:play()
        gStateMachine:change('title')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(bigFont)
    love.graphics.printf('You died a second death!', 0, 150, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(readFont)
    love.graphics.printf(self.death, 0, 250, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(scoreFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 330, VIRTUAL_WIDTH, 'center')

    --love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end