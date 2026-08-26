-- 【2025Q1】新版本稳活
local g_Kunwu_WishGift_Frame_UnifiedPosition
local g_nScriptId = 999599
local g_nUICommandID = 99959901
-- 累计进度
local g_TotalPoint = 0
-- 奖励
local g_RewardRecord = { 0, 0, 0 }
local g_RewardItem = {
    { needPoint = 4,  itemId = 38002532, num = 5 },
    { needPoint = 10, itemId = 20600002, num = 2 },
    { needPoint = 18, itemId = 38002519, num = 2 },
}
-- 关心NPC
local g_TargetId = -1
local g_ObjCared = -1
local g_Button = {}
local g_ButtonOk = {}
local g_Animate = {}
local g_HuoDongState = 1
--=========================================================
-- PreLoad
--=========================================================
function Kunwu_WishGift_PreLoad()
    this:RegisterEvent("UI_COMMAND") -- UI_COMMAND
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
    this:RegisterEvent("ADJEST_UI_POS", false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false) -- 离开场景
    this:RegisterEvent("OBJECT_CARED_EVENT", false)
end

--=========================================================
-- OnLoad
--=========================================================
function Kunwu_WishGift_OnLoad()
    g_Button[1] = Kunwu_WishGift_Item1
    g_Button[2] = Kunwu_WishGift_Item2
    g_Button[3] = Kunwu_WishGift_Item3

    g_ButtonOk[1] = Kunwu_WishGift_ItemOK1
    g_ButtonOk[2] = Kunwu_WishGift_ItemOK2
    g_ButtonOk[3] = Kunwu_WishGift_ItemOK3

    g_Animate[1] = Kunwu_WishGift_ItemAnimate1
    g_Animate[2] = Kunwu_WishGift_ItemAnimate2
    g_Animate[3] = Kunwu_WishGift_ItemAnimate3

    g_Kunwu_WishGift_Frame_UnifiedPosition = Kunwu_WishGift_Frame:GetProperty("UnifiedPosition")
end

--=========================================================
-- OnEvent
--=========================================================
function Kunwu_WishGift_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID then
        -- 0 关闭, 1 打开, 2 刷新
        local nOpType = Get_XParam_INT(0)

        -- 关闭界面
        if nOpType == 0 then
            if this:IsVisible() then
                Kunwu_WishGift_OnClose()
            end
        end

        -- 打开界面
        if nOpType == 1 then
            Kunwu_WishGift_Reset()
            Kunwu_WishGift_ParamInit()
            Kunwu_WishGift_BeginCareObject()
            Kunwu_WishGift_Update()
            this:Show()
            -- 刷新
        elseif nOpType == 2 then
            Kunwu_WishGift_ParamInit()
            Kunwu_WishGift_Update()
        end
    elseif event == "VIEW_RESOLUTION_CHANGED" or event == "ADJEST_UI_POS" then
        Kunwu_WishGift_OnResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
        --切换场景关闭界面
        Kunwu_WishGift_OnClose()
    end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function Kunwu_WishGift_ParamInit()
    g_TotalPoint      = Get_XParam_INT(1)
    g_RewardRecord[1] = Get_XParam_INT(2)
    g_RewardRecord[2] = Get_XParam_INT(3)
    g_RewardRecord[3] = Get_XParam_INT(4)
    g_HuoDongState    = Get_XParam_INT(5)
    g_TargetId        = Get_XParam_INT(6)
    g_ObjCared        = DataPool:GetNPCIDByServerID(g_TargetId)
end

--=========================================================
-- 重置界面参数（归零）
--=========================================================
function Kunwu_WishGift_Reset()
    g_TotalPoint      = 0
    g_RewardRecord[1] = 0
    g_RewardRecord[2] = 0
    g_RewardRecord[3] = 0
    g_HuoDongState    = 1
end

--=========================================================
-- 界面更新
--=========================================================
function Kunwu_WishGift_Update()
    -- 显示进度
    if g_HuoDongState >= 2 then
        Kunwu_WishGift_2BK_H:Show()
        Kunwu_WishGift_2Name:Show()
        Kunwu_WishGift_2BK_D:Hide()
    else
        Kunwu_WishGift_2BK_H:Hide()
        Kunwu_WishGift_2Name:Hide()
        Kunwu_WishGift_2BK_D:Show()
    end

    if g_HuoDongState >= 3 then
        Kunwu_WishGift_3BK_H:Show()
        Kunwu_WishGift_3Name:Show()
        Kunwu_WishGift_3BK_D:Hide()
    else
        Kunwu_WishGift_3BK_H:Hide()
        Kunwu_WishGift_3Name:Hide()
        Kunwu_WishGift_3BK_D:Show()
    end

    -- 奖励
    for i = 1, 3 do
        g_Animate[i]:Hide()
        g_ButtonOk[i]:Hide()

        -- 展示奖励
        local itemAction = DataPool:CreateBindActionItemForShow(g_RewardItem[i].itemId, g_RewardItem[i].num)
        g_Button[i]:SetActionItem(itemAction:GetID())

        -- 可领取
        if g_TotalPoint >= g_RewardItem[i].needPoint then
            if g_RewardRecord[i] == 0 then
                -- 待领取
                g_Animate[i]:Show()
            else
                -- 已领取
                g_ButtonOk[i]:Show()
            end
        end
    end

    --进度更新
    local str = ScriptGlobal_Format("#{QYWH_241210_56}", g_TotalPoint)
    Kunwu_WishGift_WishPointNum:SetText(str)
end

--=========================================================
-- 点击领取
--=========================================================
function Kunwu_WishGift_ItemClicked(idx)
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnGetProcessReward")
    Set_XSCRIPT_ScriptID(g_nScriptId)
    Set_XSCRIPT_Parameter(0, g_TargetId)
    Set_XSCRIPT_Parameter(1, idx)
    Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

--=========================================================
-- 点击帮助
--=========================================================
function Kunwu_WishGift_WishPonitNum_HelpClick()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnShowHelp")
    Set_XSCRIPT_ScriptID(g_nScriptId)
    Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end

--=========================================================
-- 关闭界面
--=========================================================
function Kunwu_WishGift_Close()
    Kunwu_WishGift_StopCareObject()
    this:Hide()
end

--=========================================================
-- 界面隐藏
--=========================================================
function Kunwu_WishGift_OnHiden()
    this:Hide()
end

--=========================================================
-- 界面重置
--=========================================================
function Kunwu_WishGift_OnResetPos()
    Kunwu_WishGift_Frame:SetProperty("UnifiedPosition", g_Kunwu_WishGift_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC
--=========================================================
function Kunwu_WishGift_BeginCareObject()
    if g_ObjCared ~= -1 then
        this:CareObject(g_ObjCared, 0, "Kunwu_WishGift")
        this:CareObject(g_ObjCared, 1, "Kunwu_WishGift")
    end
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Kunwu_WishGift_StopCareObject()
    if g_ObjCared ~= -1 then
        this:CareObject(g_ObjCared, 0, "Kunwu_WishGift");
        g_ObjCared = -1
    end
end
