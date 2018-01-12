local vector = require("src.Vector2")

local ball = {}

local ball_x_shift = 0
local platform_height = 16
local platform_starting_pos = vector(300, 500)
local first_launch_speed = vector(-150, -300)

ball.current_balls = {}
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
ball.no_more_balls = false
ball.collision_counter = 0
ball.stuck_to_platform = true
ball.separation_from_platform_center = vector(
   ball_x_shift, -1 * platform_height / 2 - ball.radius - 1
)
ball.position = platform_starting_pos + ball.separation_from_platform_center

local initial_launch_speed_magnitude = 300
ball.platform_launch_speed_magnitude = initial_launch_speed_magnitude
local ball_platform_initial_separation = vector(
   ball_x_shift, -1 * platform_height / 2 - ball.radius - 1
)
ball.separation_from_platform_center = ball_platform_initial_separation

function ball.new_ball(position, speed, platform_launch_speed_magnitude, stuck_to_platform)
    return {
        position = position,
        speed = speed,
        platform_launch_speed_magnitude = platform_launch_speed_magnitude,
        stuck_to_platform = stuck_to_platform,
        radius = ball.radius,
        collision_counter = 0,
        separation_from_platform_center = ball_platform_initial_separation,
        quad = ball.quad
    }
end

function ball.add_ball(single_ball)
    table.insert(ball.current_balls, single_ball)
end

function ball.normal_rebound(single_ball, shift_ball)
    local min_shift = math.min(math.abs(shift_ball.x), math.abs(shift_ball.y))

    if math.abs(shift_ball.x) == min_shift then
        shift_ball.y = 0
    else
        shift_ball.x = 0
    end

    single_ball.position.x = single_ball.position.x + shift_ball.x
    single_ball.position.y = single_ball.position.y + shift_ball.y

    if shift_ball.x ~= 0 then
        single_ball.speed.x = -single_ball.speed.x
    end
    if shift_ball.y ~= 0 then
        single_ball.speed.y = -single_ball.speed.y
    end
end

function ball.brick_rebound(single_ball, shift)
    ball.normal_rebound(single_ball, shift)
    ball.increase_collision_counter(single_ball)
    ball.increase_speed_after_collision(single_ball)
end

function ball.platform_rebound(single_ball, shift, platform)
    ball.increase_collision_counter(single_ball)
    ball.increase_speed_after_collision(single_ball)
    if not platform.glued then
        ball.bounce_from_sphere(single_ball, shift, platform)
    else
        single_ball.stuck_to_platform = true
        local actual_shift = ball.determine_actual_shift(shift)
        single_ball.position = single_ball.position + actual_shift
        single_ball.platform_launch_speed_magnitude = single_ball.speed:len()
        ball.compute_ball_platform_separation(single_ball, platform)
    end
end

function ball.compute_ball_platform_separation(single_ball, platform)
    local platform_centre = vector(
        platform.position.x + platform.width / 2,
        platform.position.y + platform.height / 2
    )
    local ball_centre = single_ball.position:clone()
    single_ball.separation_from_platform_center = ball_centre - platform_centre
    print(single_ball.separation_from_platform_center)
end

function ball.wall_rebound(single_ball, shift)
    ball.normal_rebound(single_ball, shift)
    ball.min_angle_rebound(single_ball)
    ball.increase_collision_counter(single_ball)
    ball.increase_speed_after_collision(single_ball)
end

function ball.bounce_from_sphere(single_ball, shift, platform)
    local actual_shift = ball.determine_actual_shift(shift)
    single_ball.position = single_ball.position + actual_shift
    if actual_shift.x ~= 0 then
        single_ball.speed.x = -single_ball.speed.x
    end
    if actual_shift.y ~= 0 then
        local sphere_radius = 200
        local ball_centre = single_ball.position
        local platform_centre = platform.position +
            vector(platform.width / 2, platform.height / 2)
        local separation = ball_centre - platform_centre
        local normal_direction = vector(separation.x / sphere_radius, -1)
        local v_normal = single_ball.speed:projectOn(normal_direction)
        local v_tangent = single_ball.speed - v_normal
        local reverse_v_normal = v_normal * -1
        single_ball.speed = reverse_v_normal + v_tangent
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

function ball.min_angle_rebound(single_ball)
    local min_horizontal_rebound_angle = math.rad(20)
    local vx, vy = single_ball.speed:unpack()
    local new_vx, new_vy = vx, vy
    rebound_angle = math.abs(math.atan(vy / vx))
    if rebound_angle < min_horizontal_rebound_angle then
        new_vx = ball.sign(vx) * single_ball.speed:len() *
            math.cos( min_horizontal_rebound_angle )
        new_vy = ball.sign(vy) * single_ball.speed:len() *
            math.sin(min_horizontal_rebound_angle)
    end
    single_ball.speed = vector(new_vx, new_vy)
