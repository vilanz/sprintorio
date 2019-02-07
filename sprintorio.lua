

--[[ function global.sprintorio.get_player(player)
    return global.sprintorio.players[player.name]
end

function global.sprintorio.update_player_oxygen(sprintorio_player, number)
    global.sprintorio_player.breath = number
    global.sprintorio_player.gui.oxygen_bar.value = (number / global.sprintorio.MAX_BREATH)
end

function global.sprintorio.init()
    for _, player in pairs(game.players) do
        global.sprintorio.setup_player(player)
    end
end

function global.sprintorio.setup_player(player)
    if not global.sprintorio.players[player.name] then
        global.sprintorio.players[player.name] = {
            ["breath"] = sprintorio.MAX_BREATH,
            ["is_sprinting"] = false,
            ["gui"] = {
                ["oxygen_bar_frame"] = player.gui.left.add{
                    type = "frame",
                    name = "sprintorio-oxygen-frame",
                    direction = "vertical",
                    caption = "sprintorio-oxygen",
                }
            }
        }
        global.sprintorio.players[player.name].gui["oxygen_bar"] = global.sprintorio.players[player.name].gui.oxygen_bar_frame.add{
            type = "progressbar",
            name = "sprintorio-oxygen"
        }
    end
end

function global.sprintorio.toggle_player_sprint(player)
    local sprintorio_player = sprintorio.get_player(player)
    sprintorio_player.is_sprinting = not sprintorio_player.is_sprinting
    if not sprintorio_player.is_sprinting then
        player.character_running_speed_modifier = 0
    end
end

function global.sprintorio.tick_sprint()
    for _, player in pairs(game.players) do
    end
end ]]


function createSprintorioPlayerIfNotExists(player)
    if not global.sprintorio[player.index] then
        global.sprintorio[player.index] = {
            ["sprinting"] = false,
            ["oxygen"] = 100
        }
    end
end

function regenSprintGUI(player)
    local guiLeft = player.gui.left
    
    if guiLeft["oxygen_frame"] then
        guiLeft["oxygen_frame"].destroy()
    end
    
    local oxygenFrame = guiLeft.add{
        type = "frame",
        name = "oxygen_frame",
        caption = "Oxygen"
    }
    
    oxygenFrame.add{
        type = "progressbar",
        name = "oxygen_bar",
    }
    
    updatePlayerOxygen(player, global.sprintorio[player.index]["oxygen"])
end

function updatePlayerOxygen(player, value)
    global.sprintorio[player.index]["oxygen"] = value
    player.gui.left["oxygen_frame"]["oxygen_bar"].value = (value / 100)
end

function togglePlayerSprint(player)
    local playerSprintorio = global.sprintorio[player.index]
    playerSprintorio["sprinting"] = not playerSprintorio["sprinting"]
end

function updatePlayerSprintStatus(player)
    local playerSprintorio = global.sprintorio[player.index]
    if playerSprintorio.sprinting then
        updatePlayerOxygen(
            player,
            math.max(0, playerSprintorio.oxygen - 5)
        )
        if playerSprintorio.oxygen > 0 then
            if player.character_running_speed_modifier < 0.65 then
                player.character_running_speed_modifier = 0.65
            end
        else
            playerSprintorio.sprinting = false
            player.character_running_speed_modifier = 0
        end
    else
        updatePlayerOxygen(
            player,
            math.min(100, playerSprintorio.oxygen + 5)
        )
    end
end