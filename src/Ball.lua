local vector = require("src.Vector2")

local ball = {}

ball.position = vector(200, 500)
ball.speed = vector(700, 700)
ball.radius = 10

function ball.rebound(shift_ball_x, shift_ball_y)
    local min_shift = math.min(math.abs(shift_ball_x), math.abs(shift_ball_y))

    if math.abs(shift_ball_x) == min_shift then
        shift_ball_y = 0
    else
        shift_ball_x = 0
    end

    ball.position.x = ball.position.x + shift_ball_x
    ball.position.y = ball.position.y + shift_ball_y

    if shift_ball_x ~= 0 then
        ball.speed.x = -ball.speed.x
    end
    if shift_ball_y ~= 0 then
        ball.speed.y = -ball.speed.y
    end
end

function ball.reposition()
   ball.position.x = 200
   ball.position.y = 500
end

function ball.update(dt)
    ball.position = ball.position + ball.speed * dt
end

function ball.draw()
    local circleSegments = 16
    love.graphics.circle(
        "line",
        ball.position.x,
		ball.position.y,
        ball.radius,
        circleSegments
    )
end

return ball
