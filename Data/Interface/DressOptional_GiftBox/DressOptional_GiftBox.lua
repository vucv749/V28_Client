-- DressOptional_GiftBox

local g_DressOptional_GiftBoxFrame_UnifiedPosition

local g_nComfirmParam1      = 0

local g_nUICommandID        = 99951501
local g_nUIComfirmCommandID = 99951502

local g_nUseItemBagPos      = -1
-- 礼包奖励内容
local g_tableRewardInfo     =
{ --???????
    [1] = { nGiveItemID = 10124876, nGiveItemNum = 1, showItem = 10124876 },
    [2] = { nGiveItemID = 10125301, nGiveItemNum = 1, showItem = 10125301 },
}
local g_contorlActionButton = {}

-- 界面选择最大值
local g_nMaxSelectedIndex   = 2

--=========================================================
-- PreLoad
--=========================================================
function DressOptional_GiftBox_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("OBJECT_CARED_EVENT")
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED")

    this:RegisterEvent("ADJEST_UI_POS")
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function DressOptional_GiftBox_OnLoad()
    g_DressOptional_GiftBoxFrame_UnifiedPosition = DressOptional_GiftBoxFrame:GetProperty("UnifiedPosition")


    g_contorlActionButton[1] = DressOptional_GiftBoxGift1_Icon
    g_contorlActionButton[2] = DressOptional_GiftBoxGift2_Icon
end

--=========================================================
-- OnEvent
--=========================================================
function DressOptional_GiftBox_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID) then
        -- 0 关睜, 1 打开, 2 刷新, 3 二次确认框
        local nOpType = Get_XParam_INT(0)

        -- 关睜界面
        if 0 == nOpType then
            if this:IsVisible() then
                DressOptional_GiftBoxOnClose()
            end
        end

        -- 打开界面
        if 1 == nOpType then
            DressOptional_GiftBox_Reset()
            DressOptional_GiftBox_Frame_On_ResetPos()
            this:Show()
            DressOptional_GiftBox_ParamInit()

            DressOptional_GiftBox_Update(1)
        end

        -- 刷新界面
        if 2 == nOpType then
            if this:IsVisible() then
                DressOptional_GiftBox_ParamInit()
                DressOptional_GiftBox_Update(0)
            end
        end
    elseif event == "HIDE_ON_SCENE_TRANSED" then
        DressOptional_GiftBoxOnClose()
    elseif (event == "ADJEST_UI_POS") then
        DressOptional_GiftBox_Frame_On_ResetPos()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DressOptional_GiftBox_Frame_On_ResetPos()
    end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function DressOptional_GiftBox_ParamInit()
    g_nUseItemBagPos = Get_XParam_INT(1)
end
--=========================================================
-- help按钮
--=========================================================
function DressOptional_GiftBox_ClickHelp()
	PushEvent("QUEST_HELPINFO", "#{XYCY_241014_5}")
end
--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =DressOptional_GiftBox
function DressOptional_GiftBox_Update(bOpen)
    if g_nUseItemBagPos < 0 then
        return
    end

    LifeAbility:Lock_Packet_Item(g_nUseItemBagPos, 1)

    for i = 1, g_nMaxSelectedIndex do
        local tRewardInfo = g_tableRewardInfo[i]
        local nGiveItemID = tRewardInfo.showItem
        local nGiveItemNum = tRewardInfo.nGiveItemNum

        local theAction = DataPool:CreateBindActionItemForShow(nGiveItemID, nGiveItemNum)
        g_contorlActionButton[i]:SetActionItem(theAction:GetID())
    end
end

--=========================================================
-- 重置界面
--=========================================================
function DressOptional_GiftBox_Reset()
    if g_nUseItemBagPos >= 0 then
        LifeAbility:Lock_Packet_Item(g_nUseItemBagPos, 0)
    end
    g_nUseItemBagPos = -1
end

--=========================================================
-- 时装预览按钮
--=========================================================
function DressOptional_GiftBoxPreview(nSelectedIndex)
    local hairId
    local dressId
    local faceId

    dressId = g_tableRewardInfo[nSelectedIndex].nGiveItemID
    hairId = Exterior:LuaFnGetExteriorInUse(4)
    faceId = Exterior:LuaFnGetExteriorInUse(3)


    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("DressPreview")
    Set_XSCRIPT_ScriptID(999515)
    Set_XSCRIPT_Parameter(0, dressId)
    Set_XSCRIPT_Parameter(1, hairId)
    Set_XSCRIPT_Parameter(2, faceId)
    Set_XSCRIPT_ParamCount(3)
    Send_XSCRIPT()
end

--=========================================================
-- 界面确认按钮
--=========================================================
function DressOptional_GiftBoxConfirm(nSelectedIndex)
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnUIClickCallBack")
    Set_XSCRIPT_ScriptID(999515)
    Set_XSCRIPT_Parameter(0, g_nUseItemBagPos)
    Set_XSCRIPT_Parameter(1, nSelectedIndex)
    Set_XSCRIPT_Parameter(2, 0)
    Set_XSCRIPT_ParamCount(3)
    Send_XSCRIPT()
end

--=========================================================
-- 关睜界面
--=========================================================
function DressOptional_GiftBoxOnClose()
    this:Hide()
    -- 重置
    DressOptional_GiftBox_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="DressOptional_GiftBox_OnHiden();" />
--=========================================================
function DressOptional_GiftBox_OnHidden()
    -- 重置
    DressOptional_GiftBox_Reset()
end

--=========================================================
-- 界面位置
--=========================================================
function DressOptional_GiftBox_Frame_On_ResetPos()
    DressOptional_GiftBoxFrame:SetProperty("UnifiedPosition", g_DressOptional_GiftBoxFrame_UnifiedPosition)
end
