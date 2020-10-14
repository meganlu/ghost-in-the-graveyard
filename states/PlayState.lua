--[[
    PlayState Class
    
    Includes bulk of the game: controlling the ghost, avoiding obstacles
    After a collision, we go to the GameOver state, then to the main menu or restart
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.ghost = Ghost()
    self.score = 0

    --tables of sprites
    self.nooses = {}
    self.graves = {}
    self.ponds = {}
    self.skulls = {}
    self.spiders = {}
    
    -- timers for spawning sprites
    self.nooseTimer = 0
    self.graveTimer = 0
    self.pondTimer = 0
    self.skullTimer = 0
    self.spiderTimer = 0

    -- reason for death
    self.death = ""
end


function PlayState:update(dt)

    if love.keyboard.wasPressed('p') then
        if SCROLLING == false then
            SCROLLING = true
            
        --stop pause
        else
            SCROLLING = false
        end
    end

    if SCROLLING == true then  
        --update ghost position
        self.ghost:update(dt)
        self.score = self.score

        -- seed the RNG
        math.randomseed(os.time())
        math.random();math.random();math.random()

        -- spawn a new noose after a random amount of time
        self.nooseTimer = self.nooseTimer + dt
        if self.nooseTimer > math.random(10,30) then
            table.insert(self.nooses, Noose())
            self.nooseTimer = 0
        end

        -- spawn a new grave after a random amount of time
        self.graveTimer = self.graveTimer + dt
        if self.graveTimer > math.random(10,30) then
            table.insert(self.graves, Grave())
            self.graveTimer = 0
        end

        -- spawn a new pond after a random amount of time
        self.pondTimer = self.pondTimer + dt
        if self.pondTimer > math.random(5,30) then
            table.insert(self.ponds, Pond())
            self.pondTimer = 0
        end

         -- spawn a new skull after a random amount of time
        self.skullTimer = self.skullTimer + dt
        if self.skullTimer > math.random(5,15) then
            table.insert(self.skulls, Skull())
            self.skullTimer = 0
        end
        
        self.spiderTimer = self.spiderTimer + dt
        if self.spiderTimer > math.random(5,15) then
            table.insert(self.spiders, Spider())
            self.spiderTimer = 0
        end
        
        -- update noose table.
        for k, noose in pairs(self.nooses) do
            noose:update(dt)

            if self.ghost:collidesnoose(noose) then
                sounds['rope']:play()
                sounds['music']:play()
                sounds['wind']:stop()
                sounds['forest']:setVolume(0.5)
                self.death = "Choked by a rope once more..."
                gStateMachine:change('score', {
                score = self.score,
                death = self.death
            })
            end

            -- if noose is no longer visible past left edge, remove it from scene
            if noose.x < -noose.width then
                table.remove(self.nooses, k)
            end
        end

        -- update grave table
        for k, grave in pairs(self.graves) do
            grave:update(dt)

            if self.ghost:collidesgrave(grave) then
                sounds['scream']:play()
                sounds['caw']:play()
                sounds['music']:play()
                sounds['wind']:stop()
                sounds['forest']:setVolume(0.5)
                self.death = "Purged by a malevolent spirit..." 
                gStateMachine:change('score', {
                score = self.score,
                death = self.death
            })
            end
            -- if grave is no longer visible past left edge, remove it from scene
            if grave.x < -grave.width then
                table.remove(self.graves, k)
            end
        end

        -- update self.ponds table
        for k, pond in pairs(self.ponds) do
            pond:update(dt)

            if self.ghost:collidespond(pond) then
                sounds['scream']:play()
                sounds['splash']:play()
                sounds['music']:play()
                sounds['wind']:stop()
                sounds['forest']:setVolume(0.5)
                self.death = "Vanquished by holy water..." 
                gStateMachine:change('score', {
                score = self.score,
                death = self.death
            })
            end
            -- if pond is no longer visible past left edge, remove it from scene
            if pond.x < -pond.width then
                table.remove(self.ponds, k)
            end
        end

        -- update self.skulls table
        for k, skull in pairs(self.skulls) do
            skull:update(dt)

            if self.ghost:collidesskull(skull) then
                if not skull.collected then
                    sounds['collect']:stop()
                    sounds['collect']:play()
                    self.score = self.score + 11
                    skull.collected = true
                end
            end
            -- if skull is no longer visible past left edge, remove it from scene
            if skull.x < -skull.width then
                table.remove(self.skulls, k)
            end
        end

        -- update self.spiders table
        for k, spider in pairs(self.spiders) do
            spider:update(dt)

            if self.ghost:collidesspider(spider) then
                if not spider.collected then
                    sounds['collect']:stop()
                    sounds['collect']:play()
                    self.score = self.score + 7
                    spider.collected = true
                end
            end
            -- if spider is no longer visible past left edge, remove it from scene
            if spider.x < -spider.width then
                table.remove(self.spiders, k)
            end
        end

        -- reset if we get to the ground
        if self.ghost.y > VIRTUAL_HEIGHT - 10 then
            self.death = "Trapped beneath the earth..." 
            sounds['music']:play()
            sounds['wind']:stop()
            sounds['scream']:play()
            sounds['forest']:setVolume(0.5)
            gStateMachine:change('score', {
                score = self.score,
                death = self.death
            })
        end

         -- reset if we go above
        if (self.ghost.y + 60) < 0 then
            self.death = "Lost in the mists above..."
            sounds['music']:play()
            sounds['wind']:stop()
            sounds['scream']:play()
            sounds['forest']:setVolume(0.5) 
            gStateMachine:change('score', {
                score = self.score,
                death = self.death
            })
        end
    end
end

function PlayState:render()
      -- render all the self.nooses 
    for k, noose in pairs(self.nooses) do
        noose:render()
    end

    -- render all the self.ponds
    for k, pond in pairs(self.ponds) do
        pond:render()
    end

     -- render all the self.graves
    for k, grave in pairs(self.graves) do
        grave:render()
    end

    -- render all the self.skulls
    for k, skull in pairs(self.skulls) do
        skull:render()
    end

    -- render all the self.skulls
    for k, spider in pairs(self.spiders) do
        spider:render()
    end


     -- render our ghost to the screen using its own render logic
    self.ghost:render()
    
    love.graphics.setColor(202, 223, 224, 255)
    love.graphics.setFont(scoreFont)
    love.graphics.print('Score: ' .. tostring(self.score), 20, 10)

end