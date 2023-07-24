-- PlacementService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )

-- Modules
local WeaponHelper = require( Knit.Helpers.WeaponHelper )

local DataService = Knit.GetService("DataService")
-- Roblox Services

-- Variables

-- Objects
local ObjectsFolder: Folder = Knit.Assets.General.Objects

---------------------------------------------------------------------


local PlacementService = Knit.CreateService {
    Name = "PlacementService";
    Client = {
        PlaceObject = RemoteSignal.new();
    };

    PlacedObjects = {}
}

function PlacementService:ClearPlacedObjects(): ()
    for _, object in pairs( self.PlacedObjects ) do
        object:Destroy()
    end
end

function PlacementService:KnitStart(): ()
    
    local function OnPlaceObject( player: Player, objectName: string, placeCFrame: CFrame ): ()
        local playerData: table = DataService:GetPlayerDataAsync(player).Data
        local object: Instance = ObjectsFolder:FindFirstChild(objectName)
        local weaponData = WeaponHelper.GetWeaponByName(objectName)

        -- Check if the player is allowed to place the object
        if( object and weaponData and playerData.Cash >= weaponData.Price) then

            -- Clone and place object
            local objectClone: Instance = object:Clone()
            objectClone:PivotTo(placeCFrame)
            objectClone.Parent = workspace
            -- Take cash from player
            DataService:IncrementPlayerData(player, "Cash", -weaponData.Price)
            table.insert(self.PlacedObjects, objectClone)
        end
    end

    self.Client.PlaceObject:Connect(OnPlaceObject)
end


function PlacementService:KnitInit(): ()
    
end


return PlacementService