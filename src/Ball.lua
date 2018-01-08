local vector = require("src.Vector2")

local ball = {}

local ball_x_shift = 0
local platform_height = 16
local platform_starting_pos = vector(300, 500)
local first_launch_speed = vector(-150, -300)

ball.position = vector(200, 500)
ball.speed = vector(0, 0)
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
ball.escaped_screen = false
ball.collision_counter = 0
ball.stuck_to_platform = true
ball.separation_from_platform_center = vector(
   ball_x_shift, -1 * platform_height / 2 - ball.radius - 1
)
ball.position = platform_starting_pos + ball.separation_from_platform_center

function ball.normal_rebound(shift_ball)
    local min_shift = math.min(math.abs(shift_ball.x), math.abs(shift_ball.y))

    if math.abs(shift_ball.x) == min_shift then
        shift_ball.y = 0
    else
        shift_ball.x = 0
    end

    ball.position.x = ball.position.x + shift_ball.x
    ball.position.y = ball.position.y + shift_ball.y

    if shift_ball.x ~= 0 then
        ball.speed.x = -ball.speed.x
    end
    if shift_ball.y ~= 0 then
        ball.speed.y = -ball.speed.y
    end
end

function ball.brick_rebound(shift)
    ball.normal_rebound(shift)
    ball.increase_collision_counter()
    ball.increase_speed_after_collision()
end

function ball.platform_rebound(shift, platform)
    ball.bounce_from_sphere(shift, platform)
    ball.increase_collision_counter()
    ball.increase_speed_after_collision()
end

function ball.wall_rebound(shift)
    ball.normal_rebound(shift)
    ball.min_angle_rebound()
    ball.increase_collision_counter()
    ball.increase_speed_after_collision()
end

function ball.bounce_from_sphere(shift, platform)
    local actual_shift = ball.determine_actual_shift(shift)
    ball.position = ball.position + actual_shift
    if actual_shift.x ~= 0 then
        ball.speed.x = -ball.speed.x
    end
    if actual_shift.y ~= 0 then
        local sphere_radius = 200
        local ball_centre = ball.position
        local platform_centre = platform.position +
            vector(platform.width / 2, platform.height / 2)
        local separation = ball_centre - platform_centre
        local normal_direction = vector(separation.x / sphere_radius, -1)
        local v_normal = ball.speed:projectOn(normal_direction)
        local v_tangent = ball.speed - v_normal
        local reverse_v_normal = v_normal * -1
        ball.speed = reverse_v_normal + v_tangent
    end
end

function ball.determine_actual_shift(shift)
    local actual_shift = vector(0, 0)
    local min_shift = math.min(math.abs(shift.x), math.abs(shift.y))
    if math.abs(shift.x) == min_shift then
        actual_shift.x = shift.x
    else
        actual_shift.y = shift.y
    end
    return actual_shift
end

function ball.min_angle_rebound()
    local min_horizontal_angle = math.rad(20)
    local vx, vy = ball.speed:unpack()
    local new_vx, new_vy = vx, vy
    local rebound_angle = math.abs(math.atan(vx / vy))
    if rebound_angle < min_horizontal_angle then
        new_vx = ball.sign(vx) * ball.speed:len() * math.cos(min_horizontal_angle)
        new_vy = ball.sign(vy) * ball.speed:len() * math.sin(min_horizontal_angle)
    end
    ball.speed = vector(new_vx, new_vy)
end

function ball.sign(x)
    return x < 0 and -1 or x > 0 and 1 or 0
end

function ball.increase_collision_counter()
    ball.collision_counter = ball.collision_counter + 1
end

function ball.increase_speed_after_collision()
    local speed_increase = 20
    local each_n_collisions = 10
    if ball.collision_counter ~= 0 then
        if ball.collision_counter >= each_n_collisions == 0 then
            ball.speed = ball.speed + ball.speed:normalized() * speed_increase
        end
    end
end

function ball.reposition()
    ball.escaped_screen = false
    ball.speed = vector(0, 0)
    ball.stuck_to_platform = true
    ball.collision_counter = 0
end

function ball.check_escape_from_screen()
   local x, y = ball.position:unpack()
   local ball_top = y - ball.radius
   if ball_top > love.graphics.getHeight() then
      ball.escaped_screen = true
   end
end

function ball.follow_platform(platform)
    local platform_centre = vector(platform.position.x + platform.width / 2, platform.position.y + platform.height / 2)
    ball.position = platform_centre + ball.separation_from_platform_center
end

function ball.launch_from_platform()
    if ball.stuck_to_platform then
       ball.stuck_to_platform = false
       ball.speed = first_launch_speed:clone()
    end
end

function ball.update(dt, platform)
    ball.position = ball.position + ball.speed * dt
    if ball.stuck_to_platform then
        ball.follow_platform(platform)
    end
    ball.check_escape_from_screen()
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
