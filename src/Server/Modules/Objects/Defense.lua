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
local CoreLoopService = Knit.GetService("CoreLoopService")
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

    -- Set MaxHealth to the default health
    self.Health = defenseModel:GetAttribute("Health")
    self.MaxHealth = self.Health
    defenseModel:SetAttribute( "MaxHealth", self.Health )

    local function OnHealthChanged(): ()
        self.Health = defenseModel:GetAttribute("Health") 
    end

    local function OnStateChanged( stateName ): ()
        if( stateName == "Intermission" ) then
            self:Build()
        end
    end

    CoreLoopService.StateChanged:Connect(OnStateChanged)
    defenseModel:GetAttributeChangedSignal("Health"):Connect(OnHealthChanged)


    -- Initialize Health bar
    self:UpdateHealthBar()

    return self
end

function Defense:Build(): ()
    self._instance:SetAttribute("Health", self.MaxHealth)
    self._ui.Enabled = true
    self._instance.PrimaryPart.Transparency = 0
    self._instance.PrimaryPart.CanCollide = true
    self:UpdateHealthBar()
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
    self._instance:SetAttribute( "Health", math.clamp( self.Health - damageAmount, 0, self.MaxHealth) )
    self:UpdateHealthBar()

    -- Make sure the defense isn't the base
    if( self.Health == 0 and not self._instance:GetAttribute("IsBase")) then
        self:Break()
    end
end

function Defense:Destroy(): ()
    self._janitor:Destroy()
end


return Defense