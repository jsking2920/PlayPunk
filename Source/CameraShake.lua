-- Based on: https://www.youtube.com/watch?v=tu-Qe66AvtY

import "CoreLibs/graphics"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("CameraShake").extends()

-- use gfx.setBackgroundColor(gfx.kColorBlack) to set color of "exposed" pixels during shake
function CameraShake:init()
    self.decay = 1.0  -- trauma decay per second [0, 1]
    self.max_offset_x = 18  -- maximum horizontal shake in pixels
    self.max_offset_y = 14 -- maximum vertical shake in pixels

    self.shakeSpeed = 4.5 -- speed of shake effect
    self.noisePeriod = 10.0 -- used to set repeat value of repeat for noise; shake will take this many seconds to loop if speed is 1.0

    self.trauma = 0.0  --current shake strength. Clamped to [0.0, 1.0]
    self.trauma_power = 2  --trauma exponent. Use [2, 3]

    self.offset_x = 0.0 -- current x offset
    self.offset_y = 0.0 -- current y offset
end

function CameraShake:update()
    if (self.trauma > 0.0) then
        self:shake()
        self.trauma = math.max(self.trauma - (self.decay * deltaTime), 0.0) -- deltaTime defined and updated in main.lua
    elseif (self.offset_x ~= 0 or self.offset_y ~= 0) then
        -- reset once trauma has completely decayed
        self.trauma = 0.0
        self.offset_x = 0.0
        self.offset_y = 0.0
        pd.display.setOffset(0, 0)
    end
end

function CameraShake:shake()
    local seconds = pd.getCurrentTimeMilliseconds() / 1000.0
    -- technically this noise is on range [-2, 2] but this perlin noise seems heavily skewed towards low/mid values so it never breaks [-1, 1]
    local x_noise = (4.0 * gfx.perlin((seconds * self.shakeSpeed), 0, 0, self.noisePeriod, 2, 1.0)) - 2.0
    local y_noise = (4.0 * gfx.perlin((seconds * self.shakeSpeed + (self.noisePeriod / 2.0)), (self.noisePeriod / 2.0), (self.noisePeriod / 2), self.noisePeriod, 2, 1.0)) - 2.0
    self.offset_x = self.max_offset_x * self.trauma * x_noise
    self.offset_y = self.max_offset_y * self.trauma * y_noise

    pd.display.setOffset(self.offset_x, self.offset_y)
end

function CameraShake:addTrauma(amount)
    self.trauma = math.max(0.0, math.min(1.0, self.trauma + amount))
end