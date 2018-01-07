local vector = require("src.Vector2")

local ball = {}

ball.position = vector(200, 500)
ball.speed = vector(1000, 1000)
ball.image = love.graphics.newImage("src/Assets/Images/800x600/ball.png")
ball.x_tile_pos = 0
ball.y_tile_pos = 0
ball.tile_width = 18
ball.tile_height = 18
ball.tileset_width = 18
ball.tileset_height = 18
ball.quad = love.graphics.newQuad(
    ball.x_tile_pos, ball.y_tile_pos,
    ball.tile_width, ball.tile_height,
    ball.tileset_width, ball.tileset_height
)
ball.radius = ball.tile_width / 2

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
   ball.position = vector(200, 500)
end

function ball.update(dt)
    ball.position = ball.position + ball.speed * dt
end

function ball.draw()
    love.graphics.draw(
        ball.image, ball.quad,
        ball.position.x - ball.radius,
        ball.position.y - ball.radius
    )

    if DEBUG then
        local circleSegments = 16
        love.graphics.circle(
            "line",
            ball.position.x,
    		ball.position.y,
            ball.radius,
            circleSegments
        )
    end
end

return ball
