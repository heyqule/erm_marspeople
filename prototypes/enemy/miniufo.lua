require('__stdlib__/stdlib/utils/defines/time')
require('util')

local ERM_UnitHelper = require('__enemyracemanager__/lib/rig/unit_helper')
local ERM_UnitTint = require('__enemyracemanager__/lib/rig/unit_tint')
local ERM_DebugHelper = require('__enemyracemanager__/lib/debug_helper')
local ERMDataHelper = require('__enemyracemanager__/lib/rig/data_helper')
local ErmMarsPeople_Sound = require('__erm_marspeople__/prototypes/sound')
local Sprites = require('__stdlib__/stdlib/data/modules/sprites')
local name = 'miniufo'

local health_multiplier = settings.startup["enemyracemanager-level-multipliers"].value
local hitpoint = 80
local max_hitpoint_multiplier = settings.startup["enemyracemanager-max-hitpoint-multipliers"].value * 2.5

local resistance_mutiplier = settings.startup["enemyracemanager-level-multipliers"].value
-- Handles acid and poison resistance
local base_acid_resistance = 0
local incremental_acid_resistance = 85
-- Handles physical resistance
local base_physical_resistance = 0
local incremental_physical_resistance = 95
-- Handles fire and explosive resistance
local base_fire_resistance = 10
local incremental_fire_resistance = 80
-- Handles laser and electric resistance
local base_electric_resistance = 10
local incremental_electric_resistance = 80
-- Handles cold resistance
local base_cold_resistance = 10
local incremental_cold_resistance = 80

-- Handles acid damages
local damage_multiplier = settings.startup["enemyracemanager-level-multipliers"].value
local base_laser_damage = 1
local incremental_laser_damage = 7

-- Handles Attack Speed
local attack_speed_multiplier = settings.startup["enemyracemanager-level-multipliers"].value
local base_attack_speed = 120
local incremental_attack_speed = 60

local attack_range = 9

local movement_multiplier = settings.startup["enemyracemanager-level-multipliers"].value
local base_movement_speed = 0.1
local incremental_movement_speed = 0.1

-- Misc settings
local vision_distance = 30
local pollution_to_join_attack = 50
local distraction_cooldown = 20

-- Animation Settings
local unit_scale = 1.3

local collision_box = { { -0.25, -0.25 }, { 0.25, 0.25 } }
local selection_box = { { -0.75, -0.75 }, { 0.75, 0.75 } }

