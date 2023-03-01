-- Imports
import "CoreLibs/ui"
import "CoreLibs/timer"
import "WordScramble" -- Demo MiniGame
import "CameraShake"
import "StatsReadout"

-- Aliases for common playdate SDK features
local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Globals (and globals-to-this-file)
DRAW_DEBUG = true -- Set to true to draw debug elements

deltaTime = 0.0 -- Time since last frame; see here for why this is neccesary: https://devforum.play.date/t/difference-in-gameplay-on-actual-device-same-fps/8576/3

shouldShowCrankIndicator = false -- update this in other scripts to show indicator
local showingCrankIndicator = false

cameraShake = CameraShake() -- for camera shake fx
statsReadout = StatsReadout() -- for fancy little fake OS-like diagnostic stats 

local wordScramble = WordScramble()

--------------------------------------------------------------------------------

-- Initializes game and sets some parameters
local function LoadGame()
	playdate.display.setRefreshRate(50) -- sets framerate to 50 fps
	math.randomseed(pd.getSecondsSinceEpoch()) -- sets seed for math.random so that it's actually random
	defaultFont = gfx.font.new("Fonts/Roobert-24-Medium-Halved")
	gfx.setFont(defaultFont) -- sets defualt font to use if one isn't specified later
	gfx.setBackgroundColor(gfx.kColorBlack) -- default "clear flag" color
	cameraShake:init()
	statsReadout:init()
end

-- Handles game logic, called once per frame
local function UpdateGame()
	wordScramble:update() -- update state of demo minigame
	cameraShake:update() -- sets display offset to create shake effect
	statsReadout:update()
end

-- Handles all drawing, called once per frame
local function DrawGame()
	gfx.clear() -- clears the screen
	wordScramble:draw() -- draw demo minigame
	statsReadout:draw()
end

local function DrawDebug()
	-- FPS included in stats readout
	--pd.drawFPS(0, 0)
end

--------------------------------------------------------------------------------

LoadGame()

function pd.update()
	deltaTime = pd.getElapsedTime()
	pd.resetElapsedTime()

	pd.timer.updateTimers()
	
	UpdateGame()
	DrawGame()

	if (DRAW_DEBUG) then
		DrawDebug()
	end

	-- Crank indicator calls have to be done here, not in other classes; see: https://devforum.play.date/t/can-crankindicator-update-be-called-in-a-class/6301/8
	if (shouldShowCrankIndicator) then
		if (showingCrankIndicator) then
			pd.ui.crankIndicator:update(-1 * cameraShake.offset_x)
		else
			pd.ui.crankIndicator:start()
			showingCrankIndicator = true
		end
	else
		showingCrankIndicator = false
	end
end