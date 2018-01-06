local Ball = require("src.Ball")
local Bricks = require("src.Bricks")
local Collisions = require("src.Collisions")
local Levels = require("src.Levels")
local Platform = require("src.Platform")
local Walls = require("src.Walls")

local gamestate = "menu"

-- TODO: Initialise instance of modules and reference them instead of directly referencing modules

function love.load()
    level = Levels.require_current_level_from_file()
    Bricks.construct_level_from_table(level)
    Walls.construct_walls()
end

function love.update(dt)
    if gamestate == "menu" then
    elseif gamestate == "game" then
        Ball.update(dt)
        Platform.update(dt)
        Bricks.update()
        Walls.update()
        Collisions.resolve_collisions()
        switch_to_next_level_table(Bricks)
    elseif gamestate == "game_paused" then
    elseif gamestate == "game_finished" then
    end
end

function love.draw()
    if gamestate == "menu" then
        love.graphics.print("Menu gamestate. Press Enter to continue.", 280, 250)
    elseif gamestate == "game" or gamestate == "game_paused" then
        Ball.draw()
        Platform.draw()
        Bricks.draw()
        Walls.draw()

        if gamestate == "game_paused" then
            love.graphics.print("Game Paused. Press Enter to continue or Esc to quit.", 280, 250)
        end
    elseif gamestate == "game_finished" then
        love.graphics.printf("Congratulations!\n" ..
            "You have finished the game!",
            300, 250, 200, "center"
        )
    end
end

function love.keyreleased(key)
    if gamestate == "menu" then
        if key == "return" then
            gamestate = "game"
        end
        if key == "escape" then
            love.event.quit()
        end
    elseif gamestate == "game" then
        if key == "escape" then
            gamestate = "game_paused"
        end
        if key == "c" then
            Bricks.clear_all_bricks()
        end
    elseif gamestate == "game_paused" then
        if key == "return" then
            gamestate = "game"
        end
        if key == "escape" then
            love.event.quit()
        end
    elseif gamestate == "game_finished" then
        if key == "return" then
            if key == "return" then
               Levels.current_level = 1
               level = Levels.require_current_level_from_file()
               Bricks.construct_level_from_table(level)
               Ball.reposition()
               gamestate = "game"
           end
        end
        if key == "escape" then
            love.event.quit()
        end
    end
end

function switch_to_next_level_table(bricks)
    if Bricks.no_more_bricks then
        if Levels.current_level < #Levels.sequence_string then
            Levels.current_level = Levels.current_level + 1
            level = Levels.require_current_level_from_file()
            Bricks.construct_level_from_table(level)
            Ball.reposition()
        else
            gamestate = "game_finished"
        end
    end
end

function switch_to_next_level_string(bricks)
    if Bricks.no_more_bricks then
        if Levels.current_level < #Levels.sequence_string then
            Levels.current_level = Levels.current_level + 1
            Bricks.construct_level_from_string(Levels.sequence_string[Levels.current_level])
            Ball.reposition()
        else
            gamestate = "game_finished"
        end
    end
end