function ErmMarsPeople.make_miniufo(level)
    level = level or 1

    data:extend({
        {
            type = "unit",
            name = MOD_NAME .. '/' .. name .. '/' .. level,
            localised_name = { 'entity-name.' .. MOD_NAME .. '/' .. name, level },
            icon = "__erm_marspeople__/graphics/entity/icons/units/" .. name .. ".png",
            icon_size = 64,
            flags = { "placeable-enemy", "placeable-player", "placeable-off-grid", "not-flammable"},
            has_belt_immunity = true,
            max_health = ERM_UnitHelper.get_health(hitpoint, hitpoint * max_hitpoint_multiplier, health_multiplier, level),
            order = MOD_NAME .. '/'  .. name .. '/' .. level,
            subgroup = "enemies",
            shooting_cursor_size = 2,
            resistances = {
                { type = "acid", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, resistance_mutiplier, level) },
                { type = "poison", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, resistance_mutiplier, level) },
                { type = "physical", percent = ERM_UnitHelper.get_resistance(base_physical_resistance, incremental_physical_resistance, resistance_mutiplier, level) },
                { type = "fire", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, resistance_mutiplier, level) },
                { type = "explosion", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, resistance_mutiplier, level) },
                { type = "laser", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, resistance_mutiplier, level) },
                { type = "electric", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, resistance_mutiplier, level) },
                { type = "cold", percent = ERM_UnitHelper.get_resistance(base_cold_resistance, incremental_cold_resistance, resistance_mutiplier, level) }
            },
            healing_per_tick = ERM_UnitHelper.get_healing(hitpoint, max_hitpoint_multiplier, health_multiplier, level),
            collision_mask = ERMDataHelper.getFlyingCollisionMask(),
            collision_box = collision_box,
            selection_box = selection_box,
            sticker_box = selection_box,
            vision_distance = vision_distance,
            movement_speed = ERM_UnitHelper.get_movement_speed(base_movement_speed, incremental_movement_speed, movement_multiplier, level),
            pollution_to_join_attack = pollution_to_join_attack,
            distraction_cooldown = distraction_cooldown,
            ai_settings = biter_ai_settings,
            attack_parameters = {
                type = "projectile",
                ammo_category = 'marspeople-damage',
                range = attack_range,
                min_attack_distance = attack_range - 3,
                cooldown = ERM_UnitHelper.get_attack_speed(base_attack_speed, incremental_attack_speed, attack_speed_multiplier, level),
                cooldown_deviation = 0.1,
                damage_modifier =  ERM_UnitHelper.get_damage(base_laser_damage, incremental_laser_damage, damage_multiplier, level),
                warmup = 12,
                use_shooter_direction = true,
                projectile_center = util.by_pixel(0, 64),
                ammo_type = {
                    category = "marspeople-damage",
                    target_type = "direction",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "projectile",
                            projectile = 'mini-ufo-projectile',
                            starting_speed = 0.2,
                        }
                    }
                },
                sound = ErmMarsPeople_Sound.mars_people_attack(0.75),
                animation = {
                    layers = {
                        {
                            filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-run.png",
                            width = 64,
                            height = 64,
                            frame_count = 16,
                            axially_symmetrical = false,
                            direction_count = 2,
                            scale = unit_scale,
                            animation_speed = 0.5
                        },
                        {
                            filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-attack.png",
                            width = 32,
                            height = 32,
                            frame_count = 16,
                            axially_symmetrical = false,
                            direction_count = 1,
                            scale = unit_scale,
                            animation_speed = 0.5,
                            shift= util.by_pixel(0, 16)
                        },
                        {
                            filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-run.png",
                            width = 64,
                            height = 64,
                            frame_count = 16,
                            axially_symmetrical = false,
                            direction_count = 2,
                            scale = unit_scale,
                            tint = ERM_UnitTint.tint_shadow(),
                            draw_as_shadow = true,
                            animation_speed = 0.5,
                            shift = {4, 0},
                        }
                    }
                }
            },

            distance_per_frame = 0.17,
            run_animation = {
                layers = {
                    {
                        filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-run.png",
                        width = 64,
                        height = 64,
                        frame_count = 16,
                        axially_symmetrical = false,
                        direction_count = 2,
                        scale = unit_scale,
                        animation_speed = 0.4,
                    },
                    {
                        filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-run.png",
                        width = 64,
                        height = 64,
                        frame_count = 16,
                        axially_symmetrical = false,
                        direction_count = 2,
                        scale = unit_scale,
                        tint = ERM_UnitTint.tint_shadow(),
                        draw_as_shadow = true,
                        animation_speed = 0.4,
                        shift = {4, 0},
                    }
                }
            },
            dying_explosion = "mini-ufo-death",
            dying_sound = ErmMarsPeople_Sound.mini_ufo_death(0.8),
            corpse = name .. '-corpse'
        },
        {
            type = "corpse",
            name = name .. '-corpse',
            icon = "__erm_marspeople__/graphics/entity/icons/units/" .. name .. ".png",
            icon_size = 64,
            flags = { "placeable-off-grid", "building-direction-8-way", "not-on-map" },
            selection_box = selection_box,
            selectable_in_game = false,
            dying_speed = 0.04,
            time_before_removed = defines.time.second,
            subgroup = "corpses",
            order = "x" .. name .. level,
            final_render_layer = "corpse",
            animation = Sprites.empty_pictures(),
        },
        {
            type = "explosion",
            name = "mini-ufo-death",
            flags = { "not-on-map" },
            animations = {
                layers = {
                    {
                        filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-death.png",
                        width = 64,
                        height = 64,
                        line_length = 8,
                        frame_count = 24,
                        direction_count = 1,
                        axially_symmetrical = false,
                        scale = unit_scale,
                        animation_speed = 0.25,
                        draw_as_glow = true,
                        shift = util.by_pixel(0, 32),
                    }
                    },
                    {
                        filename = "__erm_marspeople__/graphics/entity/units/" .. name .. "/" .. name .. "-death.png",
                        width = 64,
                        height = 64,
                        line_length = 8,
                        frame_count = 24,
                        direction_count = 1,
                        axially_symmetrical = false,
                        scale = unit_scale,
                        animation_speed = 0.25,
                        tint = ERM_UnitTint.tint_shadow(),
                        draw_as_shadow = true,
                        shift = util.by_pixel(128, 32),
                    }
            }
        },
    })

end