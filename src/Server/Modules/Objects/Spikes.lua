-- Spikes
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
local PathfindingHelper = require( Knit.Helpers.PathfindingHelper )
local EnemyHelper = require( Knit.Helpers.EnemyHelper )

local CashService = Knit.GetService("CashService")
-- Roblox Services
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
-- Variables

-- Objects

---------------------------------------------------------------------


local Spikes = {}
Spikes.__index = Spikes


function Spikes.new( instance: Model ): ( {} )
    local self = setmetatable( {}, Spikes )
    self._janitor = Janitor.new()
    
    -- Private variables
    local spikeSize = instance.Spikes.Size 
    
    PathfindingHelper.AddModifierToModel(instance, "Weapon")

    local function Deploy(): ()
        for _, spike in pairs( instance:GetChildren() ) do
            if( spike.Name == "Spikes" ) then
                spike.Mesh.Scale = spikeSize
                spike.CanCollide = true
            end
        end
    end

    local function Disable(): ()
        for _, spike in pairs( instance:GetChildren() ) do
            if( spike.Name == "Spikes" ) then
                spike.Mesh.Scale = Vector3.new(0,0,0)
                spike.CanCollide = false
            end
        end
    end

    local function GetOwner(): ()
        return game.Players[ instance:GetAttribute("Owner") ]
    end

    local enemiesOnSpike: table = {}
    local function OnSpikesTouched( hit: BasePart ): ()
        local isOnSpike: number = table.find(enemiesOnSpike, hit.Parent)
        local isAEnemy: boolean = CollectionService:HasTag(hit.Parent, "Enemy") or CollectionService:HasTag(hit.Parent.Parent, "Enemy")
        
        -- Check if hit is a enemy and hasn't already been hit
        if( ( not isOnSpike ) and isAEnemy ) then
            table.insert(enemiesOnSpike, hit.Parent)
            --Delay spike deployment
            Deploy()

            -- Prevent redeployment
            CollectionService:RemoveTag(hit.Parent, "Enemy")
            EnemyHelper.RagDollEnemy(hit.Parent)
            --hit.Parent:BreakJoints()
            --Debris:AddItem(hit.Parent, 5)

            -- Give owner cash for kill

            if( not hit.Parent ) then
                return
            end
            local enemyData = EnemyHelper.GetEnemyByName(hit.Parent.Name)
            CashService:GiveCash(GetOwner(), enemyData.RewardPerKill)
            task.wait(5)
            Disable()
            table.remove(enemiesOnSpike, isOnSpike)
        end
    end

    Disable()

    instance.Trigger.Touched:Connect(OnSpikesTouched)

    return self
end


function Spikes:Destroy(): ()
    self._janitor:Destroy()
end


return Spikes