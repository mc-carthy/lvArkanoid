GameState = require("src.GameState")

DEBUG = false

function love.load()
    GameState.set_state("Menu")
end

function love.update(dt)
    GameState.state_event("update", dt)
end

function love.draw()
    GameState.state_event("draw")
end

function love.keyreleased(key)
    GameState.state_event("keyreleased", key)
end
