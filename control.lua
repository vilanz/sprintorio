require "sprintorio"

script.on_init(function()
    sprintorio.init()
end)

script.on_event(defines.events.on_player_created, function(event)
    sprintorio.setup_player(game.players[event.player_index])
end)

script.on_event("toggle-sprintorio", function(event)
    sprintorio.toggle_player_sprint(game.players[event.player_index])
end)

script.on_event(defines.events.on_tick, function(event)
    if event.tick % 30 == 0 then
        sprintorio.tick_sprint()
    end
end)