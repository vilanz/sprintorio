
sprintorio = {
    ["MAX_BREATH"] = 10,
    ["players"] = {}
}

function get_player(player)
    return sprintorio.players[player.name]
end

function sprintorio.init()
    for _, player in pairs(game.players) do
        sprintorio.setup_player(player)
    end
end

function sprintorio.setup_player(player)
    if not sprintorio.players[player.name] then
        sprintorio.players[player.name] = {
            ["breath"] = sprintorio.MAX_BREATH,
            ["is_sprinting"] = false
        }
    end
end

function sprintorio.toggle_player_sprint(player)
    get_player(player).is_sprinting = not get_player(player).is_sprinting
end

function sprintorio.update_sprint()
    for _, player in pairs(game.players) do
        local sprintorio_player = get_player(player)
        if sprintorio_player.is_sprinting then
            sprintorio_player.breath = math.max(0, sprintorio_player.breath - 1)
            if sprintorio_player.breath > 0 then
                player.character_running_speed_modifier = 0.8
            else
                player.character_running_speed_modifier = 0
                sprintorio_player.is_sprinting = not sprintorio_player.is_sprinting
            end
        else
            sprintorio_player.breath = math.min(sprintorio.MAX_BREATH, sprintorio_player.breath + 1)
        end
    end
end