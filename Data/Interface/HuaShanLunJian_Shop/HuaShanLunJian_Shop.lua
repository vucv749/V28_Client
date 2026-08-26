-- 天机城（不老殿） 兑换商店UI

-- 服务器逻辑脚本id
local g_HuaShanLunJian_Shop_SvrScriptId = 999270
-- 商店物品最大数量
local g_HuaShanLunJian_Shop_MaxItemNum = 12
-- 代币物品id
local g_HuaShanLunJian_Shop_DaiBiNum = 0
-- 目标NPCID
local g_HuaShanLunJian_Shop_TargetNPC = -1
-- 关注NPC
local g_HuaShanLunJian_Shop_CareObjId = -1
local g_HuaShanLunJian_Shop_CareObjSvrId = -1

-- 默认位置
local g_HuaShanLunJian_Shop_UnifiedPosition = nil
-- 控件表
local g_HuaShanLunJian_Shop_CtrlList = nil


function HuaShanLunJian_Shop_PreLoad()
    this:RegisterEvent("XBW_OPENSHOP", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
    this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end -- end func HuaShanLunJian_Shop_PreLoad()

function HuaShanLunJian_Shop_OnEvent(event)
    if (event == "XBW_OPENSHOP") then
        HuaShanLunJian_Shop_UpdateShopItem()

        if (not this:IsVisible()) then
            HuaShanLunJian_Shop_BeginCareObject(arg0, arg1)

            HuaShanLunJian_Shop_Show()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        HuaShanLunJian_Shop_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        HuaShanLunJian_Shop_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        HuaShanLunJian_Shop_UnifiedPos()
	end
end -- end func HuaShanLunJian_Shop_OnEvent()

function HuaShanLunJian_Shop_OnLoad()
	g_HuaShanLunJian_Shop_UnifiedPosition = HuaShanLunJian_Shop_Frame:GetProperty("UnifiedPosition")
	HuaShanLunJian_Shop_InitCtrlList()
end -- end func HuaShanLunJian_Shop_OnLoad()

-- 界面默认位置
function HuaShanLunJian_Shop_UnifiedPos()
	if (g_HuaShanLunJian_Shop_UnifiedPosition ~= nil) then
		HuaShanLunJian_Shop_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_Shop_UnifiedPosition)
	end
end -- end func HuaShanLunJian_Shop_UnifiedPos()

-- 开启NPC关注
function HuaShanLunJian_Shop_BeginCareObject(objSvrId, objId)
	g_HuaShanLunJian_Shop_CareObjId = tonumber(objId)
    if (g_HuaShanLunJian_Shop_CareObjId >= 0) then
        g_HuaShanLunJian_Shop_CareObjSvrId = tonumber(objSvrId)
        g_HuaShanLunJian_Shop_TargetNPC = tonumber(objSvrId)
		this:CareObject(g_HuaShanLunJian_Shop_CareObjId, 1, "HuaShanLunJian_Shop")
	end
end -- end func HuaShanLunJian_Shop_BeginCareObject()

-- 取消NPC关注
function HuaShanLunJian_Shop_StopCareObject()
	if (g_HuaShanLunJian_Shop_CareObjId >= 0) then
		this:CareObject(g_HuaShanLunJian_Shop_CareObjId, 0, "HuaShanLunJian_Shop")
		g_HuaShanLunJian_Shop_CareObjId = -1
		g_HuaShanLunJian_Shop_CareObjSvrId = -1
	end
end -- end func HuaShanLunJian_Shop_StopCareObject()

