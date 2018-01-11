local Ball = require("src.Ball")
local Bricks = require("src.Bricks")
local Collisions = require("src.Collisions")
local Levels = require("src.Levels")
local Platform = require("src.Platform")
local Walls = require("src.Walls")
local LivesDisplay = require("src.LivesDisplay")
local Bonuses = require("src.Bonuses")

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
        Platform.remove_bonus_effects()
    end
    if prev_state == "GamePaused" then
        music:resume()
    end
    if prev_state == "GameOver" or prev_state == "GameFinished" then
        lives_display.reset()
        music:rewind()
    end
end

function game.check_no_more_balls(ball, lives_display)
    if ball.escaped_screen then
        lives_display.lose_life()
        if lives_display.lives < 0 then
            GameState.set_state("GameOver", { Ball, Platform, Bricks, Walls, LivesDisplay })
        else
            ball.reposition()
            Platform.remove_bonus_effects()
        end
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
    Ball.update(dt, Platform)
    Platform.update(dt)
    Bricks.update()
    Walls.update()
    Bonuses.update(dt)
    Collisions.resolve_collisions()
    game.check_no_more_balls(Ball, LivesDisplay)
    game.switch_to_next_level(Bricks, Ball, Levels)
end

function game.draw()
    Ball.draw()
    Platform.draw()
    Walls.draw()
    Bricks.draw()
    Bonuses.draw()
    LivesDisplay.draw()
end

function game.keyreleased(key)
    if key == "escape" then
        music:pause()
        GameState.set_state("GamePaused", { Ball, Platform, Bricks, Walls, LivesDisplay })
    end
    if key == "c" then
        Bricks.clear_all_bricks()
    end
    if key == "space" then
        Ball.launch_from_platform()
    end
end

function game.mousereleased(x, y, button)
    if button == 1 then
        Ball.launch_from_platform()
    elseif button == 2 then
        music:pause()
        GameState.set_state(
            "GamePaused",
            { Ball, Platform, Bricks, Walls, Lives_display }
        )
    end
end

return game
