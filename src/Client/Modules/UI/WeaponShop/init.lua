-- WeaponShop
-- Author(s): YOURNAME
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
local UIController = Knit.GetController("UIController")

local WeaponList = require( script.WeaponList )

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local WeaponShop = {}
WeaponShop.__index = WeaponShop


function WeaponShop.new( holder: Frame ): ( {} )
    local self = setmetatable( {}, WeaponShop )
    self._janitor = Janitor.new()

    WeaponList.new( holder.WeaponList )
    local function OnMenuChanged( menuName: string ): ()
        holder.Visible = if menuName == "WeaponShop" then true else false
    end

    UIController.MenuChanged:Connect(OnMenuChanged)

    self._janitor:Add(function()
        UIController:SetMenu()
    end)
    
    return self
end


function WeaponShop:Destroy(): ()
    self._janitor:Destroy()
end


return WeaponShop