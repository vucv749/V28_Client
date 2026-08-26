--Higntlight_ListMini.lua
local Higntlight_ListMini_Frame_UnifiedPosition

function Higntlight_ListMini_PreLoad()
    --第二个参数表示界面关睜时是否响应事件 默认为TRUE
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("SHOW_HIGHLIGHT_DAMAGE", true)
    this:RegisterEvent("SHOW_HIGHLIGHT_DAMAGE_MINI", true)
    this:RegisterEvent("SHOW_HIGHLIGHT_DAMAGE_MAX", true)
    this:RegisterEvent("ON_SCENE_TRANSING", false)
    this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
    this:RegisterEvent("ADJEST_UI_POS", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

function Higntlight_ListMini_OnLoad()
    Higntlight_ListMini_Frame_UnifiedPosition = Higntlight_ListMini_Frame:GetProperty("UnifiedPosition")
end

function Higntlight_ListMini_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == 20250716) then
        local op = Get_XParam_INT(0)
        if op == 0 then --????
            Higntlight_ListMini_OnClose()
        end
    elseif event == "SHOW_HIGHLIGHT_DAMAGE" then --????
    elseif event == "SHOW_HIGHLIGHT_DAMAGE_MINI" then --??????? ???????
        this:Show()
    elseif event == "SHOW_HIGHLIGHT_DAMAGE_MAX" then --??????? ?????
        this:Hide()
    elseif event == "ON_SCENE_TRANSING" then --?????????
        Higntlight_ListMini_OnClose()
    elseif event == "PLAYER_LEAVE_WORLD" then
        Higntlight_ListMini_OnClose()
    elseif (event == "ADJEST_UI_POS") then
        Higntlight_ListMini_Frame_On_ResetPos()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Higntlight_ListMini_Frame_On_ResetPos()
    end
end

--最大化按钮
function Higntlight_ListMini_Open()
    this:Hide()
    PushEvent("SHOW_HIGHLIGHT_DAMAGE_MAX")
end

--关睜
function Higntlight_ListMini_OnClose()
    this:Hide()
end

function Higntlight_ListMini_GetMenPai(menpai)
    local strName = ""
    strName = DataPool:GetMenPaiName(menpai)
    return strName
end

function Higntlight_ListMini_Frame_On_ResetPos()
    Higntlight_ListMini_Frame:SetProperty("UnifiedPosition", Higntlight_ListMini_Frame_UnifiedPosition)
end
