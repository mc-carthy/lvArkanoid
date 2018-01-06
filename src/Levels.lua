local ball = require("src.ball")

local levels = {}

levels.sequence_table = {}
levels.sequence_string = {}
levels.current_level = 1
levels.game_finished = false
levels.sequence_table[1] = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1 },
   { 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1 },
   { 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0 },
   { 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0 },
   { 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

levels.sequence_table[2] = {
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
   { 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1 },
   { 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0 },
   { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0 },
   { 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0 },
   { 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1 },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

levels.sequence_string[1] = [[
___________

# # ### # #
# # #   # #
### ##   #
# # #    #
# # ###  #
___________
]]

levels.sequence_string[2] = [[
___________

##  # # ###
# # # # #
###  #  ##
# #  #  #
###  #  ###
___________
]]

function levels.switch_to_next_level(bricks)
    if bricks.no_more_bricks then
        if levels.current_level < #levels.sequence_string then
            levels.current_level = levels.current_level + 1
            bricks.construct_level_from_string(levels.sequence_string[levels.current_level])
            ball.reposition()
        end
    else
        levels.game_finished = true
    end
end

return levels
