--[[
	GHOST

	An atmospheric side-scrolling game where the main sprite, a ghost, tries to collect 
	glowing skulls while avoiding nooses (how it perished), ravens on tombstones, and 
	puddles of holy water.
]]
push = require 'push'
Class = require 'class'
require 'Ghost'
require 'Noose'
require 'Grave'
require 'Pond'
require 'Skull'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
--VIRTUAL_WIDTH = 512
--VIRTUAL_HEIGHT = 288
VIRTUAL_WIDTH = 1024
VIRTUAL_HEIGHT = 576

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('images/background.png')
local light = love.graphics.newImage('images/light.png')
local backgroundScroll = 0

local midground = love.graphics.newImage('images/midground.png')
local midgroundScroll = 0

local foreground = love.graphics.newImage('images/foreground.png')
local foregroundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 20
local MIDGROUND_SCROLL_SPEED = 40
local FOREGROUND_SCROLL_SPEED = 80

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 864

-- ghost sprite
local ghost = Ghost()

-- tables 
local nooses = {}
local graves = {}
local ponds = {}
local skulls = {}

-- timer for spawning sprites
local nooseTimer = 0
local graveTimer = 0
local pondTimer = 0
local skullTimer = 0

-- scrolling variable to pause the game 
local scrolling = true

function love.load()
	-- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- app window title
    love.window.setTitle('Ghost in a Graveyard')

    -- initialize fonts

    -- initialize sounds

    -- start music

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions

    -- initialize input table
    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
	push:resize(w, h)
end


function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end


--[[
    Custom function to extend LÖVE's input handling; returns whether a given
    key was set to true in our input table this frame.
]]

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end



function love.update(dt)
    if scrolling then   
        -- seed the RNG
        math.randomseed(os.time())
        math.random();math.random();math.random()

    	-- scroll = how much we've scrolled since the last "repeat"
    	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
    		% BACKGROUND_LOOPING_POINT

    	midgroundScroll = (midgroundScroll + MIDGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

    	foregroundScroll = (foregroundScroll + FOREGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

        --update ghost position
        ghost:update(dt)

        -- spawn a new noose after a random amount of time
        nooseTimer = nooseTimer + dt
        if nooseTimer > math.random(10,50) then
            table.insert(nooses, Noose())
            nooseTimer = 0
        end

        -- spawn a new grave after a random amount of time
        graveTimer = graveTimer + dt
        if graveTimer > math.random(10,50) then
            table.insert(graves, Grave())
            graveTimer = 0
        end

        -- spawn a new pond after a random amount of time
        pondTimer = pondTimer + dt
        if pondTimer > math.random(10,30) then
            table.insert(ponds, Pond())
            pondTimer = 0
        end

         -- spawn a new pond after a random amount of time
        skullTimer = skullTimer + dt
        if skullTimer > math.random(5,20) then
            table.insert(skulls, Skull())
            skullTimer = 0
        end
        
    	
        -- update noose table.
        for k, noose in pairs(nooses) do
            noose:update(dt)

            if ghost:collidesnoose(noose) then
            -- pause the game to show collision
                scrolling = false
            end

            -- if noose is no longer visible past left edge, remove it from scene
            if noose.x < -noose.width then
                table.remove(nooses, k)
            end
        end

        -- update grave table
        for k, grave in pairs(graves) do
            grave:update(dt)

            if ghost:collidesgrave(grave) then
            -- pause the game to show collision
                scrolling = false 
            end
            -- if grave is no longer visible past left edge, remove it from scene
            if grave.x < -grave.width then
                table.remove(graves, k)
            end
        end

        -- update ponds table
        for k, pond in pairs(ponds) do
            pond:update(dt)

            if ghost:collidesgrave(pond) then
            -- pause the game to show collision
                scrolling = false 
            end
            -- if grave is no longer visible past left edge, remove it from scene
            if pond.x < -pond.width then
                table.remove(ponds, k)
            end
        end

        -- update skulls table
        for k, skull in pairs(skulls) do
            skull:update(dt)

            if ghost:collidesskull(skull) then
            -- pause the game to show collision
                scrolling = false 
            end
            -- if grave is no longer visible past left edge, remove it from scene
            if skull.x < -skull.width then
                table.remove(skulls, k)
            end
        end
    end

	--reset input table
	love.keyboard.keysPressed = {}
end


function love.draw()
	push:start()
    
    -- draw the backgrounds starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(light, -backgroundScroll, 0)
    love.graphics.draw(midground, -midgroundScroll, 0)
    love.graphics.draw(foreground, -foregroundScroll, 0)

     -- render all the nooses 
    for k, noose in pairs(nooses) do
        noose:render()
    end

     -- render all the graves
    for k, grave in pairs(graves) do
        grave:render()
    end

    -- render all the ponds
    for k, pond in pairs(ponds) do
        pond:render()
    end

    -- render all the skulls
    for k, skull in pairs(skulls) do
        skull:render()
    end

     -- render our ghost to the screen using its own render logic
    ghost:render()

    push:finish()
end


