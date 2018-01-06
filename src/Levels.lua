local ball = require("src.ball")

local levels = {}

levels.sequence_table = require("src.levels.SequenceTable")
levels.sequence_string = {}
levels.current_level = 1
levels.game_finished = false

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

function levels.require_current_level_from_file()
    local filename = "src/levels/" .. levels.sequence_table[levels.current_level]
    local level = require(filename)
    return level
end

function levels.switch_to_next_level_table(bricks)
    if bricks.no_more_bricks then
        if levels.current_level < #levels.sequence_string then
            levels.current_level = levels.current_level + 1
            level = levels.require_current_level_from_file()
            bricks.construct_level_from_table(level)
            ball.reposition()
        end
    else
        levels.game_finished = true
    end
end

function levels.switch_to_next_level_string(bricks)
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
