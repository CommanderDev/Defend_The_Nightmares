-- Defense
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

-- Roblox Services

-- Variables

-- Objects
local BarrierUI: Folder = Knit.Assets.UI.BarrierUI

---------------------------------------------------------------------


local Defense = {}
Defense.__index = Defense


function Defense.new( defenseModel: Model ): ( {} )
    local self = setmetatable( {}, Defense )
    self._janitor = Janitor.new()

    -- Private variables
    self._ui = BarrierUI:Clone()
    self._ui.Parent = defenseModel.PrimaryPart

    self._instance = defenseModel

    -- Public variables
    self.MaxHealth = defenseModel:GetAttribute("Health")
    self.Health = self.MaxHealth

    self:UpdateHealthBar()

    return self
end

function Defense:Build(): ()
    self.Health = self.MaxHealth
    self._ui.Enabled = true
    self._instance.Barrier.Transparency = 0
    self._instance.Barrier.CanCollide = true
    self.IsBroken = false
end

function Defense:Break(): ()
    self._ui.Enabled = false
    self._instance.Barrier.Transparency = 1
    self._instance.Barrier.CanCollide = false
    self.IsBroken = true
end

function Defense:UpdateHealthBar(): ()
    self._ui.Health.Percentage.Size = UDim2.new(self.Health/self.MaxHealth, 0, 1, 0)
end

function Defense:TakeDamage( damageAmount: number ): ()
    self.Health = math.clamp( self.Health - damageAmount, 0, self.MaxHealth)
    self:UpdateHealthBar()
end

function Defense:Destroy(): ()
    self._janitor:Destroy()
end


return Defense