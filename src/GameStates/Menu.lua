local menu = {}

function menu.update(dt)
end

function menu.draw()
    love.graphics.print("Menu gamestate. Press Enter to continue.", 280, 250)
end

function menu.keyreleased(key)
    if key == "return" then
        GameState.set_state("game", { current_level = 1 })
    end
    if key == "escape" then
        love.event.quit()
    end
end

return menu
