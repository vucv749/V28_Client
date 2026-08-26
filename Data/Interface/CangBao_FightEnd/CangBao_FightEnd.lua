--******************************************
--组队藏宝图副本 进本的tips界面
--create by  limengyue 
--2024-07-09
--******************************************
local g_CangBao_FightEnd_Frame_UnifiedPosition;

--=========================================================
--PreLoad
--=========================================================
function CangBao_FightEnd_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function CangBao_FightEnd_OnLoad()
	g_CangBao_FightEnd_Frame_UnifiedPosition = CangBao_FightEnd_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function CangBao_FightEnd_On_ResetPos()

	CangBao_FightEnd_Frame:SetProperty("UnifiedPosition", g_CangBao_FightEnd_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_FightEnd_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340302 ) then
		--打开界面
		if(IsWindowShow("CangBao_FightEnd")) then
			CloseWindow("CangBao_FightEnd", true)
		end
		CangBao_FightEnd_Open(Get_XParam_INT(0))
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_FightEnd_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_FightEnd_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_FightEnd_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--=========================================================
function CangBao_FightEnd_Open(nTipsIdx)
	if nTipsIdx < 0 then
		--关闭界面
		CangBao_FightEnd_Close()
	else
		SetTimer("CangBao_FightEnd","CangBao_FightEnd_Close()", 3);		--设置定时器5秒钟倒计时
		this:Show()
	end

end
--=========================================================
--关闭界面
--=========================================================
function CangBao_FightEnd_Close()
	KillTimer("CangBao_FightEnd_Close()")
	this:Hide()
end