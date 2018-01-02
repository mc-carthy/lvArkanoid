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
    collisions.ball_walls_collision(ball, walls)
    collisions.ball_bricks_collision(ball, bricks)
    collisions.platform_walls_collision(platform, walls)
end

function ball.rebound(shift_ball_x, shift_ball_y)
    local min_shift = math.min(math.abs(shift_ball_x), math.abs(shift_ball_y))

    if math.abs(shift_ball_x) == min_shift then
        shift_ball_y = 0
    else
        shift_ball_x = 0
    end

    ball.position_x = ball.position_x + shift_ball_x
    ball.position_y = ball.position_y + shift_ball_y

    if shift_ball_x ~= 0 then
        ball.speed_x = -ball.speed_x
    end
    if shift_ball_y ~= 0 then
        ball.speed_y = -ball.speed_y
    end
end

function platform.bounce_from_wall(shift_platform_x, shift_platform_y)
       platform.position_x = platform.position_x + shift_platform_x
end

function collisions.check_rectangles_overlap(a, b)
    local overlap = false
    local shift_b_x, shift_b_y = 0, 0
    if not (a.x + a.width < b.x or b.x + b.width < a.x or
        a.y + a.height < b.y or b.y + b.height < a.y
    ) then
        if (a.x + a.width / 2) < (b.x + b.width / 2) then
            shift_b_x = (a.x + a.width) - b.x
        else
            shift_b_x = a.x - (b.x + b.width)
        end
        if (a.y + a.height / 2) < (b.y + b.height / 2) then
            shift_b_y = (a.y + a.height) - b.y
        else
            shift_b_y = a.y - (b.y + b.height)
        end
        overlap = true
    end
    return overlap, shift_b_x, shift_b_y
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
    overlap, shift_ball_x, shift_ball_y = collisions.check_rectangles_overlap(b, a)
    if overlap then
        ball.rebound(shift_ball_x, shift_ball_y)
    end
end

function collisions.ball_walls_collision(ball, walls)
    local overlap, shift_ball_x, shift_ball_y
    a = {
        x = ball.position_x - ball.radius,
        y = ball.position_y - ball.radius,
        width = ball.radius * 2,
        height = ball.radius * 2
    }
    for _, wall in pairs(walls.current_level_walls) do
        b = {
            x = wall.position_x,
            y = wall.position_y,
            width = wall.width,
            height = wall.height
        }
        overlap, shift_ball_x, shift_ball_y = collisions.check_rectangles_overlap(b, a)
        if overlap then
            ball.rebound(shift_ball_x, shift_ball_y)
        end
    end
end

function collisions.ball_bricks_collision(ball, bricks)
    a = {
        x = ball.position_x - ball.radius,
        y = ball.position_y - ball.radius,
        width = ball.radius * 2,
        height = ball.radius * 2
    }
    for _, brick in pairs(bricks.current_level_bricks) do
        b = {
            x = brick.position_x,
            y = brick.position_y,
            width = brick.width,
            height = brick.height
        }
        if collisions.check_rectangles_overlap(a, b) then
            print("Ball-Brick collision")
        end
    end
end

function collisions.platform_walls_collision(platform, walls)
    local overlap, shift_platform_x, shift_platform_y
    a = {
        x = platform.position_x,
        y = platform.position_y,
        width = platform.width,
        height = platform.height
    }
    for _, wall in pairs(walls.current_level_walls) do
        b = {
            x = wall.position_x,
            y = wall.position_y,
            width = wall.width,
            height = wall.height
        }
        overlap, shift_platform_x, shift_platform_y = collisions.check_rectangles_overlap(b, a)
        if overlap then
            platform.bounce_from_wall(shift_platform_x, shift_platform_y)
        end
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

function love.keyreleased(key)
   if key == 'escape' then
      love.event.quit()
   end
end
