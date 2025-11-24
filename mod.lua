-- name: PISS on the MOON knockback
-- description: THIS MOD IS PISSING ON THE MOON
gServerSettings.playerKnockbackStrength = 3000

local function isempty(s)
    return s == nil or s == ''
end

function disable_local_bubble(m)
    if m.numLives ~= -1 then
        if gGlobalSyncTable.respawn_flag then
            local x, y, z = m.bubbleObj.oPosX, m.bubbleObj.oPosY, m.bubbleObj.oPosZ
            init_single_mspawnario(m)
            m.health = 0x880
            vec3f_set(m.pos, x, y, z)
            obj_set_pos(m.marioObj, x, y, z)
        else
            init_single_mario(m)
            m.health = 0x880
        end
        return true
    end
    return false
end

function on_update_frame(playerState)
    if (playerState.action == ACT_BUBBLED and (playerState.input & INPUT_B_PRESSED) ~= 0) then
        disable_local_bubble(playerState)
    end
end

function set_respawn_flag(switchState)
    if isempty(switchState) == false then
        if switchState == 'on' then
            djui_chat_message_create('Save Respawn is enabled')
            gGlobalSyncTable.respawn_flag = true
            return true
        elseif switchState == 'off' then
            djui_chat_message_create('Save Respawn is disabled')
            gGlobalSyncTable.respawn_flag = false
            return true
        else
            djui_chat_message_create('Argument is invalid: use on/off')
            return false
        end
    end
    djui_chat_message_create('Error: argument missing (on/off)')
    return false
end

function on_respawn_flag_changed(tag, oldVal, newVal)
    if gGlobalSyncTable.respawn_flag then
        djui_chat_message_create('The Pussy ass Admin activated the spawn cheat')
    else
        djui_chat_message_create('The BASED ass Admin deactivated the spawn cheat')
    end
end

if network_is_server() then
    gGlobalSyncTable.respawn_flag = false
    hook_chat_command('spawn', '<on OR off> Remembers the spawn point', set_respawn_flag)
end

hook_event(HOOK_MARIO_UPDATE, on_update_frame)
hook_on_sync_table_change(gGlobalSyncTable, 'respawn_flag', 0, on_respawn_flag_changed)
