
sprintorio = {
    ["MAX_BREATH"] = 25,
    ["players"] = {}
}

function sprintorio._get_player(player)
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
    local sprintorio_player = sprintorio._get_player(player)
    sprintorio_player.is_sprinting = not sprintorio_player.is_sprinting
    if not sprintorio_player.is_sprinting then
        player.character_running_speed_modifier = 0
    end
end

function sprintorio.tick_sprint()
    for _, player in pairs(game.players) do
        local sprintorio_player = sprintorio._get_player(player)
        if sprintorio_player.is_sprinting then
            sprintorio_player.breath = math.max(0, sprintorio_player.breath - 1)
            if sprintorio_player.breath > 0 then
                if player.character_running_speed_modifier < 0.8 then
                    player.character_running_speed_modifier = 0.8
                end
            else
                sprintorio_player.is_sprinting = false
                player.character_running_speed_modifier = 0
            end
        else
            sprintorio_player.breath = math.min(sprintorio.MAX_BREATH, sprintorio_player.breath + 1)
        end
    end
end