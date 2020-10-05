--[[
    Base State Class

    Base interface for all states, with 4 interface methods outlined in StateMachine.
]]
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end