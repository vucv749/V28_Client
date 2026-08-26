--******************************
--屏幕闪烁特效
--******************************

local g_YanMenMeng_Tips_Frame_UnifiedPosition;

function YanMenMeng_Tips_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

function YanMenMeng_Tips_OnLoad()
	-- 保存界面的默认相对位置
	g_YanMenMeng_Tips_Frame_UnifiedPosition = YanMenMeng_Tips_Frame:GetProperty("UnifiedPosition");
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function YanMenMeng_Tips_Frame_On_ResetPos()
	YanMenMeng_Tips_Frame : SetProperty("UnifiedPosition", g_YanMenMeng_Tips_Frame_UnifiedPosition);
end

function YanMenMeng_Tips_OnEvent(event)

	if( event == "UI_COMMAND" and tonumber(arg0) == 99844502) then
		SetTimer("YanMenMeng_Tips","YanMenMeng_Tips_TimerProc()", 5000)
		this:Show()
		-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		YanMenMeng_Tips_Frame_On_ResetPos()
		-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		YanMenMeng_Tips_Frame_On_ResetPos()
	elseif event=="HIDE_ON_SCENE_TRANSED"  then
		YanMenMeng_Tips_OnHiden()
	end

end

function YanMenMeng_Tips_OnHiden()
	KillTimer("YanMenMeng_Tips_TimerProc")
	this:Hide()
end

function YanMenMeng_Tips_TimerProc()
	--PushDebugMessage("YanMenMeng_Tips_TimerProc")
	KillTimer("YanMenMeng_Tips_TimerProc()")
	this:Hide()
end

