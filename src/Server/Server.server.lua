local startTime = os.clock()

local ServerStorage = game:GetService( "ServerStorage" )
local ReplicatedStorage = game:GetService( "ReplicatedStorage" )
--
local Knit = require( ReplicatedStorage.Knit )

local Component = require( Knit.Util.Component )

-- EXPOSE ASSET FOLDERS
Knit.Assets = ReplicatedStorage.Assets
Knit.ServerAssets = ServerStorage.Assets

-- EXPOSE SERVER MODULES
Knit.Modules = script.Parent.Modules

--EXPOSE SHARED MODULES
Knit.SharedModules = game.ReplicatedStorage.Shared.Modules
Knit.Helpers = Knit.SharedModules.Helpers
Knit.Enums = require( Knit.SharedModules.Enums )
Knit.GameData = game.ReplicatedStorage.Shared.Data

-- ENVIRONMENT SWITCHES
Knit.IsStudio = game:GetService( "RunService" ):IsStudio()
Knit.IsClient = game:GetService( "RunService" ):IsClient()
Knit.IsServer = game:GetService( "RunService" ):IsServer()

-- ADD SERVICES
local Services = script.Parent.Services
Knit.AddServicesDeep( Services )

Knit:Start():andThen(function()
    Component.Auto( script.Parent.Components )
    print( string.format("Server Successfully Compiled! [%s ms]", math.round((os.clock()-startTime)*1000)) )
end):catch(error )