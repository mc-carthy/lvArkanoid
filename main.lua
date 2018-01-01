local collisions = {}

local ball = {}
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300
ball.radius = 10

local platform = {}
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20

local bricks = {}
bricks.current_level_bricks = {}
bricks.columns = 11
bricks.rows = 8
bricks.top_left_position_x = 70
bricks.top_left_position_y = 50
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.brick_width = 50
bricks.brick_height = 30

local walls = {}
walls.wall_thickness = 20
walls.current_level_walls = {}

function collisions.resolve_collisions()
    collisions.ball_platform_collision(ball, platform)
    -- collisions.ball_walls_collision(ball, walls)
    -- collisions.ball_bricks_collision(ball, bricks)
    -- collisions.platform_walls_collision(platform, walls)
end

function collisions.check_rectangles_overlap(a, b)
    local overlap = false
    if not (a.x + a.width < b.x or b.x + b.width < a.x or
        a.y + a.height < b.y or b.y + b.height < a.y) then
        overlap = true
    end
    return overlap
end

function collisions.ball_platform_collision(ball, platform)
    a = {
        x = ball.position_x - ball.radius,
        y = ball.position_y - ball.radius,
        width = ball.radius * 2,
        height = ball.radius * 2
    }
    b = {
        x = platform.position_x,
        y = platform.position_y,
        width = platform.width,
        height = platform.height
    }
    if collisions.check_rectangles_overlap(a, b) then
        print("Ball-Platform collision")
    end
end

function bricks.contruct_level()
    for col = 1, bricks.columns do
        for row = 1, bricks.rows do
            local new_brick_position_x = bricks.top_left_position_x + (col - 1)
                * (bricks.brick_width + bricks.horizontal_distance)
            local new_brick_position_y = bricks.top_left_position_y + (row - 1)
                * (bricks.brick_height + bricks.vertical_distance)
            local new_brick = bricks.new_brick(new_brick_position_x, new_brick_position_y)
            bricks.add_to_current_level_bricks(new_brick)
        end
    end
end

function bricks.add_to_current_level_bricks(brick)
    table.insert(bricks.current_level_bricks, brick)
end

function bricks.new_brick(position_x, position_y, width, height)
    return {
        position_x = position_x,
        position_y = position_y,
        width = width or bricks.brick_width,
        height = height or bricks.brick_height
    }
end

function walls.construct_walls()
    local left_wall = walls.new_wall(
        0,
        0,
        walls.wall_thickness,
        love.graphics.getHeight()
    )
    local right_wall = walls.new_wall(
        love.graphics.getWidth() - walls.wall_thickness,
        0,
        walls.wall_thickness,
        love.graphics.getHeight()
    )
    local top_wall = walls.new_wall(
        0,
        0,
        love.graphics.getWidth(),
        walls.wall_thickness
    )
    local bottom_wall = walls.new_wall(
        0,
        love.graphics.getHeight() - walls.wall_thickness,
        love.graphics.getWidth(),
        walls.wall_thickness
    )

    walls.current_level_walls["left"] = left_wall
    walls.current_level_walls["right"] = right_wall
    walls.current_level_walls["top"] = top_wall
    walls.current_level_walls["bottom"] = bottom_wall
end

function walls.new_wall(position_x, position_y, width, height)
    return {
        position_x = position_x,
        position_y = position_y,
        width = width,
        height = height
    }
end

function ball.update(dt)
    ball.position_x = ball.position_x + ball.speed_x * dt
    ball.position_y = ball.position_y + ball.speed_y * dt
end

function platform.update(dt)
    if love.keyboard.isDown("right") then
        platform.position_x = platform.position_x + (platform.speed_x * dt)
    end
    if love.keyboard.isDown("left") then
        platform.position_x = platform.position_x - (platform.speed_x * dt)
    end
end

function bricks.update()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.update_brick(brick)
    end
end

function bricks.update_brick(brick)

end

function walls.update()
    for _, wall in pairs(walls.current_level_walls) do
        walls.update_wall(wall)
    end
end

function walls.update_wall(wall)

end

function ball.draw()
    local circleSegments = 16
    love.graphics.circle(
        "line",
        ball.position_x,
        ball.position_y,
        ball.radius,
        circleSegments
    )
end

function platform.draw()
    love.graphics.rectangle(
        "line",
        platform.position_x,
        platform.position_y,
        platform.width,
        platform.height
    )
end

function bricks.draw()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.draw_brick(brick)
    end
end

function bricks.draw_brick(brick)
    love.graphics.rectangle(
        "line",
        brick.position_x,
        brick.position_y,
        brick.width,
        brick.height
    )
end

function walls.draw()
    for _, wall in pairs(walls.current_level_walls) do
        walls.draw_wall(wall)
    end
end

function walls.draw_wall(wall)
    love.graphics.rectangle(
        "line",
        wall.position_x,
        wall.position_y,
        wall.width,
        wall.height
    )
end

function love.load()
    bricks.contruct_level()
    walls.construct_walls()
end

function love.update(dt)
    ball.update(dt)
    platform.update(dt)
    bricks.update()
    walls.update()
    collisions.resolve_collisions()
end

function love.draw()
    ball.draw()
    platform.draw()
    bricks.draw()
    walls.draw()
end
