require "sprintorio"

local serpent = require("serpent")

script.on_init(function()
    global.sprintorio = global.sprintorio or {}
    for _, player in pairs(game.players) do
        game.print("Player in init: " .. serpent.block(player))
        createSprintorioPlayerIfNotExists(player)
        regenSprintGUI(player)
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    game.print("Player created: " .. serpent.block(player))
    createSprintorioPlayerIfNotExists(player)
    regenSprintGUI(player)
end)

script.on_event("toggle-sprintorio", function(event)
    local player = game.players[event.player_index]
    togglePlayerSprint(player)
end)

script.on_event(defines.events.on_tick, function(event)
    if event.tick % 60 == 0 then
        for _, player in pairs(game.players) do
            updatePlayerSprintStatus(player)
        end
    end
end)