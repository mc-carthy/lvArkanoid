local game_finished = {}

function game_finished.update(dt)
end

function game_finished.draw()
    love.graphics.print(
        "Congratulations!\n" ..
        "You have finished the game!\n" ..
        "Press Enter to restart or Esc to quit",
        280, 250
    )
end

function game_finished.keyreleased(key)
    if key == "return" then
        GameState.set_state("game", { current_level = 1 })
    elseif key == "escape" then
        love.event.quit()
    end
end

return game_finished
