local g_Frame_UnifiedPosition
local g_curpage
local g_itemCountPerPage = 12
local g_itemUI
local g_TokenMaxWeekLimit = 300
local g_ZhouNian_Shop_ConvId = {}
local g_ZhouNian_Shop_DayLimitID = 19
local g_ZhouNian_Shop_WeekLimitID = 20
local g_ZhouNian_Shop_MaskToolTip = {
	{ Id = 1, ToolTip = "#{WYSD_20250807_77}" },		-- 翠竹悠悠·琢华
	{ Id = 2, ToolTip = "#{WYSD_20250807_99}" },		-- 五周年头饰
	{ Id = 3, ToolTip = "#{WYSD_20250807_100}" },		-- 五周年头饰
}

--=========
-- PreLoad()
--=========
function ZhouNian_Shop_PreLoad()
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("OPEN_5YEARS_SHOP")
    this:RegisterEvent("UPDATE_5YEARS_SHOP")
end

--=========
-- OnLoad()
--=========
function ZhouNian_Shop_OnLoad()
	g_Frame_UnifiedPosition = ZhouNian_Shop_Frame:GetProperty("UnifiedPosition")

	g_itemUI = {
		{
			Background = ZhouNian_Shop_ItemFrame1,
			ActionButton = ZhouNian_Shop_Item1,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK1,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum1,
			Mask = ZhouNian_Shop_Item_Mask1,
			Name = ZhouNian_Shop_ItemText1,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit1,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit1,
			CostIcon = ZhouNian_Shop_Item1Info_CostIcon1,
			CostText = ZhouNian_Shop_ItemInfo_CostNum1,
			ToolTip = ZhouNian_Shop_ItemTips1,
		},
		{
			Background = ZhouNian_Shop_ItemFrame2,
			ActionButton = ZhouNian_Shop_Item2,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK2,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum2,
			Mask = ZhouNian_Shop_Item_Mask2,
			Name = ZhouNian_Shop_ItemText2,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit2,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit2,
			CostIcon = ZhouNian_Shop_Item2Info_CostIcon2,
			CostText = ZhouNian_Shop_ItemInfo_CostNum2,
			ToolTip = ZhouNian_Shop_ItemTips2,
		},
		{
			Background = ZhouNian_Shop_ItemFrame3,
			ActionButton = ZhouNian_Shop_Item3,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK3,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum3,
			Mask = ZhouNian_Shop_Item_Mask3,
			Name = ZhouNian_Shop_ItemText3,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit3,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit3,
			CostIcon = ZhouNian_Shop_Item3Info_CostIcon3,
			CostText = ZhouNian_Shop_ItemInfo_CostNum3,
			ToolTip = ZhouNian_Shop_ItemTips3,
		},
		{
			Background = ZhouNian_Shop_ItemFrame4,
			ActionButton = ZhouNian_Shop_Item4,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK4,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum4,
			Mask = ZhouNian_Shop_Item_Mask4,
			Name = ZhouNian_Shop_ItemText4,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit4,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit4,
			CostIcon = ZhouNian_Shop_Item4Info_CostIcon4,
			CostText = ZhouNian_Shop_ItemInfo_CostNum4,
			ToolTip = ZhouNian_Shop_ItemTips4,
		},
		{
			Background = ZhouNian_Shop_ItemFrame5,
			ActionButton = ZhouNian_Shop_Item5,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK5,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum5,
			Mask = ZhouNian_Shop_Item_Mask5,
			Name = ZhouNian_Shop_ItemText5,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit5,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit5,
			CostIcon = ZhouNian_Shop_Item5Info_CostIcon5,
			CostText = ZhouNian_Shop_ItemInfo_CostNum5,
			ToolTip = ZhouNian_Shop_ItemTips5,
		},
		{
			Background = ZhouNian_Shop_ItemFrame6,
			ActionButton = ZhouNian_Shop_Item6,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK6,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum6,
			Mask = ZhouNian_Shop_Item_Mask6,
			Name = ZhouNian_Shop_ItemText6,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit6,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit6,
			CostIcon = ZhouNian_Shop_Item6Info_CostIcon6,
			CostText = ZhouNian_Shop_ItemInfo_CostNum6,
			ToolTip = ZhouNian_Shop_ItemTips6,
		},
		{
			Background = ZhouNian_Shop_ItemFrame7,
			ActionButton = ZhouNian_Shop_Item7,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK7,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum7,
			Mask = ZhouNian_Shop_Item_Mask7,
			Name = ZhouNian_Shop_ItemText7,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit7,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit7,
			CostIcon = ZhouNian_Shop_Item7Info_CostIcon7,
			CostText = ZhouNian_Shop_ItemInfo_CostNum7,
			ToolTip = ZhouNian_Shop_ItemTips7,
		},
		{
			Background = ZhouNian_Shop_ItemFrame8,
			ActionButton = ZhouNian_Shop_Item8,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK8,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum8,
			Mask = ZhouNian_Shop_Item_Mask8,
			Name = ZhouNian_Shop_ItemText8,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit8,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit8,
			CostIcon = ZhouNian_Shop_Item8Info_CostIcon8,
			CostText = ZhouNian_Shop_ItemInfo_CostNum8,
			ToolTip = ZhouNian_Shop_ItemTips8,
		},
		{
			Background = ZhouNian_Shop_ItemFrame9,
			ActionButton = ZhouNian_Shop_Item9,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK9,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum9,
			Mask = ZhouNian_Shop_Item_Mask9,
			Name = ZhouNian_Shop_ItemText9,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit9,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit9,
			CostIcon = ZhouNian_Shop_Item9Info_CostIcon9,
			CostText = ZhouNian_Shop_ItemInfo_CostNum9,
			ToolTip = ZhouNian_Shop_ItemTips9,
		},
		{
			Background = ZhouNian_Shop_ItemFrame10,
			ActionButton = ZhouNian_Shop_Item10,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK10,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum10,
			Mask = ZhouNian_Shop_Item_Mask10,
			Name = ZhouNian_Shop_ItemText10,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit10,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit10,
			CostIcon = ZhouNian_Shop_Item10Info_CostIcon10,
			CostText = ZhouNian_Shop_ItemInfo_CostNum10,
			ToolTip = ZhouNian_Shop_ItemTips10,
		},
		{
			Background = ZhouNian_Shop_ItemFrame11,
			ActionButton = ZhouNian_Shop_Item11,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK11,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum11,
			Mask = ZhouNian_Shop_Item_Mask11,
			Name = ZhouNian_Shop_ItemText11,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit11,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit11,
			CostIcon = ZhouNian_Shop_Item11Info_CostIcon11,
			CostText = ZhouNian_Shop_ItemInfo_CostNum11,
			ToolTip = ZhouNian_Shop_ItemTips11,
		},
		{
			Background = ZhouNian_Shop_ItemFrame12,
			ActionButton = ZhouNian_Shop_Item12,
			LimitBackground = ZhouNian_Shop_Item_BuyLimitNumBK12,
			LimitText = ZhouNian_Shop_Item_BuyLimitNum12,
			Mask = ZhouNian_Shop_Item_Mask12,
			Name = ZhouNian_Shop_ItemText12,
			ForeverLimit = ZhouNian_Shop_ItemInfo_ForeverLimit12,
			WeekLimit = ZhouNian_Shop_ItemInfo_WeekLimit12,
			CostIcon = ZhouNian_Shop_Item12Info_CostIcon12,
			CostText = ZhouNian_Shop_ItemInfo_CostNum12,
			ToolTip = ZhouNian_Shop_ItemTips12,
		},
	}

	-- 标题
	ZhouNian_Shop_DragTitleBK:SetText ("#{WYSD_20250807_14}")
	-- 简介
	ZhouNian_Shop_Info:SetText ("#{WYSD_20250807_16}")
	-- 上一页
	ZhouNian_Shop_ItemUpPage:SetText ("#{WYSD_20250807_23}")
	-- 下一页
	ZhouNian_Shop_ItemDownPage:SetText ("#{WYSD_20250807_25}")
	-- 日限购 tip
	ZhouNian_Shop_Currency_MaxDay:SetToolTip ("#{WYSD_20250807_74}")
	-- 周限购 tip
	ZhouNian_Shop_Currency_MaxWeek:SetToolTip ("#{WYSD_20250807_27}")
