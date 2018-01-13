local vector = require("src.Vector2")

local walls = {}


local image = love.graphics.newImage("src/Assets/Images/800x600/walls.png")
local wall_vertical_tile_width = 32
local wall_vertical_tile_height = 96
local wall_vertical_tile_x_pos = 0
local wall_vertical_tile_y_pos = 0
local wall_horizontal_tile_width = 96
local wall_horizontal_tile_height = 26
local wall_horizontal_tile_x_pos = 64
local wall_horizontal_tile_y_pos = 0
local topleft_corner_tile_width = 64
local topleft_corner_tile_height = 64
local topleft_corner_tile_x_pos = 64
local topleft_corner_tile_y_pos = 32
local topright_corner_tile_width = 64
local topright_corner_tile_height = 64
local topright_corner_tile_x_pos = 128
local topright_corner_tile_y_pos = 32
local tileset_width = 192
local tileset_height = 96
local vertical_quad = love.graphics.newQuad(
    wall_vertical_tile_x_pos,
    wall_vertical_tile_y_pos,
    wall_vertical_tile_width,
    wall_vertical_tile_height,
    tileset_width, tileset_height
)
local horizontal_quad = love.graphics.newQuad(
    wall_horizontal_tile_x_pos,
    wall_horizontal_tile_y_pos,
    wall_horizontal_tile_width,
    wall_horizontal_tile_height,
    tileset_width, tileset_height
)
local topright_corner_quad = love.graphics.newQuad(
    topright_corner_tile_x_pos,
    topright_corner_tile_y_pos,
    topright_corner_tile_width,
    topright_corner_tile_height,
    tileset_width, tileset_height
)
local topleft_corner_quad = love.graphics.newQuad(
    topleft_corner_tile_x_pos,
    topleft_corner_tile_y_pos,
    topleft_corner_tile_width,
    topleft_corner_tile_height,
    tileset_width, tileset_height
)


walls.side_wall_thickness = 34
walls.top_wall_thickness = 26
walls.right_border_x_pos = 576
walls.current_level_walls = {}

function walls.construct_walls()
    local left_wall = walls.new_wall(
        vector(0, 0),
        walls.side_wall_thickness,
        love.graphics.getHeight(),
        "left"
    )
    local right_wall = walls.new_wall(
        vector(walls.right_border_x_pos, 0),
        walls.side_wall_thickness,
        love.graphics.getHeight(),
        "right"
    )
    local top_wall = walls.new_wall(
        vector(0, 0),
        walls.right_border_x_pos,
        walls.top_wall_thickness,
        "top"
    )

    walls.current_level_walls["left"] = left_wall
    walls.current_level_walls["right"] = right_wall
    walls.current_level_walls["top"] = top_wall
end

function walls.new_wall(position, width, height, layout)
    return {
        position = position,
        width = width,
        height = height,
        layout = layout
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
    if wall.layout == "top" then
        love.graphics.draw( 
            image, topleft_corner_quad,
            wall.position.x, wall.position.y
        )
        love.graphics.draw(
            image, topright_corner_quad,                     
            wall.position.x + wall.width - topleft_corner_tile_width / 2, wall.position.y
        )
        local repeat_n_times = 4
        for i = 0, repeat_n_times do
            shift_x = topleft_corner_tile_width + i * wall_horizontal_tile_width
            love.graphics.draw(
                image, horizontal_quad,
                wall.position.x + shift_x, wall.position.y
            )
        end
    elseif wall.layout == "left" then
        local repeat_n_times = math.floor(
            (wall.height - topright_corner_tile_height) 
            / wall_vertical_tile_height
        )
        for i = 0, repeat_n_times do
            shift_y = topright_corner_tile_height + i * wall_vertical_tile_height
            love.graphics.draw(
                image, vertical_quad, 
                wall.position.x, wall.position.y + shift_y
            )
        end
    elseif wall.layout == "right" then
        local repeat_n_times = math.floor(
            (wall.height - topright_corner_tile_height) /
            wall_vertical_tile_height
        )
        for i = 0, repeat_n_times do
            if not (wall.next_level_bonus and i == repeat_n_times - 1 ) then
                shift_y = topright_corner_tile_height + i * wall_vertical_tile_height
                love.graphics.draw(
                    image, vertical_quad,
                    wall.position.x, wall.position.y + shift_y
                )
            end
        end
    end
end

return walls
