-- Spinner
-- Author(s): Jesse Appleton
-- Date: 07/25/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants
local SPIN_SPEED: number = 250
local FLING_POWER: number = 200

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Janitor = require( Knit.Util.Janitor )
local Promise = require( Knit.Util.Promise )

-- Modules
local PathfindingHelper = require( Knit.Helpers.PathfindingHelper )

local EnemyService = Knit.GetService("EnemyService")
-- Roblox Services
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")

-- Variables

-- Objects

---------------------------------------------------------------------


local Spinner = {}
Spinner.__index = Spinner


function Spinner.new( instance: Model ): ( {} )
    local self = setmetatable( {}, Spinner )
    self._janitor = Janitor.new()


    local function Spin( deltaTime: number ): ()
        local rotation: number = math.rad(SPIN_SPEED * deltaTime)
        instance.Spin.CFrame = instance.Spin.CFrame * CFrame.Angles(0, rotation, 0)
    end

    local function GetOwner(): ()
        return game.Players:FindFirstChild("Owner")
    end

    local enemiesTouched: table = {}

    local function OnSpinTouched( hit ): ()
        local isAEnemy = CollectionService:HasTag(hit.Parent, "Enemy")
        local isEnemyTouched = table.find(enemiesTouched, hit.Parent)

        -- Check if hit is a enemy and hasn't already been hit
        if( not isEnemyTouched and isAEnemy ) then
            table.insert(enemiesTouched, hit.Parent)
            hit.Parent.Humanoid.PlatformStand = true
            -- Fling enemy
            hit.Parent.HumanoidRootPart.AssemblyLinearVelocity = instance.Spin.CFrame.LookVector + Vector3.new(0, 1, 0.5) * FLING_POWER
            -- Ragdoll enemy
            EnemyService:KillEnemy( GetOwner(), hit.Parent)
        end
    end

    PathfindingHelper.AddModifierToModel( instance, "Weapon" )
    instance.Spin.Touched:Connect(OnSpinTouched)
    self._janitor:Add( RunService.Heartbeat:Connect(Spin) )

    return self
end


function Spinner:Destroy(): ()
    self._janitor:Destroy()
end


return Spinner