-- CoreLoopController
-- Author(s): Jesse Appleton
-- Date: 07/24/2023

--[[
    
]]

---------------------------------------------------------------------


-- Constants

-- Knit
local Knit = require( game:GetService("ReplicatedStorage"):WaitForChild("Knit") )
local Signal = require( Knit.Util.Signal )

-- Modules
local CoreLoopService = Knit.GetService("CoreLoopService")
-- Roblox Services

-- Variables

-- Objects

---------------------------------------------------------------------

local CoreLoopController = Knit.CreateController { 
    Name = "CoreLoopController";
    StateChanged = Signal.new()
 }

function CoreLoopController:GetState(): string  
    return CoreLoopService:GetState()
end

function CoreLoopController:KnitStart(): ()
    
    local function OnStateChanged( stateName: string ): ()
        self.StateChanged:Fire(stateName)
    end
    OnStateChanged(CoreLoopService:GetState())
    CoreLoopService.StateChanged:Connect(OnStateChanged)
end


function CoreLoopController:KnitInit(): ()
    
end


return CoreLoopController