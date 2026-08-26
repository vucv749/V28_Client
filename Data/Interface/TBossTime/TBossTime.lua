-- 跨服葼常BOSS 古塔

-- 默认位置
local g_tbosstime_unifiedposition = nil
local g_tbosstime_uicommand = 81015501
local g_tbosstime_towertype = 1
local g_uicommandtype = {
    open = 1,                                   -- ????
    close = 1000,                               -- ????
}

local g_Data = {}
function TBossTime_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("KFRCBOSS_GTSHOW", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function TBossTime_OnEvent(event)
    if (event == "KFRCBOSS_GTSHOW") then
        TBossTime_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_tbosstime_uicommand) then
        TBossTime_UICommandEvent()
    elseif (event == "PLAYER_LEAVE_WORLD") then
        TBossTime_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TBossTime_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TBossTime_UnifiedPos()
	end
end

function TBossTime_OnLoad()
    g_tbosstime_unifiedposition = TBossTime:GetProperty("UnifiedPosition")
end

function TBossTime_UICommandEvent()
    local opType =  Get_XParam_INT(0)
    if opType == g_uicommandtype.close then
        TBossTime_Hide()
        return
    end
    if opType == g_uicommandtype.open then
        g_Data = {}
        -- 类型
        g_Data.towerType = Get_XParam_INT(1)
        -- 沉月
        g_Data.bossCH = Get_XParam_INT(2)
        -- 地火
        g_Data.bossDH = Get_XParam_INT(3)
        -- 繁林
        g_Data.bossFL = Get_XParam_INT(4)
        -- 奖励剩余次数
        g_Data.awardRemain = Get_XParam_INT(5)
        -- 关睜时间
        g_Data.closeTime = Get_XParam_INT(6)
        TBossTime_Show()
    end
end

function TBossTime_Show()
    if IsWindowShow("TBossTime_Mini") then
        TBossTime_Hide()
        return
    end
    if IsWindowShow("TBossTime2") then
        CloseWindow("TBossTime2", true)
    end
    if IsWindowShow("TBossTime3") then
        CloseWindow("TBossTime3", true)
    end
    TBossTime_UpdateUI()
    this:Show()
end

-- 刷新UI内容
function TBossTime_UpdateUI()
    if g_Data == nil then
        return
    end

    -- 繁林
    local flStr = ScriptGlobal_Format("#{KFRC_240326_122}", g_Data.bossFL)
    TBossTime_YaoTaEnt_Num:SetText(flStr)
    -- 地火
    local dhStr = ScriptGlobal_Format("#{KFRC_240326_122}", g_Data.bossDH)
    TBossTime_YaoTaEnt2_Num:SetText(dhStr)
    -- 沉月
    local cyStr = ScriptGlobal_Format("#{KFRC_240326_122}", g_Data.bossCH)
    TBossTime_YaoTaEnt3_Num:SetText(cyStr)
    -- 剩余次数
    local awardTime = ScriptGlobal_Format("#{KFRC_240326_119}", g_Data.awardRemain)
    TBossTime_YaoTaAward_Num:SetText(awardTime)
    -- 倒计时
    local hour = math.floor(g_Data.closeTime*0.0001)
    local min = math.mod(math.floor(g_Data.closeTime*0.01), 100) - 1
    local sec = 59
    local timer = Lua_GetDiffTime_InSecond_ServerTime(hour, min, sec)
    if timer > 0 then
        TBossTime_YaoTaTime_Num:SetProperty("Timer", timer)
    else
        TBossTime_YaoTaTime_Num:SetProperty("Timer", 0)
    end
    TBossTime_YaoTaTime_Num:SetProperty("TextColor", "FF00FF00")
end

-- 界面默认位置
function TBossTime_UnifiedPos()
    if (g_tbosstime_unifiedposition ~= nil) then
        TBossTime:SetProperty("UnifiedPosition", g_tbosstime_unifiedposition)
    end
end

function TBossTime_Hide()
    this:Hide()
end

function TBossTime_OnClosed()
    TBossTime_Hide()
end

-- 打开Mini界面
function TBossTime_OpenMini()
    TBossTime_Hide()
    PushEvent("KFRCBOSS_MINISHOW", g_tbosstime_towertype)
end
