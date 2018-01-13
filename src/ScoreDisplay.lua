local vector = require ("src.Vector2")
local LivesDisplay = require("src.LivesDisplay")

local score_display = {}
score_display.position = vector(680, 32)
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
    love.graphics.print("Score: " .. tostring(score_display.score),
        score_display.position.x,
        score_display.position.y
    )
end

function score_display.reset()
    score_display.score = 0
end

return score_display