-- Round
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )
local Signal = require( Knit.Util.Signal )

-- Modules
local CoreLoopService = Knit.GetService("CoreLoopService")

local DefenseHelper = require( Knit.Helpers.DefenseHelper )
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local Round = {}
Round.__index = Round


function Round.new( ): ( {} )
    local self = setmetatable( {}, Round )
    self._janitor = Janitor.new()

    local base = DefenseHelper.GetBaseDefense()

    -- Public variables
    self.Winner = nil

    -- Initalize signals
    self.RoundEnded = Signal.new()

    -- Private functions
    local function OnBaseHealthChanged(): ()
        if( base:GetAttribute("Health") == 0 ) then
            self.Winner = "Enemies"
            self.RoundEnded:Fire()
        end
    end

    base:GetAttributeChangedSignal("Health"):Connect(OnBaseHealthChanged)

    self._janitor:Add( self.RoundEnded, "Destroy")

    return self
end


function Round:Destroy(): ()
    self._janitor:Destroy()
end


return Round