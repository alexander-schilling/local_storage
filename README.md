# Local Storage

Implementation of web browser local storage for FiveM.

- [Usage](#usage)
  - [Get](#get)
  - [Set](#set)
  - [Remove](#remove)
  - [Clear](#clear)

## Usage

Keep in mind:

- Getting an undefined value will return `nil`.
- Setting a key value to `nil` will return `'undefined'` (string) in `Get`.
- The best way to clear a key value is using `Remove`.
- `Clear` wil remove all key values. But only for this resource, for example, other resources that use `localStorage` don't share the same local storage.
- To store tables, use `json.encode` and `json.decode` (lua) / `JSON.stringify` and `JSON.parse` (js) to convert between tables and strings.

### Get

```lua
local myValue = exports.local_storage:Get('myKey')

-- Client side event
TriggerEvent('local_storage:get', 'myKey', function(value)
    myValue = value
end)
```

### Set

```lua
exports.local_storage:Set('myKey', 'myValue')

-- Client side event
TriggerEvent('local_storage:set', 'myKey', 'myValue')

-- Server side event
TriggerClientEvent('local_storage:set', playerId, 'myKey', 'myValue')
```

### Remove

```lua
exports.local_storage:Remove('myKey')

-- Client side event
TriggerEvent('local_storage:remove', 'myKey')

-- Server side event
TriggerClientEvent('local_storage:remove', playerId, 'myKey')
```

### Clear

> Careful with this one!

```lua
exports.local_storage:Clear()

-- Client side event
TriggerEvent('local_storage:clear')

-- Server side event
TriggerClientEvent('local_storage:clear', playerId)
```
