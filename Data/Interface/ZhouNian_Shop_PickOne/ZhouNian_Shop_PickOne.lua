-- ZhouNian_Shop_PickOne

local g_ZhouNian_Shop_PickOneFrame_UnifiedPosition

local g_nComfirmParam1      = 0

local g_nUICommandID        = 99991801
local g_nUIComfirmCommandID = 99991802

local g_nUseItemBagPos      = -1
-- 礼包奖励内容/ 左侧id/ 右侧id
local g_tableRewardInfo     = { 38003709, 38003710 }
local g_contorlActionButton = {}

--=========================================================
-- PreLoad
--=========================================================
function ZhouNian_Shop_PickOne_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("OBJECT_CARED_EVENT")
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED")

    this:RegisterEvent("ADJEST_UI_POS")
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function ZhouNian_Shop_PickOne_OnLoad()
    g_ZhouNian_Shop_PickOneFrame_UnifiedPosition = ZhouNian_Shop_PickOne_Frame:GetProperty("UnifiedPosition")


    g_contorlActionButton[1] = ZhouNian_Shop_PickOne_Gift1_Icon
    g_contorlActionButton[2] = ZhouNian_Shop_PickOne_Gift2_Icon
end

--=========================================================
-- OnEvent
--=========================================================
function ZhouNian_Shop_PickOne_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID) then
        -- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
        local nOpType = Get_XParam_INT(0)

        -- 关闭界面
        if 0 == nOpType then
            if this:IsVisible() then
                ZhouNian_Shop_PickOne_OnClose()
            end
        end

        -- 打开界面
        if 1 == nOpType then
            ZhouNian_Shop_PickOne_Reset()
            ZhouNian_Shop_PickOne_Frame_On_ResetPos()
            this:Show()
            ZhouNian_Shop_PickOne_ParamInit()

            ZhouNian_Shop_PickOne_Update()
        end

        -- 刷新界面
        if 2 == nOpType then
            if this:IsVisible() then
                ZhouNian_Shop_PickOne_ParamInit()
                ZhouNian_Shop_PickOne_Update()
            end
        end
    elseif event == "HIDE_ON_SCENE_TRANSED" then
        ZhouNian_Shop_PickOne_OnClose()
    elseif (event == "ADJEST_UI_POS") then
        ZhouNian_Shop_PickOne_Frame_On_ResetPos()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        ZhouNian_Shop_PickOne_Frame_On_ResetPos()
    end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function ZhouNian_Shop_PickOne_ParamInit()
    g_nUseItemBagPos = Get_XParam_INT(1)
end

--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =ZhouNian_Shop_PickOne
function ZhouNian_Shop_PickOne_Update()
    if g_nUseItemBagPos < 0 then
        return
    end

    LifeAbility:Lock_Packet_Item(g_nUseItemBagPos, 1)

    for i = 1, 2 do
        local theAction = DataPool:CreateBindActionItemForShow(g_tableRewardInfo[i], 1)
        if theAction:GetID() ~= 0 then
            g_contorlActionButton[i]:SetActionItem(theAction:GetID())
        end
    end
end

--=========================================================
-- 重置界面
--=========================================================
function ZhouNian_Shop_PickOne_Reset()
    if g_nUseItemBagPos >= 0 then
        LifeAbility:Lock_Packet_Item(g_nUseItemBagPos, 0)
    end
    g_nUseItemBagPos = -1
end

--=========================================================
-- 界面确认按钮
--=========================================================
function ZhouNian_Shop_PickOne_Left ()
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("ReceiveFreeLiHe")
        Set_XSCRIPT_ScriptID(999918)
        Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end
function ZhouNian_Shop_PickOne_Right ()
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name("BuyLiHe")
        Set_XSCRIPT_ScriptID(999918)
        Set_XSCRIPT_Parameter(0, 0)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end

--=========================================================
-- 关闭界面
--=========================================================
function ZhouNian_Shop_PickOne_OnClose()
    this:Hide()
    -- 重置
    ZhouNian_Shop_PickOne_Reset()
    PushEvent ("CLOSE_5YEARS_CHOOSE")
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="ZhouNian_Shop_PickOne_OnHiden();" />
--=========================================================
function ZhouNian_Shop_PickOne_OnHidden()
    -- 重置
    ZhouNian_Shop_PickOne_Reset()
end

--=========================================================
-- 界面位置
--=========================================================
function ZhouNian_Shop_PickOne_Frame_On_ResetPos()
    ZhouNian_Shop_PickOne_Frame:SetProperty("UnifiedPosition", g_ZhouNian_Shop_PickOneFrame_UnifiedPosition)
end
