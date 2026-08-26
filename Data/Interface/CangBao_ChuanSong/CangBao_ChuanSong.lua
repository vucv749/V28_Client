--******************************************
--组队藏宝图副本 进本的tips界面
--create by  limengyue 
--2024-07-09
--******************************************
local g_CangBao_ChuanSong_Frame_UnifiedPosition;
--关心NPc
local g_CangBao_targetId = -1;
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1


--九宫格
local g_CangBao_RoomList={0,0,0,0,0,0,0,0,0}
local g_CangBao_Goto = -1
local g_CangBao_RoomDoneList = {} --已完成图标
local g_CangBao_RoomPlayerList = {} --player当前图标
local g_CangBao_RoomCheckList = {} --图标状态0/1 不可选/可选
local g_CangBao_RoomAniList = {} --可选图标动画
local g_CangBao_RoomRoadList = {} --已完成图标
local g_CangBao_RoomBackList = {} --每个按钮底图
--g_CangBao_RoomRoadList[1]={nUp = nil,nDown = "aa",} 


--=========================================================
--PreLoad
--=========================================================
function CangBao_ChuanSong_PreLoad()
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
function CangBao_ChuanSong_OnLoad()
	g_CangBao_ChuanSong_Frame_UnifiedPosition = CangBao_ChuanSong_Frame:GetProperty("UnifiedPosition");
	--控件
	--已完成图标
	g_CangBao_RoomDoneList[1] = CangBao_ChuanSong_RoomInfo_Cover1
	g_CangBao_RoomDoneList[2] = CangBao_ChuanSong_RoomInfo_Cover2
	g_CangBao_RoomDoneList[3] = CangBao_ChuanSong_RoomInfo_Cover3
	g_CangBao_RoomDoneList[4] = CangBao_ChuanSong_RoomInfo_Cover4
	g_CangBao_RoomDoneList[5] = CangBao_ChuanSong_RoomInfo_Cover5
	g_CangBao_RoomDoneList[6] = CangBao_ChuanSong_RoomInfo_Cover6
	g_CangBao_RoomDoneList[7] = CangBao_ChuanSong_RoomInfo_Cover7
	g_CangBao_RoomDoneList[8] = CangBao_ChuanSong_RoomInfo_Cover8
	g_CangBao_RoomDoneList[9] = CangBao_ChuanSong_RoomInfo_Cover9	
	--player当前图标
	g_CangBao_RoomPlayerList[1] = CangBao_ChuanSong_RoomInfo_Player1
	g_CangBao_RoomPlayerList[2] = CangBao_ChuanSong_RoomInfo_Player2
	g_CangBao_RoomPlayerList[3] = CangBao_ChuanSong_RoomInfo_Player3
	g_CangBao_RoomPlayerList[4] = CangBao_ChuanSong_RoomInfo_Player4
	g_CangBao_RoomPlayerList[5] = CangBao_ChuanSong_RoomInfo_Player5
	g_CangBao_RoomPlayerList[6] = CangBao_ChuanSong_RoomInfo_Player6
	g_CangBao_RoomPlayerList[7] = CangBao_ChuanSong_RoomInfo_Player7
	g_CangBao_RoomPlayerList[8] = CangBao_ChuanSong_RoomInfo_Player8
	g_CangBao_RoomPlayerList[9] = CangBao_ChuanSong_RoomInfo_Player9
	--图标状态0/1 不可选/可选
	g_CangBao_RoomCheckList[1] = CangBao_ChuanSong_RoomInfo1
	g_CangBao_RoomCheckList[2] = CangBao_ChuanSong_RoomInfo2
	g_CangBao_RoomCheckList[3] = CangBao_ChuanSong_RoomInfo3
	g_CangBao_RoomCheckList[4] = CangBao_ChuanSong_RoomInfo4
	g_CangBao_RoomCheckList[5] = CangBao_ChuanSong_RoomInfo5
	g_CangBao_RoomCheckList[6] = CangBao_ChuanSong_RoomInfo6
	g_CangBao_RoomCheckList[7] = CangBao_ChuanSong_RoomInfo7
	g_CangBao_RoomCheckList[8] = CangBao_ChuanSong_RoomInfo8
	g_CangBao_RoomCheckList[9] = CangBao_ChuanSong_RoomInfo9
	--每个按钮底图
	g_CangBao_RoomBackList[1] = CangBao_ChuanSong_Room1_Back
	g_CangBao_RoomBackList[2] = CangBao_ChuanSong_Room2_Back
	g_CangBao_RoomBackList[3] = CangBao_ChuanSong_Room3_Back
	g_CangBao_RoomBackList[4] = CangBao_ChuanSong_Room4_Back
	g_CangBao_RoomBackList[5] = CangBao_ChuanSong_Room5_Back
	g_CangBao_RoomBackList[6] = CangBao_ChuanSong_Room6_Back
	g_CangBao_RoomBackList[7] = CangBao_ChuanSong_Room7_Back
	g_CangBao_RoomBackList[8] = CangBao_ChuanSong_Room8_Back
	g_CangBao_RoomBackList[9] = CangBao_ChuanSong_Room9_Back
	--可选图标动画
	g_CangBao_RoomAniList[1] = CangBao_ChuanSong_Room1_Ani
	g_CangBao_RoomAniList[2] = CangBao_ChuanSong_Room2_Ani
	g_CangBao_RoomAniList[3] = CangBao_ChuanSong_Room3_Ani
	g_CangBao_RoomAniList[4] = CangBao_ChuanSong_Room4_Ani
	g_CangBao_RoomAniList[5] = CangBao_ChuanSong_Room5_Ani
	g_CangBao_RoomAniList[6] = CangBao_ChuanSong_Room6_Ani
	g_CangBao_RoomAniList[7] = CangBao_ChuanSong_Room7_Ani
	g_CangBao_RoomAniList[8] = CangBao_ChuanSong_Room8_Ani
	g_CangBao_RoomAniList[9] = CangBao_ChuanSong_Room9_Ani	
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function CangBao_ChuanSong_On_ResetPos()
	CangBao_ChuanSong_Frame:SetProperty("UnifiedPosition", g_CangBao_ChuanSong_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_ChuanSong_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340303 ) then
		--打开界面
		if(IsWindowShow("CangBao_ChuanSong")) then
			CloseWindow("CangBao_ChuanSong", true)
		end
		--添加NPC关心 不需要
		g_CangBao_targetId = Get_XParam_INT(12)
		if g_CangBao_targetId >= 0 then
			objCared = DataPool : GetNPCIDByServerID(g_CangBao_targetId);
			CangBao_ChuanSong_BeginCareObject(objCared)
		end
		CangBao_ChuanSong_Open(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_INT(8),Get_XParam_INT(9),Get_XParam_INT(10),Get_XParam_INT(11))
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89340350 ) then
		--tab打开界面
		if(IsWindowShow("CangBao_ChuanSong")) then
			CloseWindow("CangBao_ChuanSong", true)
		end
		--不需要添加NPC关心 直接展示
		CangBao_ChuanSong_Show(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2))
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89340304 ) then
		--关闭界面
		CangBao_ChuanSong_Close()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89340305 ) then
		if(IsWindowShow("CangBao_ChuanSong")) then
			--更正时间
			CangBao_ChuanSong_CheckTime( Get_XParam_INT(0))
		end
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			CangBao_ChuanSong_Close()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_ChuanSong_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_ChuanSong_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_ChuanSong_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			CangBao_ChuanSong_Close()
		end
    end	
