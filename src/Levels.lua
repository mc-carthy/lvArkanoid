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

return levels
