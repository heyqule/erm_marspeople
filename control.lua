--
-- Created by IntelliJ IDEA.
-- User: heyqule
-- Date: 12/20/2020
-- Time: 5:04 PM
-- To change this template use File | Settings | File Templates.
--

local Game = require('__stdlib__/stdlib/game')

local ErmConfig = require('__enemyracemanager__/lib/global_config')
local ErmForceHelper = require('__enemyracemanager__/lib/helper/force_helper')
local ErmRaceSettingsHelper = require('__enemyracemanager__/lib/helper/race_settings_helper')
local CustomAttacks = require('__erm_marspeople__/prototypes/custom_attacks')

local Event = require('__stdlib__/stdlib/event/event')
local String = require('__stdlib__/stdlib/utils/string')

require('__erm_marspeople__/global')
-- Constants


local createRace = function()
    local force = game.forces[FORCE_NAME]
    if not force then
        force = game.create_force(FORCE_NAME)
    end

    force.ai_controllable = true;
    force.disable_research()
    force.friendly_fire = false;

    ErmForceHelper.set_friends(game, FORCE_NAME)
end

local addRaceSettings = function()
    if remote.call('enemy_race_manager', 'get_race', MOD_NAME) then
        return
    end
    local race_settings = {
        race = MOD_NAME,
        version = MOD_VERSION,
        level = 1, -- Race level
        tier = 1, -- Race tier
        evolution_point = 0,
        evolution_base_point = 0,
        attack_meter = 0, -- Build by killing their force (Spawner = 50, turrets = 10, unit = 1)
        next_attack_threshold = 0, -- Used by system to calculate next move
        units = {
            { 'marspeople', 'miniufo' },
            { 'eye-ufo-a', 'eye-ufo-b', 'marspeople-icy', 'daimanji-dropship', 'marspeople-builder'},
            { 'ufo', 'marspeople-fire', 'daimanji-purpleball', 'daimanji-thunderbolt' },
        },
        current_units_tier = {},
        turrets = {
            {'laser-turret'},
            {'thunderbolt-turret'},
            {},
        },
        current_turrets_tier = {},
        command_centers = {
            {'tencore'},
            {},
            {}
        },
        current_command_centers_tier = {},
        support_structures = {
            {'entrance_en','entrance_jp'},
            {'exit_en','exit_jp'},
            {},
        },
        current_support_structures_tier = {},
        flying_units = {
            {'miniufo'},
            {'eye-ufo-a','eye-ufo-b'},
            {'ufo', 'daimanji-purpleball', 'daimanji-thunderbolt'}
        },
        dropship = 'daimanji-dropship'
    }

    race_settings.current_units_tier = race_settings.units[1]
    race_settings.current_turrets_tier = race_settings.turrets[1]
    race_settings.current_command_centers_tier = race_settings.command_centers[1]
    race_settings.current_support_structures_tier = race_settings.support_structures[1]

    remote.call('enemy_race_manager', 'register_race', race_settings)
end

Event.on_init(function(event)
    createRace()
    addRaceSettings()
end)

Event.on_load(function(event)
end)

Event.on_configuration_changed(function(event)
    createRace()
    -- Mod Compatibility Upgrade for race settings
    Event.dispatch({
        name = Event.get_event_name(ErmConfig.RACE_SETTING_UPDATE), affected_race = MOD_NAME })
end)

Event.register(defines.events.on_script_trigger_effect, function(event)
    if CustomAttacks.valid(event, MOD_NAME) then
        if event.effect_id == MARSPEOPLE_DROPSHIP_ATTACK then
            CustomAttacks.process_dropship(event)
        elseif event.effect_id == MARSPEOPLE_BUILDER_ATTACK then
            CustomAttacks.process_builder(event)
        end
    end
end)

---
--- Modify Race Settings for existing game
---
Event.register(Event.generate_event_name(ErmConfig.RACE_SETTING_UPDATE), function(event)
    local race_setting = remote.call('enemy_race_manager', 'get_race', MOD_NAME)
    if (event.affected_race == MOD_NAME) and race_setting then
        if race_setting.version < MOD_VERSION then

            race_setting.version = MOD_VERSION
        end
        remote.call('enemy_race_manager', 'update_race_setting', race_setting)
    end
end)




