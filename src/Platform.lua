local platform = {}

platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20

function platform.bounce_from_wall(shift_platform_x, shift_platform_y)
    platform.position_x = platform.position_x + shift_platform_x
end

function platform.update(dt)
    if love.keyboard.isDown("right") then
        platform.position_x = platform.position_x + (platform.speed_x * dt)
    end
    if love.keyboard.isDown("left") then
        platform.position_x = platform.position_x - (platform.speed_x * dt)
    end
end

function platform.draw()
    love.graphics.rectangle(
        "line",
        platform.position_x,
        platform.position_y,
        platform.width,
        platform.height
    )
end

return platform
