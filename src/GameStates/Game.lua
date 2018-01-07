local Ball = require("src.Ball")
local Bricks = require("src.Bricks")
local Collisions = require("src.Collisions")
local Levels = require("src.Levels")
local Platform = require("src.Platform")
local Walls = require("src.Walls")

local game = {}

function game.load()
    Walls.construct_walls()
end

function game.enter(prev_state, ...)
    args = ...
    if args and args.current_level then
        Levels.current_level = args.current_level
        local level = Levels.require_current_level_from_file()
        Bricks.construct_level_from_table(level)
        Ball.reposition()
    end
end

function game.switch_to_next_level(bricks, ball, levels)
    if bricks.no_more_bricks then
        bricks.clear_all_bricks()
        if levels.current_level < #levels.sequence_table then
            GameState.set_state("Game", { current_level = levels.current_level + 1 })
        else
            GameState.set_state("GameFinished")
        end
    end
end

function game.update(dt)
    Ball.update(dt)
    Platform.update(dt)
    Bricks.update()
    Walls.update()
    Collisions.resolve_collisions()
    game.switch_to_next_level(Bricks, Ball, Levels)
end

function game.draw()
    Ball.draw()
    Platform.draw()
    Walls.draw()
    Bricks.draw()
end

function game.keyreleased(key)
    if key == "escape" then
        GameState.set_state("GamePaused", { ball, platform, bricks, walls })
    end
    if key == "c" then
        Bricks.clear_all_bricks()
    end
end

return game
