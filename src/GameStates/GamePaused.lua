local game_paused = {}

local game_objects = {}

local bungee_font = love.graphics.newFont("src/Assets/Fonts/BungeeInline-Regular.ttf", 30)

function game_paused.enter(prev_state, ...)
    game_objects = ...
end

function game_paused.exit()
    game_objects = nil
end

function game_paused.cast_shadow()
    love.graphics.push("all")
    love.graphics.setColor(10, 10, 10, 100)
    love.graphics.rectangle(
        "fill",
        0, 0,
        love.graphics.getWidth(),
        love.graphics.getHeight()
    )
    love.graphics.pop("all")
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
    game_paused.cast_shadow()
    love.graphics.push("all")
    love.graphics.setFont(bungee_font)
    love.graphics.printf("Game Paused...", 108, 110, 400, "center")
    love.graphics.pop("all")
end

return game_paused
