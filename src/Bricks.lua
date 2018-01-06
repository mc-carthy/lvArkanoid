local vector = require("src.Vector2")

local bricks = {}

bricks.current_level_bricks = {}
bricks.columns = 11
bricks.rows = 8
bricks.top_left_position = vector(70, 50)
bricks.horizontal_distance = 10
bricks.vertical_distance = 15
bricks.brick_width = 50
bricks.brick_height = 30
bricks.no_more_bricks = false

function bricks.clear_all_bricks()
    for i in pairs( bricks.current_level_bricks ) do
        bricks.current_level_bricks[i] = nil
    end
end

function bricks.brick_hit_by_ball(i, brick, shift_ball_x, shift_ball_y)
    table.remove(bricks.current_level_bricks, i)
end

function bricks.construct_level_from_table(level_bricks_arrangement)
    bricks.no_more_bricks = false
    for row_index, row in ipairs(level_bricks_arrangement) do
        for col_index, brick_type in ipairs(row) do
            if brick_type ~= 0 then
                local new_brick_position_x = bricks.top_left_position.x + (col_index - 1)
                    * (bricks.brick_width + bricks.horizontal_distance)
                local new_brick_position_y = bricks.top_left_position.y + (row_index - 1)
                    * (bricks.brick_height + bricks.vertical_distance)
                local new_brick_position = vector(
                    bricks.top_left_position.x + (col_index - 1) * (bricks.brick_width + bricks.horizontal_distance),
                    bricks.top_left_position.y + (row_index - 1) * (bricks.brick_height + bricks.vertical_distance)
                )
                local new_brick = bricks.new_brick(new_brick_position, brick_type)
                bricks.add_to_current_level_bricks(new_brick)
            end
        end
    end
end

function bricks.construct_level_from_string(level_bricks_arrangement)
    bricks.no_more_bricks = false
    local row_index = 0
    for row in level_bricks_arrangement:gmatch('(.-)\n') do
        row_index = row_index + 1
        local col_index = 0
        for brick_type in row:gmatch('.') do
            col_index = col_index + 1
            if brick_type == "#" then
                local new_brick_position = vector(
                    bricks.top_left_position.x + (col_index - 1) * (bricks.brick_width + bricks.horizontal_distance),
                    bricks.top_left_position.y + (row_index - 1) * (bricks.brick_height + bricks.vertical_distance)
                )
                local new_brick = bricks.new_brick(new_brick_position, brick_type)
                bricks.add_to_current_level_bricks(new_brick)
            end
        end
    end
end

function bricks.add_to_current_level_bricks(brick)
    table.insert(bricks.current_level_bricks, brick)
end

function bricks.new_brick(position, brick_type, width, height)
    return {
        position = position,
        brick_type = brick_type,
        width = width or bricks.brick_width,
        height = height or bricks.brick_height
    }
end

function bricks.update()
    if #bricks.current_level_bricks == 0 then
        bricks.no_more_bricks = true
    else
        for _, brick in pairs(bricks.current_level_bricks) do
            bricks.update_brick(brick)
        end
    end
end

function bricks.update_brick(brick)
end

function bricks.draw()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.draw_brick(brick)
    end
end

function bricks.draw_brick(brick)
    love.graphics.rectangle(
        'line',
        brick.position.x,
        brick.position.y,
        brick.width,
        brick.height
    )

    local r, g, b, a = love.graphics.getColor()
    if brick.brick_type == 1 then
       love.graphics.setColor(255, 0, 0, 100)
    elseif brick.brick_type == 2 then
       love.graphics.setColor(0, 255, 0, 100)
    elseif brick.brick_type == 3 then
       love.graphics.setColor(0, 0, 255, 100)
    end

    love.graphics.rectangle(
        'fill',
        brick.position.x,
        brick.position.y,
        brick.width,
        brick.height
    )
    love.graphics.setColor(r, g, b, a)
end

return bricks
