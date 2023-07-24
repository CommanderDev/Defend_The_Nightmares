-- Knit
local Knit = require( game.ReplicatedStorage.Knit )

-- Modules
local WeaponData = require( Knit.GameData.WeaponData )

local WeaponHelper = {}

function WeaponHelper.GetWeaponByName( weaponName: string ): table
    for _, weapon in pairs( WeaponData.Weapons ) do 
        if( weapon.Name == weaponName ) then
            return weapon
        end
    end
end

return WeaponHelper