-- 控件列表
function HuaShanLunJian_Shop_InitCtrlList()
    if (g_HuaShanLunJian_Shop_CtrlList ~= nil) then
        g_HuaShanLunJian_Shop_CtrlList = {}
    end

    local _prefix_l = "HuaShanLunJian_Shop_"
    local makeGroup = function(prefix,item,name,price,need,bg)
        return {
            ["item"] = _G[prefix..item],
            ["name"] = _G[prefix..name],
            ["price"] = _G[prefix..price],
            ["need"] = _G[prefix..need],
            ["bg"] = _G[prefix..bg],
		}
    end
    
    g_HuaShanLunJian_Shop_CtrlList.item = {}
    g_HuaShanLunJian_Shop_CtrlList.item = {
        makeGroup(_prefix_l, "Item1", "ItemInfo1_Text", "ItemInfo1_Price", "ItemInfo1_GB", "ItemInfo1"),
        makeGroup(_prefix_l, "Item2", "ItemInfo2_Text", "ItemInfo2_Price", "ItemInfo2_GB", "ItemInfo2"),
        makeGroup(_prefix_l, "Item3", "ItemInfo3_Text", "ItemInfo3_Price", "ItemInfo3_GB", "ItemInfo3"),
        makeGroup(_prefix_l, "Item4", "ItemInfo4_Text", "ItemInfo4_Price", "ItemInfo4_GB", "ItemInfo4"),
        makeGroup(_prefix_l, "Item5", "ItemInfo5_Text", "ItemInfo5_Price", "ItemInfo5_GB", "ItemInfo5"),
        makeGroup(_prefix_l, "Item6", "ItemInfo6_Text", "ItemInfo6_Price", "ItemInfo6_GB", "ItemInfo6"),
        makeGroup(_prefix_l, "Item7", "ItemInfo7_Text", "ItemInfo7_Price", "ItemInfo7_GB", "ItemInfo7"),
        makeGroup(_prefix_l, "Item8", "ItemInfo8_Text", "ItemInfo8_Price", "ItemInfo8_GB", "ItemInfo8"),
        makeGroup(_prefix_l, "Item9", "ItemInfo9_Text", "ItemInfo9_Price", "ItemInfo9_GB", "ItemInfo9"),
        makeGroup(_prefix_l, "Item10", "ItemInfo10_Text", "ItemInfo10_Price", "ItemInfo10_GB", "ItemInfo10"),
        makeGroup(_prefix_l, "Item11", "ItemInfo11_Text", "ItemInfo11_Price", "ItemInfo11_GB", "ItemInfo11"),
        makeGroup(_prefix_l, "Item12", "ItemInfo12_Text", "ItemInfo12_Price", "ItemInfo12_GB", "ItemInfo12"),
    }
    
end -- end func HuaShanLunJian_Shop_InitCtrlList()

function HuaShanLunJian_Shop_Show()
    if IsWindowShow("YuanbaoShop") then
        CloseWindow("YuanbaoShop", true)
    end
    this:Show()

    OpenWindow("Packet")
end -- end func HuaShanLunJian_Shop_Show()

function HuaShanLunJian_Shop_Hide()
    HuaShanLunJian_Shop_StopCareObject()
    this:Hide()
end -- end func HuaShanLunJian_Shop_Hide()

-- 关闭按钮
function HuaShanLunJian_Shop_CloseShop()
    HuaShanLunJian_Shop_Hide()
end -- end func HuaShanLunJian_Shop_CloseShop()

function HuaShanLunJian_Shop_ClearShopItem()
    for _, ui in (g_HuaShanLunJian_Shop_CtrlList.item or {}) do
        if ui.item ~= nil then
            ui.item:SetActionItem(-1)
        end
        if ui.name ~= nil then
            ui.name:SetText("")
        end
        if ui.need ~= nil then
            ui.need:SetText("")
        end
        if ui.price ~= nil then
            ui.price:Hide()
        end
    end
end

