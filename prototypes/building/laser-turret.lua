---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 6/28/2021 9:38 PM
---
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 6/28/2021 9:38 PM
---
require('__stdlib__/stdlib/utils/defines/time')
require('util')

local ERM_UnitHelper = require('__enemyracemanager__/lib/rig/unit_helper')
local ERM_UnitTint = require('__enemyracemanager__/lib/rig/unit_tint')
local ERM_DebugHelper = require('__enemyracemanager__/lib/debug_helper')
local ERM_Config = require('__enemyracemanager__/lib/global_config')

local enemy_autoplace = require("__enemyracemanager__/lib/enemy-autoplace-utils")

local name = 'laser-turret'
local shortrange_name = 'shortrange-laser-turret'

-- Hitpoints

local hitpoint = 400
local max_hitpoint_multiplier = settings.startup["enemyracemanager-max-hitpoint-multipliers"].value * 1.5


-- Handles acid and poison resistance
local base_acid_resistance = 0
local incremental_acid_resistance = 75
-- Handles physical resistance
local base_physical_resistance = 0
local incremental_physical_resistance = 85
-- Handles fire and explosive resistance
local base_fire_resistance = 5
local incremental_fire_resistance = 75
-- Handles laser and electric resistance
local base_electric_resistance = 25
local incremental_electric_resistance = 55
-- Handles cold resistance
local base_cold_resistance = 15
local incremental_cold_resistance = 65

-- Handles laser damage multipliers

local base_laser_damage = 3
local incremental_laser_damage = 22

-- Handles Attack Speed

local base_attack_speed = 120
local incremental_attack_speed = 60

local attack_range = ERM_Config.get_max_attack_range() + 16
local shortrange_attack_range = 14

local collision_box = { { -0.7, -0.7 }, { 0.7, 0.7 } }
local map_generator_bounding_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
local selection_box = { { -1, -1 }, { 1, 1 } }

