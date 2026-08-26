local g_ZhouNian_Shop_MBuy_Frame_UnifiedXPosition
local g_ZhouNian_Shop_MBuy_Frame_UnifiedYPosition
local g_ZhouNian_Shop_MBuy_nSearch = 0
local g_ZhouNian_Shop_MBuy_Item = -1
local g_ZhouNian_Shop_MBuy_CaredNpc = -1
local g_ZhouNian_Shop_MBuy_itemCountPerPage = 8
local g_ZhouNian_Shop_MBuy_OriNum = 1
local g_ZhouNian_Shop_MBuy_Color_Y = "#cfff263"

function ZhouNian_Shop_MBuy_PreLoad()
	this:RegisterEvent("OPEN_5YEARS_MBUY_SHOP")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	-- this:RegisterEvent("UPDATE_5YEARS_SHOP")
end

function ZhouNian_Shop_MBuy_OnLoad()
	g_ZhouNian_Shop_MBuy_Frame_UnifiedXPosition = ZhouNian_Shop_MBuy_Frame:GetProperty("UnifiedXPosition")
	g_ZhouNian_Shop_MBuy_Frame_UnifiedYPosition = ZhouNian_Shop_MBuy_Frame:GetProperty("UnifiedYPosition")
end

function ZhouNian_Shop_MBuy_OnEvent(event)
	if ( event == "OPEN_5YEARS_MBUY_SHOP" ) then
		g_ZhouNian_Shop_MBuy_Item = tonumber(arg0)
		ZhouNian_Shop_MBuy_Update()
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then 
		ZhouNian_Shop_MBuy_OnHidden()
	elseif ( event == "ADJEST_UI_POS" ) then
		ZhouNian_Shop_MBuy_Frame_On_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZhouNian_Shop_MBuy_Frame_On_ResetPos()
	-- elseif ( event == "UPDATE_5YEARS_SHOP" ) then
	-- 	this:Hide()
	end
end

function ZhouNian_Shop_MBuy_Frame_On_ResetPos()
	ZhouNian_Shop_MBuy_Frame:SetProperty( "UnifiedXPosition", g_ZhouNian_Shop_MBuy_Frame_UnifiedXPosition )
	ZhouNian_Shop_MBuy_Frame:SetProperty( "UnifiedYPosition", g_ZhouNian_Shop_MBuy_Frame_UnifiedYPosition )
end

