-- EnemyHelper
-- Author(s): Jesse Appleton
-- Date: 7/22/2023

--[[

    SHARED
        FUNCTION    EnemyHelper.GetEnemyByName( enemyName: string ) -> ( {} )  
        FUNCTION    EnemyHelper.GetRandomEnemySpawn() -> BasePart   
]]

-- Knit
local Knit = require( game.ReplicatedStorage.Knit )
local t = require( Knit.Util.t )

-- Modules
local EnemyData = require( Knit.GameData.EnemyData )

-- Roblox Services
local CollectionService = game:GetService("CollectionService")

local EnemyHelper = {}

function EnemyHelper.RagDollEnemy(character): ()
    local baseAttachments = {}
	local constraints = {}
	for _, limb in pairs(character:GetChildren()) do
		if limb:IsA("BasePart") then
			local Motor6D = limb:FindFirstChildOfClass("Motor6D")
			if Motor6D then
				constraints[limb.Name] = {
					["Attachment0"] = {["Name"] = Motor6D.Name.."RigAttachment",["Parent"] = Motor6D.Part0.Name},
					["Attachment1"] = {["Name"] = Motor6D.Name.."RigAttachment",["Parent"] = Motor6D.Part1.Name}
				}
			end
		end
	end
	for _, constraint: table in pairs(constraints) do
		local Part0
		local Part1
		for _, characterObject: BasePart in pairs(character:GetChildren()) do
			if characterObject.Name == constraint.Attachment0.Parent then
				local Part = characterObject
				for _, partObject in pairs(Part:GetChildren()) do
					if partObject.Name == constraint.Attachment0.Name then
						Part0 = partObject
					end
				end
			elseif characterObject.Name == constraint.Attachment1.Parent then
				local Part = characterObject
				for _, partObject in pairs(Part:GetChildren()) do
					if partObject.Name == constraint.Attachment1.Name then
						Part1 = partObject
					end
				end
			end
		end
		local Constraint = Instance.new('BallSocketConstraint', character)
		Constraint.Name = "RagdollConstraint"
		Constraint.Color = BrickColor.new('New Yeller')
		Constraint.Attachment0 = Part0
		Constraint.Attachment1 = Part1
		Constraint.Enabled = true
		Constraint.LimitsEnabled = true
		Constraint.Radius = 0.15
		Constraint.Restitution = 0
		Constraint.TwistLimitsEnabled = false
		Constraint.Visible = false
	end

    character:SetAttribute("Ragdolled", true)
	character:BreakJoints()
end

local tGetEnemyByName = t.tuple( t.string )
function EnemyHelper.GetEnemyByName( enemyName: string ): table | nil  
    assert( tGetEnemyByName(enemyName) )
    
    for _, data in pairs( EnemyData.Enemies ) do 
        if( data.Name == enemyName ) then
            return data
        end
    end
end

function EnemyHelper.GetRandomEnemySpawn(): ()
    local enemySpawns: { BasePart } = CollectionService:GetTagged("EnemySpawn")
    
    return enemySpawns[ math.random(1, #enemySpawns) ]
end

return EnemyHelper
