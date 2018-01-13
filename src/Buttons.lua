local vector = require("src.Vector2")

local buttons = {}

function buttons.new_button(object)
    return {
        position = object.position or vector(300, 300),
        width = object.width or 100,
        height = object.height or 50,
        text = object.text or "Hello!",
        image = object.image or nil,
        quad = object.quad or nil,
        quad_when_selected = object.quad_when_selected or nil,
        selected = false
    }
end

function buttons.inside(button, mouse_pos)
    return (
        button.position.x < mouse_pos.x and
        mouse_pos.x < button.position.x + button.width and 
        button.position.y < mouse_pos.y and
        mouse_pos.y < button.position.y + button.height
    )
end

function buttons.update_button(button, dt)
    local mouse_pos = vector(love.mouse.getPosition())
    if buttons.inside(button, mouse_pos) then
        button.selected = true
    else
        button.selected = false
    end
end

function buttons.draw_button(button)
    if button.selected then
        if button.image and button.quad_when_selected then
            love.graphics.draw(button.image, button.quad_when_selected, button.position.x, button.position.y)
        else
            love.graphics.rectangle("line", button.position.x, button.position.y, button.width, button.height)
            love.graphics.push("all")
            love.graphics.setColor(255, 0, 0, 100)
            love.graphics.print(button.text, button.position.x, button.position.y)
            love.graphics.pop("all")
        end
    else
        if button.image and button.quad then
            love.graphics.draw(button.image, button.quad, button.position.x, button.position.y)
        else
            love.graphics.rectangle("line", button.position.x, button.position.y, button.width, button.height)
            love.graphics.print(button.text, button.position.x, button.position.y)
        end
    end
end

function buttons.mousereleased(selected_button, x, y, button)
    return selected_button.selected
end

return buttons