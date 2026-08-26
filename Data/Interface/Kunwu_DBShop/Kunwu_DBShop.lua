--- UI 相关
-- 界面的默认相对位置
local g_Kunwu_DBShop_UnifiedXPosition
local g_Kunwu_DBShop_UnifiedYPosition
local objCared = -1
local g_UIItem

-- 常量
local g_LevelLimit = 65
local g_ShengWangLimit = {1, 3, 5, 7, 8, 9, 1, 1, 1, 1, 1, 1}
local g_ServerBuyScriptId = 879999
local g_ServerBuyFuncName = "Buy"
-- 玩家数据
local g_TokenNumber
local g_ShengWangNumber
local g_CaredNPCId

--- default funcs 
function Kunwu_DBShop_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    -- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--离开场景，自动关睜
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function Kunwu_DBShop_OnLoad()
    -- 保存界面的默认相对位置
	g_Kunwu_DBShop_UnifiedXPosition	= Kunwu_DBShop_Frame:GetProperty("UnifiedXPosition")
    g_Kunwu_DBShop_UnifiedYPosition	= Kunwu_DBShop_Frame:GetProperty("UnifiedYPosition")
    Kunwu_DBShop_DragTitle:SetText("#{ZSSD_241211_6}")
    Kunwu_DBShop_Info_Text1:SetText ("#{ZSSD_241211_25}")
    Kunwu_DBShop_querengoumai_Text:SetText("#{ZSSD_241211_8}")
    Kunwu_DBShop_querengoumai_Text:SetToolTip("#{ZSSD_241211_9}")

    g_UIItem = {
        {
            ActionItem = Kunwu_DBShop_Item1,
            ItemName = Kunwu_DBShop_ItemInfo1_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo1_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo1_LevelLimit,
            ItemMask = Kunwu_DBShop_Item1_Mask,
            ItemId = 38003439,
            ItemPriceNum = 60
        },
        {
            ActionItem = Kunwu_DBShop_Item2,
            ItemName = Kunwu_DBShop_ItemInfo2_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo2_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo2_LevelLimit,
            ItemMask = Kunwu_DBShop_Item2_Mask,
            ItemId = 38003440,
            ItemPriceNum = 80
        },
        {
            ActionItem = Kunwu_DBShop_Item3,
            ItemName = Kunwu_DBShop_ItemInfo3_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo3_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo3_LevelLimit,
            ItemMask = Kunwu_DBShop_Item3_Mask,
            ItemId = 38003441,
            ItemPriceNum = 105
        },
        {
            ActionItem = Kunwu_DBShop_Item4,
            ItemName = Kunwu_DBShop_ItemInfo4_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo4_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo4_LevelLimit,
            ItemMask = Kunwu_DBShop_Item4_Mask,
            ItemId = 38003442,
            ItemPriceNum = 140
        },
        {
            ActionItem = Kunwu_DBShop_Item5,
            ItemName = Kunwu_DBShop_ItemInfo5_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo5_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo5_LevelLimit,
            ItemMask = Kunwu_DBShop_Item5_Mask,
            ItemId = 38003443,
            ItemPriceNum = 185
        },
        {
            ActionItem = Kunwu_DBShop_Item6,
            ItemName = Kunwu_DBShop_ItemInfo6_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo6_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo6_LevelLimit,
            ItemMask = Kunwu_DBShop_Item6_Mask,
            ItemId = 38003444,
            ItemPriceNum = 240
        },
        {
            ActionItem = Kunwu_DBShop_Item7,
            ItemName = Kunwu_DBShop_ItemInfo7_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo7_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo7_LevelLimit,
            ItemMask = Kunwu_DBShop_Item7_Mask,
            ItemId = 38003481,
            ItemPriceNum = 1360
        },
        {
            ActionItem = Kunwu_DBShop_Item8,
            ItemName = Kunwu_DBShop_ItemInfo8_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo8_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo8_LevelLimit,
            ItemMask = Kunwu_DBShop_Item8_Mask,
            ItemId = 38003482,
            ItemPriceNum = 1760
        },
        {
            ActionItem = Kunwu_DBShop_Item9,
            ItemName = Kunwu_DBShop_ItemInfo9_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo9_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo9_LevelLimit,
            ItemMask = Kunwu_DBShop_Item9_Mask,
            ItemId = 38003483,
            ItemPriceNum = 2160
        },
        {
            ActionItem = Kunwu_DBShop_Item10,
            ItemName = Kunwu_DBShop_ItemInfo10_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo10_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo10_LevelLimit,
            ItemMask = Kunwu_DBShop_Item10_Mask,
            ItemId = 38003512,
            ItemPriceNum = 1360
        },
        {
            ActionItem = Kunwu_DBShop_Item11,
            ItemName = Kunwu_DBShop_ItemInfo11_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo11_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo11_LevelLimit,
            ItemMask = Kunwu_DBShop_Item11_Mask,
            ItemId = 38003513,
            ItemPriceNum = 3760
        },
        {
            ActionItem = Kunwu_DBShop_Item12,
            ItemName = Kunwu_DBShop_ItemInfo12_Text,
            ItemPriceUI = Kunwu_DBShop_ItemInfo12_Price,
            ItemLimit = Kunwu_DBShop_ItemInfo12_LevelLimit,
            ItemMask = Kunwu_DBShop_Item12_Mask,
            ItemId = 38003514,
            ItemPriceNum = 5760
        },
    }
end

