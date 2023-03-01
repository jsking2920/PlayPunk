import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/crank"

local pd <const> = playdate
local gfx <const> = playdate.graphics

local font = gfx.font.new("Fonts/Roobert-24-Medium-Halved")

--------------------------------------------------------------------------------
local clickSound = pd.sound.sampleplayer.new("Audio/SFX/rotaryClick.wav")
local loseSound = pd.sound.sampleplayer.new("Audio/SFX/electricGrowl.wav")
local winSound = pd.sound.sampleplayer.new("Audio/SFX/positiveBeep.wav")
local selectSound = pd.sound.sampleplayer.new("Audio/SFX/weeoh.wav")

-- TODO: this should extend a more general MiniGame class
class("WordScramble").extends()

function WordScramble:init()
    --TODO: expand on these; make sure theres no possible combinations with "nonsense" string
    local possibleTargetStrings = {"concrete", "designer", "believer", "licenses", "nonsense", "follower", "dominion"}
    
    -- TODO: randomize these
    self.leftStrings = {"skjs", "beli", "qpcj", "port", "crea"}
    self.rightStrings = {"lots", "pors", "ooop", "ners", "eyzs"}
    
    self.targetWord = possibleTargetStrings[math.random(#possibleTargetStrings)] -- tables are 1 indexed, random is min and max inclusive, # is length operator
    table.insert(self.leftStrings, math.random(#self.leftStrings), string.sub(self.targetWord, 1, 4))
    table.insert(self.rightStrings, math.random(#self.rightStrings), string.sub(self.targetWord, 5, 8))

    self.curLeftStringIndex = math.random(#self.leftStrings)
    self.curRightStringIndex = math.random(#self.rightStrings)

    -- TODO: generalize this for three/four section words
    self.leftSelected = false

    self.crankPromptActive = false
end

function WordScramble:update()
    -- Crank Required Alert
    if (pd.isCrankDocked() and not self.crankPromptActive) then
        shouldShowCrankIndicator = true
        self.crankPromptActive = true
    elseif (not pd.isCrankDocked() and self.crankPromptActive) then
        shouldShowCrankIndicator = false
        self.crankPromptActive = false
    end

    -- Left/Right changes which part of the string is selected
    if (self.leftSelected and pd.buttonJustPressed(pd.kButtonRight)) then
        self.leftSelected = false
        selectSound:play()
    elseif (not self.leftSelected and pd.buttonJustPressed(pd.kButtonLeft)) then
        self.leftSelected = true
        selectSound:play()
    end

    --1 full revolution of crank to cycle through all words
    local activeStringArray = self.leftSelected and self.leftStrings or self.rightStrings --busted ternary op in lua
    local crankTicks = pd.getCrankTicks(#activeStringArray)

    if (crankTicks ~= 0) then
        clickSound:play()
        -- Loop through strings, math is weird because it's 1-indexed
        if (self.leftSelected) then
            self.curLeftStringIndex = ((self.curLeftStringIndex + crankTicks - 1) % #self.leftStrings) + 1
        else
            self.curRightStringIndex = ((self.curRightStringIndex + crankTicks - 1) % #self.rightStrings) + 1
        end
    end

    -- Press A to lock in a word
    if (pd.buttonJustPressed(pd.kButtonA)) then
        if (self.leftStrings[self.curLeftStringIndex] .. self.rightStrings[self.curRightStringIndex] == self.targetWord) then
            winSound:play()
            self:init()
        else
            loseSound:play()
            cameraShake:addTrauma(1.0)
        end
    end
end

function WordScramble:draw()
    -- set font to use for this text
    gfx.setFont(font)

    -- Background color is set to black to make camera shake look good, so draw a big white rect for the border
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    
    gfx.setColor(gfx.kColorBlack)
    -- Selected half is drawn with negative text on a filled rect
    if (self.leftSelected) then
        -- (topLeftCornerX, topLeftCornerY, width, height)
        gfx.fillRect(5, 5, 195, 230)
        drawTextScaled(self.leftStrings[self.curLeftStringIndex], 194, 120, 2, kTextAlignment.right, gfx.kDrawModeFillWhite)
        drawTextScaled(self.rightStrings[self.curRightStringIndex], 206, 120, 2, kTextAlignment.left, gfx.kDrawModeCopy)
    else
        gfx.fillRect(200, 5, 195, 230)
        drawTextScaled(self.leftStrings[self.curLeftStringIndex], 194, 120, 2, kTextAlignment.right, gfx.kDrawModeCopy)
        drawTextScaled(self.rightStrings[self.curRightStringIndex], 206, 120, 2, kTextAlignment.left, gfx.kDrawModeFillWhite)
    end
end

--------------------------------------------------------------------------------
-- Helpers

-- Draws to an image and scales the image to scale the text
-- Handles good round scaling factors best, 1.5, 2, 3, etc
-- Pivot x is relative to alignment, y is centered (but maybe a little off?)
-- Based on: https://devforum.play.date/t/add-a-drawtextscaled-api-see-code-example/7108 
function drawTextScaled(text, x, y, scale, alignment, drawMode)
    local f = gfx.getFont()
    if (f == nil) then
        print("No font set to draw text!")
        return
    end

    local w <const> = f:getTextWidth(text)
    local h <const> = f:getHeight()

    -- Create image and draw text to it, image is exactly the dimensions of the text
    local img <const> = gfx.image.new(w, h, gfx.kColorClear)
    gfx.lockFocus(img)
    gfx.setImageDrawMode(drawMode)
    gfx.drawTextAligned(text, w / 2, 0, kTextAlignment.center)
    gfx.unlockFocus()

    -- Draw image using given coords and alignment
    if (alignment == kTextAlignment.left) then
        img:drawScaled(x, y - (scale * h) / 2, scale)
    elseif (alignment == kTextAlignment.center) then
        img:drawScaled(x - (scale * w) / 2, y - (scale * h) / 2, scale)
    elseif (alignment == kTextAlignment.right) then
        img:drawScaled(x - (scale * w), y - (scale * h) / 2, scale)
    else
        print("Improper alignment provided!")
    end
end