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
local BACKGROUND_SCROLL_SPEED = 15
local MIDGROUND_SCROLL_SPEED = 30
local FOREGROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 864

-- ghost sprite
local ghost = Ghost()

-- table of spawning nooses
local nooses = {}

-- timer for spawning nooses
local spawnTimer = 0

function love.load()
	-- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- app window title
    love.window.setTitle('Ghost in the Graveyard')

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
    -- seed the RNG
    math.randomseed(os.time())

	-- scroll = how much we've scrolled since the last "repeat"
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
		% BACKGROUND_LOOPING_POINT

	midgroundScroll = (midgroundScroll + MIDGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

	foregroundScroll = (foregroundScroll + FOREGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    spawnTimer = spawnTimer + dt
    -- spawn a new noose after a random amount of time
    math.random();math.random();math.random()
    if spawnTimer > math.random(10,40) then
        table.insert(nooses, Noose())
        spawnTimer = 0
    end
	
	--update ghost position
    ghost:update(dt)
	
    -- for every noose in the scene...
    for k, noose in pairs(nooses) do
        noose:update(dt)

        -- if noose is no longer visible past left edge, remove it from scene
        if noose.x < -noose.width then
            table.remove(nooses, k)
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

     -- render our ghost to the screen using its own render logic
    ghost:render()

    push:finish()
end