function ErmMarsPeople.make_laser_turret(level)
    level = level or 1

    local attack_range = ERM_UnitHelper.get_attack_range(level) + 16
    local shortrange_attack_range =  ERM_UnitHelper.get_attack_range(level)

    local marspeople_laser_turret = util.table.deepcopy(data.raw['electric-turret']['laser-turret'])

    -- Base changes
    marspeople_laser_turret['type'] = 'turret'
    marspeople_laser_turret['subgroup'] = 'enemies'
    marspeople_laser_turret['name'] = MOD_NAME .. '/' .. name .. '/' .. level
    marspeople_laser_turret['localised_name'] = { 'entity-name.' .. MOD_NAME .. '/' .. name, level }
    marspeople_laser_turret['flag'] = { "placeable-player", "placeable-enemy" }
    marspeople_laser_turret['max_health'] = ERM_UnitHelper.get_building_health(hitpoint, hitpoint * max_hitpoint_multiplier, level)
    marspeople_laser_turret['healing_per_tick'] = ERM_UnitHelper.get_building_healing(hitpoint, max_hitpoint_multiplier, level)
    marspeople_laser_turret['order'] = MOD_NAME .. '/' .. name .. '/'.. level
    marspeople_laser_turret['resistance'] = {
        { type = "acid", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, level) },
        { type = "poison", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, level) },
        { type = "physical", percent = ERM_UnitHelper.get_resistance(base_physical_resistance, incremental_physical_resistance, level) },
        { type = "fire", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, level) },
        { type = "explosion", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, level) },
        { type = "laser", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, level) },
        { type = "electric", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, level) },
        { type = "cold", percent = ERM_UnitHelper.get_resistance(base_cold_resistance, incremental_cold_resistance, level) }
    }
    marspeople_laser_turret['map_color'] = ERM_UnitHelper.format_map_color(settings.startup['erm_marspeople-map-color'].value)
    marspeople_laser_turret['collision_box'] = collision_box
    marspeople_laser_turret['selection_box'] = selection_box
    marspeople_laser_turret['map_generator_bounding_box'] = map_generator_bounding_box
    marspeople_laser_turret['autoplace'] = enemy_autoplace.enemy_worm_autoplace(0, FORCE_NAME)
    marspeople_laser_turret['call_for_help_radius'] = 50
    marspeople_laser_turret['spawn_decorations_on_expansion'] = false
    marspeople_laser_turret['energy_source'] = nil

    -- Attack Changes
    marspeople_laser_turret['attack_parameters']['ammo_category'] = "marspeople-damage"
    marspeople_laser_turret['attack_parameters']['cooldown'] = ERM_UnitHelper.get_attack_speed(base_attack_speed, incremental_attack_speed, level)
    marspeople_laser_turret['attack_parameters']['cooldown_deviation'] = 0.1
    marspeople_laser_turret['attack_parameters']['range'] = attack_range
    marspeople_laser_turret['attack_parameters']['damage_modifier'] = ERM_UnitHelper.get_damage(base_laser_damage, incremental_laser_damage, level)

    marspeople_laser_turret['attack_parameters']['ammo_type'] = {
        category = "marspeople-damage",
        action = {
            type = "direct",
            action_delivery = {
                type = "beam",
                beam = MOD_NAME.."/marspeople-laser-beam",
                max_length = ERM_Config.get_max_projectile_range(),
                duration = 20,
                source_offset = { 0, -1.31439 },
            }
        }
    }
    marspeople_laser_turret['corpse'] = 'marspeople-laser-turret-remnants',


    -- Animation Changes
    ERM_UnitTint.mask_tint(marspeople_laser_turret['folded_animation']['layers'][3], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_laser_turret['preparing_animation']['layers'][3], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_laser_turret['prepared_animation']['layers'][3], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_laser_turret['folding_animation']['layers'][3], ERM_UnitTint.tint_green())

    local marspeople_laser_turret_remants = util.table.deepcopy(data.raw['corpse']['laser-turret-remnants'])
    marspeople_laser_turret_remants.name = 'marspeople-laser-turret-remnants'
    ERM_UnitTint.mask_tint(marspeople_laser_turret_remants['animation'][1]['layers'][2], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_laser_turret_remants['animation'][2]['layers'][2], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_laser_turret_remants['animation'][3]['layers'][2], ERM_UnitTint.tint_green())

    local marspeople_shortrange_laser_turret = util.table.deepcopy(data.raw['electric-turret']['laser-turret'])
    marspeople_shortrange_laser_turret['type'] = 'turret'
    marspeople_shortrange_laser_turret['subgroup'] = 'enemies'
    marspeople_shortrange_laser_turret['name'] = MOD_NAME .. '/' .. shortrange_name .. '/' .. level
    marspeople_shortrange_laser_turret['localised_name'] = { 'entity-name.' .. MOD_NAME .. '/' .. shortrange_name, level }
    marspeople_shortrange_laser_turret['flag'] = { "placeable-player", "placeable-enemy" }
    marspeople_shortrange_laser_turret['max_health'] = ERM_UnitHelper.get_building_health(hitpoint, hitpoint * max_hitpoint_multiplier, level)
    marspeople_shortrange_laser_turret['healing_per_tick'] = ERM_UnitHelper.get_building_healing(hitpoint, max_hitpoint_multiplier, level)
    marspeople_shortrange_laser_turret['order'] = MOD_NAME .. "-" .. shortrange_name
    marspeople_shortrange_laser_turret['resistance'] = {
        { type = "acid", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, level) },
        { type = "poison", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, level) },
        { type = "physical", percent = ERM_UnitHelper.get_resistance(base_physical_resistance, incremental_physical_resistance, level) },
        { type = "fire", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, level) },
        { type = "explosion", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, level) },
        { type = "laser", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, level) },
        { type = "electric", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, level) },
        { type = "cold", percent = ERM_UnitHelper.get_resistance(base_cold_resistance, incremental_cold_resistance, level) }
    }
    marspeople_shortrange_laser_turret['map_color'] = MS_MAP_COLOR
    marspeople_shortrange_laser_turret['collision_box'] = collision_box
    marspeople_shortrange_laser_turret['selection_box'] = selection_box
    marspeople_shortrange_laser_turret['map_generator_bounding_box'] = map_generator_bounding_box
    marspeople_shortrange_laser_turret['autoplace'] = nil
    marspeople_shortrange_laser_turret['call_for_help_radius'] = 50
    marspeople_shortrange_laser_turret['spawn_decorations_on_expansion'] = false
    marspeople_shortrange_laser_turret['energy_source'] = nil

    -- Attack Changes
    marspeople_shortrange_laser_turret['attack_parameters']['ammo_category'] = "marspeople-damage"
    marspeople_shortrange_laser_turret['attack_parameters']['cooldown'] = ERM_UnitHelper.get_attack_speed(base_attack_speed, incremental_attack_speed, level)
    marspeople_shortrange_laser_turret['attack_parameters']['cooldown_deviation'] = 0.1
    marspeople_shortrange_laser_turret['attack_parameters']['range'] = shortrange_attack_range
    marspeople_shortrange_laser_turret['attack_parameters']['damage_modifier'] = ERM_UnitHelper.get_damage(base_laser_damage, incremental_laser_damage, level)

    marspeople_shortrange_laser_turret['attack_parameters']['ammo_type'] = {
        category = "marspeople-damage",
        action = {
            type = "direct",
            action_delivery = {
                type = "beam",
                beam = MOD_NAME.."/marspeople-laser-beam",
                max_length = ERM_Config.get_max_projectile_range(),
                duration = 20,
                source_offset = { 0, -1.31439 },
            }
        }
    }
    marspeople_shortrange_laser_turret['corpse'] = 'marspeople-laser-turret-remnants',
    -- Animation Changes
    ERM_UnitTint.mask_tint(marspeople_shortrange_laser_turret['folded_animation']['layers'][3], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_shortrange_laser_turret['preparing_animation']['layers'][3], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_shortrange_laser_turret['prepared_animation']['layers'][3], ERM_UnitTint.tint_green())
    ERM_UnitTint.mask_tint(marspeople_shortrange_laser_turret['folding_animation']['layers'][3], ERM_UnitTint.tint_green())

    data:extend({
        marspeople_laser_turret_remants,
        marspeople_laser_turret,
        marspeople_shortrange_laser_turret
    })
end
