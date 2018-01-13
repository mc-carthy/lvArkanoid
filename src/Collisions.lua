local ball = require("src.Ball")
local platform = require("src.Platform")
local walls = require("src.Walls")
local bricks = require("src.Bricks")
local bonuses = require("src.Bonuses")
local vector = require("src.Vector2")

local collisions = {}

function collisions.resolve_collisions()
    collisions.ball_platform_collision(ball, platform)
    collisions.ball_walls_collision(ball, walls)
    collisions.ball_bricks_collision(ball, bricks, bonuses)
    collisions.platform_walls_collision(platform, walls)
    collisions.platform_bonuses_collision(platform, bonuses, ball)
end

function collisions.check_rectangles_overlap(a, b)
    local overlap = false
    local shift_b = vector(0, 0)
    if not (a.x + a.width < b.x or b.x + b.width < a.x or
        a.y + a.height < b.y or b.y + b.height < a.y
    ) then
        if (a.x + a.width / 2) < (b.x + b.width / 2) then
            shift_b.x = (a.x + a.width) - b.x
        else
            shift_b.x = a.x - (b.x + b.width)
        end
        if (a.y + a.height / 2) < (b.y + b.height / 2) then
            shift_b.y = (a.y + a.height) - b.y
        else
            shift_b.y = a.y - (b.y + b.height)
        end
        overlap = true
    end
    return overlap, shift_b
end

function collisions.ball_platform_collision(ball, platform)
    b = {
        x = platform.position.x,
        y = platform.position.y,
        width = platform.width,
        height = platform.height
    }
    for _, single_ball in ipairs(ball.current_balls) do
        a = {
            x = single_ball.position.x - single_ball.radius,
            y = single_ball.position.y - single_ball.radius,
            width = single_ball.radius * 2,
            height = single_ball.radius * 2
        }
        overlap, shift_ball = collisions.check_rectangles_overlap(b, a)
        if overlap then
            ball.platform_rebound(single_ball, shift_ball, platform)
        end
    end
end

function collisions.ball_walls_collision(ball, walls)
    for _, single_ball in ipairs(ball.current_balls) do
        local overlap, shift_ball
        a = {
            x = single_ball.position.x - single_ball.radius,
            y = single_ball.position.y - single_ball.radius,
            width = single_ball.radius * 2,
            height = single_ball.radius * 2
        }
        for _, wall in pairs(walls.current_level_walls) do
            b = {
                x = wall.position.x,
                y = wall.position.y,
                width = wall.width,
                height = wall.height
            }
            overlap, shift_ball = collisions.check_rectangles_overlap(b, a)
            if overlap then
                ball.wall_rebound(single_ball, shift_ball)
            end
        end
    end
end

function collisions.ball_bricks_collision(ball, bricks)
    local overlap, shift_ball
    for _, single_ball in pairs(ball.current_balls) do
        a = {
            x = single_ball.position.x - single_ball.radius,
            y = single_ball.position.y - single_ball.radius,
            width = single_ball.radius * 2,
            height = single_ball.radius * 2
        }
        for i, brick in pairs(bricks.current_level_bricks) do
            b = {
                x = brick.position.x,
                y = brick.position.y,
                width = brick.width,
                height = brick.height
            }
            overlap, shift_ball = collisions.check_rectangles_overlap(b, a)
            if overlap then
                ball.brick_rebound(single_ball, shift_ball)
                bricks.brick_hit_by_ball(i, brick, shift_ball, bonuses)
            end
        end
    end
end

function collisions.platform_walls_collision(platform, walls)
    local overlap, shift_platform
    a = {
        x = platform.position.x,
        y = platform.position.y,
        width = platform.width,
        height = platform.height
    }
    for _, wall in pairs(walls.current_level_walls) do
        b = {
            x = wall.position.x,
            y = wall.position.y,
            width = wall.width,
            height = wall.height
        }
        overlap, shift_platform = collisions.check_rectangles_overlap(b, a)
        if overlap then
            platform.bounce_from_wall(shift_platform.x, shift_platform.y, wall)
        end
    end
end

function collisions.platform_bonuses_collision(platform, bonuses, ball)
    local overlap
    local b = {
        x = platform.position.x,
        y = platform.position.y,
        width = platform.width,
        height = platform.height
    }
    for i, bonus in ipairs(bonuses.current_level_bonuses) do
        local a = {
            x = bonus.position.x,
            y = bonus.position.y,
            width = 2 * bonuses.radius,
            height = 2 * bonuses.radius
        }
        overlap = collisions.check_rectangles_overlap(a, b)
        if overlap then
            bonuses.bonus_collected(i, bonus, ball, platform)
        end
    end
end

return collisions
