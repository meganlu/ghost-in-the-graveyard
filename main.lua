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

--require all statemachine classes
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

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
local FOREGROUND_SCROLL_SPEED = 100

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 864

-- scrolling variable to pause the game 
local scrolling = true

function love.load()
	-- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- app window title
    love.window.setTitle('Ghost in a Graveyard')

    scoreFont = love.graphics.newFont('bigFont.ttf', 50)
    bigFont = love.graphics.newFont('bigFont.ttf', 90)
    readFont = love.graphics.newFont('smallFont.ttf', 40)

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

     -- initialize sounds
    sounds = {
        --['dive'] = love.audio.newSource('dive.wav', 'static'),
        ['collect'] = love.audio.newSource('sounds/collect.wav', 'static'),
        ['rope'] = love.audio.newSource('sounds/rope.wav', 'static'),
        ['scream'] = love.audio.newSource('sounds/scream.wav', 'static'),
        ['caw'] = love.audio.newSource('sounds/caw.wav', 'static'),
        ['splash'] = love.audio.newSource('sounds/splash.wav', 'static'),
        ['wind'] = love.audio.newSource('sounds/wind.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
        ['forest'] = love.audio.newSource('sounds/forest.wav', 'static')
    }

    sounds['wind']:setVolume(0.1)
    sounds['music']:setVolume(0.4)
    sounds['forest']:setVolume(0.5)
    sounds['scream']:setVolume(0.6)
    sounds['caw']:setVolume(0.6)
    sounds['rope']:setVolume(0.4)
    sounds['collect']:setVolume(0.8)


    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()
    sounds['forest']:setLooping(true)
    sounds['forest']:play()


    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

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

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if scrolling then   
    	-- scroll = how much we've scrolled since the last "repeat"
    	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
    		% BACKGROUND_LOOPING_POINT

    	midgroundScroll = (midgroundScroll + MIDGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

    	foregroundScroll = (foregroundScroll + FOREGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT

        -- update the state machine
        gStateMachine:update(dt)

        
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

    gStateMachine:render()

    push:finish()
end


