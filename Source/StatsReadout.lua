-- Draws a bunch of flavorful computer-y stuff to make the game look like it's a little hacking rig
import "CoreLibs/graphics"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("StatsReadout").extends()

function StatsReadout:init()
    self.ipString = "192.168.0.0" -- ranges from this to 192.168.255.255; changes periodically to obscure rigs location/identity
    self.ipTimer = 10.0
    self.ipTimeToUpdate = 10.0
    self:randomizeIP()

    self.timeString = "2117.03.17 14:00:00" -- TODO: decide on date for this to start at
    self.fps = 50 -- pd.getFPS()
    self.temp = 65.2 --in °C; ranges from 0°C up to 80°C; should increase from startup, and peak during high intensity gameplay; should average around 60°C

    self.networkUp = 2.2 -- Gb/s; ranges from 1.1 Gb/s to 2.6 Gb/s
    self.networkDown = 213.7 -- Gb/s; ranges from 107 Gb/s to 246 Gb/s

    self.cpuUsage = 0.9 -- Ranges from 15% to 100%; should scale based on gameplay intensity
    self.memoryUsage = 0.3 -- Ranges from 10% to 65%

    -------
    self.font = gfx.font.new("Fonts/font-full-circle-halved")
    self.fontHeight = self.font:getHeight()

    self.yMargin = 7
    self.xMargin = 7

    self.verticalSpacing = 2
end

function StatsReadout:update()
    self.fps = pd.getFPS()
    self.timeString = getTimeString()

    self.ipTimer -= deltaTime -- defined in main
    if (self.ipTimer <= 0.0) then
        -- TODO: animate/juice this a bit
        self:randomizeIP()
        self.ipTimer = math.random(self.ipTimeToUpdate * 0.5, self.ipTimeToUpdate * 1.5)
    end
end

function StatsReadout:draw()
    gfx.setFont(self.font)

    local previousDrawMode = gfx.getImageDrawMode() -- shouldn't be neccesary; just set draw mode before you draw anything anywhere
    gfx.setImageDrawMode(gfx.kDrawModeNXOR) -- Makes halved fonts work on black or white backgrounds, nice

    -- Vertical layout group, anchored to bottom left, left aligned
    -- TODO: todo make a generic function for drawing things like this, put everything in a table
    gfx.drawTextAligned(self.ipString, self.xMargin, 240 - self.fontHeight - self.yMargin, kTextAlignment.left)
    gfx.drawTextAligned("FPS: " .. self.fps, self.xMargin, 240 - (self.fontHeight * 2) - self.yMargin - self.verticalSpacing, kTextAlignment.left)

    gfx.drawTextAligned(self.timeString, self.xMargin, self.yMargin, kTextAlignment.left)

    gfx.setImageDrawMode(previousDrawMode)
end

--------------------------------------------------------------------------------

function StatsReadout:randomizeIP()
    local thirdNumber = math.random(0, 255)
    local fourthNumber = math.random(0, 255)
    self.ipString = "192.168." .. thirdNumber .. "." .. fourthNumber
end

function getTimeString()
    local time = pd.getTime()
    return "2117-" .. time["month"] .. "-" .. time["day"] .. " " .. time["hour"] .. ":" .. time["minute"] .. ":" .. time["second"]
end