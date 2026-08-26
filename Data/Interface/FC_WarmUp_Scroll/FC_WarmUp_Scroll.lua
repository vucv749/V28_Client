
--预热道具页面

local g_FC_WarmUp_Scroll_Frame_UnifiedPosition

function FC_WarmUp_Scroll_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");		
end

function FC_WarmUp_Scroll_OnLoad()
	g_FC_WarmUp_Scroll_Frame_UnifiedPosition = FC_WarmUp_Scroll_Frame:GetProperty("UnifiedPosition");
end

function FC_WarmUp_Scroll_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99974601 ) then
		
		this:Show()
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		FC_WarmUp_Scroll_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FC_WarmUp_Scroll_ResetPos()	
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide()		
	end
end

function FC_WarmUp_Scroll_Hide()
	this:Hide()
end

function FC_WarmUp_Scroll_Frame_OnHiden()
	this:Hide()
end

function FC_WarmUp_Scroll_Closed()
	FC_WarmUp_Scroll_Hide()
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function FC_WarmUp_Scroll_ResetPos()
  FC_WarmUp_Scroll_Frame:SetProperty("UnifiedPosition", g_FC_WarmUp_Scroll_Frame_UnifiedPosition);
end