end

function ball.sign(x)
    return x < 0 and -1 or x > 0 and 1 or 0
end

function ball.increase_collision_counter(single_ball)
    single_ball.collision_counter = single_ball.collision_counter + 1
end

function ball.increase_speed_after_collision(single_ball)
    local speed_increase = 20
    local each_n_collisions = 10
    if single_ball.collision_counter ~= 0 then
        if single_ball.collision_counter >= each_n_collisions == 0 then
            single_ball.speed = single_ball.speed + single_ball.speed:normalized() * speed_increase
        end
    end
end

function ball.reset()
    ball.no_more_balls = false
    for i in pairs(ball.current_balls) do
        ball.current_balls[i] = nil
    end

    local position = platform_starting_pos + ball_platform_initial_separation
    local speed = vector(0, 0)
    local platform_launch_speed_magnitude = initial_launch_speed_magnitude
    local stuck_to_platform = true
    ball.add_ball(ball.new_ball(
        position, speed, platform_launch_speed_magnitude, stuck_to_platform
    ))
end

function ball.check_escape_from_screen()
    for i, single_ball in ipairs(ball.current_balls) do
        local x, y = single_ball.position:unpack()
        local ball_top = y - single_ball.radius
        if ball_top > love.graphics.getHeight() then
            table.remove(ball.current_balls, i)
        end
    end
    if next(ball.current_balls) == nil then
        ball.no_more_balls = true
    end
end

function ball.react_on_decelerate_bonus()
    local speed_difference = 0.7
    for _, single_ball in ipairs(ball.current_balls) do
        single_ball.speed = single_ball.speed * speed_difference
    end
end

function ball.react_on_accelerate_bonus()
    local speed_difference = 1.3
    for _, single_ball in ipairs(ball.current_balls) do
        single_ball.speed = single_ball.speed * speed_difference
    end
end

function ball.react_on_new_ball_bonus()
    local first_ball = ball.current_balls[1]
    local new_ball_position = first_ball.position:clone()
    local new_ball_speed = first_ball.speed:rotated(math.pi / 4)
    local new_ball_launch_speed_magnitude = first_ball.platform_launch_speed_magnitude
    local new_ball_stuck = first_ball.stuck_to_platform
    ball.add_ball(ball.new_ball(
        new_ball_position, new_ball_speed, new_ball_launch_speed_magnitude, new_ball_stuck
    ))
end

function ball.follow_platform(single_ball, platform)
    local platform_centre = vector(platform.position.x + platform.width / 2, platform.position.y + platform.height / 2)
    single_ball.position = platform_centre + single_ball.separation_from_platform_center
end

function ball.launch_single_ball_from_platform()
    for _, single_ball in pairs(ball.current_balls) do
        if single_ball.stuck_to_platform then
            single_ball.stuck_to_platform = false
            local platform_halfwidth = 70
            local launch_direction = vector(
                single_ball.separation_from_platform_center.x /
                platform_halfwidth, -1
            )
            single_ball.speed = launch_direction / launch_direction:len() *
                single_ball.platform_launch_speed_magnitude
            break
        end
    end
end

function ball.launch_all_balls_from_platform()
    for _, single_ball in pairs(ball.current_balls) do
        if single_ball.stuck_to_platform then
            single_ball.stuck_to_platform = false
            local platform_halfwidth = 70
            local launch_direction = vector(
            single_ball.separation_from_platform_center.x /
                platform_halfwidth, -1 )
            single_ball.speed = launch_direction / launch_direction:len() *
                single_ball.platform_launch_speed_magnitude
        end
    end
end

function ball.update_ball(single_ball, dt, platform)
    if single_ball.stuck_to_platform then
        ball.follow_platform(single_ball, platform)
    else
        single_ball.position = single_ball.position + single_ball.speed * dt
    end
end

function ball.draw_ball(single_ball)
    love.graphics.draw(
        ball.image, single_ball.quad,
        single_ball.position.x - single_ball.radius,
        single_ball.position.y - single_ball.radius
    )

    if DEBUG then
        local circleSegments = 16
        love.graphics.circle(
            "line",
            single_ball.position.x,
    		single_ball.position.y,
            single_ball.radius,
            circleSegments
        )
    end
end

function ball.update(dt, platform)
    for _, single_ball in ipairs(ball.current_balls) do
       ball.update_ball(single_ball, dt, platform)
    end
    ball.check_escape_from_screen()
end

function ball.draw()
    for _, single_ball in ipairs(ball.current_balls) do
       ball.draw_ball(single_ball)
    end
end

return ball