end

--=========
-- Event
--=========
function ZhouNian_Shop_OnEvent(event)
	if event == "OPEN_5YEARS_SHOP" then
		g_curpage = 1
		ZhouNian_Shop_Update ()
		this:Show ()
	elseif event == "UPDATE_5YEARS_SHOP" then
		if this:IsVisible() then
			ZhouNian_Shop_Update ()
		end
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ZhouNian_Shop_OnClose ()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		ZhouNian_Shop_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		ZhouNian_Shop_On_ResetPos()
	end
end

function ZhouNian_Shop_Clicked(clickId)
	if not g_ZhouNian_Shop_ConvId[clickId] then
		return
	end
	PushEvent( "OPEN_5YEARS_MBUY_SHOP", g_ZhouNian_Shop_ConvId[clickId] )
end

-- 帮助按钮
function ZhouNian_Shop_HelpClicked ()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenHelpUI")
		Set_XSCRIPT_ScriptID(999899)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

-- 上一页
function ZhouNian_Shop_PrevPage ()
	if g_curpage <= 1 then
		ZhouNian_Shop_ItemUpPage:Disable ()
		return
	end
	g_curpage = g_curpage - 1
	ZhouNian_Shop_Update ()
end

-- 下一页
function ZhouNian_Shop_NextPage ()
	local sumpage = ZhouNian_Shop_GetSumPage ()
	if g_curpage >= sumpage then
		ZhouNian_Shop_ItemDownPage:Disable ()
		return
	end
	g_curpage = g_curpage + 1
	ZhouNian_Shop_Update ()
