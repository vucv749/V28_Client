-- 跨服日常BOSS 龙塔

-- 默认位置
local g_tbosstime_unifiedposition = nil
local g_tbosstime_uicommand = 81015501
local g_tbosstime_towertype = 2
local g_uicommandtype = {
    open = 2,                                   -- 打开界面
    close = 1000,                               -- 关闭界面
}

local g_Data = {}
function TBossTime2_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("KFRCBOSS_LTSHOW", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function TBossTime2_OnEvent(event)
    if (event == "KFRCBOSS_LTSHOW") then
        TBossTime2_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_tbosstime_uicommand) then
        TBossTime2_UICommandEvent()
    elseif (event == "PLAYER_LEAVE_WORLD") then
        TBossTime2_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TBossTime2_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TBossTime2_UnifiedPos()
	end
end

function TBossTime2_OnLoad()
    g_tbosstime_unifiedposition = TBossTime2:GetProperty("UnifiedPosition")
end

function TBossTime2_UICommandEvent()
    local opType =  Get_XParam_INT(0)
    if opType == g_uicommandtype.close then
        TBossTime2_Hide()
        return
    end
    if opType == g_uicommandtype.open then
        g_Data = {}
        -- 类型
        g_Data.towerType = Get_XParam_INT(1)
        -- 数量
        g_Data.bossNum = Get_XParam_INT(2)
        -- 奖励剩余次数
        g_Data.awardRemain = Get_XParam_INT(3)
        -- 奖励剩余次数
        g_Data.closeTime = Get_XParam_INT(4)
        TBossTime2_Show()
    end
end

function TBossTime2_Show()
    if IsWindowShow("TBossTime_Mini") then
        TBossTime2_Hide()
        return
    end
    if IsWindowShow("TBossTime") then
        CloseWindow("TBossTime", true)
    end
    if IsWindowShow("TBossTime3") then
        CloseWindow("TBossTime3", true)
    end
    TBossTime2_UpdateUI()
    this:Show()
end

-- 刷新UI内容
function TBossTime2_UpdateUI()
    if g_Data == nil then
        return
    end

    -- 数量
    local numStr = ScriptGlobal_Format("#{KFRC_240326_122}", g_Data.bossNum)
    TBossTime2_Num:SetText(numStr)
    -- 剩余次数
    local awardTime = ScriptGlobal_Format("#{KFRC_240326_119}", g_Data.awardRemain)
    TBossTime2_Award:SetText(awardTime)
    -- 倒计时
    local hour = math.floor(g_Data.closeTime*0.0001)
    local min = math.mod(math.floor(g_Data.closeTime*0.01), 100)-1
    local sec = 59
    local timer = Lua_GetDiffTime_InSecond_ServerTime(hour, min, sec)
    if timer > 0 then
        TBossTime2_Time:SetProperty("Timer", timer)
    else
        TBossTime2_Time:SetProperty("Timer", 0)
    end
    TBossTime2_Time:SetProperty("TextColor", "FF00FF00")
    
end

-- 界面默认位置
function TBossTime2_UnifiedPos()
    if (g_tbosstime_unifiedposition ~= nil) then
        TBossTime2:SetProperty("UnifiedPosition", g_tbosstime_unifiedposition)
    end
end

function TBossTime2_Hide()
    this:Hide()
end

function TBossTime2_OnClosed()
    TBossTime2_Hide()
end

-- 打开Mini界面
function TBossTime2_OpenMini()
    TBossTime2_Hide()
    PushEvent("KFRCBOSS_MINISHOW", g_tbosstime_towertype)
end
