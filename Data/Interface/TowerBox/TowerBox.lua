-- 跨服爬塔 小界面

-- 默认位置
local g_towerbox_unifiedposition = nil
local g_towerbox_uicommand = 99855901

local g_towerbox_timer = {
    tickbegin = 9,         -- 心跳开始
    tickend = 12,          -- 心跳结束
}

-- 塔结构
local g_towerbox_info = {
    {begin=200000,over=201000,str="#{PTDB_231225_47}"},
    {begin=201000,over=202000,str="#{PTDB_231225_247}"},
    {begin=202000,over=203000,str="#{PTDB_231225_248}"},
    {begin=203000,over=235900,str="#{PTDB_231225_249}"},
}

-- 对应奖励值对应的权重
local g_towerbox_reward = {
    {weight=99,item=38003103,},
    {weight=50,item=38003103,},
    {weight=40,item=38003102,},
    {weight=30,item=38003101,},
    {weight=20,item=38003100,},
    {weight=10,item=38003099,},
}

local g_towerbox_rewardspecial = 
{
    [38003103] = {item=39920140},
    [38003102] = {item=39920141},
}

function TowerBox_PreLoad()
    this:RegisterEvent("PTDB_OPEN_TOWERBOX_UI", true)
    this:RegisterEvent("PTDB_UPDATE_TOWERBOX_UI", false)
    this:RegisterEvent("UI_COMMAND", false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function TowerBox_OnEvent(event)
    if event == "PTDB_OPEN_TOWERBOX_UI" then
        TowerBox_Show()
    elseif event == "PTDB_UPDATE_TOWERBOX_UI" then
        TowerBox_UpdateUI()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_towerbox_uicommand) then
        TowerBox_Hide()
    elseif (event == "PLAYER_LEAVE_WORLD") then
        TowerBox_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TowerBox_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TowerBox_UnifiedPos()
	end
end

function TowerBox_OnLoad()
    g_towerbox_unifiedposition = TowerBox_Frame:GetProperty("UnifiedPosition")
end

-- 界面默认位置
function TowerBox_UnifiedPos()
	if (g_towerbox_unifiedposition ~= nil) then
		TowerBox_Frame:SetProperty("UnifiedPosition", g_towerbox_unifiedposition)
	end
end

function TowerBox_Show()
    if IsWindowShow("TowerBox_Mini") then
        TowerBox_Hide()
        return
    end

    --if IsWindowShow("TowerBox_ProjectInfo") then
    --    CloseWindow("TowerBox_ProjectInfo", true)
    --end

    TowerBox_InitTimer()
    TowerBox_UpdateUI()
    this:Show()
end

-- 刷新UI内容
function TowerBox_UpdateUI()
    local itemId = TowerBox_GetPlayerReward()
    if itemId > 0 then
        local theAction = DataPool:CreateActionItemForShow(itemId, 1)
        if theAction:GetID() ~= 0 then
            TowerBox_NowAwardItem:SetActionItem(theAction:GetID())
        end
        -- 第二个姜奖励
        local rewardData = g_towerbox_rewardspecial[itemId]
        if rewardData ~= nil then
            local theActionEx = DataPool:CreateActionItemForShow(rewardData.item, 1)
            if theActionEx:GetID() ~= 0 then
                TowerBox_NowAwardItem2:SetActionItem(theActionEx:GetID())
            else
                TowerBox_NowAwardItem2:SetActionItem(-1)
            end
            TowerBox_NowAwardItem2:Show()
        else
            TowerBox_NowAwardItem2:Hide()
        end
        TowerBox_NowAwardItem:Show()
        TowerBox_Text3:Hide()
    else
        TowerBox_Text3:Show()
        TowerBox_NowAwardItem:SetActionItem(-1)
        TowerBox_NowAwardItem:Hide()
        TowerBox_NowAwardItem2:Hide()
    end

    -- 显示提示
    local rewardStr = TowerBox_GetPlayerRewardStr()
    if rewardStr ~= nil then
        TowerBox_Text:SetText(rewardStr)
    end
end

-- 获取玩家奖励
function TowerBox_GetPlayerReward()
    -- 获取我当前的奖励
    local myAwardType = PTDB:LuaFnGetAwardType()
    if myAwardType == nil or myAwardType <= 0 then
        return -1
    end

    -- 计算我当前应获得奖励
    for i, data in (g_towerbox_reward or {}) do
        if myAwardType >= data.weight then
            return data.item
        end
    end

    return -100
end

-- 获取玩家奖励
function TowerBox_GetPlayerRewardStr()
    -- 获取我当前的奖励

    local curHMS = tonumber(DataPool:GetServerMinuteTime())
    for i, data in (g_towerbox_info or {}) do
        if curHMS >= data.begin and curHMS < data.over then
            return data.str
        end
    end

    return ""
end

function TowerBox_AskOk()
    local curHMS = tonumber(DataPool:GetServerMinuteTime())
end


-- 激活心跳
function TowerBox_InitTimer()
    local randomValue = math.random(g_towerbox_timer.tickbegin, g_towerbox_timer.tickend)
    KillTimer("TowerBox_Timer()")
    SetTimer("TowerBox","TowerBox_Timer()", randomValue*1000)
end

-- 心跳
function TowerBox_Timer()
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("AskBattleInfo")
        Set_XSCRIPT_ScriptID(998559)
        Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end

-- 关闭界面回调
function TowerBox_OnHidden()
    if IsWindowShow("TowerBox_ProjectInfo") then
        CloseWindow("TowerBox_ProjectInfo", true)
    end

    KillTimer("TowerBox_Timer()")
end


function TowerBox_Hide()
    this:Hide()
end

function TowerBox_OnClosed()
    TowerBox_Hide()
    PushEvent("PTDB_OPEN_TOWERBOXMINI_UI")
end

-- 显示详情信息
function TowerBox_OpenDetail()
    --TowerBox_Hide()
    PushEvent("PTDB_OPEN_TOWERBOX_DETAILSUI")
end

-- 奖励按钮，目前没什么用
function TowerBox_NowAwardItemClick()

end