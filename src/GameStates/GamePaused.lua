local game_paused = {}

local game_objects = {}

function game_paused.enter(prev_state, ...)
    game_objects = ...
end

function game_paused.exit()
    game_objects = nil
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
