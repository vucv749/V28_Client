-- 跨服日常BOSS 迷你UI

-- 默认位置
local g_TBossTime_Mini_UnifiedPosition = nil
local g_TBossTime_Mini_UICommand = 81015501
local g_TBossTime_Mini_UICommandClose = 1000
local g_TBossTime_Mini_TowerType_GT = 1
local g_TBossTime_Mini_TowerType_LT = 2
local g_TBossTime_Mini_TowerType_FLAG_GT = 10
local g_TBossTime_Mini_TowerType_FLAG_LT = 20
function TBossTime_Mini_PreLoad()
    this:RegisterEvent("KFRCBOSS_MINISHOW", true)
    this:RegisterEvent("UI_COMMAND", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function TBossTime_Mini_OnEvent(event)
    if event == "KFRCBOSS_MINISHOW" then
        TBossTime_Mini_Show(tonumber(arg0))
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_TBossTime_Mini_UICommand) then
        local opType = Get_XParam_INT(0)
        if opType == g_TBossTime_Mini_UICommandClose then
            TBossTime_Mini_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        if KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) < 1 then
            TBossTime_Mini_Hide()
        end
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TBossTime_Mini_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TBossTime_Mini_UnifiedPos()
	end
end

function TBossTime_Mini_OnLoad()
    g_TBossTime_Mini_UnifiedPosition = TBossTime_Mini_Frame:GetProperty("UnifiedPosition")
end



-- 界面默认位置
function TBossTime_Mini_UnifiedPos()
	if (g_TBossTime_Mini_UnifiedPosition ~= nil) then
		TBossTime_Mini_Frame:SetProperty("UnifiedPosition", g_TBossTime_Mini_UnifiedPosition)
	end
end

function TBossTime_Mini_Show(towerType)
    if IsWindowShow("TBossTime") then
        CloseWindow("TBossTime", true)
    end
    if IsWindowShow("TBossTime2") then
        CloseWindow("TBossTime2", true)
    end
    if IsWindowShow("TBossTime3") then
        CloseWindow("TBossTime3", true)
    end
    g_TBossTime_Mini_TowerType = towerType

    if g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_GT then
        TBossTime_Mini_PageHeader:SetText("#{KFRC_240326_03}")
    elseif g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_LT then
        TBossTime_Mini_PageHeader:SetText("#{KFRC_240326_73}")
    elseif g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_FLAG_GT then
        TBossTime_Mini_PageHeader:SetText("#{KFRC_240326_03}")
    elseif g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_FLAG_LT then
        TBossTime_Mini_PageHeader:SetText("#{KFRC_240326_73}")
    end

    this:Show()
end


function TBossTime_Mini_Hide()
    this:Hide()
end

function TBossTime_Mini_Open()
    TBossTime_Mini_Hide()
    if g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_GT then
        PushEvent("KFRCBOSS_GTSHOW")
    elseif g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_LT then
        PushEvent("KFRCBOSS_LTSHOW")
    elseif g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_FLAG_GT then
        PushEvent("KFRCBOSS_FLAGSHOW")
    elseif g_TBossTime_Mini_TowerType == g_TBossTime_Mini_TowerType_FLAG_LT then
        PushEvent("KFRCBOSS_FLAGSHOW")
    end
    --PushDebugMessage("我打开了Mini="..g_TBossTime_Mini_TowerType)
end