end

--=========
-- 重置
--=========
function ZhouNian_Shop_On_ResetPos()
	ZhouNian_Shop_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--=========
-- 关闭
--=========
function ZhouNian_Shop_OnClose()
	this:Hide()
end

-- 获取最大页数
function ZhouNian_Shop_GetSumPage ()
	local data = Lua_GetZhouNianShopTable ()
	if not data then
		return 0
	end
	return math.ceil (table.getn (data) / g_itemCountPerPage)
end

-- 更新页数
function ZhouNian_Shop_UpdatePage ()
	local sumpage = ZhouNian_Shop_GetSumPage ()
	local str = ScriptGlobal_Format("#{WYSD_20250807_24}", g_curpage, sumpage)
	ZhouNian_ItemShop_PageNum:SetText (str)

	ZhouNian_Shop_ItemUpPage:Enable ()
	ZhouNian_Shop_ItemDownPage:Enable ()

	if g_curpage == 1 then
		ZhouNian_Shop_ItemUpPage:Disable ()
	end

	if g_curpage == sumpage then
		ZhouNian_Shop_ItemDownPage:Disable ()
	end
end

-- 更新代币数量
function ZhouNian_Shop_UpdateToken ()
	local cur, daylimit, weeklimit = Lua_GetZhouNianShopCurrency()
	-- 设置当前拥有 token 数量
	local curtokenstr = ScriptGlobal_Format ("#{WYSD_20250807_75}", cur)
	ZhouNian_Shop_Currency:SetText (curtokenstr)

	local dayLimitId, _1, _2, _3, dayLimitNum = Lua_GetLimitShopTable (g_ZhouNian_Shop_DayLimitID)
	local weekLimitId, _1, _2, _3, weekLimitNum = Lua_GetLimitShopTable (g_ZhouNian_Shop_WeekLimitID)
	-- 设置日限购数据
	if dayLimitId > 0 then
		local daylimitstrtip = ScriptGlobal_Format ("#{WYSD_20250807_73}", dayLimitNum - daylimit)
		ZhouNian_Shop_Currency_MaxDay:SetText (daylimitstrtip)
		ZhouNian_Shop_Currency_MaxDay:Show()
	else
		ZhouNian_Shop_Currency_MaxDay:Hide()
	end

	if weekLimitId > 0 then
		-- 设置周限购数据
		local weeklimitstrtip = ScriptGlobal_Format ("#{WYSD_20250807_26}", weekLimitNum - weeklimit)
		ZhouNian_Shop_Currency_MaxWeek:SetText (weeklimitstrtip)
		ZhouNian_Shop_Currency_MaxWeek:Show()
	else
		ZhouNian_Shop_Currency_MaxWeek:Hide()
	end
end

