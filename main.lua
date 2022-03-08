local UI_LOADED = false
local HANDLE = {}
local UNDEFINED_CALLBACK = 'LOCAL_STORAGE_UNDEFINED_CALLBACK'

--[[
    Functions
]]

function AwaitUI()
    while not UI_LOADED do Wait(50) end
end

function CreateHandle(key, value)
    local handle = {
        key = key,
        value = value,
        callback = UNDEFINED_CALLBACK
    }

    local handleKey = tostring(handle)
    HANDLE[handleKey] = handle

    return handleKey
end

function HandleNUICallback(data, cb)
    local handleKey = data.handleKey
    local callback = data.callback

    HANDLE[handleKey].callback = callback

    cb(1)
end

function HandleCallback(handleKey)
    while HANDLE[handleKey].callback == UNDEFINED_CALLBACK do Wait(0) end

    return HANDLE[handleKey].callback
end

--[[
    Main Functions
]]

--- Get a key value from local storage.
--- @param key string
--- @return string
function Get(key)
    AwaitUI()

    local handleKey = CreateHandle(key)

    SendNUIMessage({
        action = 'get',
        handleKey = handleKey,
        key = key
    })

    return HandleCallback(handleKey)
end

--- Set a key value in local storage.
--- @param key string
--- @param value string
--- @return boolean
function Set(key, value)
    AwaitUI()

    local handleKey = CreateHandle(key, value)

    SendNUIMessage({
        action = 'set',
        handleKey = handleKey,
        key = key,
        value = value
    })

    return HandleCallback(handleKey)
end

--- Remove a key value from local storage.
--- @param key string
--- @return boolean
function Remove(key)
    AwaitUI()

    local handleKey = CreateHandle(key)

    SendNUIMessage({
        action = 'remove',
        handleKey = handleKey,
        key = key
    })

    return HandleCallback(handleKey)
end

--- Clear all key values from local storage (`local_storage` resource only).
--- @return boolean
function Clear()
    AwaitUI()

    local handleKey = CreateHandle()

    SendNUIMessage({
        action = 'clear',
        handleKey = handleKey
    })

    return HandleCallback(handleKey)
end

--[[
    NUI Callbacks
]]

RegisterNUICallback('ui_loaded', function(data, cb)
    UI_LOADED = true
    cb(1)
end)

RegisterNUICallback('get', HandleNUICallback)
RegisterNUICallback('set', HandleNUICallback)
RegisterNUICallback('remove', HandleNUICallback)
RegisterNUICallback('clear', HandleNUICallback)


--[[
    Exports
]]

exports('Get', Get)
exports('Set', Set)
exports('Remove', Remove)
exports('Clear', Clear)

--[[
    Events
]]

AddEventHandler('local_storage:get', function(key, cb)
    cb(Get(key))
end)

RegisterNetEvent('local_storage:set', function(key, value)
    Set(key, value)
end)

RegisterNetEvent('local_storage:remove', function(key)
    Remove(key)
end)

RegisterNetEvent('local_storage:clear', function()
    Clear()
end)
