-- 跨服葼常BOSS 龙塔

-- 默认位置
local g_tbosstime_unifiedposition = nil
local g_tbosstime_uicommand = 81015501
local g_tbosstime_towertype = 1
local g_tbosstime_towertype_gt = 1
local g_tbosstime_towertype_lt = 2

local g_uicommandtype = {
    open = 10,                                   -- ????
    close = 1000,                                -- ????
}

local g_Data = {}
function TBossTime3_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("KFRCBOSS_FLAGSHOW", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function TBossTime3_OnEvent(event)
    if (event == "KFRCBOSS_FLAGSHOW") then
        TBossTime3_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_tbosstime_uicommand) then
        TBossTime3_UICommandEvent()
    elseif (event == "PLAYER_LEAVE_WORLD") then
        TBossTime3_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TBossTime3_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TBossTime3_UnifiedPos()
	end
end

function TBossTime3_OnLoad()
    g_tbosstime_unifiedposition = TBossTime3:GetProperty("UnifiedPosition")
end

function TBossTime3_UICommandEvent()
    local opType =  Get_XParam_INT(0)
    if opType == g_uicommandtype.close then
        TBossTime3_Hide()
        return
    end
    if opType == g_uicommandtype.open then
        g_Data = {}
        -- 类型
        g_Data.towerType = Get_XParam_INT(1)
        -- 奖励剩余次数
        g_Data.awardRemain = Get_XParam_INT(2)
        -- 关睜时间
        g_Data.closeTime = Get_XParam_INT(3)
        -- 旗子牸领
        g_Data.flagState = Get_XParam_INT(4)
        -- 下阶段开始时间
        g_Data.nextBeginTime = Get_XParam_INT(5)
        -- 下阶段开始时间
        g_Data.nextEndTime = Get_XParam_INT(6)
        TBossTime3_Show()
    end
end

function TBossTime3_Show()
    if IsWindowShow("TBossTime_Mini") then
        TBossTime3_Hide()
        return
    end
    if IsWindowShow("TBossTime") then
        CloseWindow("TBossTime", true)
    end
    if IsWindowShow("TBossTime2") then
        CloseWindow("TBossTime2", true)
    end

    TBossTime3_UpdateUI()
    this:Show()
end

-- 刷新UI内容
function TBossTime3_UpdateUI()
    if g_Data == nil then
        return
    end

    if g_Data.towerType == g_tbosstime_towertype_gt then
        TBossTime3_DragTitle:SetText("#{KFRC_240326_03}")
        TBossTime3_Text:SetText("#{KFRC_240326_04}")
    else
        TBossTime3_DragTitle:SetText("#{KFRC_240326_73}")
        TBossTime3_Text:SetText("#{KFRC_240326_118}")
    end

    -- 倒计时
    local nextHour = math.floor(g_Data.nextEndTime*0.0001)
    local nextMin = math.mod(math.floor(g_Data.nextEndTime*0.01), 100)
    local nextSec = math.mod(g_Data.nextEndTime, 100) - 1
    local nextTimer = Lua_GetDiffTime_InSecond_ServerTime(nextHour, nextMin, nextSec)
    if nextTimer > 0 then
        TBossTime3_ZhuXieEnt2_Num:SetProperty("Timer", nextTimer)
    else
        TBossTime3_ZhuXieEnt2_Num:SetProperty("Timer", 0)
    end
    TBossTime3_ZhuXieEnt2_Num:SetProperty("TextColor", "FF00FF00")

    -- 结束时间
    --local nextMinTimeStr = ScriptGlobal_Format("#{KFRC_240326_131}", nextMin+1)
    --TBossTime3_ZhuXieEnt:SetText(nextMinTimeStr)

    -- 剩余次数
    local awardTime = ScriptGlobal_Format("#{KFRC_240326_119}", g_Data.awardRemain)
    TBossTime3_ZhuXieAward_Num:SetText(awardTime)
    -- 旗子状态
    local flagState = ScriptGlobal_Format("#{KFRC_240326_135}", g_Data.flagState)
    TBossTime3_ZhuXieEnt3_Num:SetText(flagState) 

    -- 倒计时
    local hour = math.floor(g_Data.closeTime*0.0001)
    local min = math.mod(math.floor(g_Data.closeTime*0.01), 100)-1
    local sec = 59
    local timer = Lua_GetDiffTime_InSecond_ServerTime(hour, min, sec)
    if timer > 0 then
        TBossTime3_ZhuXieTime_Num:SetProperty("Timer", timer)
    else
        TBossTime3_ZhuXieTime_Num:SetProperty("Timer", 0)
    end
    TBossTime3_ZhuXieTime_Num:SetProperty("TextColor", "FF00FF00")
    
end

-- 界面默认位置
function TBossTime3_UnifiedPos()
    if (g_tbosstime_unifiedposition ~= nil) then
        TBossTime3:SetProperty("UnifiedPosition", g_tbosstime_unifiedposition)
    end
end

function TBossTime3_Hide()
    this:Hide()
end

function TBossTime3_OnClosed()
    TBossTime3_Hide()
end

-- 打开Mini界面
function TBossTime3_OpenMini()
    TBossTime3_Hide()
    PushEvent("KFRCBOSS_MINISHOW", g_Data.towerType*10)
end
