-- PlaceableObject
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
local GridData = require( Knit.GameData.GridData )

-- Roblox Services
local UserInputService = game:GetService("UserInputService")
-- Variables

-- Objects
local LocalPlayer: Player = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local camera: Camera = workspace.CurrentCamera

---------------------------------------------------------------------


local PlaceableObject = {}
PlaceableObject.__index = PlaceableObject


-- Private functions

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = {}
raycastParams.IgnoreWater = true

local function _getMousePoint( x: number, y: number ): ()
    local cameraRay = camera:ScreenPointToRay(x, y)

    local raycastResult = workspace:Raycast(cameraRay.Origin, cameraRay.Direction * 2048, raycastParams)

    if( not raycastResult ) then
        return
    end

    return raycastResult.Instance, raycastResult.Position
end

function PlaceableObject.new( instance: Instance ): ( {} )
    local self = setmetatable( {}, PlaceableObject )
    self._janitor = Janitor.new()

    -- Private variables
    self._instance = instance:Clone()
    self._halfBaseSize = workspace.Map.Base.Size * 0.5

    -- Check if the primary part exists, then base the size off that, otherwise base it off the model size
    self._halfInstanceSize = if self._instance.PrimaryPart then self._instance.PrimaryPart.Size * 0.5 else self._instance:GetExtentsSize() * 0.5

    self._instance.Parent = workspace

    self._rotation = 180

    self:SetCancollide(false)
    self:UpdateColor()

    self._janitor:Add(self._instance)
    
    return self
end

function PlaceableObject:SetCancollide( canCollide: boolean ): ()
    for _, object: Instance in pairs( self._instance:GetDescendants() ) do 
        if( object:IsA("BasePart") ) then
            object.CanCollide = canCollide
        end
    end
end

function PlaceableObject:UpdateColor(): ()
    for _, object: Instance in pairs( self._instance:GetDescendants() ) do
        if( object:IsA("BasePart") ) then
            object.BrickColor = BrickColor.Green()
            object.Transparency = 0.5
        end
    end
end

function PlaceableObject:Update(): ()
    local MouseRay = Ray.new(Mouse.UnitRay.Origin, Mouse.UnitRay.Direction * 150)
    local whitelist = {workspace.Map.Base}
    local hit, position, normal = workspace:FindPartOnRayWithWhitelist(MouseRay, whitelist)
    local positionWithNormalFactoredIn: Vector3 = position + normal * self._halfInstanceSize

    local rotation = CFrame.Angles(0, 0, 0)
		
    if hit then 
        rotation = hit.CFrame.Rotation
    end

    local LocalSpace: Vector3 = workspace.Map.Base.CFrame:PointToObjectSpace( (CFrame.new(positionWithNormalFactoredIn) * rotation.Position) )
    
    -- Make sure instance doesn't leave the bounds of placement
    local ClampX = math.clamp(LocalSpace.X, -self._halfBaseSize.X + self._halfInstanceSize.X, self._halfBaseSize.X - self._halfInstanceSize.X)
    local ClampY = math.max(LocalSpace.Y, 0)
    local ClampZ = math.clamp(LocalSpace.Z, -self._halfBaseSize.Z + self._halfInstanceSize.Z, self._halfBaseSize.Z - self._halfInstanceSize.Z)
   
    LocalSpace = Vector3.new(
        ClampX, 
        ClampY, 
        ClampZ
    )
    LocalSpace = Vector3.new(
        math.round(LocalSpace.X), 
        self._halfInstanceSize.Y + (workspace.Map.Base.Size.Y/2),			
        math.round(LocalSpace.Z)
    )
    local WorldSpace = ( CFrame.new(workspace.Map.Base.CFrame:PointToWorldSpace(LocalSpace)) * rotation ) * CFrame.Angles(0, math.rad(self._rotation), 0) 
    self._instance:PivotTo(WorldSpace)
    self.CFrame = WorldSpace
end

function PlaceableObject:Destroy(): ()
    self._janitor:Destroy()
end


return PlaceableObject