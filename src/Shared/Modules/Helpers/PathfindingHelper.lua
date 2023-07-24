local Knit = require( game.ReplicatedStorage.Knit )
local t = require( Knit.Util.t )

local PathfindingHelper = {} 

local tAddModifierToModel = t.tuple(t.instanceIsA("Model"), t.string)

function PathfindingHelper.AddModifierToModel( instance: Model, label: string ): ()
    assert( tAddModifierToModel(instance, label) )

    for _, object: Instance in pairs( instance:GetDescendants() ) do 
        if( object:IsA("BasePart") and not object:FindFirstChild("PathfindingModifier") ) then
            local pathfindingModifier: PathfindingModifier = Instance.new("PathfindingModifier")
            pathfindingModifier.Label = "Weapon"
            pathfindingModifier.Parent = object
        end
    end
end

return PathfindingHelper