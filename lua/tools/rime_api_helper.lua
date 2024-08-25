local M = {}


function M.detect_os()
    local user_distribute_name = rime_api:get_distribution_code_name()
    if user_distribute_name:lower():match("weasel") then
        return "Windows"
    elseif user_distribute_name:lower():match("squirrel") then
        return "MacOS"
    elseif (
            user_distribute_name:lower():match("fcitx%-rime")
            and io.popen("uname -s"):read("*l"):lower():match("darwin")
        ) then
        return "MacOS"
    elseif user_distribute_name:lower():match("^fcitx%-rime$") then
        return "Android"
    elseif user_distribute_name:lower():match("^fcitx$") then
        return "Linux"
    elseif user_distribute_name:lower():match("ibus") then
        return "Linux"
    elseif user_distribute_name:lower():match("hamster") then
        return "iOS"
    else
        return "Unknow"
    end
end

function M.get_selected_candidate_index(key_value, selected_index, page_size)
    local keyValue = key_value
    local selected_cand_idx = -1
    if keyValue == "space" then
        keyValue = -1
    elseif keyValue == "Return" then
        keyValue = -1
    elseif keyValue == "semicolon" then
        keyValue = 1
    elseif keyValue == "apostrophe" then
        keyValue = 2
    elseif keyValue:match("^[1-9]$") then
        keyValue = tonumber(keyValue) - 1
    elseif keyValue == "0" then
        keyValue = 9
    else
        return -1
    end

    local page_pos = math.floor(selected_index / page_size) + 1
    local idx = (keyValue == -1) and selected_index or keyValue
    selected_cand_idx = (
        (type(keyValue) == "number") and (keyValue ~= -1) and (page_pos > 1)
    ) and (keyValue + (page_pos - 1) * page_size) or idx
    return selected_cand_idx
end

return M
