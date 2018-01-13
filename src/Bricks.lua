local vector = require("src.Vector2")
local score_display = require("src.ScoreDisplay")

local bricks = {}

local simple_break_sound = {
    love.audio.newSource("src/Assets/SFX/recordered_glass_norm.ogg", "static"),   
    love.audio.newSource("src/Assets/SFX/edgardedition_glass_hit_norm.ogg", "static")
}
 
 local armored_hit_sound = {
    love.audio.newSource("src/Assets/SFX/qubodupImpactMetal_short_norm.ogg", "static"),
    love.audio.newSource("src/Assets/SFX/cast_iron_clangs_14_short_norm.ogg", "static"),
    love.audio.newSource("src/Assets/SFX/cast_iron_clangs_22_short_norm.ogg", "static")
}
 
 local armored_break_sound = {
    love.audio.newSource("src/Assets/SFX/armored_glass_break_short_norm.ogg", "static"),
    love.audio.newSource("src/Assets/SFX/ngruber__breaking-glass_6_short_norm.ogg", "static")
}
 
 local ball_heavyarmored_sound = {
    love.audio.newSource("src/Assets/SFX/cast_iron_clangs_11_short_norm.ogg", "static"),
    love.audio.newSource("src/Assets/SFX/cast_iron_clangs_18_short_norm.ogg", "static")
}

local snd_rng = love.math.newRandomGenerator(os.time())

bricks.current_level_bricks = {}
bricks.image = love.graphics.newImage("src/Assets/Images/800x600/bricks.png")
bricks.tile_width = 64
bricks.tile_height = 32
bricks.tileset_width = 384
bricks.tileset_height = 160
bricks.columns = 11
bricks.rows = 8
bricks.top_left_position = vector(47, 34)
bricks.horizontal_distance = 0
bricks.vertical_distance = 0
bricks.brick_width = bricks.tile_width
bricks.brick_height = bricks.tile_height
bricks.no_more_bricks = false

function bricks.new_brick(position, brick_type, bonus_type, width, height)
    return {
        position = position,
        brick_type = brick_type,
        bonus_type = bonus_type,
        width = width or bricks.brick_width,
        height = height or bricks.brick_height,
        quad = bricks.brick_type_to_quad(brick_type)
    }
end

function bricks.brick_type_to_quad(brick_type)
    local row = math.floor(brick_type / 10)
    local col = brick_type % 10
    local x_pos = bricks.tile_width * (col - 1)
    local y_pos = bricks.tile_height * (row - 1)
    return love.graphics.newQuad(
        x_pos, y_pos,
        bricks.tile_width, bricks.tile_height,
        bricks.tileset_width, bricks.tileset_height
    )
end

function bricks.is_simple(brick)
    local row = math.floor(brick.brick_type / 10)
    return row == 1
end

function bricks.is_armored(brick)
    local row = math.floor(brick.brick_type / 10)
    return row == 2
end

function bricks.is_scratched(brick)
    local row = math.floor(brick.brick_type / 10)
    return row == 3
end

function bricks.is_cracked(brick)
    local row = math.floor(brick.brick_type / 10)
    return row == 4
end

function bricks.is_heavy_armored(brick)
    local row = math.floor(brick.brick_type / 10)
    return row == 5
end

function bricks.clear_all_bricks()
    for i in pairs( bricks.current_level_bricks ) do
        bricks.current_level_bricks[i] = nil
    end
end

function bricks.weaken_brick(brick)
    brick.brick_type = brick.brick_type + 10
    brick.quad = bricks.brick_type_to_quad(brick.brick_type)
end

function bricks.brick_hit_by_ball(i, brick, shift_ball, bonuses)
    if bricks.is_simple(brick) then
        bonuses.generate_bonus(
            vector(
                brick.position.x + brick.width / 2,
                brick.position.y + brick.height / 2
            ),
            brick.bonus_type
        )
        score_display.add_score_for_simple_brick()
        table.remove(bricks.current_level_bricks, i)
        local snd = simple_break_sound[snd_rng:random(#simple_break_sound)]
        snd:play()
    elseif bricks.is_armored(brick) then
        bricks.weaken_brick(brick)
        local snd = armored_hit_sound[snd_rng:random(#armored_hit_sound)]
        snd:play()
    elseif bricks.is_scratched(brick) then
        bricks.weaken_brick(brick)
        local snd = armored_hit_sound[snd_rng:random(#armored_hit_sound)]
        snd:play()
    elseif bricks.is_cracked(brick) then
        bonuses.generate_bonus(
            vector(
                brick.position.x + brick.width / 2,
                brick.position.y + brick.height / 2
            ),
            brick.bonus_type
        )
        score_display.add_score_for_cracked_brick()
        table.remove(bricks.current_level_bricks, i)
        local snd = armored_break_sound[snd_rng:random(#armored_break_sound)]
        snd:play()
    elseif bricks.is_heavy_armored(brick) then
        local snd = ball_heavyarmored_sound[snd_rng:random(#ball_heavyarmored_sound)]
        snd:play()
    end
end

function bricks.construct_level_from_table(level)
    bricks.no_more_bricks = false
    for row_index, row in ipairs(level.bricks) do
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
                local bonus_type = level.bonuses[row_index][col_index]
                local new_brick = bricks.new_brick(new_brick_position, brick_type, bonus_type)
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

function bricks.update()
    local no_more_bricks = true
    for _, brick in pairs(bricks.current_level_bricks) do
        if bricks.is_heavy_armored(brick) then
            no_more_bricks = no_more_bricks and true
        else
            no_more_bricks = no_more_bricks and false
        end
        bricks.update_brick(brick)
    end
    bricks.no_more_bricks = no_more_bricks
end

function bricks.update_brick(brick)
end

function bricks.draw()
    for _, brick in pairs(bricks.current_level_bricks) do
        bricks.draw_brick(brick)
    end
end

function bricks.draw_brick(brick)
    if brick.quad then
        love.graphics.draw(
            bricks.image, brick.quad,
            brick.position.x,
            brick.position.y
        )
    end

    if DEBUG then
        love.graphics.rectangle(
            'line',
            brick.position.x,
            brick.position.y,
            brick.width,
            brick.height
        )
    end
end

return bricks
