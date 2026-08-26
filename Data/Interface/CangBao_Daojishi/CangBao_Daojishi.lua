--******************************************
--组队藏宝图副本 进本的tips界面
--create by  limengyue 
--2024-07-09
--******************************************
local g_CangBao_Daojishi_Frame_UnifiedPosition;

--boss正计时
local g_CangBao_BossTimer = 0
--幸运等级
local g_CangBao_LuckyPoint = 
{
	[1] = {nMin=0,nMax=199,nLevel=1},
	[2] = {nMin=200,nMax=499,nLevel=2},
	[3] = {nMin=500,nMax=699,nLevel=3},
	[4] = {nMin=700,nMax=2000,nLevel=4},
}

--每个阶段显示什么
local g_CangBao_RoomTips = 
{
	[1] = {Title="#{ZDBT_240703_272}",nTips1="#{ZDBT_240703_78}",nMemo="初始房间",},
	[2] = {Title="#{ZDBT_240703_273}",nTips1="#{ZDBT_240703_82}",nMemo="大boss房间",},
	[3] = {Title="#{ZDBT_240703_275}",nTips1="#{ZDBT_240703_84}",nMemo="开宝箱房间",},
	[4] = {Title="#{ZDBT_240703_277}",nTips1="#{ZDBT_240703_296}",nMemo="捡金币房间",},
	[5] = {Title="#{ZDBT_240703_276}",nTips1="#{ZDBT_240703_294}",nMemo="小怪房间",},
	[6] = {Title="#{ZDBT_240703_278}",nTips1="#{ZDBT_240703_298}",nMemo="接宝箱房间",},
	[7] = {Title="#{ZDBT_240703_279}",nTips1="#{ZDBT_240703_300}",nMemo="躲避球房间",},
	[8] = {Title="#{ZDBT_240703_274}",nTips1="#{ZDBT_240703_83}",nMemo="小boss房间",},
	[9] = {Title="#{ZDBT_240703_280}",nTips1="#{ZDBT_240703_281}",nMemo="结算房间",},
}


