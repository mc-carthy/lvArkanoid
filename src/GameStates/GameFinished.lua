local game_finished = {}

local bungee_font = love.graphics.newFont("src/Assets/Fonts/BungeeInline-Regular.ttf", 30)

function game_finished.update(dt)
end

function game_finished.draw()
    love.graphics.push("all")
    love.graphics.setFont(bungee_font)
    love.graphics.printf(
        "Congratulations!", 235, 200, 350, "center"
    )
    love.graphics.printf(
        "You have finished the game!",
        100, 240, 600, "center"
    )
    love.graphics.pop()
end

function game_finished.keyreleased(key)
    if key == "return" then
        GameState.set_state("game", { current_level = 1 })
    elseif key == "escape" then
        love.event.quit()
    end
end

return game_finished
