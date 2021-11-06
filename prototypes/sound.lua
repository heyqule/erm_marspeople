---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 7/3/2021 10:29 PM
---

local MarsPeopleSound = {}

function MarsPeopleSound.mars_people_death(volume)
    return  {
        variations = {
            {
                filename = "__erm_marspeople__/sounds/death/mp_death.ogg",
                volume = volume
            },
            {
                filename = "__erm_marspeople__/sounds/death/mpp_death.ogg",
                volume = volume
            }
        }
    }
end

function MarsPeopleSound.mars_people_attack(volume)
    return  {
        variations = {
            {
                filename = "__erm_marspeople__/sounds/projectile/mars_people_attack.ogg",
                volume = volume
            }
        }
    }
end

return MarsPeopleSound;