local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local Makefriends_Activity_Mini_UnifiedPosition = nil
function Makefriends_Activity_Mini_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("JIAOYOU_SHOW_MINI")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UI_COMMAND")
end

function Makefriends_Activity_Mini_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Makefriends_Activity_Mini_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Makefriends_Activity_Mini_Frame:GetProperty("UnifiedYPosition");
	Makefriends_Activity_Mini_UnifiedPosition = Makefriends_Activity_Mini_Frame:GetProperty("UnifiedPosition")
end

function Makefriends_Activity_Mini_OnEvent(event)

	if( event == "ADJEST_UI_POS" ) then
		Makefriends_Activity_Mini_ResetPos()
	 elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_Activity_Mini_ResetPos()
	--elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
	--	this:Hide();
	elseif( event == "JIAOYOU_SHOW_MINI" ) then
		this:Show();
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 998329003) then	--比赛结束
		this:Hide()
	end
	
end

function Makefriends_Activity_Mini_ResetPos()

	Makefriends_Activity_Mini_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Makefriends_Activity_Mini_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
	if (Makefriends_Activity_Mini_UnifiedPosition ~= nil) then
		Makefriends_Activity_Mini_Frame:SetProperty("UnifiedPosition", Makefriends_Activity_Mini_UnifiedPosition)
	end

end

function Makefriends_Activity_Mini_OnShowNormalUI()
	this:Hide()
	PushEvent( "JIAOYOU_SHOW_BIG" )
end