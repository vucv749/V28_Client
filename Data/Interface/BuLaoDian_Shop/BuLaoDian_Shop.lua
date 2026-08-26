-- 天机城（不老殿） 兑换商店UI

-- 服务器逻辑脚本id
local BuLaoDian_Shop_SvrScriptId = 890254
-- 商店物品最大数量
local BuLaoDian_Shop_MaxItemNum = 12
-- 代币物品id
local BuLaoDian_Shop_DaiBiNum = 0
-- 目标NPCID
local BuLaoDian_Shop_TargetNPC = -1
-- 关注NPC
local BuLaoDian_Shop_CareObjId = -1
local BuLaoDian_Shop_CareObjSvrId = -1
local BuLaoDian_Shop_MAX_OBJ_DISTANCE = 5.0
-- 默认位置
local BuLaoDian_Shop_UnifiedPosition = nil
-- 控件表
local BuLaoDian_Shop_CtrlList = nil



function BuLaoDian_Shop_PreLoad()
    this:RegisterEvent("TJCPVP_SHOP_OPEN", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func BuLaoDian_Shop_PreLoad()

function BuLaoDian_Shop_OnEvent(event)
    if (event == "TJCPVP_SHOP_OPEN") then
        BuLaoDian_Shop_UpdateShopItem(arg0)

        if (not this:IsVisible()) then
            BuLaoDian_Shop_BeginCareObject(arg1, arg2)

            BuLaoDian_Shop_Show()
            -- 打开背包
            OpenWindow("Packet")
        end
    elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(BuLaoDian_Shop_CareObjId < 0 or tonumber(arg0) ~= BuLaoDian_Shop_CareObjId) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            BuLaoDian_Shop_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        BuLaoDian_Shop_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        BuLaoDian_Shop_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        BuLaoDian_Shop_UnifiedPos()
	end
end -- end func BuLaoDian_Shop_OnEvent()

function BuLaoDian_Shop_OnLoad()
	BuLaoDian_Shop_UnifiedPosition = BuLaoDian_Shop_Frame:GetProperty("UnifiedPosition")
	BuLaoDian_Shop_InitCtrlList()
end -- end func BuLaoDian_Shop_OnLoad()

-- 界面默认位置
function BuLaoDian_Shop_UnifiedPos()
	if (BuLaoDian_Shop_UnifiedPosition ~= nil) then
		BuLaoDian_Shop_Frame:SetProperty("UnifiedPosition", BuLaoDian_Shop_UnifiedPosition)
	end
end -- end func BuLaoDian_Shop_UnifiedPos()

-- 开启NPC关注
function BuLaoDian_Shop_BeginCareObject(objSvrId, objId)
	BuLaoDian_Shop_CareObjId = tonumber(objId)
    if (BuLaoDian_Shop_CareObjId >= 0) then
        BuLaoDian_Shop_CareObjSvrId = tonumber(objSvrId)
        BuLaoDian_Shop_TargetNPC = tonumber(objSvrId)
		this:CareObject(BuLaoDian_Shop_CareObjId, 1, "BuLaoDian_Shop")
	end
end -- end func BuLaoDian_Shop_BeginCareObject()

-- 取消NPC关注
function BuLaoDian_Shop_StopCareObject()
	if (BuLaoDian_Shop_CareObjId >= 0) then
		this:CareObject(BuLaoDian_Shop_CareObjId, 0, "BuLaoDian_Shop")
		BuLaoDian_Shop_CareObjId = -1
		BuLaoDian_Shop_CareObjSvrId = -1
	end
end -- end func BuLaoDian_Shop_StopCareObject()

-- 控件列表
function BuLaoDian_Shop_InitCtrlList()
    if (BuLaoDian_Shop_CtrlList ~= nil) then
        BuLaoDian_Shop_CtrlList = {}
    end

    BuLaoDian_Shop_CtrlList.item = {}
    BuLaoDian_Shop_CtrlList.item[1] = {}
    BuLaoDian_Shop_CtrlList.item[1].item = BuLaoDian_Shop_Item1
    BuLaoDian_Shop_CtrlList.item[1].name = BuLaoDian_Shop_ItemInfo1_Text
    BuLaoDian_Shop_CtrlList.item[1].price = BuLaoDian_Shop_ItemInfo1_Price
    BuLaoDian_Shop_CtrlList.item[1].num = BuLaoDian_Shop_Item1Num
    BuLaoDian_Shop_CtrlList.item[2] = {}
    BuLaoDian_Shop_CtrlList.item[2].item = BuLaoDian_Shop_Item2
    BuLaoDian_Shop_CtrlList.item[2].name = BuLaoDian_Shop_ItemInfo2_Text
    BuLaoDian_Shop_CtrlList.item[2].price = BuLaoDian_Shop_ItemInfo2_Price
    BuLaoDian_Shop_CtrlList.item[2].num = BuLaoDian_Shop_Item2Num
    BuLaoDian_Shop_CtrlList.item[3] = {}
    BuLaoDian_Shop_CtrlList.item[3].item = BuLaoDian_Shop_Item3
    BuLaoDian_Shop_CtrlList.item[3].name = BuLaoDian_Shop_ItemInfo3_Text
    BuLaoDian_Shop_CtrlList.item[3].price = BuLaoDian_Shop_ItemInfo3_Price
    BuLaoDian_Shop_CtrlList.item[3].num = BuLaoDian_Shop_Item3Num
    BuLaoDian_Shop_CtrlList.item[4] = {}
    BuLaoDian_Shop_CtrlList.item[4].item = BuLaoDian_Shop_Item4
    BuLaoDian_Shop_CtrlList.item[4].name = BuLaoDian_Shop_ItemInfo4_Text
    BuLaoDian_Shop_CtrlList.item[4].price = BuLaoDian_Shop_ItemInfo4_Price
    BuLaoDian_Shop_CtrlList.item[4].num = BuLaoDian_Shop_Item4Num
    BuLaoDian_Shop_CtrlList.item[5] = {}
    BuLaoDian_Shop_CtrlList.item[5].item = BuLaoDian_Shop_Item5
    BuLaoDian_Shop_CtrlList.item[5].name = BuLaoDian_Shop_ItemInfo5_Text
    BuLaoDian_Shop_CtrlList.item[5].price = BuLaoDian_Shop_ItemInfo5_Price
    BuLaoDian_Shop_CtrlList.item[5].num = BuLaoDian_Shop_Item5Num
    BuLaoDian_Shop_CtrlList.item[6] = {}
    BuLaoDian_Shop_CtrlList.item[6].item = BuLaoDian_Shop_Item6
    BuLaoDian_Shop_CtrlList.item[6].name = BuLaoDian_Shop_ItemInfo6_Text
    BuLaoDian_Shop_CtrlList.item[6].price = BuLaoDian_Shop_ItemInfo6_Price
    BuLaoDian_Shop_CtrlList.item[6].num = BuLaoDian_Shop_Item6Num
    BuLaoDian_Shop_CtrlList.item[7] = {}
    BuLaoDian_Shop_CtrlList.item[7].item = BuLaoDian_Shop_Item7
    BuLaoDian_Shop_CtrlList.item[7].name = BuLaoDian_Shop_ItemInfo7_Text
    BuLaoDian_Shop_CtrlList.item[7].price = BuLaoDian_Shop_ItemInfo7_Price
    BuLaoDian_Shop_CtrlList.item[7].num = BuLaoDian_Shop_Item7Num
    BuLaoDian_Shop_CtrlList.item[8] = {}
    BuLaoDian_Shop_CtrlList.item[8].item = BuLaoDian_Shop_Item8
    BuLaoDian_Shop_CtrlList.item[8].name = BuLaoDian_Shop_ItemInfo8_Text
    BuLaoDian_Shop_CtrlList.item[8].price = BuLaoDian_Shop_ItemInfo8_Price
    BuLaoDian_Shop_CtrlList.item[8].num = BuLaoDian_Shop_Item8Num
    BuLaoDian_Shop_CtrlList.item[9] = {}
    BuLaoDian_Shop_CtrlList.item[9].item = BuLaoDian_Shop_Item9
    BuLaoDian_Shop_CtrlList.item[9].name = BuLaoDian_Shop_ItemInfo9_Text
    BuLaoDian_Shop_CtrlList.item[9].price = BuLaoDian_Shop_ItemInfo9_Price
    BuLaoDian_Shop_CtrlList.item[9].num = BuLaoDian_Shop_Item9Num
    BuLaoDian_Shop_CtrlList.item[10] = {}
    BuLaoDian_Shop_CtrlList.item[10].item = BuLaoDian_Shop_Item10
    BuLaoDian_Shop_CtrlList.item[10].name = BuLaoDian_Shop_ItemInfo10_Text
    BuLaoDian_Shop_CtrlList.item[10].price = BuLaoDian_Shop_ItemInfo10_Price
    BuLaoDian_Shop_CtrlList.item[10].num = BuLaoDian_Shop_Item10Num
    BuLaoDian_Shop_CtrlList.item[11] = {}
    BuLaoDian_Shop_CtrlList.item[11].item = BuLaoDian_Shop_Item11
    BuLaoDian_Shop_CtrlList.item[11].name = BuLaoDian_Shop_ItemInfo11_Text
    BuLaoDian_Shop_CtrlList.item[11].price = BuLaoDian_Shop_ItemInfo11_Price
    BuLaoDian_Shop_CtrlList.item[11].num = BuLaoDian_Shop_Item11Num
    BuLaoDian_Shop_CtrlList.item[12] = {}
    BuLaoDian_Shop_CtrlList.item[12].item = BuLaoDian_Shop_Item12
    BuLaoDian_Shop_CtrlList.item[12].name = BuLaoDian_Shop_ItemInfo12_Text
    BuLaoDian_Shop_CtrlList.item[12].price = BuLaoDian_Shop_ItemInfo12_Price
    BuLaoDian_Shop_CtrlList.item[12].num = BuLaoDian_Shop_Item12Num
end -- end func BuLaoDian_Shop_InitCtrlList()

function BuLaoDian_Shop_Show()
    this:Show()
end -- end func BuLaoDian_Shop_Show()

function BuLaoDian_Shop_Hide()
    BuLaoDian_Shop_StopCareObject()
    this:Hide()
end -- end func BuLaoDian_Shop_Hide()

-- 关睜按钮
function BuLaoDian_Shop_CloseShop()
    BuLaoDian_Shop_Hide()
end -- end func BuLaoDian_Shop_CloseShop()

-- 物品点击按钮事件
function BuLaoDian_Shop_ItemClicked(arg)
    local itemIndex = tonumber(arg) - 1
    if (itemIndex < 0) then
        return
    end
    if (itemIndex >= BuLaoDian_Shop_MaxItemNum) then
        return
    end

    -- 获取商店物品信息
    local itemId, revealId, isBind, bagType, onceNum, maxNum, needNum = TJCPVP:GetShopItemInfo(itemIndex)
    if (itemId == nil or itemId <= 0) then
        return
    end
    -- 获取物品已兑换数量
    local exchangedNum = TJCPVP:GetExchangedNum(itemIndex)

    if (maxNum <= exchangedNum) then
        -- 可兑换数量为0
        PushDebugMessage("#{BLDPVP_221214_138}")
        return
    end
    if (BuLaoDian_Shop_DaiBiNum < needNum) then
        -- 代币数量不足
        PushDebugMessage("#{BLDPVP_221214_139}")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(BuLaoDian_Shop_SvrScriptId)
        Set_XSCRIPT_Function_Name("Callback_Exchange")
        Set_XSCRIPT_Parameter(0, itemIndex)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end -- end func BuLaoDian_Shop_ItemClicked()

-- 更新兑换物品信息
function BuLaoDian_Shop_UpdateShopItem(daibiNum)
    if (BuLaoDian_Shop_CtrlList == nil or BuLaoDian_Shop_CtrlList.item == nil) then
        BuLaoDian_Shop_InitCtrlList()
    end

    BuLaoDian_Shop_DaiBiNum = tonumber(daibiNum)
    local daibiNumText = ScriptGlobal_Format("#{BLDPVP_221214_135}", BuLaoDian_Shop_DaiBiNum)
    BuLaoDian_Shop_Num_Text:SetText(daibiNumText)

    local shopItemNum = TJCPVP:GetShopItemCount()
    if (shopItemNum <= 0) then
        return
    elseif (shopItemNum > BuLaoDian_Shop_MaxItemNum) then
        shopItemNum = BuLaoDian_Shop_MaxItemNum
    end

    for i=1, shopItemNum, 1 do
        -- 获取商店物品信息
        local itemId, revealId, isBind, bagType, onceNum, maxNum, needNum = TJCPVP:GetShopItemInfo(i-1)
        if (itemId ~= nil and itemId > 0) then
            local itemCtrl = BuLaoDian_Shop_CtrlList.item[i]
            if (itemCtrl ~= nil) then
                local itemViewId = itemId
                if (revealId > 0) then
                    itemViewId = revealId
                end
                local exchangedNum = TJCPVP:GetExchangedNum(i-1)
                local leftNum = maxNum - exchangedNum
                if (leftNum < 0) then
                    leftNum = 0
                end

                itemCtrl.item:Enable()
                itemCtrl.item:SetProperty("Gloom", "false")

                itemCtrl.num:SetText(tostring(leftNum))

                --local theAction = DataPool:CreateBindActionItemForShowWithMaxNum(itemViewId, onceNum, leftNum)
                local theAction = DataPool:CreateBindActionItemForShow(itemViewId, 1)
                if theAction:GetID() ~= 0 then
                    itemCtrl.item:SetActionItem(theAction:GetID())
                end

                -- if (leftNum > 0) then
                --     itemCtrl.item:SetProperty("Gloom", "false")
                -- else
                --     itemCtrl.item:SetProperty("Gloom", "true")
                -- end

                if (leftNum <= 0) then
                    itemCtrl.item:SetProperty("Gloom", "true")
                    itemCtrl.item:Disable()
                end
                -- if (BuLaoDian_Shop_DaiBiNum < needNum) then
                --     itemCtrl.item:SetProperty("Gloom", "true")
                --     itemCtrl.item:Disable()
                -- end

                local itemName = DataPool:LuaFnGetItemNameByTableIndex(itemId)
                itemCtrl.name:SetText(itemName)
                local szNeedNum = ScriptGlobal_Format("#{BLDPVP_221214_159}", needNum)
                itemCtrl.price:SetText(szNeedNum)
            end
        end
    end -- end for
end -- end func BuLaoDian_Shop_UpdateShopItem()
