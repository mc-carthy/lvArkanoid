local Ball = require("src.Ball")
local Bricks = require("src.Bricks")
local Collisions = require("src.Collisions")
local Levels = require("src.Levels")
local Platform = require("src.Platform")
local Walls = require("src.Walls")

-- TODO: Initialise instance of modules and reference them instead of directly referencing modules

function love.load()
    level = Levels.require_current_level_from_file()
    Bricks.construct_level_from_table(level)
    Walls.construct_walls()
end

function love.update(dt)
    Ball.update(dt)
    Platform.update(dt)
    Bricks.update()
    Walls.update()
    Collisions.resolve_collisions()
    Levels.switch_to_next_level_table(Bricks)
end

function love.draw()
    Ball.draw()
    Platform.draw()
    Bricks.draw()
    Walls.draw()
    if Levels.gamefinished then
        love.graphics.printf( "Congratulations!\n" ..
            "You have finished the game!",
            300, 250, 200, "center"
        )
    end
end

function love.keyreleased(key)
   if key == 'escape' then
      love.event.quit()
   end
   if key == "c" then
       Bricks.clear_all_bricks()
   end
end
