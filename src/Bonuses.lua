local vector = require("src.Vector2")
local livesDisplay = require("src.LivesDisplay")
local walls = require("src.Walls")

local bonuses = {}

bonuses.image = love.graphics.newImage("src/Assets/Images/800x600/bonuses.png")
bonuses.tile_width = 64
bonuses.tile_height = 32
bonuses.tileset_width = 512
bonuses.tileset_height = 32
bonuses.radius = 14
bonuses.speed = vector(0, 100)
bonuses.current_level_bonuses = {}

local bonus_type_rng = love.math.newRandomGenerator(os.time())

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
    if bonuses.bonus_type_random(bonus_type) then
        bonus_type = bonuses.random_bonus_type()
    end
    if bonuses.valid_bonus_type(bonus_type) then
        bonuses.add_bonus(bonuses.new_bonus(position, bonus_type))
    end
end

function bonuses.random_bonus_type()
    local bonus_type
    local prob = bonus_type_rng:random(400)
    if prob == 400 then
        bonus_type = bonuses.choose_valuable_bonus()
    elseif prob >= 300 then
        bonus_type = bonuses.choose_common_bonus()
    else
        bonus_type = nil
    end
    return bonus_type
end

function bonuses.choose_valuable_bonus()
    local valuable_bonus_types = { 17, 18 }
    return valuable_bonus_types[bonus_type_rng:random(#valuable_bonus_types)]
end
 
function bonuses.choose_common_bonus()
    local common_bonus_types = { 11, 12, 13, 14, 15, 16 }
    return common_bonus_types[bonus_type_rng:random(#common_bonus_types)]
end

function bonuses.bonus_collected(i, bonus, ball, platform)
    if not bonuses.is_glue(bonus) then
        platform.remove_glued_effect()
        ball.launch_all_balls_from_platform()
    end
    if bonuses.is_decelerate(bonus) then
        ball.react_on_decelerate_bonus()
    elseif bonuses.is_accelerate(bonus) then
        ball.react_on_accelerate_bonus()
    elseif bonuses.is_increase(bonus) then
        platform.react_on_increase_bonus()
    elseif bonuses.is_decrease(bonus) then
        platform.react_on_decrease_bonus()
    elseif bonuses.is_glue(bonus) then
        platform.react_on_glue_bonus()
    elseif bonuses.is_new_ball(bonus) then
        ball.react_on_new_ball_bonus()
    elseif bonuses.is_extra_life(bonus) then
        livesDisplay.add_life()
    elseif bonuses.is_next_level(bonus) then
        walls.current_level_walls["right"].next_level_bonus = true
    end
    table.remove(bonuses.current_level_bonuses, i)
end

function bonuses.bonus_type_random(bonus_type)
    return bonus_type == 0
end

function bonuses.is_decelerate(bonus)
    local col = bonus.bonus_type % 10
    return col == 1
end

function bonuses.is_accelerate(bonus)
    local col = bonus.bonus_type % 10
    return col == 5
end

function bonuses.is_increase(bonus)
    local col = bonus.bonus_type % 10
    return col == 3
end

function bonuses.is_decrease(bonus)
    local col = bonus.bonus_type % 10
    return col == 6
end

function bonuses.is_glue(bonus)
   local col = bonus.bonus_type % 10
   return col == 2
end

function bonuses.is_new_ball(bonus)
   local col = bonus.bonus_type % 10
   return col == 4
end

function bonuses.is_extra_life(bonus)
    local col = bonus.bonus_type % 10
    return col == 8
end

function bonuses.is_next_level(bonus)
    local col = bonus.bonus_type % 10
    return col == 7
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
