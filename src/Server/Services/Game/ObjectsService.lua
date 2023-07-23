-- ObjectsService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )

-- Modules
local ObjectClasses: Folder = Knit.Modules.Objects

-- Roblox Services
local CollectionService = game:GetService("CollectionService")
-- Variables

-- Objects

---------------------------------------------------------------------


local ObjectsService = Knit.CreateService {
    Name = "ObjectsService";
    Client = {
        
    };
    Objects = {};
}

-- Public functions
function ObjectsService:GetObjectByInstanceAsync( instance: Instance ): table
    local object: Instance | nil
    repeat
        object = self.Objects[ instance ]
        task.wait()
    until object

    return object
end

function ObjectsService:KnitStart(): ()
    -- Iterate available object classes
    for _, objectClass in pairs( ObjectClasses:GetChildren() ) do

        local function OnInstanceAdded( instance: Instance ): ()
            self.Objects[ instance ] = require(objectClass).new(instance)
        end

        local function OnInstanceRemoved( instance: Instance ): ()
            self.Objects[ instance ]:Destroy()
            self.Objects[ instance ] = nil
        end

        for _, instance: Instance in pairs( CollectionService:GetTagged(objectClass.Name) ) do
            OnInstanceAdded(instance)
        end

        CollectionService:GetInstanceAddedSignal(objectClass.Name):Connect(OnInstanceAdded)
        CollectionService:GetInstanceRemovedSignal(objectClass.Name):Connect(OnInstanceRemoved)
    end
end


function ObjectsService:KnitInit(): ()
    
end


return ObjectsService