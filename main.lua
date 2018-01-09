GameState = require("src.GameState")

DEBUG = false
music = love.audio.newSource("src/Assets/Music/S31-Night Prowler.ogg")
music:setLooping(true)

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

function love.mousereleased(x, y, button)
   GameState.state_event("mousereleased", x, y, button)
end