-- 物品点击按钮事件
function HuaShanLunJian_Shop_ItemClicked(arg)
    local itemIndex = tonumber(arg) - 1
    if (itemIndex < 0) then
        return
    end
    if (itemIndex >= g_HuaShanLunJian_Shop_MaxItemNum) then
        return
    end

    -- 获取商店物品信息
    local itemId, revealId, isBind, bagType, onceNum, maxNum, needNum, destIndex = NewXBW:GetShopItemInfo(itemIndex)
    if (itemId == nil or itemId <= 0) then
        return
    end
    -- 获取物品已兑换数量
    local exchangedNum = NewXBW:GetExchangedNum(destIndex)

    if (maxNum <= exchangedNum) then
        -- 可兑换数量为0
        PushDebugMessage("#{HSLJ_190919_374}")
        return
    end
    
    g_HuaShanLunJian_Shop_DaiBiNum = NewXBW:GetShopCoin()
    if (g_HuaShanLunJian_Shop_DaiBiNum < needNum) then
        -- 代币数量不足
        PushDebugMessage("#{HSLJ_190919_375}")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(g_HuaShanLunJian_Shop_SvrScriptId)
        Set_XSCRIPT_Function_Name("Callback_Exchange")
        Set_XSCRIPT_Parameter(0, g_HuaShanLunJian_Shop_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, itemIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func HuaShanLunJian_Shop_ItemClicked()

-- 更新兑换物品信息
function HuaShanLunJian_Shop_UpdateShopItem()
    if (g_HuaShanLunJian_Shop_CtrlList == nil or g_HuaShanLunJian_Shop_CtrlList.item == nil) then
        HuaShanLunJian_Shop_InitCtrlList()
    end

    HuaShanLunJian_Shop_ClearShopItem()

    g_HuaShanLunJian_Shop_DaiBiNum = NewXBW:GetShopCoin()
    local daibiNumText = ScriptGlobal_Format("#{HSLJ_190919_371}", g_HuaShanLunJian_Shop_DaiBiNum)
    HuaShanLunJian_Shop_Total_Text:SetText(daibiNumText)
    HuaShanLunJian_Shop_Total_Text:SetToolTip("#{HSLJ_190919_372}")
    
    local shopItemNum = NewXBW:GetShopItemCount()
    if (shopItemNum <= 0) then
        return
    elseif (shopItemNum > g_HuaShanLunJian_Shop_MaxItemNum) then
        shopItemNum = g_HuaShanLunJian_Shop_MaxItemNum
    end

    for i=1, shopItemNum, 1 do
        -- 获取商店物品信息
        local itemId, revealId, isBind, bagType, onceNum, maxNum, needNum, destIndex = NewXBW:GetShopItemInfo(i-1)
        if (itemId ~= nil and itemId > 0) then
            local itemCtrl = g_HuaShanLunJian_Shop_CtrlList.item[i]
            if (itemCtrl ~= nil) then
                local itemViewId = itemId
                if (revealId > 0) then
                    itemViewId = revealId
                end
                local exchangedNum = NewXBW:GetExchangedNum(destIndex)
                local leftNum = maxNum - exchangedNum
                if (leftNum < 0) then
                    leftNum = 0
                end

                itemCtrl.item:Enable()
                itemCtrl.item:SetProperty("Gloom", "false")

                --itemCtrl.num:SetText(tostring(leftNum))

                local theAction = nil
                if isBind > 0 then
                    theAction = DataPool:CreateBindActionItemForShowWithMaxNum(itemViewId, onceNum, leftNum)
                else
                    theAction = DataPool:CreateActionItemForShowWithMaxNum(itemViewId, onceNum, leftNum)
                end
                if theAction:GetID() ~= 0 then
                    itemCtrl.item:SetActionItem(theAction:GetID())
                end

                if (leftNum <= 0) then
                    itemCtrl.item:SetProperty("Gloom", "true")
                    itemCtrl.item:Disable()
                end

                local itemName = DataPool:LuaFnGetItemNameByTableIndex(itemId)
                itemCtrl.name:SetText(itemName)
                local szNeedNum = ScriptGlobal_Format("#{HSLJ_190919_390}", needNum)
                itemCtrl.need:SetText(szNeedNum)
            end
        end
    end -- end for
end -- end func HuaShanLunJian_Shop_UpdateShopItem()