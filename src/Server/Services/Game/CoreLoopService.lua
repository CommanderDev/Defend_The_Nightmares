-- CoreLoopService
-- Author(s): Jesse Appleton
-- Date: 07/23/2023

--[[
    
]]

---------------------------------------------------------------------

-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local RemoteSignal = require( Knit.Util.Remote.RemoteSignal )

-- Modules
local Enums = require( Knit.SharedModules.Enums )

local StatesFolder: Folder = Knit.Modules.States

-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------


local CoreLoopService = Knit.CreateService {
    Name = "CoreLoopService";
    Client = {
    };
}


function CoreLoopService:KnitStart(): ()
    self:SetState(Enums.State.InProgress)
end

function CoreLoopService:SetState( stateName: string ): ()

    if( self.State ) then
        self.State:Destroy()
    end

    self.State = require( StatesFolder[stateName] ).new()
end

function CoreLoopService:KnitInit(): ()
    
end


return CoreLoopService