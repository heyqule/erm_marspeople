require('__stdlib__/stdlib/utils/defines/time')
require('util')

local ERM_UnitHelper = require('__enemyracemanager__/lib/rig/unit_helper')
local ERM_UnitTint = require('__enemyracemanager__/lib/rig/unit_tint')
local ERM_DebugHelper = require('__enemyracemanager__/lib/debug_helper')
local ERMDataHelper = require('__enemyracemanager__/lib/rig/data_helper')
local ERM_Config = require('__enemyracemanager__/lib/global_config')
local ErmMarsPeople_Sound = require('__erm_marspeople__/prototypes/sound')
local Sprites = require('__stdlib__/stdlib/data/modules/sprites')
local name = 'marspeople-builder'

local hitpoint = 100
local max_hitpoint_multiplier = settings.startup["enemyracemanager-max-hitpoint-multipliers"].value * 2.5


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

local base_laser_damage = 1
local incremental_laser_damage = 8

-- Handles Attack Speed

local base_attack_speed = 300
local incremental_attack_speed = 240

local attack_range = math.ceil(ERM_Config.get_max_attack_range() * 0.75)

local base_movement_speed = 0.1
local incremental_movement_speed = 0.1

-- Misc settings
local vision_distance = ERM_UnitHelper.get_vision_distance(attack_range)
local pollution_to_join_attack = 200
local distraction_cooldown = 300

-- Animation Settings
local unit_scale = 1

local collision_box = { { -0.25, -0.25 }, { 0.25, 0.25 } }
local selection_box = { { -0.75, -0.75 }, { 0.75, 0.75 } }

function ErmMarsPeople.make_marspeople_builder(level)
    level = level or 1

    data:extend({
        {
            type = "unit",
            name = MOD_NAME .. '/' .. name .. '/' .. level,
            localised_name = { 'entity-name.' .. MOD_NAME .. '/' .. name, level },
            icon = "__erm_marspeople__/graphics/entity/icons/units/marspeople.png",
            icon_size = 64,
            flags = { "placeable-enemy", "placeable-player", "placeable-off-grid" },
            has_belt_immunity = true,
            max_health = ERM_UnitHelper.get_health(hitpoint, hitpoint * max_hitpoint_multiplier, level),
            order = MOD_NAME .. '/' .. name .. '/' .. level,
            subgroup = "enemies",
            shooting_cursor_size = 2,
            resistances = {
                { type = "acid", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, level) },
                { type = "poison", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, level) },
                { type = "physical", percent = ERM_UnitHelper.get_resistance(base_physical_resistance, incremental_physical_resistance, level) },
                { type = "fire", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, level) },
                { type = "explosion", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, level) },
                { type = "laser", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, level) },
                { type = "electric", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, level) },
                { type = "cold", percent = ERM_UnitHelper.get_resistance(base_cold_resistance, incremental_cold_resistance, level) }
            },
            map_color = ERM_UnitHelper.format_map_color(settings.startup['erm_marspeople-map-color'].value),
            healing_per_tick = ERM_UnitHelper.get_healing(hitpoint, max_hitpoint_multiplier, level),
            collision_box = collision_box,
            selection_box = selection_box,
            sticker_box = selection_box,
            vision_distance = vision_distance,
            movement_speed = ERM_UnitHelper.get_movement_speed(base_movement_speed, incremental_movement_speed, level),
            pollution_to_join_attack = ERM_UnitHelper.get_pollution_attack(pollution_to_join_attack, level),
            distraction_cooldown = distraction_cooldown,
            ai_settings = biter_ai_settings,
            spawning_time_modifier = 1.5,
            attack_parameters = {
                type = "projectile",
                range = attack_range,
                min_attack_distance = attack_range - 4,
                cooldown = 10,
                warmup = ERM_UnitHelper.get_attack_speed(base_attack_speed, incremental_attack_speed, level),
                ammo_type = {
                    category = "melee",
                    target_type = "direction",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = 'instant',
                            source_effects = {
                                {
                                    type = "script",
                                    effect_id = MARSPEOPLE_BUILDER_ATTACK,
                                }
                            }
                        }
                    }
                },
                sound = ErmMarsPeople_Sound.mars_people_attack(0.65),
                animation = {
                    layers = {
                        {
                            filename = "__erm_marspeople__/graphics/entity/units/marspeople/marspeople-run.png",
                            width = 96,
                            height = 96,
                            frame_count = 16,
                            axially_symmetrical = false,
                            direction_count = 2,
                            scale = unit_scale,
                            animation_speed = 0.5
                        },
                        {
                            filename = "__erm_marspeople__/graphics/entity/units/marspeople/marspeople-run.png",
                            width = 96,
                            height = 96,
                            frame_count = 16,
                            axially_symmetrical = false,
                            direction_count = 2,
                            scale = unit_scale,
                            tint = ERM_UnitTint.tint_shadow(),
                            draw_as_shadow = true,
                            animation_speed = 0.5,
                            shift = { 0.2, 0 }
                        }
                    }
                }
            },

            distance_per_frame = 0.17,
            run_animation = {
                layers = {
                    {
                        filename = "__erm_marspeople__/graphics/entity/units/marspeople/marspeople-run.png",
                        width = 96,
                        height = 96,
                        frame_count = 16,
                        axially_symmetrical = false,
                        direction_count = 2,
                        scale = unit_scale,
                        animation_speed = 0.5,
                    },
                    {
                        filename = "__erm_marspeople__/graphics/entity/units/marspeople/marspeople-run.png",
                        width = 96,
                        height = 96,
                        frame_count = 16,
                        axially_symmetrical = false,
                        direction_count = 2,
                        scale = unit_scale,
                        tint = ERM_UnitTint.tint_shadow(),
                        draw_as_shadow = true,
                        animation_speed = 0.5,
                        shift = { 0.2, 0 }
                    }
                }
            },
            --dying_explosion = "marspeople-death",
            dying_sound = ErmMarsPeople_Sound.mars_people_death(0.75),
            corpse = name .. '-corpse'
        },
        {
            type = "corpse",
            name = name .. '-corpse',
            icon = "__erm_marspeople__/graphics/entity/icons/units/marspeople.png",
            icon_size = 64,
            flags = { "placeable-off-grid", "building-direction-8-way", "not-on-map" },
            selection_box = selection_box,
            selectable_in_game = false,
            dying_speed = 0.015,
            time_before_removed = defines.time.second * 1,
            time_before_shading_off = 1,
            subgroup = "corpses",
            order = "x" .. name,
            final_render_layer = "corpse",
            animation = {
                {
                    filename = "__erm_marspeople__/graphics/entity/sfx/marspeople-builder-vanish.png",
                    width = 96,
                    height = 96,
                    frame_count = 11,
                    direction_count = 1,
                    axially_symmetrical = false,
                    scale = unit_scale
                }
            }
        }
    })

end