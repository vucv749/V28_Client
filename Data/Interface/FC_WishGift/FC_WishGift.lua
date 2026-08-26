-- 【2025Q2】新版本稳活
local g_FC_WishGift_Frame_UnifiedPosition
local g_nScriptId = 999724
local g_nUICommandID = 99972401
-- 累计进度
local g_TotalPoint = 0
-- 奖励
local g_RewardRecord = { 0, 0, 0 }
local g_RewardItem = {
    { needPoint = 4, itemId = 20600002, num = 1 },
    { needPoint = 10, itemId = 20501003, num = 1 },
    { needPoint = 18, itemId = 20502003, num = 1 },
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
function FC_WishGift_PreLoad()
    this:RegisterEvent("UI_COMMAND") -- UI_COMMAND
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
    this:RegisterEvent("ADJEST_UI_POS", false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false) -- 离开场景
    this:RegisterEvent("OBJECT_CARED_EVENT", false)
end

--=========================================================
-- OnLoad
--=========================================================
function FC_WishGift_OnLoad()
    g_Button[1] = FC_WishGift_Item1
    g_Button[2] = FC_WishGift_Item2
    g_Button[3] = FC_WishGift_Item3

    g_ButtonOk[1] = FC_WishGift_ItemOK1
    g_ButtonOk[2] = FC_WishGift_ItemOK2
    g_ButtonOk[3] = FC_WishGift_ItemOK3

    g_Animate[1] = FC_WishGift_ItemAnimate1
    g_Animate[2] = FC_WishGift_ItemAnimate2
    g_Animate[3] = FC_WishGift_ItemAnimate3

    g_FC_WishGift_Frame_UnifiedPosition = FC_WishGift_Frame:GetProperty("UnifiedPosition")
end

--=========================================================
-- OnEvent
--=========================================================
function FC_WishGift_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID then
        -- 0 关闭, 1 打开, 2 刷新
        local nOpType = Get_XParam_INT(0)

        -- 关闭界面
        if nOpType == 0 then
            if this:IsVisible() then
                FC_WishGift_OnClose()
            end
        end

        -- 打开界面
        if nOpType == 1 then
            FC_WishGift_Reset()
            FC_WishGift_ParamInit()
            FC_WishGift_BeginCareObject()
            FC_WishGift_Update()
            this:Show()
            -- 刷新
        elseif nOpType == 2 then
            FC_WishGift_ParamInit()
            FC_WishGift_Update()
        end
    elseif event == "VIEW_RESOLUTION_CHANGED" or event == "ADJEST_UI_POS" then
        FC_WishGift_OnResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
        --切换场景关闭界面
        FC_WishGift_OnClose()
    end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function FC_WishGift_ParamInit()
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
function FC_WishGift_Reset()
    g_TotalPoint      = 0
    g_RewardRecord[1] = 0
    g_RewardRecord[2] = 0
    g_RewardRecord[3] = 0
    g_HuoDongState    = 1
end

--=========================================================
-- 界面更新
--=========================================================
function FC_WishGift_Update()
    -- 显示进度
    FC_WishGift_ImageBK1:Hide()
    FC_WishGift_ImageBK2:Hide()
    FC_WishGift_ImageBK3:Hide()

    if g_HuoDongState == 1 then
        FC_WishGift_ImageBK1:Show()
    elseif g_HuoDongState == 2 then
        FC_WishGift_ImageBK2:Show()
    elseif g_HuoDongState == 3 then
        FC_WishGift_ImageBK3:Show()
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
    -- 进度
    local progressText = ScriptGlobal_Format("#{XFJB_250331_74}", g_TotalPoint)
    FC_WishGift_TextInfo:SetText(progressText)
    FC_WishGift_Progress:SetProgress(g_TotalPoint, 20)
end

--=========================================================
-- 点击领取
--=========================================================
function FC_WishGift_ItemClicked(idx)
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
function FC_WishGift_WishPonitNum_HelpClick()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnShowHelp")
    Set_XSCRIPT_ScriptID(g_nScriptId)
    Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end

--=========================================================
-- 关闭界面
--=========================================================
function FC_WishGift_Close()
    FC_WishGift_StopCareObject()
    this:Hide()
end

--=========================================================
-- 界面隐藏
--=========================================================
function FC_WishGift_OnHiden()
    this:Hide()
end

--=========================================================
-- 界面重置
--=========================================================
function FC_WishGift_OnResetPos()
    FC_WishGift_Frame:SetProperty("UnifiedPosition", g_FC_WishGift_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC
--=========================================================
function FC_WishGift_BeginCareObject()
    if g_ObjCared ~= -1 then
        this:CareObject(g_ObjCared, 0, "FC_WishGift")
        this:CareObject(g_ObjCared, 1, "FC_WishGift")
    end
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function FC_WishGift_StopCareObject()
    if g_ObjCared ~= -1 then
        this:CareObject(g_ObjCared, 0, "FC_WishGift");
        g_ObjCared = -1
    end
end
