--CaiLing界面
local g_CaiLing_Str_LingqiState =
{
	[1] = "#{CLCW_240328_72}", --??
	[2] = "#{CLCW_240328_73}", --??
	[3] = "#{CLCW_240328_74}", --??
}
local g_CaiLing_Str_TDRFlag =
{
	[1] = "#{CLCW_240328_84}", --?
	[2] = "#{CLCW_240328_85}", --?
	[3] = "#{CLCW_240328_86}", --?
}
local g_CaiLing_Str_NowLingqi = "#{CLCW_240328_71}" --???????
--变量
local g_CaiLing_Param_NowLingqi = 0
local g_CaiLing_Param_LingqiState = 0
local g_CaiLing_Param_Flag = 0 --????? 1-3
--控件
local g_CaiLing_Frame_UnifiedXPosition
local g_CaiLing_Frame_UnifiedYPosition
--uicommand
local g_CaiLing_Uicmd = 89036102
local g_CaiLing_Uicmd_Op = { open = 1, close = 2, updateLingqi = 3, }

function CaiLing_PreLoad()
	-- uicommand
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false) --??????????????????,???true
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	-- 切换场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function CaiLing_OnLoad()
	-- 保存界面的默认相对位置
	g_CaiLing_Frame_UnifiedXPosition = CaiLing_Frame:GetProperty("UnifiedXPosition");
	g_CaiLing_Frame_UnifiedYPosition = CaiLing_Frame:GetProperty("UnifiedYPosition");
end

function CaiLing_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == g_CaiLing_Uicmd then
		local uicmdOp = Get_XParam_INT(0)
		if uicmdOp == g_CaiLing_Uicmd_Op.open then
			local lingqiState = Get_XParam_INT(1) --???0
			local flag = Get_XParam_INT(2) --???0
			if lingqiState < 1 or lingqiState > 3 or flag < 1 or flag > 3 then
				return 0
			end
			CaiLing_OnOpen(lingqiState, flag)
			CaiLing_UpdateUI()
			this:Show()
		elseif uicmdOp == g_CaiLing_Uicmd_Op.close then
			CaiLing_OnClose()
			this:Hide()
		elseif uicmdOp == g_CaiLing_Uicmd_Op.updateLingqi then
			if this:IsVisible() then
				local lingqi = Get_XParam_INT(1)
				if lingqi < 0 then
					lingqi = 0
				end
				if lingqi > g_CaiLing_Param_NowLingqi then--?????? ??????????????????
					g_CaiLing_Param_NowLingqi = lingqi
					CaiLing_UpdateUI()
				end
			end
		end
	elseif event == "ADJEST_UI_POS" then
		CaiLing_UpdateUIPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		CaiLing_UpdateUIPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CaiLing_OnClose()
		this:Hide()
	end
	return 1
end

function CaiLing_UpdateUI()
	local lingqiStr = ScriptGlobal_Format(g_CaiLing_Str_NowLingqi, tostring(g_CaiLing_Param_NowLingqi))
	CaiLing_Text1:SetText(lingqiStr)
	if g_CaiLing_Param_LingqiState >= 1 and g_CaiLing_Param_LingqiState <= 3 and
		g_CaiLing_Str_LingqiState[g_CaiLing_Param_LingqiState] ~= nil and
		g_CaiLing_Param_Flag >= 1 and g_CaiLing_Param_Flag <= 3 and g_CaiLing_Str_TDRFlag[g_CaiLing_Param_Flag] ~= nil then
		local flagStr = g_CaiLing_Str_TDRFlag[g_CaiLing_Param_Flag]
		local lingqiStateStr = " "
		if g_CaiLing_Param_LingqiState ~= 3 then
			lingqiStateStr = ScriptGlobal_Format(g_CaiLing_Str_LingqiState[g_CaiLing_Param_LingqiState], flagStr)
		else
			lingqiStateStr = g_CaiLing_Str_LingqiState[g_CaiLing_Param_LingqiState]
		end
		CaiLing_Text2:SetText(lingqiStateStr)
		CaiLing_Text2:Show()
	else
		CaiLing_Text2:Hide()
	end
end

--开启界面设置变量
function CaiLing_OnOpen(lingqiState, flag)
	g_CaiLing_Param_NowLingqi = 0
	g_CaiLing_Param_LingqiState = lingqiState
	g_CaiLing_Param_Flag = flag
end

--关睜界面初始化变量
function CaiLing_OnClose()
	g_CaiLing_Param_NowLingqi = 0
	g_CaiLing_Param_LingqiState = 0
	g_CaiLing_Param_Flag = 0
end

--适应屏幕变化
function CaiLing_UpdateUIPos()
	CaiLing_Frame:SetProperty("UnifiedXPosition", g_CaiLing_Frame_UnifiedXPosition);
	CaiLing_Frame:SetProperty("UnifiedYPosition", g_CaiLing_Frame_UnifiedYPosition);
end
