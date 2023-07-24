-- WeaponList
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
local WeaponData = require( Knit.GameData.WeaponData )

local ItemEntry = require( Knit.Modules.UI.ItemEntry )

local PlacementController = Knit.GetController("PlacementController")
local DataController = Knit.GetController("DataController")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local WeaponList = {}
WeaponList.__index = WeaponList


function WeaponList.new( holder: ScrollingFrame ): ( {} )
    local self = setmetatable( {}, WeaponList )
    self._janitor = Janitor.new()

    -- Public variables
    self.Entries = {}

    -- Private functions
    local function _findOrCreateEntryByName( name: string ): table
        if( self.Entries[ name ] ) then 
            return self.Entries[ name ]
        end

        local entry = ItemEntry.new()
        self.Entries[ name ] = entry
        return entry
    end

    -- Sort weapon data by price
    table.sort(WeaponData.Weapons, function(a, b)
        return a.Price < b.Price
    end)

    for index, weapon in pairs( WeaponData.Weapons ) do
        local entry = _findOrCreateEntryByName(weapon.Name)
        entry:SetName(weapon.Name)
        entry:SetPrice(weapon.Price)
        entry:SetLayoutOrder(index)
        entry:SetParent(holder)
        local function OnEntryClicked(): ()

            -- Check if player has enough cash
            if( DataController:GetDataByName("Cash") >= weapon.Price ) then
                PlacementController:SetPlaceableObject(weapon.Name)
            end
        end

        entry._button.MouseButton1Click:Connect(OnEntryClicked)
    end

    return self
end


function WeaponList:Destroy(): ()
    self._janitor:Destroy()
end


return WeaponList