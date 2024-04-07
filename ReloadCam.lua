obs = obslua

-- Replace 'Cam' with the name of your video capture source
local source_name = 'Cam'

-- The value below (default: 5) is the reload interval in minutes. Change as needed.
local reload_interval_minutes = 5

local function disable_source()
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        obs.obs_source_set_enabled(source, false)
        obs.obs_source_release(source)
    end
end

local function enable_source()
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        obs.obs_source_set_enabled(source, true)
        obs.obs_source_release(source)
    end
end

local function timer_callback()
    print("Disabling source...")
    disable_source()
    obs.timer_add(function()
        print("Enabling source...")
        enable_source()
    end, 1000) -- 1000ms delay before enabling
    obs.remove_current_callback()
    obs.timer_add(timer_callback, reload_interval_minutes * 60 * 1000)
end

function script_load(settings)
    print("Script loaded.")
    obs.timer_add(timer_callback, reload_interval_minutes * 60 * 1000)
end

function script_unload()
    print("Script unloaded.")
    -- Stop timers when the script is unloaded
    obs.timer_remove(timer_callback)
end
