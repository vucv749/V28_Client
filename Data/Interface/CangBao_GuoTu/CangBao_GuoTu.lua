--******************************************
--组队藏宝图副本 切玩法特效界面
--create by  limengyue 
--2024-08-12
--******************************************
local g_CangBao_GuoTu_Frame_UnifiedPosition;

--动画时长 单位秒
local g_CangBao_AnimationTime = 5


--=========================================================
--PreLoad
--=========================================================
function CangBao_GuoTu_PreLoad()
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
function CangBao_GuoTu_OnLoad()
	g_CangBao_GuoTu_Frame_UnifiedPosition = CangBao_GuoTu:GetProperty("UnifiedPosition");
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function CangBao_GuoTu_On_ResetPos()

	CangBao_GuoTu:SetProperty("UnifiedPosition", g_CangBao_GuoTu_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_GuoTu_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340330 ) then
		--打开界面
		if(IsWindowShow("CangBao_GuoTu")) then
			CloseWindow("CangBao_GuoTu", true)
		end
		CangBao_GuoTu_Open(Get_XParam_INT(0))
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_GuoTu_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_GuoTu_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_GuoTu_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--=========================================================
function CangBao_GuoTu_Open(nType)
	if nType < 0 then
		--关闭界面
		CangBao_GuoTu_Close()
	else
		--打开界面
		--PushDebugMessage("过去界面show")
		--播放动画
		CangBao_GuoTu_Eff:Show();
		--倒计时
		SetTimer("CangBao_GuoTu","CangBao_GuoTu_Close()", g_CangBao_AnimationTime*1000);		--设置定时器5秒钟倒计时
		this:Show()
	end

end
--=========================================================
--关闭界面
--=========================================================
function CangBao_GuoTu_Close()
	KillTimer("CangBao_GuoTu_Close()")
	this:Hide()
end
