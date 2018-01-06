local gameState = {}

local loaded = {}
local current_state = nil

local function get_key_for_value(t, value)
    for k,v in pairs( t ) do
        if v == value then
            return k
        end
    end
    return nil
end

function gameState.state_event(function_name, ...)
    if current_state and type(current_state[function_name]) == "function" then
        current_state[function_name](...)
    end
end

function gameState.set_state(state_name, ...)
    gameState.state_event("exit")
    local old_state_name = get_key_for_value(loaded, current_state)
    current_state = loaded[state_name]
    if not current_state then
        current_state = require("src.GameStates." .. state_name)
        loaded[state_name] = current_state
        gameState.state_event("load", old_state_name,  ...)
    end
    gameState.state_event("enter", old_state_name, ...)
end

return gameState