function ZhouNian_Shop_MBuy_Update()
	ZhouNian_Shop_MBuy_InputNumBK:SetProperty("DefaultEditBox", "True")
	ZhouNian_Shop_MBuy_InputNumBK:SetTextOriginal(tostring(g_ZhouNian_Shop_MBuy_OriNum))
	ZhouNian_Shop_MBuy_InputNumBK:SetSelected(0, -1)

	local mId, mItemid, mItemNum, mLimitId, mCostNum, mRemain = Lua_GetZhouNianShopTableByIdx(g_ZhouNian_Shop_MBuy_Item)

	if mId == nil or mId < 0 then
		this:Hide()
		return
	end

	-- Action Button
	local mActionItem = DataPool:CreateBindActionItemForShow( mItemid, mItemNum )
	if mActionItem:GetID() ~= 0 then
		ZhouNian_Shop_MBuy_Item:SetActionItem(mActionItem:GetID())
	end

	ZhouNian_Shop_MBuy_Item_BuyLimitNum:SetText(mRemain)

	if mRemain <= 0 then
		ZhouNian_Shop_MBuy_Item_Mask:Show()
		mRemain = 0
		ZhouNian_Shop_MBuy_InputNumBK:SetTextOriginal(tostring(mRemain))
	else
		ZhouNian_Shop_MBuy_Item_Mask:Hide()
	end

	-- Item Name
	local name = DataPool:LuaFnGetItemNameByTableIndex(mItemid)
	local strname = ScriptGlobal_Format ("#{WYSD_20250807_21}", name)
	ZhouNian_Shop_MBuy_ItemInfo_Text:SetText(strname)

	ZhouNian_Shop_MBuy_ItemInfo_Lilianzhi2:SetText(g_ZhouNian_Shop_MBuy_Color_Y .. tostring (mCostNum))

	local mmid, UpperLimittype, Limittype, UniId, LimitNum = Lua_GetLimitShopTable(mLimitId)

	if mmid >= 0 then
		if Limittype == 2 then
			ZhouNian_Shop_MBuy_Item_ForeverLimit:Hide ()
			ZhouNian_Shop_MBuy_Item_WeekLimit:Show ()
		elseif Limittype == 3 then
			ZhouNian_Shop_MBuy_Item_ForeverLimit:Show ()
			ZhouNian_Shop_MBuy_Item_WeekLimit:Hide ()
		else
			ZhouNian_Shop_MBuy_Item_ForeverLimit:Hide ()
			ZhouNian_Shop_MBuy_Item_WeekLimit:Hide ()
		end
	end

	local cur = Lua_GetZhouNianShopCurrency()

	local num = tonumber(ZhouNian_Shop_MBuy_InputNumBK:GetText())
	ZhouNian_Shop_MBuy_PriceNum:SetText(g_ZhouNian_Shop_MBuy_Color_Y .. tostring (mCostNum*num))
	ZhouNian_Shop_MBuy_CashNum:SetText(g_ZhouNian_Shop_MBuy_Color_Y .. tostring (cur))

	this:Show()
end

function ZhouNian_Shop_MBuy_OnHidden()
	this:Hide()
	PushEvent ("OPEN_5YEARS_MBUY_SHOP_CONFIRM", -1, -1)
end

function ZhouNian_Shop_MBuy_OK_Clicked()
	local num = tonumber(ZhouNian_Shop_MBuy_InputNumBK:GetText())

	if num == nil or num == 0 then
		PushDebugMessage ("#{WYSD_20250807_36}")
		return
	end

	PushEvent( "OPEN_5YEARS_MBUY_SHOP_CONFIRM", g_ZhouNian_Shop_MBuy_Item, num )
end

function ZhouNian_Shop_MBuy_Close_Clicked()
	this:Hide()
	PushEvent ("OPEN_5YEARS_MBUY_SHOP_CONFIRM", -1, -1)
end

function ZhouNian_Shop_MBuy_TextChanged()
	local num = tonumber(ZhouNian_Shop_MBuy_InputNumBK:GetText())

	if num == nil then
		return
	end

	local cur = Lua_GetZhouNianShopCurrency()
	local mId, mItemid, mItemNum, mLimitId, mCostNum, mRemain = Lua_GetZhouNianShopTableByIdx(g_ZhouNian_Shop_MBuy_Item)

	if num > mRemain then
		num = mRemain
	end

	if num*mCostNum > cur then
		num = math.floor(cur/mCostNum)
	end

	ZhouNian_Shop_MBuy_InputNumBK:SetTextOriginal(tostring(num))

	ZhouNian_Shop_MBuy_PriceNum:SetText(g_ZhouNian_Shop_MBuy_Color_Y .. tostring (mCostNum*num))
end

function ZhouNian_Shop_MBuy_CalMax()
	local num = 0

	local cur = Lua_GetZhouNianShopCurrency()
	local mId, mItemid, mItemNum, mLimitId, mCostNum, mRemain = Lua_GetZhouNianShopTableByIdx(g_ZhouNian_Shop_MBuy_Item)

	num = math.floor(cur/mCostNum)

	if num > mRemain then
		num = mRemain
	end

	ZhouNian_Shop_MBuy_InputNumBK:SetTextOriginal(tostring(num))

	ZhouNian_Shop_MBuy_PriceNum:SetText(g_ZhouNian_Shop_MBuy_Color_Y .. tostring (mCostNum*num))
end

