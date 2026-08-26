--******************************************
--组队藏宝图副本 进本的tips界面
--create by  limengyue 
--2024-07-09
--******************************************
local g_CangBao_Tips_Frame_UnifiedPosition;

--服务器不传字典 直接传编号提示
local g_CangBao_TipsList = 
{
	[1] = {tips="#{ZDBT_240703_38}",nTime=6},--击杀入门boss
	[2] = {tips="#{ZDBT_240703_209}",nTime=6},--捡金币
	[3] = {tips="#{ZDBT_240703_68}",nTime=6},--群小怪
	[4] = {tips="#{ZDBT_240703_70}",nTime=6},--接宝箱
	[5] = {tips="#{ZDBT_240703_206}",nTime=6},--躲避球
	[6] = {tips="#{ZDBT_240703_47}",nTime=6},--结算房间
}


--=========================================================
--PreLoad
--=========================================================
function CangBao_Tips_PreLoad()
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
function CangBao_Tips_OnLoad()
	g_CangBao_Tips_Frame_UnifiedPosition = CangBao_Tips:GetProperty("UnifiedPosition");
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function CangBao_Tips_On_ResetPos()

	CangBao_Tips:SetProperty("UnifiedPosition", g_CangBao_Tips_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_Tips_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340301 ) then
		--打开界面
		if(IsWindowShow("CangBao_Tips")) then
			CloseWindow("CangBao_Tips", true)
		end
		CangBao_Tips_Open(Get_XParam_INT(0))
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_Tips_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_Tips_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_Tips_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--=========================================================
function CangBao_Tips_Open(nTipsIdx)
	if nTipsIdx < 0 then
		--关闭界面
		CangBao_Tips_Close()
	else
		if g_CangBao_TipsList[nTipsIdx] then
			CangBao_Tips_Text:SetText(g_CangBao_TipsList[nTipsIdx].tips)
			--倒计时
			SetTimer("CangBao_Tips","CangBao_Tips_Close()", g_CangBao_TipsList[nTipsIdx].nTime*1000);		--设置定时器5秒钟倒计时
			this:Show()
		end
	end

end
--=========================================================
--关闭界面
--=========================================================
function CangBao_Tips_Close()
	KillTimer("CangBao_Tips_Close()")
	this:Hide()
end
