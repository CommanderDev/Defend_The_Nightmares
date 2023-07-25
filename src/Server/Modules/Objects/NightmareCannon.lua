-- NightmareCannon
-- Author(s): Jesse Appleton
-- Date: 07/25/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local CANNON_COOLDOWN: number = 3
local FLING_POWER: number = 150
-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local EnemyHelper = require( Knit.Helpers.EnemyHelper )
local PathfindingHelper = require( Knit.Helpers.PathfindingHelper )

local EnemyService = Knit.GetService("EnemyService")
-- Roblox Services
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")

-- Variables

-- Objects
local Nightmare: Model = Knit.Assets.General.Enemies.Nightmare

---------------------------------------------------------------------


local NightmareCannon = {}
NightmareCannon.__index = NightmareCannon


function NightmareCannon.new( instance: Instance ): ( {} )
    local self = setmetatable( {}, NightmareCannon )
    self._janitor = Janitor.new()

    local lastTick: number = os.clock()

    local function GetOwner(): ()
        return game.Players[ instance:GetAttribute("Owner") ]
    end

    local function ShootNightmare(): ()
        local nightmareClone = Nightmare:Clone()
        nightmareClone:PivotTo(instance.HumanoidPositionPart.CFrame)
        nightmareClone.Parent = workspace
        nightmareClone.HumanoidRootPart.AssemblyLinearVelocity = instance.HumanoidPositionPart.CFrame.LookVector * 250
        EnemyHelper.RagDollEnemy(nightmareClone)
        Debris:AddItem(nightmareClone, 5)

        local enemiesHit = {}

        -- Add touched event to nightmare clone to take out enemies
        for _, object: Instance in pairs( nightmareClone:GetChildren() ) do

            local function OnObjectTouched( hit: BasePart ): ()
                local isAEnemy: boolean = CollectionService:HasTag(hit.Parent, "Enemy")
                local isHit = table.find(enemiesHit, hit.Parent)
                if( not isHit and isAEnemy and not hit.Parent:GetAttribute("Ragdolled") ) then
                    hit.Parent.HumanoidRootPart.AssemblyLinearVelocity = object.CFrame.LookVector + Vector3.new(0, 1, 0.5) * FLING_POWER
                    EnemyService:KillEnemy( GetOwner(), hit.Parent)
                    table.insert(enemiesHit, hit.Parent)
                end
            end

            if( object:IsA("BasePart") ) then
                object.Touched:Connect(OnObjectTouched)
            end
        end
    end

    local function Run(): ()
        local currentTick = os.clock()
        if( currentTick >= lastTick + CANNON_COOLDOWN ) then
            -- Fire nightmare
            ShootNightmare()
            -- Reset cooldown
            lastTick = currentTick
        end
    end

    PathfindingHelper.AddModifierToModel(instance, "Weapon")
    self._janitor:Add( RunService.Heartbeat:Connect(Run) )

    return self
end


function NightmareCannon:Destroy(): ()
    self._janitor:Destroy()
end


return NightmareCannon