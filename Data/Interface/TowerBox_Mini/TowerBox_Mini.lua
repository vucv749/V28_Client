-- 跨服爬塔夺宝 迷你UI

-- 默认位置
local TowerBox_Mini_UnifiedPosition = nil
local TowerBox_Mini_UICommandClose = 99855901
local TowerBox_Mini_UICommandMini = 99855902

function TowerBox_Mini_PreLoad()
    this:RegisterEvent("PTDB_OPEN_TOWERBOXMINI_UI", true)
    this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function TowerBox_Mini_OnEvent(event)
    if event == "PTDB_OPEN_TOWERBOXMINI_UI" then
        TowerBox_Mini_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == TowerBox_Mini_UICommandClose) then
        TowerBox_Mini_Hide()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == TowerBox_Mini_UICommandMini) then
        TowerBox_Mini_MiniShow()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        if PTDB:LuaFnIsPTDBScene(GetSceneID()) < 1 then
            TowerBox_Mini_Hide()
        end
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TowerBox_Mini_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TowerBox_Mini_UnifiedPos()
	end
end

function TowerBox_Mini_OnLoad()
    TowerBox_Mini_UnifiedPosition = TowerBox_Mini_Frame:GetProperty("UnifiedPosition")
end



-- 界面默认位置
function TowerBox_Mini_UnifiedPos()
	if (TowerBox_Mini_UnifiedPosition ~= nil) then
		TowerBox_Mini_Frame:SetProperty("UnifiedPosition", TowerBox_Mini_UnifiedPosition)
	end
end

function TowerBox_Mini_Show()
    if IsWindowShow("TowerBox") then
        CloseWindow("TowerBox", true)
    end
    if IsWindowShow("TowerBox_ProjectInfo") then
        CloseWindow("TowerBox_ProjectInfo", true)
    end

    this:Show()
end

function TowerBox_Mini_MiniShow()
    if IsWindowShow("TowerBox") then
        return
    end
    if this:IsVisible() then
        return
    end

    this:Show()
end

function TowerBox_Mini_Hide()
    this:Hide()
end

function TowerBox_Mini_Open()
    TowerBox_Mini_Hide()
    PushEvent("PTDB_OPEN_TOWERBOX_UI")
end