--=========================================================
--PreLoad
--=========================================================
function CangBao_Daojishi_PreLoad()
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
function CangBao_Daojishi_OnLoad()
	g_CangBao_Daojishi_Frame_UnifiedPosition = CangBao_Daojishi:GetProperty("UnifiedPosition");
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function CangBao_Daojishi_On_ResetPos()

	CangBao_Daojishi:SetProperty("UnifiedPosition", g_CangBao_Daojishi_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_Daojishi_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340310 ) then
		--打开界面
		if(IsWindowShow("CangBao_Daojishi")) then
			CloseWindow("CangBao_Daojishi", true)
		end
		CangBao_Daojishi_Open(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4))
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_Daojishi_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_Daojishi_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_Daojishi_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--nLuckyPoint幸运值
--nStage 阶段 对应g_CangBao_RoomTips的idx
--nState 状态 0 1 2 关卡未开启  已开启  已结束 3关卡结束耗尽
--nRemainTime玩法剩余时间
--nParam1 参数变量
--=========================================================
function CangBao_Daojishi_Open(nLuckyPoint,nStage,nState,nRemainTime,nParam1)
	--PushDebugMessage("test open nLuckyPoint="..nLuckyPoint.." nStage="..nStage.." nState="..nState.." nRemainTime="..nRemainTime.." nParam1="..nParam1 )
	if nStage < 1 or nStage >  table.getn(g_CangBao_RoomTips) then
		PushDebugMessage("数据非法")
		return
	end
	--自己算分值段
	local nLevel = g_CangBao_LuckyPoint[1].nLevel
	local nCurMax = g_CangBao_LuckyPoint[1].nMax - g_CangBao_LuckyPoint[1].nMin
	local nCurValue =  nLuckyPoint - g_CangBao_LuckyPoint[1].nMin --当前分值占据当前最大数值百分比计算用值
	local nMaxLen = table.getn(g_CangBao_LuckyPoint)
	if nLuckyPoint > g_CangBao_LuckyPoint[nMaxLen].nMax then
		nLevel = g_CangBao_LuckyPoint[nMaxLen].nLevel
		nCurMax = g_CangBao_LuckyPoint[nMaxLen].nMax - g_CangBao_LuckyPoint[nMaxLen].nMin+1
		nCurValue =  nCurMax
	else
		for index=1,table.getn(g_CangBao_LuckyPoint)  do
			if index == 1 then
				if nLuckyPoint >= g_CangBao_LuckyPoint[index].nMin and nLuckyPoint <= g_CangBao_LuckyPoint[index].nMax then
					nLevel = g_CangBao_LuckyPoint[index].nLevel
					nCurMax = g_CangBao_LuckyPoint[index].nMax - g_CangBao_LuckyPoint[index].nMin
					nCurValue =  nLuckyPoint - g_CangBao_LuckyPoint[index].nMin
				end
			else
				if nLuckyPoint >= g_CangBao_LuckyPoint[index].nMin and nLuckyPoint <= g_CangBao_LuckyPoint[index].nMax then
					nLevel = g_CangBao_LuckyPoint[index].nLevel
					nCurMax = g_CangBao_LuckyPoint[index].nMax - g_CangBao_LuckyPoint[index].nMin+1
					nCurValue =  nLuckyPoint - g_CangBao_LuckyPoint[index-1].nMax 
				end
			end
		end
	end

	--进度条显示
	CangBao_Daojishi_Text2:SetText(nLevel);
	CangBao_Daojishi_Text3:SetText(nCurValue.."/"..nCurMax);
	CangBao_Daojishi_Progress:SetProgress(nCurValue, nCurMax)
	
	--title
	CangBao_Daojishi_Pair_Title1:SetText(g_CangBao_RoomTips[nStage].Title);
	--固定文字
	CangBao_Daojishi_Pair_Text1:SetText(g_CangBao_RoomTips[nStage].nTips1);
	--默认
	CangBao_Daojishi_Pair_Text2:Hide();
	KillTimer("CangBao_Daojishi_Timer()")
	--阶段
	if nState == 0 then
		if nStage == 3 or nStage == 9 then
			CangBao_Daojishi_Pair_Text3:Hide();
		else
			CangBao_Daojishi_Time:Hide();
			CangBao_Daojishi_Pair_Text3:Show();
			CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_81}");
		end
	elseif nState == 1 then
		CangBao_Daojishi_Pair_Text3:Show();
		--如果是boss阶段
		if nStage == 1 or nStage == 2 or nStage == 8 then
			--正计时
			CangBao_Daojishi_Time:Hide();
			g_CangBao_BossTimer = nRemainTime
			local  nTimeStringMin = ""
			local  nTimeStringSec = ""
			local mMinute = math.floor(g_CangBao_BossTimer / 60)
			local mSecond = math.mod(g_CangBao_BossTimer, 60)
			if mMinute < 10 then
				nTimeStringMin =  "0"..tostring(mMinute)
			else
				nTimeStringMin = tostring(mMinute)
			end
			if mSecond < 10 then
				nTimeStringSec = "0"..tostring(mSecond)
			else
				nTimeStringSec = tostring(mSecond)
			end
			
			CangBao_Daojishi_Pair_Text3:SetText(ScriptGlobal_Format("#{ZDBT_240703_306}",nTimeStringMin,nTimeStringSec));	
			--挂计时器
			SetTimer("CangBao_Daojishi","CangBao_Daojishi_Timer()", 1000);--计时
		else
			CangBao_Daojishi_Time:Show();
			CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_92}");
			--剩余时间
			if nRemainTime > 0 then
				CangBao_Daojishi_Time:SetProperty("Timer", tostring(nRemainTime))
			else
				CangBao_Daojishi_Time:SetProperty("Timer", "0")
			end
		end
	elseif nState == 2 then
		CangBao_Daojishi_Time:Hide();
		CangBao_Daojishi_Pair_Text3:Show();
		CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_80}");
	else
		CangBao_Daojishi_Time:Hide();
		CangBao_Daojishi_Pair_Text3:Show();
		CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_90}");
	end
	--玩法进行时的显示
	if nState == 1 then
		if nStage == 4 then
			--捡金币
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_297}",nParam1));		
		elseif nStage == 5 then
			--杀小怪
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_295}",nParam1));	
		elseif nStage == 6 then
			--接宝箱
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_299}",nParam1));	
		elseif nStage == 7 then
			--躲避球
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_301}",nParam1));	
		end
	end
	
	this:Show()
end


--=========================================================
--计时器
--=========================================================
function CangBao_Daojishi_Timer()
	KillTimer("CangBao_Daojishi_Timer()")
	if(IsWindowShow("CangBao_Daojishi")) then
		g_CangBao_BossTimer = g_CangBao_BossTimer + 1
		local  nTimeStringMin = ""
		local  nTimeStringSec = ""
		local mMinute = math.floor(g_CangBao_BossTimer / 60)
		local mSecond = math.mod(g_CangBao_BossTimer, 60)
		if mMinute < 10 then
			nTimeStringMin =  "0"..tostring(mMinute)
		else
			nTimeStringMin = tostring(mMinute)
		end
		
		if mSecond < 10 then
			nTimeStringSec = "0"..tostring(mSecond)
		else
			nTimeStringSec = tostring(mSecond)
		end
		
		CangBao_Daojishi_Pair_Text3:SetText(ScriptGlobal_Format("#{ZDBT_240703_306}",nTimeStringMin,nTimeStringSec));	
		--挂计时器
		SetTimer("CangBao_Daojishi","CangBao_Daojishi_Timer()", 1000);--计时
	end
end

--=========================================================
--关闭界面
--=========================================================
function CangBao_Daojishi_Close()
	KillTimer("CangBao_Daojishi_Timer()")
	this:Hide()
end

--=========================================================
--帮助
--=========================================================
function CangBao_Daojishi_Help()
	PushEvent("QUEST_HELPINFO", "#{ZDBT_240703_217}")
end


--=========================================================
--显示奖励预览
--=========================================================
function CangBao_Daojishi_ShowItem()
	--PushEvent("OPEN_CANGBAOTU_AWARD")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenCangBaoAward")
		Set_XSCRIPT_ScriptID(893403)
	Send_XSCRIPT()
end
