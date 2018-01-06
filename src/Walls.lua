local walls = {}

walls.wall_thickness = 20
walls.current_level_walls = {}

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

function walls.update()
    for _, wall in pairs(walls.current_level_walls) do
        walls.update_wall(wall)
    end
end

function walls.update_wall(wall)
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

return walls
