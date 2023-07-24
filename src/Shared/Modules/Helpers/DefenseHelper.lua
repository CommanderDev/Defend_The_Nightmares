-- Roblox services
local CollectionService = game:GetService("CollectionService")

local DefenseHelper = {}

function DefenseHelper.GetBaseDefense(): Model
    for _, defense in pairs( CollectionService:GetTagged("Defense") ) do 
        if defense:GetAttribute("IsBase") then
            return defense
        end
    end
end

return DefenseHelper