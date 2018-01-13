local vector = require("src.Vector2")

local lives_display = {}

local bungee_font = love.graphics.newFont("src/Assets/Fonts/BungeeInline-Regular.ttf", 30)
local position = vector(620, 500)
local width = 170
local height = 65

lives_display.lives = 5
lives_display.lives_added_from_score = 0

function lives_display.lose_life()
    lives_display.lives = lives_display.lives - 1
end

function lives_display.add_life()
    lives_display.lives = lives_display.lives + 1
end

function lives_display.add_life_if_score_reached(score)
    local score_milestone = (lives_display.lives_added_from_score + 1) * 3000
    if score >= score_milestone then
       lives_display.add_life()
       lives_display.lives_added_from_score = lives_display.lives_added_from_score + 1
    end
 end

function lives_display.reset()
    lives_display.lives = 5
    lives_display.lives_added_from_score = 0
 end

function lives_display.update(dt)
end

function lives_display.draw()
    love.graphics.push("all")
    love.graphics.setFont(bungee_font)
    love.graphics.setColor(255, 255, 255, 215)
    love.graphics.printf(
        "Lives: " .. tostring(lives_display.lives),
        position.x, position.y,
        width, "center"
    )
    love.graphics.pop("all")
end

return lives_display