--=========
-- 更新界面
--=========
function ZhouNian_Shop_Update ()
	ZhouNian_Shop_On_Hide ()
	local data = Lua_GetZhouNianShopTable ()
	if not data then
		return
	end

	if table.getn (data) == 0 then
		return
	end

	for _, one in ipairs (g_itemUI) do
		one.Background:Hide ()
	end

	local sumcount = table.getn (data)
	local beg_index = (g_curpage - 1) * g_itemCountPerPage + 1
	local end_index = math.min (beg_index + g_itemCountPerPage - 1, sumcount)
	local ui_index = 1
	local curDay = tonumber(DataPool:GetServerDayTime())
	-- 清空 id 转换 table
	g_ZhouNian_Shop_ConvId = {}

	for i = beg_index, end_index do
		local one = data[i]
		local ui = g_itemUI[ui_index]
		g_ZhouNian_Shop_ConvId[ui_index] = one.mId
		ui_index = ui_index + 1
		ui.Background:Show ()

		-- Action Button
		local mActionItem = DataPool:CreateBindActionItemForShow(one.mItemId, one.mItemNum)
		if mActionItem:GetID() ~= 0 then
			ui.ActionButton:SetActionItem(mActionItem:GetID())
		end

		ui.ToolTip:Hide()

		-- Mask
		if curDay < one.mSellDate then
			-- PushDebugMessage("SS: " .. tostring (one.mId) .. "|" .. tostring (curDay) .. "|" .. tostring (one.mSellDate))
			for _, msk in g_ZhouNian_Shop_MaskToolTip do
				if msk.Id == one.mId then
					-- PushDebugMessage("Show: " .. tostring (one.mId) .. "|" .. tostring (msk.ToolTip))
					ui.ToolTip:Show()
					ui.ToolTip:SetToolTip(msk.ToolTip)
					break
				end
			end
			ui.Mask:Show()
			ui.ActionButton:Disable()
		else
			ui.Mask:Hide()
			ui.ActionButton:Enable()
		end

		-- Item Name
		local name = DataPool:LuaFnGetItemNameByTableIndex(one.mItemId)
		local strname = ScriptGlobal_Format ("#{WYSD_20250807_21}", name)
		ui.Name:SetText (strname)

		-- Limit Background & Limit Text & Mask & LimitIcon
		if one.mLimitId >= 0 then
			ui.LimitBackground:Show()
			ui.LimitText:SetText (one.mRemainNum)
			if one.mRemainNum == 0 and not ui.Mask:IsVisible() then
				if ui.ToolTip:IsVisible () then
					ui.ToolTip:Hide()
				end
				ui.Mask:Show ()
				ui.ActionButton:Disable()
			end

			local mId, UpperLimittype, Limittype, UniId, LimitNum = Lua_GetLimitShopTable (one.mLimitId)

			if mId >= 0 then
				if Limittype == 2 then
					ui.ForeverLimit:Hide ()
					ui.WeekLimit:Show ()
				elseif Limittype == 3 then
					ui.ForeverLimit:Show ()
					ui.WeekLimit:Hide ()
				else
					ui.ForeverLimit:Hide ()
					ui.WeekLimit:Hide ()
				end
			end
		else
			ui.LimitBackground:Hide()
		end

		-- CostIcon 这个暂时不用改...
		-- CostText
		local strcost = ScriptGlobal_Format("#{WYSD_20250807_20}", one.mCostNum)
		ui.CostText:SetText (strcost)
	end

	ZhouNian_Shop_UpdatePage ()
	ZhouNian_Shop_UpdateToken ()
end

-- 用 Update 关闭子界面
function ZhouNian_Shop_On_Hide ()
	-- PushEvent ("UPDATE_5YEARS_SHOP")
	if(IsWindowShow("ZhouNian_Shop_CurrencyBuy")) then
		CloseWindow("ZhouNian_Shop_CurrencyBuy", true)
	end
	if(IsWindowShow("ZhouNian_Shop_MBuy")) then
		CloseWindow("ZhouNian_Shop_MBuy", true)
	end
	-- 用这个关闭 打开的二次确认界面
	PushEvent ("OPEN_5YEARS_CURRENCY_SHOP_CONFIRM", -1, -1)
end

function ZhouNian_Shop_Currency_BuyClicked()
	PushEvent("OPEN_5YEARS_CURRENCY_SHOP")
end

function ZhouNian_Shop_ReviewClicked()
	PushEvent("OPEN_DRESSPREVIEW", 10126621, 128, 86) --时装\发型\脸型
end