end

--=========================================================
--打开界面
--mBossPoint所在点位编号
--mIsBossDie boss是否死了 1死了
--mRoomState 1是可走的点位 2是所在点位 3是已完成的点位
--=========================================================
function CangBao_ChuanSong_Open( mGameStart,nRemainTimes,mRoomState1,mRoomState2,mRoomState3,mRoomState4,mRoomState5,mRoomState6,mRoomState7,mRoomState8,mRoomState9,nRemainTick)
	
	--PushDebugMessage("CangBao_ChuanSong_Open mGameStart="..mGameStart.." nRemainTimes="..nRemainTimes.." nRemainTick="..nRemainTick.." RoomState="..mRoomState1..mRoomState2..mRoomState3..mRoomState4..mRoomState5..mRoomState6..mRoomState7..mRoomState8..mRoomState9)
	g_CangBao_RoomList={0,0,0,0,0,0,0,0,0}
	g_CangBao_Goto = -1
	if mRoomState1 < 0 or mRoomState1 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[1]= mRoomState1
	end
	if mRoomState2 < 0 or mRoomState2 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[2]= mRoomState2
	end
	if mRoomState3 < 0 or mRoomState3 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[3]= mRoomState3
	end
	if mRoomState4 < 0 or mRoomState4 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[4]= mRoomState4
	end
	if mRoomState5 < 0 or mRoomState5 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[5]= mRoomState5
	end
	if mRoomState6 < 0 or mRoomState6 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[6]= mRoomState6
	end
	if mRoomState7 < 0 or mRoomState7 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[7]= mRoomState7
	end
	if mRoomState8 < 0 or mRoomState8 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[8]= mRoomState8
	end
	if mRoomState9 < 0 or mRoomState9 > 3 then
		PushDebugMessage("数据错误")
	else
		g_CangBao_RoomList[9]= mRoomState9
	end
	--显示
	CangBao_ChuanSong_GetPrize:Enable();
	CangBao_ChuanSong_GetPrize:Show()
	CangBao_ChuanSong_TextTime:Show()
	CangBao_ChuanSong_Text3:Show()
	CangBao_ChuanSong_Text3Time:Show()
	--剩余时间
	if nRemainTick > 0 then
		CangBao_ChuanSong_Text3Time:SetProperty("Timer", tostring(nRemainTick))
	else
		CangBao_ChuanSong_Text3Time:SetProperty("Timer", "0")
	end
	CangBao_ChuanSong_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_91}",nRemainTimes))
	--计算
	local mBossPoint =  math.floor(math.mod(mGameStart,100)/10)  
	local mIsBossDie = math.floor(math.mod(mGameStart,1000)/100) 
	
	--设置下boss点
	for index=1,table.getn(g_CangBao_RoomList)  do
		--Boss图标
		if mBossPoint == index then
			--换图
			g_CangBao_RoomCheckList[index]:SetProperty("PushedImage", "set:CangBao image:CangBao_BossP");
			g_CangBao_RoomCheckList[index]:SetProperty("NormalImage", "set:CangBao image:CangBao_BossN");
			g_CangBao_RoomCheckList[index]:SetProperty("HoverImage", "set:CangBao image:CangBao_BossP");
			g_CangBao_RoomCheckList[index]:SetProperty("DisabledImage", "set:CangBao image:CangBao_BossD2");
			--boss点位 boss死了
			if mIsBossDie > 0 and g_CangBao_RoomList[index] ~= 2 then
				g_CangBao_RoomList[index] = 3
			end
			--背景图
			g_CangBao_RoomBackList[index]:SetProperty("Image", "set:CangBao image:CangBao_BossD");
		else
			--非boss点图
			g_CangBao_RoomCheckList[index]:SetProperty("PushedImage", "set:CangBao image:CangBao_PlayP");
			g_CangBao_RoomCheckList[index]:SetProperty("NormalImage", "set:CangBao image:CangBao_PlayN");
			g_CangBao_RoomCheckList[index]:SetProperty("HoverImage", "set:CangBao image:CangBao_PlayP");
			g_CangBao_RoomCheckList[index]:SetProperty("DisabledImage", "set:CangBao image:CangBao_PlayD2");
			--背景图
			g_CangBao_RoomBackList[index]:SetProperty("Image", "set:CangBao image:CangBao_PlayD");
		end
		--默认隐藏特效 已探索 当前
		g_CangBao_RoomAniList[index]:Hide();
		g_CangBao_RoomDoneList[index]:Hide();
		g_CangBao_RoomPlayerList[index]:Hide();
	end
	
	--1是可走的点位 2是所在点位 3是已完成的点位
	for index=1,table.getn(g_CangBao_RoomList)  do
		--图标状态0/1 不可选/可选
		if g_CangBao_RoomList[index]== 1 then
			g_CangBao_RoomCheckList[index]:Show();
			g_CangBao_RoomCheckList[index]:Enable();
			g_CangBao_RoomCheckList[index]:SetCheck(0)
			--可选图标动画
			g_CangBao_RoomAniList[index]:Show();
			g_CangBao_RoomAniList[index]:Play(true)
		else
			g_CangBao_RoomCheckList[index]:Show();
			g_CangBao_RoomCheckList[index]:Disable();
			g_CangBao_RoomCheckList[index]:SetCheck(0)
		end
		--player当前图标
		if g_CangBao_RoomList[index]== 2 then
			g_CangBao_RoomPlayerList[index]:Show();
			g_CangBao_RoomCheckList[index]:Hide();
		end
		--已完成图标
		if g_CangBao_RoomList[index]== 3 then
			g_CangBao_RoomDoneList[index]:Show();
			g_CangBao_RoomCheckList[index]:Hide();
		end
	end		
	this:Show()
