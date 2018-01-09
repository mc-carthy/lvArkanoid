local game_over = {}

function game_over.update(dt)
end

function game_over.draw()
    love.graphics.print(
        "Game Over!\n" ..
        "Press Enter to restart or Esc to quit",
        280, 250
    )
end

function game_over.keyreleased(key)
    if key == "return" then
        GameState.set_state("Game", { current_level = 1 })
    elseif key == "escape" then
        love.event.quit()
    end
end

function game_over.mousereleased(x, y, button)
    if button == 1 then
        GameState.set_state("Game", { current_level = 1 })
    elseif button == 2 then
        love.event.quit()
    end
end

return game_over
