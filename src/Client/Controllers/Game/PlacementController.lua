-- PlacementController
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local PlaceableObject = require( Knit.Modules.PlaceableObject )

local PlacementService = Knit.GetService("PlacementService")
-- Roblox Services
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
-- Variables

-- Objects
local ObjectsFolder: Folder = Knit.Assets.General.Objects

---------------------------------------------------------------------

local PlacementController = Knit.CreateController { 
    Name = "PlacementController";
    Object = nil;
}

function PlacementController:SetPlaceableObject( objectName: string ): ()

    local object = ObjectsFolder[ objectName ]

    if( self.Object ) then
        self:RemovePlaceableObject()
    end

    local function HandleObjectPlacement(): ()
        if( not self.Object ) then
            return
        end

        -- Update object position
        self.Object:Update()
    end

    local function PlaceObject( actionName: string, inputState ): ()
        if( inputState == Enum.UserInputState.Begin ) then
            self:PlaceObject()
        end
    end

    self.Object = PlaceableObject.new(object)

    RunService:BindToRenderStep("HandleObjectPlacement", Enum.RenderPriority.Last.Value, HandleObjectPlacement)
    ContextActionService:BindAction("PlaceObject", PlaceObject, false, Enum.UserInputType.MouseButton1)
end

function PlacementController:RemovePlaceableObject(): ()
    if( self.Object ) then
        ContextActionService:UnbindAction("PlaceObject")
        RunService:UnbindFromRenderStep("HandleObjectPlacement")
        self.Object:Destroy()
        self.Object = nil
    end
end

function PlacementController:PlaceObject(): ()
    local instanceName: string = self.Object._instance.Name
    local instanceCFrame: CFrame = self.Object.CFrame

    self:RemovePlaceableObject()
    PlacementService.PlaceObject:Fire(instanceName, instanceCFrame)
end

function PlacementController:KnitStart(): ()
end


function PlacementController:KnitInit(): ()
    
end


return PlacementController