end

--=========================================================
--服务器发来的同步时间
--=========================================================
function CangBao_ChuanSong_CheckTime( nRemainTick)
	--显示
	CangBao_ChuanSong_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_91}",nRemainTimes))
	--剩余时间
	if nRemainTick > 0 then
		CangBao_ChuanSong_Text3Time:SetProperty("Timer", tostring(nRemainTick))
	else
		CangBao_ChuanSong_Text3Time:SetProperty("Timer", "0")
	end
end

--=========================================================
--点选能前往的按钮
--=========================================================
function CangBao_ChuanSong_Select(nGotoIdx)
	--PushDebugMessage("Play_Ani nGotoIdx="..nGotoIdx)
	if nGotoIdx < 0 or nGotoIdx > 9 then
		return
	end
	
	--设置显示
	for index=1,table.getn(g_CangBao_RoomCheckList)  do
		if nGotoIdx == index then
			g_CangBao_RoomCheckList[index]:SetCheck(1)
		else
			g_CangBao_RoomCheckList[index]:SetCheck(0)
		end
	end
	g_CangBao_Goto = nGotoIdx
end

--=========================================================
--确认前往
--=========================================================
function CangBao_ChuanSong_Goto()
	--全交给服务器判断
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("StartNextGame")
		Set_XSCRIPT_ScriptID(893403)
		Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		Set_XSCRIPT_Parameter( 1,g_CangBao_Goto)
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()	
end


