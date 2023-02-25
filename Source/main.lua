-- Imports
import "WordScramble" -- Demo MiniGame

-- Aliases for common playdate SDK features
local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Resource loading; TODO: move this into loading coroutine to avoid performance hit on startup
local font = gfx.font.new('Fonts/Roobert-24-Medium-Halved')

-- Main global variables
local DRAW_DEBUG <const> = true -- Set to true to draw debug elements

local wordScramble = WordScramble()

--------------------------------------------------------------------------------

-- Initializes game and sets some parameters
local function LoadGame()
	playdate.display.setRefreshRate(50) -- sets framerate to 50 fps
	math.randomseed(pd.getSecondsSinceEpoch()) -- sets seed for math.random so that it's actually random
	gfx.setFont(font) -- sets font to actually use
end

-- Handles game logic, called once per frame
local function UpdateGame()
	wordScramble:update() -- update state of demo minigame 
end

-- Handles all drawing, called once per frame
local function DrawGame()
	gfx.clear() -- clears the screen
	wordScramble:draw() -- draw demo minigame
end

local function DrawDebug()
	pd.drawFPS(0, 0)
end

--------------------------------------------------------------------------------

LoadGame()

function pd.update()
	UpdateGame()
	DrawGame()
	if (DRAW_DEBUG) then
		DrawDebug()
	end
end