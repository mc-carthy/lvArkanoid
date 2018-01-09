local vector = require("src.Vector2")

local bonuses = {}

bonuses.image = love.graphics.newImage("src/Assets/Images/800x600/bonuses.png")
bonuses.tile_width = 64
bonuses.tile_height = 32
bonuses.tileset_width = 512
bonuses.tileset_height = 32
bonuses.radius = 14
bonuses.speed = vector(0, 100)
bonuses.current_level_bonuses = {}

function bonuses.new_bonus(position, bonus_type)
    return {
        position = position,
        bonus_type = bonus_type,
        quad = bonuses.bonus_type_to_quad(bonus_type)
    }
end

function bonuses.add_bonus(bonus)
    table.insert(bonuses.current_level_bonuses, bonus)
end

function bonuses.bonus_type_to_quad(bonus_type)
    if bonus_type == nil or bonus_type <= 10 or bonus_type >= 19 then
        return nil
    end

    local row = math.floor(bonus_type / 10)
    local col = bonus_type % 10
    local x_pos = bonuses.tile_width * (col - 1)
    local y_pos = bonuses.tile_height * (row - 1)

    return love.graphics.newQuad(
        x_pos, y_pos,
        bonuses.tile_width, bonuses.tile_height,
        bonuses.tileset_width, bonuses.tileset_height
    )
end

function bonuses.generate_bonus(position, bonus_type)
    if bonuses.valid_bonus_type(bonus_type) then
        bonuses.add_bonus(bonuses.new_bonus(position, bonus_type))
    end
end

function bonuses.valid_bonus_type(bonus_type)
    if bonus_type and bonus_type > 10 and bonus_type < 19 then
        return true
    else
        return false
    end
end

function bonuses.clear_current_level_bonuses()
    for i in pairs(bonuses.current_level_bonuses) do
        bonuses.current_level_bonuses[i] = nil
    end
end

function bonuses.update_bonus(dt, bonus)
    bonus.position = bonus.position + (bonuses.speed * dt)
end

function bonuses.draw_bonus(bonus)
    if bonus.quad then
        love.graphics.draw(
            bonuses.image, bonus.quad,
            bonus.position.x - bonuses.tile_width / 2,
            bonus.position.y - bonuses.tile_height / 2
        )
    end
    local segments_in_circle = 16
    love.graphics.circle("line", bonus.position.x, bonus.position.y, bonuses.radius, segments_in_circle)
end

function bonuses.update(dt)
    for _, bonus in pairs(bonuses.current_level_bonuses) do
        bonuses.update_bonus(dt, bonus)
    end
end

function bonuses.draw()
    for _, bonus in pairs(bonuses.current_level_bonuses) do
        bonuses.draw_bonus(bonus)
    end
end

return bonuses
