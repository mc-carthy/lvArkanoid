local game_paused = {}

local game_objects = {}

function game_paused.enter(prev_state, ...)
    game_objects = ...
end

function game_paused.exit()
    game_objects = nil
end

function game_paused.keyreleased(key)
    if key == "return" then
        GameState.set_state("game")
    elseif key == "escape" then
        love.event.quit()
    end
end

function game_paused.mousereleased(x, y, button)
    if button == 1 then
        GameState.set_state("Game")
    elseif button == 2 then
        love.event.quit()
    end
end

function game_paused.draw()
    for _, o in pairs(game_objects) do
        if type(o) == "table" and o.draw then
            o.draw()
        end
    end
    love.graphics.print("Game Paused. Press Enter to continue or Esc to quit.", 50, 50)
end

return game_paused
