import "CoreLibs/graphics"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = playdate.graphics
local random <const> = math.random

-- Data used for game; TODO: put this into a seperate file, generate it randomly, or something else
local nonsenseStrings = {"skjs", "wuoa", "qpcj", "neor", "eyzs", "gapo", "bron", "rlep"}
local targetStrings = {"concrete", "designer"}

--------------------------------------------------------------------------------

-- TODO: this should extend a more general MiniGame class
class("WordScramble").extends()

function WordScramble:init()
    self.targetWord = targetStrings[random(#targetStrings)] -- tables are 1 indexed, random is min and max inclusive, # is length operator
end

function WordScramble:update()

end

function WordScramble:draw()
    gfx.drawTextInRect(self.targetWord, 100, 100, 200, 80)
end