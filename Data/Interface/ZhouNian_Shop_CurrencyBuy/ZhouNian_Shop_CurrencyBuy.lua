local g_ZhouNian_Shop_CurrencyBuy_Frame_UnifiedXPosition
local g_ZhouNian_Shop_CurrencyBuy_Frame_UnifiedYPosition
local g_ZhouNian_Shop_CurrencyBuy_nSearch = 0
local g_ZhouNian_Shop_CurrencyBuy_Item = -1
local g_ZhouNian_Shop_CurrencyBuy_CaredNpc = -1
local g_ZhouNian_Shop_CurrencyBuy_OriNum = 1
local g_ZhouNian_Shop_CurrencyBuy_Color_Y = "#cfff263"

-- X 个元宝兑换一个token
local g_ZhouNian_Shop_Yuanbao2token = 10
local g_ZhouNian_Shop_CurrencyBuy_YBConvTokenLimitId = 21

function ZhouNian_Shop_CurrencyBuy_PreLoad()
	this:RegisterEvent("OPEN_5YEARS_CURRENCY_SHOP")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	-- this:RegisterEvent("UPDATE_5YEARS_SHOP")
end

function ZhouNian_Shop_CurrencyBuy_OnLoad()
	g_ZhouNian_Shop_CurrencyBuy_Frame_UnifiedXPosition = ZhouNian_Shop_CurrencyBuy_Frame:GetProperty("UnifiedXPosition")
	g_ZhouNian_Shop_CurrencyBuy_Frame_UnifiedYPosition = ZhouNian_Shop_CurrencyBuy_Frame:GetProperty("UnifiedYPosition")
end

function ZhouNian_Shop_CurrencyBuy_OnEvent(event)
	if ( event == "OPEN_5YEARS_CURRENCY_SHOP" ) then
		ZhouNian_Shop_CurrencyBuy_Update()
		this:Show()
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then 
		ZhouNian_Shop_CurrencyBuy_OnHidden()
	elseif ( event == "ADJEST_UI_POS" ) then
		ZhouNian_Shop_CurrencyBuy_Frame_On_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		ZhouNian_Shop_CurrencyBuy_Frame_On_ResetPos()
	-- elseif ( event == "UPDATE_5YEARS_SHOP" ) then
	-- 	this:Hide()
	end
end

function ZhouNian_Shop_CurrencyBuy_Frame_On_ResetPos()
	ZhouNian_Shop_CurrencyBuy_Frame:SetProperty( "UnifiedXPosition", g_ZhouNian_Shop_CurrencyBuy_Frame_UnifiedXPosition )
	ZhouNian_Shop_CurrencyBuy_Frame:SetProperty( "UnifiedYPosition", g_ZhouNian_Shop_CurrencyBuy_Frame_UnifiedYPosition )
end

function ZhouNian_Shop_CurrencyBuy_Update()
	ZhouNian_Shop_CurrencyBuy_InputNumBK:SetProperty("DefaultEditBox", "True")
	ZhouNian_Shop_CurrencyBuy_InputNumBK:SetTextOriginal(tostring(g_ZhouNian_Shop_CurrencyBuy_OriNum))
	ZhouNian_Shop_CurrencyBuy_InputNumBK:SetSelected(0, -1)

	local num = tonumber(ZhouNian_Shop_CurrencyBuy_InputNumBK:GetText())
	if num == nil then
		num = 0
	end
	local needmoney = num * g_ZhouNian_Shop_Yuanbao2token
	ZhouNian_Shop_CurrencyBuy_PriceNum:SetText(g_ZhouNian_Shop_CurrencyBuy_Color_Y .. tostring (needmoney))

	local money = Player:GetData("YUANBAO")
	ZhouNian_Shop_CurrencyBuy_CashNum:SetText(g_ZhouNian_Shop_CurrencyBuy_Color_Y .. tostring (money))
end

function ZhouNian_Shop_CurrencyBuy_OnHidden()
	this:Hide()
	PushEvent ("OPEN_5YEARS_CURRENCY_SHOP_CONFIRM", -1, -1)
end

function ZhouNian_Shop_CurrencyBuy_OK_Clicked()
	local num = tonumber(ZhouNian_Shop_CurrencyBuy_InputNumBK:GetText())
	if num == nil or num <= 0 then
		PushDebugMessage ("#{WYSD_20250807_51}")
		return
	end

	PushEvent( "OPEN_5YEARS_CURRENCY_SHOP_CONFIRM", g_ZhouNian_Shop_Yuanbao2token * num, num )
end

function ZhouNian_Shop_CurrencyBuy_Close_Clicked()
	this:Hide()
	PushEvent ("OPEN_5YEARS_CURRENCY_SHOP_CONFIRM", -1, -1)
end

function ZhouNian_Shop_CurrencyBuy_TextChanged()
	local num = tonumber(ZhouNian_Shop_CurrencyBuy_InputNumBK:GetText())
	if num == nil then
		return
	end

	local money = Player:GetData("YUANBAO")
	local cur = Lua_GetZhouNianShopCurrency()
	local _1, _2, _3, remain = Lua_GetZhouNianShopCurrency ()
	local tar = num
	if tar > remain then
		tar = remain
	end	

	if tar * g_ZhouNian_Shop_Yuanbao2token > money then
		tar = math.floor(money / g_ZhouNian_Shop_Yuanbao2token)
	end

	if tar + cur > 999999 then
		tar = 999999 - cur
	end

	if tar ~= num then
		num = tar
		ZhouNian_Shop_CurrencyBuy_InputNumBK:SetText(tostring(num))
	end

	local needmoney = num * g_ZhouNian_Shop_Yuanbao2token
	ZhouNian_Shop_CurrencyBuy_PriceNum:SetText(g_ZhouNian_Shop_CurrencyBuy_Color_Y .. tostring (needmoney))
end

function ZhouNian_Shop_CurrencyBuy_CalMax()
	local num = 0

	local money = Player:GetData("YUANBAO")
	local cur = Lua_GetZhouNianShopCurrency()

	num = math.floor(money / g_ZhouNian_Shop_Yuanbao2token)

	if num + cur > 999999 then
		num = 999999 - cur
	end

	local _1, _2, _3, remain = Lua_GetZhouNianShopCurrency ()
	if num > remain then
		num = remain
	end	

	ZhouNian_Shop_CurrencyBuy_InputNumBK:SetText(tostring(num))

	local needmoney = num * g_ZhouNian_Shop_Yuanbao2token
	ZhouNian_Shop_CurrencyBuy_PriceNum:SetText(g_ZhouNian_Shop_CurrencyBuy_Color_Y .. tostring (needmoney))
end

