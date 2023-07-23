-- Barrier
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

-- Modules
local BarrierData = require( Knit.GameData.BarrierData )

-- Roblox Services
-- Variables

-- Objects
local BarrierUI: Folder = Knit.Assets.UI.BarrierUI
---------------------------------------------------------------------


local Barrier = {}
Barrier.__index = Barrier


function Barrier.new( barrier: Model ): ( {} )
    local self = setmetatable( {}, Barrier )
    self._janitor = Janitor.new()

    -- Private variables
    self._ui = BarrierUI:Clone()
    self._ui.Parent = barrier.PrimaryPart

    -- Public variables
    self.MaxHealth = BarrierData.Health
    self.Health = BarrierData.Health

    self:UpdateHealthBar()

    return self
end

function Barrier:UpdateHealthBar(): ()
    self._ui.Health.Percentage.Size = UDim2.new(self.Health/self.MaxHealth, 0, 1, 0)
end

function Barrier:TakeDamage( damageAmount: number ): ()
    self.Health = math.clamp( self.Health - damageAmount, 0, self.MaxHealth)
    self:UpdateHealthBar()
end

function Barrier:Destroy(): ()
    self._janitor:Destroy()
end


return Barrier