function Kunwu_DBShop_OnEvent(event)
    if event == "UI_COMMAND" then
        if tonumber(arg0) == 88999901 then
            g_TokenNumber = Get_XParam_INT(0)
            g_ShengWangNumber = Get_XParam_INT(1)
            g_CaredNPCId = Get_XParam_INT(2)

            if g_CaredNPCId and g_CaredNPCId > 0 then
                objCared = DataPool:GetNPCIDByServerID(g_CaredNPCId)
                this:CareObject(objCared, 1, "Kunwu_DBShop")
            end

            Kunwu_DBShop_Info_Text2:SetText(ScriptGlobal_Format("#{ZSSD_241211_26}", g_ShengWangNumber))
            Kunwu_DBShop_DBNum_Text:SetText(ScriptGlobal_Format("#{ZSSD_241211_7}", g_TokenNumber))
            if NpcShop:GetZSCShopBuyDirectly() == 0 then
                Kunwu_DBShop_querengoumai:SetProperty("Selected", "True")
            else
                Kunwu_DBShop_querengoumai:SetProperty("Selected", "False")
            end

            for i, v in ipairs (g_UIItem) do
                local mActionItem = DataPool:CreateBindActionItemForShow(v.ItemId, 1)
                if mActionItem:GetID() ~= 0 then
                    v.ActionItem:SetActionItem(mActionItem:GetID())
                end
                local name = DataPool:LuaFnGetItemNameByTableIndex(v.ItemId)
                v.ItemName:SetText (name)

                if g_ShengWangNumber < g_ShengWangLimit[i] then
                    v.ItemMask:Show()
                    v.ItemPriceUI:Hide()
                    v.ItemLimit:Show()
                    local str = ScriptGlobal_Format("#{ZSSD_241211_29}", tostring(g_ShengWangLimit[i]))
                    v.ItemLimit:SetText(str)
                else
                    v.ItemMask:Hide()
                    v.ItemPriceUI:Show()
                    v.ItemLimit:Hide()
                    local str = ScriptGlobal_Format("#{ZSSD_241211_10}", tostring(v.ItemPriceNum))
                    v.ItemPriceUI:SetText (str)
                end
            end
            Kunwu_DBShop_Item10_Mask:Hide()
            Kunwu_DBShop_Item11_Mask:Hide()
            Kunwu_DBShop_Item12_Mask:Hide()

            this:Show()
        elseif tonumber(arg0) == 88999903 then
            if not this:IsVisible() then
                return
            end
            g_TokenNumber = Get_XParam_INT(0)
            g_ShengWangNumber = Get_XParam_INT(1)

            Kunwu_DBShop_Info_Text2:SetText(ScriptGlobal_Format("#{ZSSD_241211_26}", g_ShengWangNumber))
            Kunwu_DBShop_DBNum_Text:SetText(ScriptGlobal_Format("#{ZSSD_241211_7}", g_TokenNumber))

            for i, v in ipairs (g_UIItem) do
                if g_ShengWangNumber < g_ShengWangLimit[i] then
                    v.ItemMask:Show()
                else
                    v.ItemMask:Hide()
                end
            end
        end

    -- 游戏窗口尺寸发生了变化
	elseif event == "ADJEST_UI_POS" then
		Kunwu_DBShop_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_DBShop_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide();
    end
end
--- default end

--- ui funcs
-- 关睜
function Kunwu_DBShop_Close()
    this:CareObject(objCared, 0, "Kunwu_DBShop")
    this:Hide()
end

-- 购买是否开启二次确认切换
function Kunwu_DBShop_querengoumai_Clicked()
    if NpcShop:GetZSCShopBuyDirectly() == 0 then
        NpcShop:SetZSCShopBuyDirectly(1)
        Kunwu_DBShop_querengoumai:SetProperty("Selected", "False")
    else
        NpcShop:SetZSCShopBuyDirectly(0)
        Kunwu_DBShop_querengoumai:SetProperty("Selected", "True")
    end
end

-- 购买道具
function Kunwu_DBShop_Btn_Clicked(idx)
    if idx > table.getn(g_ShengWangLimit) then
        return
    end
    local nLevel = Player:GetLevel()
    if nLevel < g_LevelLimit then
        PushDebugMessage("#{ZSSD_241211_14}")
        return
    end
    if g_ShengWangNumber < g_ShengWangLimit[idx] then
        PushDebugMessage("#{ZSSD_241211_27}")
        return
    end
    if g_TokenNumber < g_UIItem[idx].ItemPriceNum then
        PushDebugMessage("#{ZSSD_241211_18}")
        return
    end
    if NpcShop:GetZSCShopBuyDirectly() == 0 then
        local name = DataPool:LuaFnGetItemNameByTableIndex(g_UIItem[idx].ItemId)
        PushEvent("UI_COMMAND", 88999902, idx, name, g_UIItem[idx].ItemPriceNum, objCared)
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name(g_ServerBuyFuncName)
        Set_XSCRIPT_ScriptID(g_ServerBuyScriptId)
        Set_XSCRIPT_Parameter(0, idx)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end
--- ui end

--- func 2 func
function Kunwu_DBShop_On_ResetPos()
	Kunwu_DBShop_Frame:SetProperty("UnifiedXPosition", g_Kunwu_DBShop_UnifiedXPosition);
	Kunwu_DBShop_Frame:SetProperty("UnifiedYPosition", g_Kunwu_DBShop_UnifiedYPosition);
end
