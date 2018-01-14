local vector = require("src.Vector2")
local buttons = require("src.Buttons")

local menu = {}


local menu_buttons_image = love.graphics.newImage("src/Assets/Images/800x600/buttons.png")
local button_tile_width = 128
local button_tile_height = 64
local play_button_tile_x_pos = 0
local play_button_tile_y_pos = 0
local quit_button_tile_x_pos = 0
local quit_button_tile_y_pos = 64
local selected_x_shift = 128
local tileset_width = 256
local tileset_height = 128
local play_button_quad = love.graphics.newQuad(
    play_button_tile_x_pos,
    play_button_tile_y_pos,
    button_tile_width,
    button_tile_height,
    tileset_width,
    tileset_height
)
local play_button_selected_quad = love.graphics.newQuad(
    play_button_tile_x_pos + selected_x_shift,
    play_button_tile_y_pos,
    button_tile_width,
    button_tile_height,
    tileset_width,
    tileset_height
)
local quit_button_quad = love.graphics.newQuad(
    quit_button_tile_x_pos,
    quit_button_tile_y_pos,
    button_tile_width,
    button_tile_height,
    tileset_width,
    tileset_height
)
local quit_button_selected_quad = love.graphics.newQuad(
    quit_button_tile_x_pos + selected_x_shift,
    quit_button_tile_y_pos,
    button_tile_width,
    button_tile_height,
    tileset_width,
    tileset_height
)

local start_button = {}
local quit_button = {}


function menu.load()
    start_button = buttons.new_button{
        text = "New game",
        position = vector((800 - button_tile_width) / 2, 200),
        width = button_tile_width,
        height = button_tile_height,
        image = menu_buttons_image,
        quad = play_button_quad,
        quad_when_selected = play_button_selected_quad
    }
    quit_button = buttons.new_button{
        text = "Quit",
        position = vector((800 - button_tile_width) / 2, 310),
        width = button_tile_width,
        height = button_tile_height,
        image = menu_buttons_image,
        quad = quit_button_quad,
        quad_when_selected = quit_button_selected_quad
    }
    music:play()
end

function menu.update(dt)
    buttons.update_button(start_button)
    buttons.update_button(quit_button)
end

function menu.draw()
    -- love.graphics.print("Menu gamestate. Press Enter to continue.", 280, 250)
    buttons.draw_button(start_button)
    buttons.draw_button(quit_button)
end

function menu.keyreleased(key)
    if key == "return" then
        GameState.set_state("Game", { current_level = 1 })
    end
    if key == "escape" then
        love.event.quit()
    end
end

function menu.mousereleased(x, y, button)
    if button == 1 then
        -- GameState.set_state("Game", { current_level = 1 })
        if buttons.mousereleased(start_button, x, y, button) then
            GameState.set_state("Game", { current_level = 1 })
        elseif buttons.mousereleased(quit_button, x, y, button) then
            love.event.quit()
        end
    elseif button == 2 then
        love.event.quit()
    end
end

return menu
