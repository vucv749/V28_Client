--CaiLing_CountDown界面
--控件
local g_CaiLing_CountDown_Frame_UnifiedXPosition
local g_CaiLing_CountDown_Frame_UnifiedYPosition
--uicommand
local g_CaiLing_CountDown_Uicmd = 89036103

function CaiLing_CountDown_PreLoad()
	-- uicommand
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false) --第二个参数代表界面隐藏时事件是否有效,默认为true
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	-- 切换场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function CaiLing_CountDown_OnLoad()
	-- 保存界面的默认相对位置
	g_CaiLing_CountDown_Frame_UnifiedXPosition = CaiLing_CountDown_Frame:GetProperty("UnifiedXPosition");
	g_CaiLing_CountDown_Frame_UnifiedYPosition = CaiLing_CountDown_Frame:GetProperty("UnifiedYPosition");
end

function CaiLing_CountDown_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == g_CaiLing_CountDown_Uicmd then
		local openOrClose = Get_XParam_INT(0)
		if openOrClose == 1 then
			this:Show()
			CaiLing_CountDown_Animate:Play(true)
		else
			this:Hide()
			CaiLing_CountDown_Animate:Play(false)
		end
	elseif event == "ADJEST_UI_POS" then
		CaiLing_CountDown_UpdateUIPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		CaiLing_CountDown_UpdateUIPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	return 1
end

--适应屏幕变化
function CaiLing_CountDown_UpdateUIPos()
	CaiLing_CountDown_Frame:SetProperty("UnifiedXPosition", g_CaiLing_CountDown_Frame_UnifiedXPosition);
	CaiLing_CountDown_Frame:SetProperty("UnifiedYPosition", g_CaiLing_CountDown_Frame_UnifiedYPosition);
end
