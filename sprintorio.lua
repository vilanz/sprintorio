
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

function getPlayerSprintorioOxygen(playerSprintorio)
    if playerSprintorio.sprinting then
        return math.max(0, playerSprintorio.oxygen - 5)
    else
        return math.min(100, playerSprintorio.oxygen + 5)
    end
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

    local updatedOxygen = getPlayerSprintorioOxygen(playerSprintorio)
    updatePlayerOxygen(player, updatedOxygen)

    if playerSprintorio.oxygen > 0 and playerSprintorio.sprinting then
        if player.character_running_speed_modifier < 0.65 then
            player.character_running_speed_modifier = 0.65
        end
    end

    if playerSprintorio.oxygen == 0 or not playerSprintorio.sprinting then
        playerSprintorio.sprinting = false
        player.character_running_speed_modifier = 0
    end

end