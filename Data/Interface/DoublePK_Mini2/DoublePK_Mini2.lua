-- 双人玩法 基本信息UI

-- 默认位置
local DoublePK_Mini2_UnifiedPosition = nil
local DoublePK_Mini2_UICommandClose = 99831901
local DoublePK_Mini2_UICommandOpen = 99831902


function DoublePK_Mini2_PreLoad()
    this:RegisterEvent("OPEN_DOUBLEPK_MINIEX", true)
    this:RegisterEvent("UI_COMMAND", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function DoublePK_Mini2_OnEvent(event)
    if event == "OPEN_DOUBLEPK_MINIEX" then
        DoublePK_Mini2_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == DoublePK_Mini2_UICommandClose) then
        DoublePK_Mini2_Hide()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_Mini2_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Mini2_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Mini2_UnifiedPos()
	end
end

function DoublePK_Mini2_OnLoad()
    DoublePK_Mini2_UnifiedPosition = DoublePK_Mini2_Frame:GetProperty("UnifiedPosition")
end



-- 界面默认位置
function DoublePK_Mini2_UnifiedPos()
	if (DoublePK_Mini2_UnifiedPosition ~= nil) then
		DoublePK_Mini2_Frame:SetProperty("UnifiedPosition", DoublePK_Mini2_UnifiedPosition)
	end
end

function DoublePK_Mini2_Show()
    if IsWindowShow("DoublePK_Mini") then
        CloseWindow("DoublePK_Mini", true)
    end
    
    this:Show()
end

function DoublePK_Mini2_Hide()
    this:Hide()
end

function DoublePK_Mini2_Small()
    DoublePK_Mini2_Hide()
    PushEvent("OPEN_DOUBLEPK_MINI")
end
