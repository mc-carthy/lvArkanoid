local vector = require("src.Vector2")

local walls = {}

walls.side_wall_thickness = 34
walls.top_wall_thickness = 26
walls.right_border_x_pos = 576
walls.current_level_walls = {}

function walls.construct_walls()
    local left_wall = walls.new_wall(
        vector(0, 0),
        walls.side_wall_thickness,
        love.graphics.getHeight()
    )
    local right_wall = walls.new_wall(
        vector(walls.right_border_x_pos, 0),
        walls.side_wall_thickness,
        love.graphics.getHeight()
    )
    local top_wall = walls.new_wall(
        vector(0, 0),
        walls.right_border_x_pos,
        walls.top_wall_thickness
    )
    local bottom_wall = walls.new_wall(
        vector(0, love.graphics.getHeight()),
        walls.right_border_x_pos,
        walls.top_wall_thickness
    )

    walls.current_level_walls["left"] = left_wall
    walls.current_level_walls["right"] = right_wall
    walls.current_level_walls["top"] = top_wall
    -- walls.current_level_walls["bottom"] = bottom_wall
end

function walls.new_wall(position, width, height)
    return {
        position = position,
        width = width,
        height = height
    }
end

function walls.remove_bonus_effects()
    walls.current_level_walls["right"].next_level_bonus = false
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
    love.graphics.push("all")
    love.graphics.setColor(255, 0, 0, 100)
    if wall.next_level_bonus then
        love.graphics.setColor(0, 0, 255, 100)
    end
    love.graphics.rectangle(
        "fill",
        wall.position.x,
        wall.position.y,
        wall.width,
        wall.height
    )
    love.graphics.pop("all")
end

return walls
