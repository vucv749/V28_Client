----------------------
--2025Q3 周年庆累计消费时装
----------------------

--界面位置
local g_UnifiedPosition = nil
-- 外观激活状态 0 不可激活，1 可激活，2 已激活
local g_ActivateState = {}
-- 累计领奖状态 0 不可领取，1 可领取，2 已领取
local g_PrizeState = {}

-- 外观展示图片
local g_WaiguanWidgets = {}

-- 奖励按钮
local g_PrizeButtons = {}

-- 外观对应的道具Id
local g_WaiGuanCfg = {} -- {{type = x, itemId = y}, {}, ...}

-- 界面操作类型：打开，刷新
local g_UICommandType_Close = 0
local g_UICommandType_Open = 1
local g_UICommandType_Refresh = 2
-- 外观类型：时装，坐骑，幻武
local g_ExteriorType_Fashion = 1
local g_ExteriorType_Ride = 2
local g_ExteriorType_Weapon = 3
-- 激活状态：未获得，待激活，已激活
local g_ActivateState_None = 0
local g_ActivateState_ToBeActivated = 1
local g_ActivateState_Activated = 2
-- 领奖状态
local g_GetPrizeState_None = 0
local g_GetPrizeState_Got = 1

--===============================================
-- PreLoad()
--===============================================
function Cumulative_Appearance_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function Cumulative_Appearance_OnLoad()
	g_UnifiedPosition = Cumulative_Appearance_Frame:GetProperty("UnifiedPosition")	
	g_WaiguanWidgets = {
		[1] = {normal = Cumulative_Appearance_Img_1, lock = Cumulative_Appearance_Img_1_LockImg, get = Cumulative_Appearance_Img_1_Get, preview = Cumulative_Appearance_Info_Preview1}, 
		[2] = {normal = Cumulative_Appearance_Img_2, lock = Cumulative_Appearance_Img_2_LockImg, get = Cumulative_Appearance_Img_2_Get, preview = Cumulative_Appearance_Info_Preview2}, 
		[3] = {normal = Cumulative_Appearance_Img_3, lock = Cumulative_Appearance_Img_3_LockImg, get = Cumulative_Appearance_Img_3_Get, preview = Cumulative_Appearance_Info_Preview3}, 
		-- [4] = {normal = Cumulative_Appearance_Img_3, lock = Cumulative_Appearance_Img_3_LockImg, get = Cumulative_Appearance_Img_3_Get, preview = Cumulative_Appearance_Info_Preview4}, 
	}
	g_PrizeButtons = {
		[1] = {prizeBtn = Cumulative_Appearance_Item1, redPoint = Cumulative_Appearance_RedDot1, received = Cumulative_Appearance_Received1},
		[2] = {prizeBtn = Cumulative_Appearance_Item2, redPoint = Cumulative_Appearance_RedDot2, received = Cumulative_Appearance_Received2},
		[3] = {prizeBtn = Cumulative_Appearance_Item3, redPoint = Cumulative_Appearance_RedDot3, received = Cumulative_Appearance_Received3},
	}
end

--===============================================
-- OnEvent()
--===============================================
function Cumulative_Appearance_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 29203501) then
		--打开/关闭/刷新界面
		local flag = Get_XParam_INT(0)
		if not flag then
			return
		end 
		if flag == g_UICommandType_Close then
			--关界面
			if this:IsVisible() then
				Cumulative_Appearance_OnClose()
			end
			return
		end
		-- 开界面or刷新界面
		if flag == g_UICommandType_Open then
			this:Show()
		end
		
		for i = 1, 3 do
			g_ActivateState[i] = Get_XParam_INT((i-1) * 3 + 1)
			g_WaiGuanCfg[i] = {
				type = Get_XParam_INT((i-1) * 3 + 2),
				itemId = Get_XParam_INT((i-1) * 3 + 3),
			}
		end
		g_PrizeState = {Get_XParam_INT(10), Get_XParam_INT(11), Get_XParam_INT(12)}
		if this:IsVisible() then
			Cumulative_Appearance_Update()
		end
	elseif (event == "ADJEST_UI_POS") then
		Cumulative_Appearance_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Cumulative_Appearance_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Cumulative_Appearance_OnClose()
	end
end

--===============================================
--刷新
--===============================================
function Cumulative_Appearance_Update()
	local activatedCount = 0
	for i = 1, table.getn(g_WaiguanWidgets) do
		local cfg = g_WaiGuanCfg[i]
		local widget = g_WaiguanWidgets[i]
		local state = g_ActivateState[i]
		if state == g_ActivateState_ToBeActivated then -- 可激活
			widget.lock:Hide()
			widget.get:Hide()
		elseif state == g_ActivateState_Activated then -- 已激活
			-- if i <= 3 then
				activatedCount = activatedCount + 1
			-- end
			widget.lock:Hide()
			widget.get:Show()
		else -- 不可激活
			widget.lock:Show()
			widget.get:Hide()
		end
		if cfg.type == g_ExteriorType_Weapon then
			widget.preview:Hide()
		else
			widget.preview:Show()
		end
	end
	Cumulative_Appearance_TextTips:SetText(ScriptGlobal_Format("#{LJSZ_250808_15}", activatedCount))
	for i = 1, table.getn(g_PrizeButtons) do
		local btn = g_PrizeButtons[i]
		local state = g_PrizeState[i]
		if state == g_GetPrizeState_Got then -- 已领取
			btn.redPoint:Hide()
			btn.received:Show()
			btn.prizeBtn:Hide()
		else -- 不可/未领取
			if i <= activatedCount then
				btn.redPoint:Show()
			else
				btn.redPoint:Hide()
			end
			btn.received:Hide()
			btn.prizeBtn:Show()
		end
	end
end

--===============================================
--重置
--===============================================
function Cumulative_Appearance_ResetPos()
	Cumulative_Appearance_Frame:SetProperty("UnifiedPosition", g_UnifiedPosition)
end

--===============================================
--关闭
--===============================================
function Cumulative_Appearance_OnClose()
	--界面隐藏
	this:Hide()
end

--===============================================
--领奖
--===============================================
function Cumulative_Appearance_Reward_OnRewardClick(index)
	if index == nil then
		return
	end
	if index < 1 or index > 3 then
		return
	end
	--兑换
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetPrize")
		Set_XSCRIPT_ScriptID(292035)
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--===============================================
--关于 -- Quest.lua
--===============================================
function Cumulative_Appearance_HelpClicked()
	PushEvent("CCSHOP_HELP", 39)
end

--===============================================
--打开元宝商店
--===============================================
function Cumulative_Appearance_ShopClicked()
	Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(292035)
        Set_XSCRIPT_Function_Name("OpenYuanbaoShop")
        Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--===============================================
--时装预览
--===============================================
function Cumulative_Appearance_OnView(index)
	local cfg = g_WaiGuanCfg[index]
	if not cfg then
		return
	end
	if cfg.type == g_ExteriorType_Ride then -- 坐骑
		local nExteriorRideId = Exterior:LuaFnGetExteriorIdByItem(cfg.itemId)
		PushEvent("OPEN_RIDE_PREVIEW", nExteriorRideId)
	elseif cfg.type == g_ExteriorType_Weapon then -- 幻武
		-- PushEvent("OPEN_GEMEFFECTPREVIEW", cfg.itemId)
	elseif cfg.type == g_ExteriorType_Fashion then -- 时装
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(292035)
			Set_XSCRIPT_Function_Name("DressPreview")
			Set_XSCRIPT_Parameter(0, index)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end
