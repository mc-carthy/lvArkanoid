local buttons = require("src.Buttons")
local vector = require("src.Vector2")

local buttons_with_url = {}

function buttons_with_url.new_button(object)
    btn = buttons.new_button(object)
    btn.url = object.url or nil
    btn.font = object.font or love.graphics.getFont()
    btn.text_align = object.text_align or "center"
    btn.sizing = object.sizing or nil
    btn.positioning = object.positioning or nil
    btn.displacement_from_auto = object.displacement_from_auto or vector(0, 0)

    return btn
end

function buttons_with_url.inside(button, pos)
    buttons.inside(button, pos)
end

function buttons_with_url.new_layout( o )
    return {
        position = o.position or vector(300, 300),
        default_width = o.default_width or 100,
        default_height = o.default_height or 50,
        default_offset = o.default_offset or vector(10, 10),
        orientation = o.orientation or "vertical",
        children = o.children or {}
    }
end

function buttons_with_url.add_to_layout(layout, element)
    if element.positioning and element.positioning == 'auto' then
        local position = layout.position
        for i, elem in ipairs(layout.children) do
            if layout.orientation == "vertical" then
                position = position + vector(0, elem.height ) + layout.default_offset
            else
                print("Unknown layout orientation")
            end
        end
        element.position = position + element.displacement_from_auto
    end
    if element.sizing and element.sizing == 'auto' then
        element.width = layout.default_width
        element.height = layout.default_height
    end
    table.insert(layout.children, element)
end

function buttons_with_url.update_layout(layout, dt)
    for _, btn in pairs(layout.children) do
        buttons_with_url.update_button(btn, dt)
    end
end

function buttons_with_url.draw_layout(layout)
    for _, btn in pairs(layout.children) do
        buttons_with_url.draw_button(btn)
    end
end

function buttons_with_url.mousereleased_layout(layout, x, y, button)
    for _, btn in pairs(layout.children) do
        buttons_with_url.mousereleased_button(btn, x, y, button)
    end
end

function buttons_with_url.update_button(button, dt)
    buttons.update_button(button, dt)
end

function buttons_with_url.draw_button(single_button)
    love.graphics.push("all")
    love.graphics.setFont(single_button.font)
    if single_button.selected then
        love.graphics.setColor(255, 0, 0, 100)
        love.graphics.printf(
            single_button.text,
            single_button.position.x,
            single_button.position.y,
            single_button.width,
            single_button.text_align 
        )
    else
        love.graphics.printf(
            single_button.text,
            single_button.position.x,
            single_button.position.y,
            single_button.width,
            single_button.text_align
        )   
    end
    love.graphics.pop()
end

function buttons_with_url.mousereleased_button(single_button, x, y, button)
    if single_button.selected then
        local status = love.system.openURL(single_button.url)
    end
    return single_button.selected 
end

return buttons_with_url