--[[
    ScoreState Class
    
    Displays the player's score after colliding with an obstacle. Goes back to play state
    or title state
]]

ScoreState = Class{__includes = BaseState}

function ScoreState:init()
     self.image = love.graphics.newImage('images/score.png')
end

    --receive the score and reason for death from the play state
function ScoreState:enter(params)
    self.score = params.score
    self.death = params.death
end

function ScoreState:update(dt)
    --if mouse pressed play
    if love.mouse.wasPressed(1) then
        if love.mouse.getX() >= 370 and love.mouse.getX() <= 570 then
            if love.mouse.getY() >= 485 and love.mouse.getY() <= 555 then
                gStateMachine:change('countdown')
                sounds['music']:stop()
                sounds['wind']:setLooping(true)
                sounds['wind']:play()
                sounds['forest']:setVolume(1)
                print(love.mouse.wasPressed(1))
            end
        end
    end

    --if mouse pressed main
    if love.mouse.wasPressed(1) then
        if love.mouse.getX() >= 640 and love.mouse.getX() <= 840 then
            if love.mouse.getY() >= 485 and love.mouse.getY() <= 555 then
                sounds['rope']:stop()
                sounds['music']:play()
                gStateMachine:change('title')
            end
        end
    end
    

    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        sounds['rope']:stop()
        sounds['splash']:stop()
        sounds['caw']:stop()
        sounds['music']:stop()
        sounds['wind']:play()
        sounds['forest']:setVolume(1)
        gStateMachine:change('countdown')
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
    --love.graphics.setFont(bigFont)
    --love.graphics.printf('You died a second death!', 0, 150, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(self.image, 80, 20)

    love.graphics.setColor(202, 223, 224, 255)

    love.graphics.setFont(readFont)
    love.graphics.printf(self.death, 0, 230, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(scoreFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 300, VIRTUAL_WIDTH, 'center')

    --love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end