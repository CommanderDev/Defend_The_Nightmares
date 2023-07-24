-- BaseHealth
-- Author(s): Jesse Appleton
-- Date: 07/24/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local DefenseHelper = require( Knit.Helpers.DefenseHelper )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects

---------------------------------------------------------------------


local BaseHealth = {}
BaseHealth.__index = BaseHealth


function BaseHealth.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, BaseHealth )
    self._janitor = Janitor.new()

    local base = DefenseHelper.GetBaseDefense()

    local function OnHealthChanged(): ()
        local health: number = base:GetAttribute("Health")
        local maxHealth: number = base:GetAttribute("MaxHealth")
        holder.Percentage.Size = UDim2.new(health/maxHealth, 0, 1, 0)
        holder.BaseHealthLabel.Text = health.." / "..maxHealth
    end

    OnHealthChanged()
    base:GetAttributeChangedSignal("Health"):Connect(OnHealthChanged)

    return self
end


function BaseHealth:Destroy(): ()
    self._janitor:Destroy()
end


return BaseHealth