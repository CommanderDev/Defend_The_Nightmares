-- Enemy
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
local EnemyHelper = require( Knit.Helpers.EnemyHelper )
local PathfindingHelper = require( Knit.Helpers.PathfindingHelper )

-- Roblox Services
local PathfindingService = game:GetService("PathfindingService")
-- Variables

-- Objects
local EnemiesFolder: Folder = Knit.Assets.General.Enemies
local Animations: Folder = Knit.Assets.General.Animations

---------------------------------------------------------------------


local Enemy = {}
Enemy.__index = Enemy


function Enemy.new( instance: BasePart ): ( {} )
    local self = setmetatable( {}, Enemy )
    self._janitor = Janitor.new()

    local enemyData = EnemyHelper.GetEnemyByName(instance.Name)
    -- Private variables

    self._instance = instance
    self._humanoid = self._instance:WaitForChild("Humanoid")
    self._animator = self._humanoid:WaitForChild("Animator")


    -- Initialize path
    self._path = PathfindingService:CreatePath({
        AgentRadius = 0.05;
        AgentHeight = 5;
        WaypointSpacing = 3;
        Costs = {
            Enemy = 80;
            Weapon = 60;
            Path = 0.05
        }
    })

    -- Preload animations
    self._walkAnimation = self._animator:LoadAnimation( Animations.Walk )

    -- Public variables
    self.MaxHealth = enemyData.Health
    self.Health = enemyData.Health
    self.Damage = enemyData.Damage

    -- Initialize signals
    self.MoveToReached = Signal.new()
    self.Ragdolled = Signal.new()
    PathfindingHelper.AddModifierToModel(instance, "Enemy")

    local function OnRagdolledChanged(): ()
        if( instance:GetAttribute("Ragdolled") ) then
            self:MoveTo(instance.HumanoidRootPart)
            self.Ragdolled:Fire()
        end
    end
    instance:SetAttribute("Ragdolled", false)
    instance:GetAttributeChangedSignal("Ragdolled"):Connect(OnRagdolledChanged)
    self._janitor:Add( self._path )

    return self
end

function Enemy:MoveTo( destination: Vector3 ): ()

    local success, errorMessage = pcall(function()
        self._path:ComputeAsync( self._instance.HumanoidRootPart.Position, destination)
    end)

    if( success and self._path.Status == Enum.PathStatus.Success ) then
        
        self._walkAnimation:Play()
        self._waypoints = self._path:GetWaypoints()
        -- Detect if path becomes blocked
        local function OnPathBlocked( blockedWaypointIndex: number ): ()
            if ( blockedWaypointIndex >= self._nextWaypointIndex ) then
                -- Stop detecting path blockage until path is re-computed
                self.blockedConnection:Disconnect()
                -- Call function to re-compute new path
                self:MoveTo(destination)
            end
        end

        local function OnMoveToFinished( reached: boolean ): ()
            if( self._instance:GetAttribute("Ragdolled") ) then
                return
            end

            if( not reached ) then 
                return
            end

            -- Check if the destination isn't yet reached
            if( self._nextWaypointIndex < #self._waypoints ) then
                self._nextWaypointIndex += 1
                self._instance.Humanoid:MoveTo( self._waypoints[self._nextWaypointIndex].Position )
            else
                -- Destination reached, clean up connections
                self.blockedConnection:Disconnect()
                self.reachedConnection:Disconnect()
                self._walkAnimation:Stop()
                self.MoveToReached:Fire()
            end
        end

        self.blockedConnection = self._path.Blocked:Connect(OnPathBlocked)
        self.reachedConnection = self._instance.Humanoid.MoveToFinished:Connect(OnMoveToFinished)

        self._nextWaypointIndex = 2
        self._humanoid:MoveTo( self._waypoints[self._nextWaypointIndex].Position )
    end
end 

function Enemy:Destroy(): ()
    self._janitor:Destroy()
end


return Enemy