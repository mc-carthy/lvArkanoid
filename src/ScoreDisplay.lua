local vector = require ("src.Vector2")
local LivesDisplay = require("src.LivesDisplay")

local score_display = {}

local position = vector( 650, 32 )
local width = 120
local height = 65
local separation = 35
local bungee_font = love.graphics.newFont("src/Assets/Fonts/BungeeInline-Regular.ttf", 30)

score_display.score = 0

function score_display.add_score_for_simple_brick()
    score_display.add_score(10)
end

function score_display.add_score_for_cracked_brick()
    score_display.add_score(30)
end

function score_display.add_score(value)
    score_display.score = score_display.score + value
    LivesDisplay.add_life_if_score_reached(score_display.score)
end

function score_display.update(dt)
end

function score_display.draw()
    love.graphics.push("all")
    love.graphics.setFont(bungee_font)
    love.graphics.setColor(255, 255, 255, 215)
    love.graphics.printf(
        "Score:",
        position.x, position.y,
        width, "center"
    )
    love.graphics.printf(
        score_display.score,
        position.x, position.y + separation,
        width, "center"
    )
    love.graphics.pop("all")
end

function score_display.reset()
    score_display.score = 0
end

return score_display