--=========================================================
--tab键展示
--=========================================================
function CangBao_ChuanSong_Show(mGameStart,nRemainTimes,mGameDonePointList)
	--PushDebugMessage("CangBao_ChuanSong_Show mGameStart="..mGameStart.." nRemainTimes="..nRemainTimes.." mGameDonePointList="..mGameDonePointList)
	
	--隐藏一些内容
	CangBao_ChuanSong_GetPrize:Disable();
	CangBao_ChuanSong_GetPrize:Hide()
	CangBao_ChuanSong_TextTime:Hide()
	CangBao_ChuanSong_Text3:Hide()
	CangBao_ChuanSong_Text3Time:Hide()
	--显示的
	CangBao_ChuanSong_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_91}",nRemainTimes))
	--拆字段
	local mBossPoint =  math.floor(math.mod(mGameStart,100)/10)  
	local mIsBossDie = math.floor(math.mod(mGameStart,1000)/100) 
	
	local nCurPoint = 0
	local nGameDoneList = {0,0,0,0,0,0}
	nGameDoneList[1] = math.mod(mGameDonePointList,10)
	if nGameDoneList[1] > 0 then
		nCurPoint = nGameDoneList[1]
	end
	nGameDoneList[2] = math.floor(math.mod(mGameDonePointList,100)/10)  
	if nGameDoneList[2] > 0 then
		nCurPoint = nGameDoneList[2]
	end
	nGameDoneList[3] = math.floor(math.mod(mGameDonePointList,1000)/100) 
	if nGameDoneList[3] > 0 then
		nCurPoint = nGameDoneList[3]
	end
	nGameDoneList[4] = math.floor(math.mod(mGameDonePointList,10000)/1000) 
	if nGameDoneList[4] > 0 then
		nCurPoint = nGameDoneList[4]
	end
	nGameDoneList[5] = math.floor(math.mod(mGameDonePointList,100000)/10000) 
	if nGameDoneList[5] > 0 then
		nCurPoint = nGameDoneList[5]
	end
	nGameDoneList[6] = math.floor(math.mod(mGameDonePointList,1000000)/100000)
	if nGameDoneList[6] > 0 then
		nCurPoint = nGameDoneList[6]
	end
	--计算九宫格怎么显示吧
	--设置下boss点
	for index=1,table.getn(g_CangBao_RoomList)  do
		--Boss图标
		if mBossPoint == index then
			--换图
			g_CangBao_RoomCheckList[index]:SetProperty("PushedImage", "set:CangBao image:CangBao_BossP");
			g_CangBao_RoomCheckList[index]:SetProperty("NormalImage", "set:CangBao image:CangBao_BossN");
			g_CangBao_RoomCheckList[index]:SetProperty("HoverImage", "set:CangBao image:CangBao_BossP");
			g_CangBao_RoomCheckList[index]:SetProperty("DisabledImage", "set:CangBao image:CangBao_BossD2");
			--背景图
			g_CangBao_RoomBackList[index]:SetProperty("Image", "set:CangBao image:CangBao_BossD");
		else
			--非boss点图
			g_CangBao_RoomCheckList[index]:SetProperty("PushedImage", "set:CangBao image:CangBao_PlayP");
			g_CangBao_RoomCheckList[index]:SetProperty("NormalImage", "set:CangBao image:CangBao_PlayN");
			g_CangBao_RoomCheckList[index]:SetProperty("HoverImage", "set:CangBao image:CangBao_PlayP");
			g_CangBao_RoomCheckList[index]:SetProperty("DisabledImage", "set:CangBao image:CangBao_PlayD2");
			--背景图
			g_CangBao_RoomBackList[index]:SetProperty("Image", "set:CangBao image:CangBao_PlayD");
		end
		--默认隐藏特效 已探索 当前 可选按钮
		g_CangBao_RoomAniList[index]:Hide();
		g_CangBao_RoomDoneList[index]:Hide();
		g_CangBao_RoomPlayerList[index]:Hide();
		g_CangBao_RoomCheckList[index]:Show();
		g_CangBao_RoomCheckList[index]:Disable();
		g_CangBao_RoomCheckList[index]:SetCheck(0)
	end
	
	--nGameDoneList[idx] 走过的点 nCurPoint是当前点
	for index=1,table.getn(nGameDoneList)  do
		--走过的点
		local mDoneIdx = nGameDoneList[index]
		if mDoneIdx > 0 then
			if nCurPoint == mDoneIdx then
				g_CangBao_RoomPlayerList[mDoneIdx]:Show();
			else
				g_CangBao_RoomDoneList[mDoneIdx]:Show();
			end
			g_CangBao_RoomCheckList[mDoneIdx]:Hide();
		end
	end		
	this:Show()
end

--=========================================================
--关闭界面
--=========================================================
function CangBao_ChuanSong_Close()
	CangBao_ChuanSong_StopCareObject()
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function CangBao_ChuanSong_BeginCareObject(objCaredId)
	if g_Object ~= -1 then
		this:CareObject(objCaredId, 0, "CangBao_ChuanSong");
	end
	g_Object = objCaredId
	this:CareObject(g_Object, 1, "CangBao_ChuanSong")
end


--=========================================================
--停止对某NPC的关心
--=========================================================
function CangBao_ChuanSong_StopCareObject()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "CangBao_ChuanSong");
		g_Object = -1;
	end
end

--=========================================================
--帮助
--=========================================================
function CangBao_ChuanSong_Help()
	PushEvent("QUEST_HELPINFO", "#{ZDBT_240703_217}")
end