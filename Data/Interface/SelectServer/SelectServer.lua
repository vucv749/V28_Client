-------------------------------------------------------------------------------------------------------------
--
-- 全局变量
--
local g_LastServer = -1;
local g_LastArea   = -1;
local g_LastServerState = -1;
local g_LastServerName = "";
local CriticalSpeed1 =250
local CriticalSpeed2 =500
local CriticalSpeed3 =1000

local CriticalSpeed =200;
local CurPage = 0
local NetSpeed ={"#e010101网络速度:#c4CFA4C良好","#e010101网络速度:#cff0000繁忙","#e010101网络速度:未知", "#e010101网络速度:#cff0000拥堵" }
local PageSize = 24

-- 区域按钮的个数
local LOGIN_SERVER_AREA_COUNT = 16;
--目前有效的区域按钮个数，由于界面改动太大，怕以后有人又反悔，加这个变量，主要是不想去掉翻页代码。
local EFFECT_LOGIN_SERVER_AREA_COUNT = 16;
-- 公测区域按钮的个数
local LOGIN_SERVER_TESTAREA_COUNT = 16;
-- 区域按钮
local g_BnArea = {};

-- 公测区域按钮
local g_BntestArea = {};

-- 当前选择的区域
local g_iCurSelArea = 0;
local g_iCurSelAreaType = 0;
local g_iCurSelAreaIndex = 0;
-- login server 客户端索引
local g_AreaIndex ={};
-- login server 名字
local g_AreaName = {};
-- login server 名字
local g_AreaDis = {};
-- testlogin server 客户端索引
local g_testAreaIndex ={};
-- login server 名字
local g_testAreaName = {};
-- login server 名字
local g_testAreaDis = {};
-- 当前选择的区域名字
local g_iCurSelAreaName;
-- 当前选择的服务器名字
local g_iCurSelLoginServerName;

--区域tips
local g_AreaTip = {};
local g_testAreaTip = {};



local g_idBackSound = -1;

-- 记载推荐服务器的个数
local indexForCommendable = 1;
------------------------------------------------------------------------------
--
-- login server 信息
--

-- login server 的个数
--local LOGIN_SERVER_COUNT = 55;    -- modify by zchw 45-->55
local LOGIN_SERVER_COUNT = 85;    -- modify by zchw 45-->55

local COMMENDABLE_LOGIN_SERVER_COUNT = 12;

-- login server 按钮
local g_BnLoginServer = {};
-- login server 状态
local g_LoginServerStatus = {};
-- login server 名字
local g_LoginServerName = {};
-- login server 推荐等级
local g_LoginServerCommendableLevel = {};
-- login server 是否新开
local g_LoginServerIsNew = {};



-- 推荐服务器按钮
local g_CommendableBnLoginServer = {};
local g_CommendableBnLoginServerTuiJian = {};
-- 推荐服务器名字
local g_CommendableLoginServerName = {};
-- 推荐服务器Index
local g_CommendableLoginServerServerIndex = {};
-- 推荐服务器区域Index
local g_CommendableLoginServerAreaIndex = {};
-- 推荐服务器推荐等级
local g_CommendableLoginServerCommendableLevel = {};
-- 推荐服务器是否新服
local g_CommendableLoginServerIsNew = {};
-- 推荐服务器 状态
local g_CommendableLoginServerStatus = {};
-- 推荐服务器区域 类型
local g_CommendableLoginServeAreaType = {};
-- 推荐服务器区域 类型内索引
local g_CommendableLoginServeAreaInnerIndex = {};

-------------------------------------------------------------------------------
--
-- 其他信息
--

-- 当前选择的login server
local g_iCurSelLoginServer = -1;
-- 当前选择的推荐login server index
local g_iCurComSelLoginServer = -1;

-- 区域的个数
local g_iCurAreaCount = 0;
--公测区域个数
local g_iCurTestAreaCount = 0;

local g_FirstLogin = 1;

--服务器处于维护状态
local StateStop = 4;
--不显示状态
local StatMax = 10;

local RECOMMEND_AREA_COUNT = 4;
--记载电信推荐大区数量
local indexForRecommendArea = 0;
--推荐电信大区按钮
local g_RecommendAreaBtn = {};
--推荐电信大区名字
local g_RecommendAreaName = {};
--推荐电信大区推荐等级
local g_RecommendAreaRecommendLevel = {};

-- 搜索列表服务器Index
local g_SearchServerIndex = {};
-- 搜索列表服务器大区Index
local g_SearchServerAreaIndex = {};
-- 搜索列表服务器名称
local g_SearchServerName = {};
-- 搜索列表服务器是否新服
local g_SearchServerIsNew = {};
-- 搜索列表服务器状态
local g_SearchServerStatus = {};
-- 是否显示搜索页面
local g_bSearch = 0;

-------------------------------------------------------------------------------------------------------------
--
-- 函数区.
--
--

-- 注册onLoad事件
function LoginSelectServer_PreLoad()
	-- 打开选择服务器界面
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_SERVER");

	-- 选择区域
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_SERVER");

	-- 打开选择服务器界面
	this:RegisterEvent("GAMELOGIN_SELECT_AREA");

	-- 选择login
	this:RegisterEvent("GAMELOGIN_SELECT_LOGINSERVER");

	-- 注册选择一个login server事件
	this:RegisterEvent("GAMELOGIN_SELECT_LOGIN_SERVER");

	-- 玩家进入场景
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	--上次登录的服务器
	this:RegisterEvent("GAMELOGIN_LASTSELECT_AREA_AND_SERVER");

	--进入账号输入界面
	this:RegisterEvent("GAMELOGIN_SERVER_SHOW_COUNTINPUT");

	--返回服务器选择Sub1
	this:RegisterEvent("GAMELOGIN_SERVER_SHOW_SUB");

	--更新服务器列表信息
	this:RegisterEvent("GAMELOGIN_UPDATE_SERVERINFO");

end

function LoginSelectServer_OnLoad()

	-- 得到区域按钮
	g_BnArea[1] = SelectServer_Subarea1;
	g_BnArea[2] = SelectServer_Subarea2;
	g_BnArea[3] = SelectServer_Subarea3;
	g_BnArea[4] = SelectServer_Subarea4;
	g_BnArea[5] = SelectServer_Subarea5;
	g_BnArea[6] = SelectServer_Subarea6;
	g_BnArea[7] = SelectServer_Subarea7;
	g_BnArea[8] = SelectServer_Subarea8;
	g_BnArea[9] = SelectServer_Subarea9;
	g_BnArea[10] = SelectServer_Subarea10;
	g_BnArea[11] = SelectServer_Subarea11;
	g_BnArea[12] = SelectServer_Subarea12;

	g_BnArea[13] = SelectServer_Subarea13;
	g_BnArea[14] = SelectServer_Subarea14;
	g_BnArea[15] = SelectServer_Subarea15;
	g_BnArea[16] = SelectServer_Subarea16;

	g_BntestArea[1] = SelectServer2_Subarea1;
	g_BntestArea[2] = SelectServer2_Subarea2;
	g_BntestArea[3] = SelectServer2_Subarea3;
	g_BntestArea[4] = SelectServer2_Subarea4;
	g_BntestArea[5] = SelectServer2_Subarea5;
	g_BntestArea[6] = SelectServer2_Subarea6;
	g_BntestArea[7] = SelectServer2_Subarea7;
	g_BntestArea[8] = SelectServer2_Subarea8;
	g_BntestArea[9] = SelectServer2_Subarea9;
	g_BntestArea[10] = SelectServer2_Subarea10;
	g_BntestArea[11] = SelectServer2_Subarea11;
	g_BntestArea[12] = SelectServer2_Subarea12;
	g_BntestArea[13] = SelectServer2_Subarea13;
	g_BntestArea[14] = SelectServer2_Subarea14;
	g_BntestArea[15] = SelectServer2_Subarea15;
	g_BntestArea[16] = SelectServer2_Subarea16;

	--得到推荐服务器列表
	g_CommendableBnLoginServer[1] = SelectServer_Commendable_Subarea1;
	g_CommendableBnLoginServer[2] = SelectServer_Commendable_Subarea2;
	g_CommendableBnLoginServer[3] = SelectServer_Commendable_Subarea3;
	g_CommendableBnLoginServer[4] = SelectServer_Commendable_Subarea4;
	g_CommendableBnLoginServer[5] = SelectServer_Commendable_Subarea5;
	g_CommendableBnLoginServer[6] = SelectServer_Commendable_Subarea6;
	g_CommendableBnLoginServer[7] = SelectServer_Commendable_Subarea7;
	g_CommendableBnLoginServer[8] = SelectServer_Commendable_Subarea8;
	g_CommendableBnLoginServer[9] = SelectServer_Commendable_Subarea9;
	g_CommendableBnLoginServer[10] = SelectServer_Commendable_Subarea10;
	g_CommendableBnLoginServer[11] = SelectServer_Commendable_Subarea11;
	g_CommendableBnLoginServer[12] = SelectServer_Commendable_Subarea12;
	
	g_CommendableBnLoginServerTuiJian[1] = SelectServer_Commendable_Subarea1_TuiJian;
	g_CommendableBnLoginServerTuiJian[2] = SelectServer_Commendable_Subarea2_TuiJian;
	g_CommendableBnLoginServerTuiJian[3] = SelectServer_Commendable_Subarea3_TuiJian;
	g_CommendableBnLoginServerTuiJian[4] = SelectServer_Commendable_Subarea4_TuiJian;
	g_CommendableBnLoginServerTuiJian[5] = SelectServer_Commendable_Subarea5_TuiJian;
	g_CommendableBnLoginServerTuiJian[6] = SelectServer_Commendable_Subarea6_TuiJian;
	g_CommendableBnLoginServerTuiJian[7] = SelectServer_Commendable_Subarea7_TuiJian;
	g_CommendableBnLoginServerTuiJian[8] = SelectServer_Commendable_Subarea8_TuiJian;
	g_CommendableBnLoginServerTuiJian[9] = SelectServer_Commendable_Subarea9_TuiJian;
	g_CommendableBnLoginServerTuiJian[10]= SelectServer_Commendable_Subarea10_TuiJian;
	g_CommendableBnLoginServerTuiJian[11]= SelectServer_Commendable_Subarea11_TuiJian;
	g_CommendableBnLoginServerTuiJian[12]= SelectServer_Commendable_Subarea12_TuiJian;

	--得到推荐大区列表
	g_RecommendAreaBtn[1] = SelectServer_Tuijian_Area1;
	g_RecommendAreaBtn[2] = SelectServer_Tuijian_Area2;
	g_RecommendAreaBtn[3] = SelectServer_Tuijian_Area3;
	g_RecommendAreaBtn[4] = SelectServer_Tuijian_Area4;

	local i;
	for i = 1, LOGIN_SERVER_AREA_COUNT do

	 	g_BnArea[i]:SetProperty("CheckMode", "1");

		g_AreaName[i] = "";
		g_AreaDis[i] = "";
		g_AreaTip[i] = "";
		g_testAreaTip[i] = "";
	end

	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
	 	-- Login server 按钮

	 	g_CommendableBnLoginServer[i]:SetProperty("CheckMode", "1");
		-- login server 名字
		g_CommendableLoginServerName[i] = "";
		--login server index
		g_CommendableLoginServerIndex[i]=-1;
	end
	-- 得到服务器按钮
	g_BnLoginServer[1] = SelectServer_Server1;
	g_BnLoginServer[2] = SelectServer_Server2;
	g_BnLoginServer[3] = SelectServer_Server3;
	g_BnLoginServer[4] = SelectServer_Server4;
	g_BnLoginServer[5] = SelectServer_Server5;
	g_BnLoginServer[6] = SelectServer_Server6;
	g_BnLoginServer[7] = SelectServer_Server7;
	g_BnLoginServer[8] = SelectServer_Server8;
	g_BnLoginServer[9] = SelectServer_Server9;
	g_BnLoginServer[10] = SelectServer_Server10;

	g_BnLoginServer[11] = SelectServer_Server11;
	g_BnLoginServer[12] = SelectServer_Server12;
	g_BnLoginServer[13] = SelectServer_Server13;
	g_BnLoginServer[14] = SelectServer_Server14;
	g_BnLoginServer[15] = SelectServer_Server15;
	g_BnLoginServer[16] = SelectServer_Server16;
	g_BnLoginServer[17] = SelectServer_Server17;
	g_BnLoginServer[18] = SelectServer_Server18;
	g_BnLoginServer[19] = SelectServer_Server19;
	g_BnLoginServer[20] = SelectServer_Server20;

	g_BnLoginServer[21] = SelectServer_Server21;
	g_BnLoginServer[22] = SelectServer_Server22;
	g_BnLoginServer[23] = SelectServer_Server23;
	g_BnLoginServer[24] = SelectServer_Server24;
	g_BnLoginServer[25] = SelectServer_Server25;
	g_BnLoginServer[26] = SelectServer_Server26;
	g_BnLoginServer[27] = SelectServer_Server27;
	g_BnLoginServer[28] = SelectServer_Server28;
	g_BnLoginServer[29] = SelectServer_Server29;
	g_BnLoginServer[30] = SelectServer_Server30;

	g_BnLoginServer[31] = SelectServer_Server31;
	g_BnLoginServer[32] = SelectServer_Server32;
	g_BnLoginServer[33] = SelectServer_Server33;
	g_BnLoginServer[34] = SelectServer_Server34;
	g_BnLoginServer[35] = SelectServer_Server35;
	g_BnLoginServer[36] = SelectServer_Server36;
	g_BnLoginServer[37] = SelectServer_Server37;
	g_BnLoginServer[38] = SelectServer_Server38;
	g_BnLoginServer[39] = SelectServer_Server39;
	g_BnLoginServer[40] = SelectServer_Server40;

	g_BnLoginServer[41] = SelectServer_Server41;
	g_BnLoginServer[42] = SelectServer_Server42;
	g_BnLoginServer[43] = SelectServer_Server43;
	g_BnLoginServer[44] = SelectServer_Server44;
	g_BnLoginServer[45] = SelectServer_Server45;
	g_BnLoginServer[46] = SelectServer_Server46;
	g_BnLoginServer[47] = SelectServer_Server47;
	g_BnLoginServer[48] = SelectServer_Server48;
	g_BnLoginServer[49] = SelectServer_Server49;
	g_BnLoginServer[50] = SelectServer_Server50;

	g_BnLoginServer[51] = SelectServer_Server51;
	g_BnLoginServer[52] = SelectServer_Server52;
	g_BnLoginServer[53] = SelectServer_Server53;
	g_BnLoginServer[54] = SelectServer_Server54;
	g_BnLoginServer[55] = SelectServer_Server55;
	g_BnLoginServer[56] = SelectServer_Server56;
	g_BnLoginServer[57] = SelectServer_Server57;
	g_BnLoginServer[58] = SelectServer_Server58;
	g_BnLoginServer[59] = SelectServer_Server59;
	g_BnLoginServer[60] = SelectServer_Server60;

	g_BnLoginServer[61] = SelectServer_Server61;
	g_BnLoginServer[62] = SelectServer_Server62;
	g_BnLoginServer[63] = SelectServer_Server63;
	g_BnLoginServer[64] = SelectServer_Server64;
	g_BnLoginServer[65] = SelectServer_Server65;
	g_BnLoginServer[66] = SelectServer_Server66;
	g_BnLoginServer[67] = SelectServer_Server67;
	g_BnLoginServer[68] = SelectServer_Server68;
	g_BnLoginServer[69] = SelectServer_Server69;
	g_BnLoginServer[70] = SelectServer_Server70;

	g_BnLoginServer[71] = SelectServer_Server71;
	g_BnLoginServer[72] = SelectServer_Server72;
	g_BnLoginServer[73] = SelectServer_Server73;
	g_BnLoginServer[74] = SelectServer_Server74;
	g_BnLoginServer[75] = SelectServer_Server75;
	g_BnLoginServer[76] = SelectServer_Server76;
	g_BnLoginServer[77] = SelectServer_Server77;
	g_BnLoginServer[78] = SelectServer_Server78;
	g_BnLoginServer[79] = SelectServer_Server79;
	g_BnLoginServer[80] = SelectServer_Server80;

	g_BnLoginServer[81] = SelectServer_Server81;
	g_BnLoginServer[82] = SelectServer_Server82;
	g_BnLoginServer[83] = SelectServer_Server83;
	g_BnLoginServer[84] = SelectServer_Server84;
	g_BnLoginServer[85] = SelectServer_Server85;


	for i = 1, LOGIN_SERVER_COUNT do
	 	-- Login server 按钮
	 	g_BnLoginServer[i]:SetProperty("CheckMode", "1");

		-- login server 状态
		g_LoginServerStatus[i] = 0;

		-- login server 名字
		g_LoginServerName[i] = "";

		g_LoginServerCommendableLevel[i]="";
	end
	-- 隐藏所有推荐服务器
	HideAllCommendableBn();
	--先隐藏推荐大区按钮
	HideRecommendAreaBn();
	-- 得到服务器信息
	LoginSelectServer_GetServerInfo();

	local strNormalColor = "#cFFF263";
	SelectServer_Help_Text1:SetText(	strNormalColor.."#e010101#cff0000红色表示:爆满#cffffff" );
	SelectServer_Help_Text2:SetText(	strNormalColor.."#e010101#cECE58D浅色表示:良好#cffffff" );
	SelectServer_Help_Text3:SetText(	strNormalColor.."#e010101#c959595灰色表示:维护#cffffff" );
	SelectServer_Help_Text4:SetText(	strNormalColor.."#e010101#cff8a00橙色表示:繁忙#cffffff" );
	SelectServer_Help_Text5:SetText(	strNormalColor.."#e010101#c4CFA4C绿色表示:极佳#cffffff" );


	-- 打开界面
	SelectServer_Frame:SetProperty("AlwaysOnTop", "True");

	-- 先隐藏所有按钮。
	HideAreaBn();
	-- 先隐藏所有按钮。
	HideTestAreaBn();

end

function HideAllCommendableBn()
	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
		g_CommendableBnLoginServer[i]:Hide();
	end;
end
--是否自动把选择的服务器序号变成0，防止.txt文件有大的变动
local autoZero = 0;
-- OnEvent
function LoginSelectServer_OnEvent(event)

	if GameProduceLogin:IsYunGameMobileClient() then 
		return
	end

	if( event == "GAMELOGIN_OPEN_SELECT_SERVER" ) then
		this:Show();
		if GameProduceLogin:IsWeGameClient() > 0 then
			SelectServer_Regist:Hide();
			SelectServer_Charge:Hide();
		end
		SelectServer_Server_SearchName:SetText("");
		-- 显示存在的区域按钮。
		--ShowAreaBn();
		--ShowTestAreaBn();
		--显示上下翻页
		UpdateUpAddDownButton();
		ShowServerSelectSub1();

		-- 播放背景音乐
		if(g_idBackSound == -1) then
			g_idBackSound = Sound:PlaySound(2108, true, true);
		end

		for i = 1,indexForCommendable do
			if(g_CommendableLoginServerAreaIndex[i] == g_LastArea and g_CommendableLoginServerName[i] == g_LastServerName)then
				g_CommendableBnLoginServer[i]:SetCheck(1);
				NotFlashAreaBtnAll();
 				if(g_CommendableLoginServeAreaType[i] == 0) then
 					local tAreaIndex=g_CommendableLoginServeAreaInnerIndex[i]
 					if(tAreaIndex > 0) then
						g_BnArea[tAreaIndex]:SetCheck(1);
						g_BnArea[tAreaIndex]:FlashMe(1);
					end
				else
					local testAreaindex = g_CommendableLoginServeAreaInnerIndex[i];
					if(testAreaindex > 0) then
						g_BntestArea[testAreaindex]:SetCheck(1);
						g_BntestArea[testAreaindex]:FlashMe(1);
					end
 				end
				Commendable_ShowServerInfo(i);
				return;
			end
		end
		for i = 1,indexForCommendable do
			g_CommendableBnLoginServer[i]:SetCheck(0)
		end
		ClearServerTextInfo();
		--if( 1 == g_FirstLogin ) then
           -- GameProduceLogin:ShowMessageBox( "    目前只开放了一台网通服务器用于测试，如果您是电信的用户，请在服务器选择界面的右边选择“电信”进行登录，这样才能使用互联互通功能以保证您的连接速度。", "OK", "1" );
		    --g_FirstLogin = 0
		--end

		return;
	end


	-- 关闭界面
	if( event == "GAMELOGIN_CLOSE_SELECT_SERVER") then
		NotFlashAreaBtnAll();
		this:Hide();
		return;
	end

	-- 选择一个login server
	if( event == "GAMELOGIN_SELECT_LOGIN_SERVER") then
		local num = tonumber(arg0);
		for aindex = 1,g_iCurAreaCount do
			if(num == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				SelectServer_SelectLoginServer(tonumber(arg1),1);
			return;
			end
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(num == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				SelectServer_SelectLoginServer(tonumber(arg1),1);
				return;
			end
		end
		return;
	end

	-- 选择区域
	if( event == "GAMELOGIN_SELECT_AREA") then
		--如果从账号输入界面返回大区界面
		if( g_iCurComSelLoginServer ~= -1) then
			return;
		end
		autoZero = 0;
		local num = tonumber(arg0);
		for aindex = 1,g_iCurAreaCount do
			if(num == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				return;
			end
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(num == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				return;
			end
		end
		--完全没有找到，说明文件有了大的变化
		CurPage = 0;
		autoZero = 1;
		SelectServer_SelectAreaServer(1 - CurPage*PageSize -1);
		return;
	end;

	-- 选择login
	if( event == "GAMELOGIN_SELECT_LOGINSERVER") then
		--如果从账号输入界面返回大区界面
		if( g_iCurComSelLoginServer ~= -1) then
			for i = 1,indexForCommendable do
				if( g_iCurSelArea == g_CommendableLoginServerAreaIndex[i] and g_CommendableLoginServerName[i] == g_iCurSelLoginServerName) then
					g_CommendableBnLoginServer[i]:SetCheck(1);
					NotFlashAreaBtnAll();
					if(g_CommendableLoginServeAreaType[i] == 0) then
						local tAreaIndex=g_CommendableLoginServeAreaInnerIndex[i]
						if(tAreaIndex > 0) then
							g_BnArea[tAreaIndex]:SetCheck(1);
							g_BnArea[tAreaIndex]:FlashMe(1);
						end
					else
						local testAreaindex = g_CommendableLoginServeAreaInnerIndex[i];
						if(testAreaindex > 0) then
							g_BntestArea[testAreaindex]:SetCheck(1);
							g_BntestArea[testAreaindex]:FlashMe(1);
						end
 					end
					Commendable_ShowServerInfo(i);
				end
			end
			return;
		end
		if ( g_BnLoginServer[tonumber(arg0)+1]:GetProperty("Disabled")=="False") then
			if(autoZero == 0 )then
				SelectServer_SelectLoginServer(tonumber(arg0),0);
			else
				SelectServer_SelectLoginServer(0,0);
				autoZero = 0;
			end
		end;
		return;
	end;

	-- 进入场景，停止背景音乐
	if( event == "PLAYER_ENTERING_WORLD") then
		if(g_idBackSound ~= -1) then
			Sound:StopSound(g_idBackSound);
			g_idBackSound = -1;
		end
	end
	
	--上次登录服务器
	if( event == "GAMELOGIN_LASTSELECT_AREA_AND_SERVER") then
		local numArea =-1;
		local numServer = -1;
		if(arg0~=nil)then
			numArea = tonumber(arg0);
			g_LastArea = numArea;
		end
		if(arg1~=nil)then
			numServer = tonumber(arg1);
			g_LastServer = numServer;
		end
		if(numArea ~= -1 and numServer~=-1)then
			local have = 0;
			for aindex = 1,g_iCurAreaCount do
				if(numArea == g_AreaIndex[aindex]) then
					have = 1;
					break;
				end
			end
			for bindex = 1,g_iCurTestAreaCount do
				if(numArea == g_testAreaIndex[bindex]) then
					have = 1;
					break;
				end
			end
			if(have == 1)then
				g_LastServerName, g_LastServerState = GameProduceLogin:GetAreaLoginServerInfo(numArea, numServer);
				SelectServer_Server_Last:SetText(g_LastServerName);
				--判断上次登录服务器是否处于维护状态 tt69698
				if (g_LastServerState == StateStop) then
					SelectServer_Server_Last:SetCheck(0);
					SelectServer_Server_Last:Disable();
				else
					SelectServer_Server_Last:Enable();
					--if(g_iCurSelArea == g_LastArea and g_LastServer ==g_iCurSelLoginServer)then
						SelectServer_Server_Last:SetCheck(1);
					--end
				end
				--获取选择大区
				SelectServer_Server_AreaNameShow:SetText(g_iCurSelAreaName);
				if g_iCurSelAreaName ~= "" then
					SelectServer_Server_Lastarea:SetText(g_iCurSelAreaName);
				else
					SelectServer_Server_Lastarea:SetText("无");
				end
				SelectServer_Server_Lastarea:Enable();
			else
				SelectServer_Server_Last:SetText("无");
				SelectServer_Server_Last:SetCheck(0);
				SelectServer_Server_Last:Disable();
			end
		else
			SelectServer_Server_Last:SetText("无");
			SelectServer_Server_Last:SetCheck(0);
			SelectServer_Server_Last:Disable();
		end
		return;
	end;

	if( event == "GAMELOGIN_SERVER_SHOW_COUNTINPUT") then
		SelectServer_SelectOk();
	end

	if( event == "GAMELOGIN_SERVER_SHOW_SUB") then
		SelectServer_ReturnAreaSelect_click();
	end

	if( event == "GAMELOGIN_UPDATE_SERVERINFO") then
		-- 隐藏所有推荐服务器
		HideAllCommendableBn();
		--先隐藏推荐大区按钮
		HideRecommendAreaBn();
		-- 得到服务器信息
		LoginSelectServer_GetServerInfo();
			-- 先隐藏所有按钮。
		HideAreaBn();
		-- 先隐藏所有按钮。
		HideTestAreaBn();
	end
end

function SelectServer_SelectLastServer()
	if(g_LastArea ~=-1 and g_LastServer ~= -1)then
		for aindex = 1,g_iCurAreaCount do
			if(g_LastArea == g_AreaIndex[aindex]) then
				CurPage = math.floor((aindex-1)/PageSize);
				ShowPage();
				SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
				SelectServer_SelectLoginServer(g_LastServer,1);
				return;
			end
		end
		for bindex = 1,g_iCurTestAreaCount do
			if(g_LastArea == g_testAreaIndex[bindex]) then
				SelectServer_SelectTestAreaServer(bindex-1);
				SelectServer_SelectLoginServer(g_LastServer,1);
				return;
			end
		end

	end
end

function SelectServer_CurSelectArea()
	--SelectServer_Server_Lastarea:SetCheck(0);
end

--------------------------------------------------------------------------------------------------------------
--
-- 得到服务器信息
--

function LoginSelectServer_GetServerInfo()

	 	local iCurAreaCount = GameProduceLogin:GetServerAreaCount();
	 	local strAreaName = "无服务器";
		local iLoginServerCount = -1;
		local ServerName;
		local ServerStatus;
		--推荐等级
		local RecommendLevel;
		local IsNew;
		indexForCommendable = 0;
		indexForRecommendArea = 0;
		local testindex = 0;
		local nomalindex =0;
		local tuijian=0;
	 	for index = 0, iCurAreaCount - 1 do
			tuijian =0;
			if(testindex>=LOGIN_SERVER_TESTAREA_COUNT and nomalindex>=EFFECT_LOGIN_SERVER_AREA_COUNT) then
				break;
			end
			local bAreaType=0;
			local nAreaInnerIndex=0;
			local areaname = GameProduceLogin:GetServerAreaName(index);
	 		-- 得到区域名字.
			local i = string.find(areaname,"-");
			if(i~=nil and i<string.len(areaname)) then
				if(string.sub(areaname,1,i-1)=="网通" and testindex<LOGIN_SERVER_TESTAREA_COUNT)then
					testindex = testindex +1;
					g_testAreaName[testindex] = string.sub(areaname,i+1);
					g_testAreaDis[testindex] = GameProduceLogin:GetServerAreaDis(index);
					g_testAreaIndex[testindex] = index;
					tuijian = 1;
					g_testAreaTip[testindex] = GameProduceLogin:GetServerAreaDis(index);
					bAreaType = 1
					nAreaInnerIndex = testindex
				elseif(string.sub(areaname,1,i-1)=="公测" and nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
					nomalindex = nomalindex +1;
	 				g_AreaName[nomalindex] = string.sub(areaname,i+1);
					g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
					g_AreaIndex[nomalindex] = index;
					tuijian = 1;
					g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
					bAreaType = 0
					nAreaInnerIndex = nomalindex
				end
			elseif(nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
				nomalindex = nomalindex +1;
	 			g_AreaName[nomalindex] = GameProduceLogin:GetServerAreaName(index);
				g_AreaDis[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				g_AreaIndex[nomalindex] = index;
				tuijian = 1;
				g_AreaTip[nomalindex] = GameProduceLogin:GetServerAreaDis(index);
				bAreaType = 0
				nAreaInnerIndex = nomalindex
			end;
	 		-- 设置名字.
			iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(index);
			if(iLoginServerCount > LOGIN_SERVER_COUNT) then
				iLoginServerCount=LOGIN_SERVER_COUNT;
			end
			--得到推荐大区列表
			local areaRecommendLevel = GameProduceLogin:GetServerAreaRecommendLevel(index);
			if(areaRecommendLevel > 0)  then
				if(i~=nil and i<string.len(areaname)) then
					if(string.sub(areaname,1,i-1)=="公测" and indexForRecommendArea< RECOMMEND_AREA_COUNT) then
						indexForRecommendArea = indexForRecommendArea+1;
						g_RecommendAreaRecommendLevel[indexForRecommendArea] = areaRecommendLevel;
						g_RecommendAreaName[indexForRecommendArea] = string.sub(areaname,i+1);
					end
				elseif( indexForRecommendArea < RECOMMEND_AREA_COUNT) then
					indexForRecommendArea = indexForRecommendArea+1;
					g_RecommendAreaRecommendLevel[indexForRecommendArea] = areaRecommendLevel;
					g_RecommendAreaName[indexForRecommendArea] = areaname
				end
			end

			--得到推荐服务器列表
			if(tuijian==1)then
				for i=0,iLoginServerCount-1 do
					if(indexForCommendable>=COMMENDABLE_LOGIN_SERVER_COUNT) then
							break;
					end;
					ServerName,
					ServerStatus,
					--ServerID,
					--AreaID,
					RecommendLevel,
					IsNew
						= GameProduceLogin:GetAreaLoginServerInfo(index, i);
						-- 推荐服务器id
					if(RecommendLevel>0 and indexForCommendable <COMMENDABLE_LOGIN_SERVER_COUNT and ServerStatus ~= StatMax) then
						indexForCommendable = indexForCommendable + 1;
						g_CommendableLoginServerName[indexForCommendable] = ServerName;
						g_CommendableLoginServerServerIndex[indexForCommendable] = i;
						g_CommendableLoginServerAreaIndex[indexForCommendable] = index;
						g_CommendableLoginServerCommendableLevel[indexForCommendable] = RecommendLevel;
						g_CommendableLoginServerIsNew[indexForCommendable] = IsNew;
						g_CommendableLoginServerStatus[indexForCommendable] = ServerStatus;
						g_CommendableLoginServeAreaType[indexForCommendable] = bAreaType;
						g_CommendableLoginServeAreaInnerIndex[indexForCommendable] = nAreaInnerIndex;
					end;
				end
			end;
	 	end
		--按序显示推荐大区
		if(indexForRecommendArea>=1)then
			SortRecommendArea();
			for i = 1,indexForRecommendArea do
				g_RecommendAreaBtn[i]:Show();
				g_RecommendAreaBtn[i]:SetText( g_RecommendAreaName[i]);
				g_RecommendAreaBtn[i]:SetCheck(0);
			end
		end
		--按序显示推荐服务器
		if(indexForCommendable>=1)then
			SortCommendableLoginServer();

			local strName="";
			for i = 1,indexForCommendable do
				if ( g_CommendableLoginServerCommendableLevel[i] >= 51 and g_CommendableLoginServerCommendableLevel[i] <= 60 ) then
					g_CommendableBnLoginServer[i]:SetProperty("PushedImage","set:CommonFrame38 image:TuiJian2_Hover")
					g_CommendableBnLoginServer[i]:SetProperty("NormalImage","set:CommonFrame38 image:TuiJian2_Normal")
					g_CommendableBnLoginServer[i]:SetProperty("HoverImage","set:CommonFrame38 image:TuiJian2_Hover")
					g_CommendableBnLoginServer[i]:SetProperty("DisabledImage","set:CommonFrame38 image:TuiJian2_Hover")
				end
				g_CommendableBnLoginServer[i]:Enable();
				g_CommendableBnLoginServer[i]:Show();
				local tmpAreaName = GameProduceLogin:GetServerAreaName(g_CommendableLoginServerAreaIndex[i]);
				local _i = string.find(tmpAreaName,"-");
				local bIsOriServer = 0;
				if(_i~=nil and _i<string.len(tmpAreaName)) then
					if(string.sub(tmpAreaName,1,_i-1)=="公测" or string.sub(tmpAreaName,1,_i-1)=="网通")then
						tmpAreaName = string.sub(tmpAreaName,_i+1);
						bIsOriServer = 1;
					end
				end
				strName =tmpAreaName.."-"..g_CommendableLoginServerName[i];
				if(g_CommendableLoginServerIsNew[i]~=0)then
					strName =strName.."(新)";
				end
				if bIsOriServer > 0 then
					g_CommendableBnLoginServerTuiJian[i]:Show();
				else
					g_CommendableBnLoginServerTuiJian[i]:Hide();
				end
				if(0 == g_CommendableLoginServerStatus[i]) then
					strName = "#cff0000#e010101"..strName.."#cffffff";
				elseif(1 == g_CommendableLoginServerStatus[i]) then

					strName = "#cff8a00#e010101"..strName.."#cffffff";
				elseif(2 == g_CommendableLoginServerStatus[i]) then

					strName = "#cECE58D#e010101"..strName.."#cffffff";
				elseif(3 == g_CommendableLoginServerStatus[i]) then

					strName = "#c4CFA4C#e010101"..strName.."#cffffff";
				else

					strName = "#c959595#e010101"..strName.."#cffffff";
					g_CommendableBnLoginServer[i]:Disable();
				end

				g_CommendableBnLoginServer[i]:SetText(strName);
				g_CommendableBnLoginServer[i]:SetCheck(0);
			end;
		end;
		g_iCurAreaCount =nomalindex ;
		g_iCurTestAreaCount = testindex;
end

--排序推荐大区，从小到大
function SortRecommendArea()
	local TotalCount = indexForRecommendArea;
	if (2 > TotalCount) then
		return;
	end
	local tmp ;
	for j = 1, TotalCount -1 do
		for i = 1, TotalCount -j do
			if(g_RecommendAreaRecommendLevel[i]>g_RecommendAreaRecommendLevel[i+1]) then
				tmp = g_RecommendAreaRecommendLevel[i];
				g_RecommendAreaRecommendLevel[i] = g_RecommendAreaRecommendLevel[i+1];
				g_RecommendAreaRecommendLevel[i+1] = tmp;

				tmp = g_RecommendAreaName[i];
				g_RecommendAreaName[i] = g_RecommendAreaName[i+1];
				g_RecommendAreaName[i+1] = tmp;
			end
		end
	end
end

--排序列，从小到大
function SortCommendableLoginServer()

	local TotalCount = indexForCommendable;
	local tmp ;
	local p=0;
	for j = 1 , TotalCount -1 do
		for i=1, TotalCount-j do
			if(g_CommendableLoginServerCommendableLevel[i]>g_CommendableLoginServerCommendableLevel[i+1]) then
				tmp = g_CommendableLoginServerCommendableLevel[i];
				g_CommendableLoginServerCommendableLevel[i] = g_CommendableLoginServerCommendableLevel[i+1];
				g_CommendableLoginServerCommendableLevel[i+1] = tmp;

				tmp = g_CommendableLoginServerName[i];
				g_CommendableLoginServerName[i] = g_CommendableLoginServerName[i+1];
				g_CommendableLoginServerName[i+1] = tmp;

				tmp = g_CommendableLoginServerServerIndex[i];
				g_CommendableLoginServerServerIndex[i] = g_CommendableLoginServerServerIndex[i+1];
				g_CommendableLoginServerServerIndex[i+1] = tmp;

				tmp = g_CommendableLoginServerAreaIndex[i];
				g_CommendableLoginServerAreaIndex[i] = g_CommendableLoginServerAreaIndex[i+1];
				g_CommendableLoginServerAreaIndex[i+1] = tmp;

				tmp = g_CommendableLoginServerIsNew[i];
				g_CommendableLoginServerIsNew[i] = g_CommendableLoginServerIsNew[i+1];
				g_CommendableLoginServerIsNew[i+1] = tmp;

				tmp = g_CommendableLoginServerStatus[i];
				g_CommendableLoginServerStatus[i] = g_CommendableLoginServerStatus[i+1];
				g_CommendableLoginServerStatus[i+1] = tmp;
				
				tmp = g_CommendableLoginServeAreaType[i];
				g_CommendableLoginServeAreaType[i] = g_CommendableLoginServeAreaType[i+1];
				g_CommendableLoginServeAreaType[i+1] = tmp;
				
				tmp = g_CommendableLoginServeAreaInnerIndex[i];
				g_CommendableLoginServeAreaInnerIndex[i] = g_CommendableLoginServeAreaInnerIndex[i+1];
				g_CommendableLoginServeAreaInnerIndex[i+1] = tmp;
			end
		end;
	end;
end;
--------------------------------------------------------------------------------------------------------------
--
-- 选择一个公测区域
--
function SelectServer_SelectTestAreaServer(index)
	-- 记录当前选择的区域索引.
	g_iCurSelArea = g_testAreaIndex[index+1];
	g_iCurSelAreaType = 1
	g_iCurSelAreaIndex = index+1

	-- 设置选择的名字
	g_iCurSelAreaName = g_testAreaName[index+1];

	-- 设置按钮选中状态.
	g_BntestArea[index+1]:SetCheck(1);

	-- 隐藏区域按钮.
	SelectServer_HideLoginServerBn();

	-- 得到login server的信息
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);

	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	for indexLoginServer = 0, iLoginServerCount - 1 do
		SelectServer_GetAndShowLoginServer(indexLoginServer);
	end
	for iArea = 1, g_iCurAreaCount do
		g_BnArea[iArea]:SetCheck(0);
	end
	DisableSelect();
end
--------------------------------------------------------------------------------------------------------------
--
-- 选择一个区域
--
function SelectServer_SelectAreaServer(index)

	-- 记录当前选择的区域索引.
	g_iCurSelArea = g_AreaIndex[index+CurPage*PageSize+1];
	g_iCurSelAreaType = 0
	g_iCurSelAreaIndex = index+CurPage*PageSize+1

	-- 设置选择的名字
	g_iCurSelAreaName = g_AreaName[index+CurPage*PageSize+1];

	-- 设置按钮选中状态.
	g_BnArea[index+1]:SetCheck(1);

	-- 隐藏区域按钮.
	SelectServer_HideLoginServerBn();

	-- 得到login server的信息
	local iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(g_iCurSelArea);

	if(iLoginServerCount > LOGIN_SERVER_COUNT) then
		iLoginServerCount=LOGIN_SERVER_COUNT;
	end
	for indexLoginServer = 0, iLoginServerCount - 1 do
		SelectServer_GetAndShowLoginServer(indexLoginServer);
	end
	for itestArea = 1, g_iCurTestAreaCount do
		g_BntestArea[itestArea]:SetCheck(0);
	end
	DisableSelect();
end

function DisableSelect()
		g_iCurSelLoginServer =-1;
		g_iCurComSelLoginServer = -1;
		for i = 1,indexForCommendable do
				g_CommendableBnLoginServer[i]:SetCheck(0)
		end;
		NotFlashAll();
		NotFlashAreaBtnAll();
		ClearServerTextInfo();
		--SelectServer_Accept:Disable();
end
--function EnableSelect()
--		SelectServer_Accept:Enable();
--end
--------------------------------------------------------------------------------------------------------------
--
-- 从推荐列表里选择一个login server
--
--------------------------------------------------------------------------------------------------------------
function Commendable_SelectLoginServer(index)
	-- 设置按钮选中状态.
	if(g_CommendableBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end

	g_iCurComSelLoginServer = index;

	g_CommendableBnLoginServer[index]:SetCheck(1);

	--Modify by ChengJianCai 2010/03/04
	g_iCurSelArea = g_CommendableLoginServerAreaIndex[index];
	g_iCurSelLoginServer = g_CommendableLoginServerServerIndex[index];
	g_iCurSelLoginServerName = GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, g_iCurSelLoginServer);
	--大区按钮闪烁效果
	NotFlashAreaBtnAll();

 	if(g_CommendableLoginServeAreaType[index] == 0) then
		local tAreaIndex=g_CommendableLoginServeAreaInnerIndex[index]
		if(tAreaIndex > 0) then
			g_BnArea[tAreaIndex]:SetCheck(1);
			g_BnArea[tAreaIndex]:FlashMe(1);
		end
	else
		local testAreaindex = g_CommendableLoginServeAreaInnerIndex[index];
		if(testAreaindex > 0) then
			g_BntestArea[testAreaindex]:SetCheck(1);
			g_BntestArea[testAreaindex]:FlashMe(1);
		end
 	end;
	Commendable_ShowServerInfo(index);

--	i = g_CommendableLoginServerAreaIndex[index]
--	SelectServer_ShowServerInfo(g_AreaName[i+1].."  "..g_CommendableLoginServerName[index], strLoginServerStatus);
	--同时更新下面的服务器和server
--	g_iCurSelArea = g_CommendableLoginServerAreaIndex[index];
--	for aindex = 1,g_iCurAreaCount do
--		if(g_iCurSelArea == g_AreaIndex[aindex]) then
--			AxTrace(0,2,"5" )
--			CurPage = math.floor((aindex-1)/PageSize);
--			ShowPage();
--			SelectServer_SelectAreaServer(aindex - CurPage*PageSize -1);
--			SelectServer_SelectLoginServer(g_CommendableLoginServerServerIndex[index],1);
--			return;
--		end
--	end
--	for bindex = 1,g_iCurTestAreaCount do
--		if(g_iCurSelArea == g_testAreaIndex[bindex]) then
--			SelectServer_SelectTestAreaServer(bindex-1);
--			SelectServer_SelectLoginServer(g_CommendableLoginServerServerIndex[index],1);
--			return;
--		end
--	end
end;

function Commendable_ShowServerInfo(index)
	--得到推荐服务器大区名字
	local tmpAreaName = GameProduceLogin:GetServerAreaName(g_CommendableLoginServerAreaIndex[index]);
	local _i = string.find(tmpAreaName,"-");
	if(_i~=nil and _i<string.len(tmpAreaName)) then
		if(string.sub(tmpAreaName,1,_i-1)=="公测" or string.sub(tmpAreaName,1,_i-1)=="网通")then
			tmpAreaName = string.sub(tmpAreaName,_i+1);
		end
	end
	g_iCurSelAreaName = tmpAreaName;

	local strLoginServerStatus = "???";

	if(0 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff0000爆满#cffffff";
	elseif(1 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff8a00繁忙#cffffff";
	elseif(2 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cECE58D良好#cffffff";
	elseif(3 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#c4CFA4C极佳#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595维护#cffffff";
	end

	-- 设置信息
	SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_CommendableLoginServerName[index], strLoginServerStatus);
end


-- 选择一个login server
--
function SelectServer_SelectLoginServer(index,flash)
	if(g_BnLoginServer[index+1]:GetProperty("Disabled")=="True") then
		return;
	end
	--如果处于搜索显示页面
	if(g_bSearch == 1) then
		g_iCurSelArea = g_SearchServerAreaIndex[index+1];
		g_iCurSelLoginServer = 	g_SearchServerIndex[index+1];
		g_BnLoginServer[index+1]:SetCheck(1);

		local strSearchServerStatus = "???";

		if(0 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#cff0000爆满#cffffff";
		elseif(1 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#c9E5705繁忙#cffffff";
		elseif(2 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#cECE58D良好#cffffff";
		elseif(3 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#c4CFA4C极佳#cffffff";
		else

			strSearchServerStatus = "#e010101#c959595维护#cffffff";
		end

		g_iCurSelAreaType = 0;
		local tmpAreaName = GameProduceLogin:GetServerAreaName(g_iCurSelArea);
		local _i = string.find(tmpAreaName,"-");
		if(_i~=nil and _i<string.len(tmpAreaName)) then
			if(string.sub(tmpAreaName,1,_i-1)=="公测" or string.sub(tmpAreaName,1,_i-1)=="网通")then
				tmpAreaName = string.sub(tmpAreaName,_i+1);
				g_iCurSelAreaType = 1;
			end
		end
		g_iCurSelAreaName = tmpAreaName;
		--
		if g_iCurSelAreaType == 0 then
			for i=1,g_iCurAreaCount do
				if g_iCurSelArea == g_AreaIndex[i] then
					g_iCurSelAreaIndex = i;
					break;
				end
			end
		else
			for i=1,g_iCurTestAreaCount do
				if g_iCurSelArea == g_testAreaIndex[i] then
					g_iCurSelAreaIndex = i;
					break;
				end
			end
		end
		--

		SelectServer_Server_Lastarea:SetText(g_iCurSelAreaName);
		-- 设置信息
		SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_SearchServerName[index+1], strSearchServerStatus);

		return;
	end

	--EnableSelect();
	-- 记录当前选择的login server
	g_iCurSelLoginServer = index;


	if(g_LastServer == g_iCurSelLoginServer and g_LastArea == g_iCurSelArea)then
		SelectServer_Server_Last:SetCheck(1);
	else
		SelectServer_Server_Last:SetCheck(0);
	end

	if(flash==1)then
		g_BnLoginServer[index+1]:FlashMe(1);
	else
		NotFlashAll();
	end

	-- 设置按钮选中状态.
	g_BnLoginServer[index+1]:SetCheck(1);
	local strLoginServerStatus = "???";

	if(0 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cff0000爆满#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c9E5705繁忙#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cECE58D良好#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c4CFA4C极佳#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595维护#cffffff";
	end

	-- 设置信息
	SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_LoginServerName[index+1], strLoginServerStatus);

	--更新推荐服务器
--	local tmpNum = 0
	--if(g_LoginServerCommendableLevel[index+1]>0) then
--		for i = 1,indexForCommendable do
--			if(g_CommendableLoginServerAreaIndex[i] == g_iCurSelArea and g_CommendableLoginServerServerIndex[i] == g_iCurSelLoginServer)then
--				g_iCurComSelLoginServer = i;
--				g_CommendableBnLoginServer[i]:SetCheck(1)
--			else
--				tmpNum = tmpNum+1;
--				g_CommendableBnLoginServer[i]:SetCheck(0)
--			end;
--		end;
--		if tmpNum>=indexForCommendable then
--			g_iCurComSelLoginServer = -1
--		end;
	--else
	--	g_iCurComSelLoginServer = -1;
	--end;

end

function NotFlashAll()
	for i=1,LOGIN_SERVER_COUNT do
		g_BnLoginServer[i]:FlashMe(0);
		g_BnLoginServer[i]:SetCheck(0);
	end
end

function NotFlashAreaBtnAll()
	for i=1,LOGIN_SERVER_AREA_COUNT do
		g_BnArea[i]:FlashMe(0);
		g_BnArea[i]:SetCheck(0);
	end
	for i=1,LOGIN_SERVER_TESTAREA_COUNT do
		g_BntestArea[i]:FlashMe(0);
		g_BntestArea[i]:SetCheck(0);
	end
end

--------------------------------------------------------------------------------------------------------------
--
-- 得到一个login server信息并显示
--
function SelectServer_GetAndShowLoginServer(index)

	g_LoginServerName[index+1]
	,g_LoginServerStatus[index+1]
	,g_LoginServerCommendableLevel[index+1]
	,g_LoginServerIsNew[index+1]
	= GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, index);

	ShowServerSelectSub2();
	g_BnLoginServer[index+1]:Enable();
	g_BnLoginServer[index+1]:Show();
	if(g_LoginServerStatus[index+1] == StatMax) then
		g_BnLoginServer[index+1]:Hide();
		return;
	end
	local strName = g_LoginServerName[index+1];

	if(g_LoginServerIsNew[index+1]==1)then
		strName = strName.."(新)";
	end;

	if(0 == g_LoginServerStatus[index+1]) then

		strName = "#cff0000#e010101"..strName.."#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strName = "#cff8a00#e010101"..strName.."#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strName = "#cECE58D#e010101"..strName.."#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strName = "#c4CFA4C#e010101"..strName.."#cffffff";
	else

		strName = "#c959595#e010101"..strName.."#cffffff";
		g_BnLoginServer[index+1]:Disable();
	end

	g_BnLoginServer[index+1]:SetText(strName);



end

--------------------------------------------------------------------------------------------------------------
--
-- 隐藏login server 按钮
--
function SelectServer_HideLoginServerBn()

	local index;
	for index = 1, LOGIN_SERVER_COUNT  do
 		g_BnLoginServer[index]:Hide();
 	end

end

--------------------------------------------------------------------------------------------------------------
--
-- 隐藏login server 按钮
--
function SelectServer_ShowServerInfo(ServerName, ServerStatus)

	SelectServer_Text1:SetText("#e010101您选择的服务器是:#cFFFF00"..ServerName);

	SelectServer_Text3:SetText("#e010101状态:"..ServerStatus);

end

---------------------------------------------------------------------------------------------------------------
--
--  确定选择一个服务器
--
function SelectServer_SelectOk()

	-- 连接到login server
	--童喜，不使用代理,传入服务器供应商

	--选择Last服务器 Modify by ChengJiancai 2010/03/10
	if(g_iCurSelArea == -1 or g_iCurSelLoginServer == -1) and g_LastServerState ~= StateStop then
		GameProduceLogin:SelectLoginServer(g_LastArea, g_LastServer, 3);
	else
		GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, 3);
	end
	return;
end

---------------------------------------------------------------------------------------------------------------
--
--   自动选择一个服务器
--
function SelectServer_SelectAuto()
	GameProduceLogin:AutoSelLoginServer(3);
end

---------------------------------------------------------------------------------------------------------------
--
--   退出游戏
--
function SelectServer_Exit()
	QuitApplication("quit");
end

---------------------------------------------------------------------------------------------------------------
--
-- 鼠标进入推荐服务器
--
function Commendable_LoginServer_MouseEnter(index)

	SelectServer_Info:SetText(g_CommendableLoginServerName[index]..tostring(" 服务器"));
end

---------------------------------------------------------------------------------------------------------------
--
-- 鼠标进入区域按钮
--
function SelectServer_LoginServer_MouseEnter(index)
	if (g_bSearch == 1 ) then
		SelectServer_Info:SetText(g_SearchServerName[index+1]..tostring(" 服务器"));
	else
		SelectServer_Info:SetText(g_LoginServerName[index+1]..tostring(" 服务器"));
	end
end

---------------------------------------------------------------------------------------------------------------
--
-- 鼠标进入区域按钮
--
function SelectServer_LastServer_MouseEnter()
	if(g_LastServerName~="") then
		SelectServer_Info:SetText(g_LastServerName..tostring(" 服务器"));
	else
		SelectServer_Info:SetText("");
	end
end
---------------------------------------------------------------------------------------------------------------
--
-- 鼠标离开区域按钮
--
function SelectServer_LastServer_MouseLeave()

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- 鼠标离开区域按钮
--
function SelectServer_LoginServer_MouseLeave(index)

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- 鼠标公测区域 按钮
--
function SelectServer_TestArea_MouseEnter(index)

	SelectServer_Info:SetText(g_testAreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- 鼠标离开公测区域 按钮
--
function SelectServer_TestArea_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


---------------------------------------------------------------------------------------------------------------
--
-- 鼠标进入login server 按钮
--
function SelectServer_Area_MouseEnter(index)

	SelectServer_Info:SetText(g_AreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- 鼠标离开login server 按钮
--
function SelectServer_Area_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


function SelectServer_Accept_MouseEnter()

	SelectServer_Info:SetText("点击进入所选择服务器登陆界面");
end;

function SelectServer_MouseLeave()

	SelectServer_Info:SetText("");

end;

function SelectServer_Automatic_MouseEnter()

	SelectServer_Info:SetText("帮助你选择最佳的服务器");
end;


function SelectServer_Cancel_MouseEnter()

	SelectServer_Info:SetText("退出天龙八部");
end;

function HideTestAreaBn()
	local index;
	--SelectServer2_Commendable_Text:Hide();
	for index = 1, LOGIN_SERVER_TESTAREA_COUNT  do
 		g_BntestArea[index]:Hide();
 	end
end
function HideAreaBn()
	local index;
	for index = 1, LOGIN_SERVER_AREA_COUNT  do
 		g_BnArea[index]:Hide();
 	end
end

--隐藏推荐大区按钮
function HideRecommendAreaBn()
	local index;
	for index = 1, RECOMMEND_AREA_COUNT  do
 		g_RecommendAreaBtn[index]:Hide();
 	end
end

function ShowTestAreaBn()
	local index;
	local index1 = 1;
	if g_iCurTestAreaCount<=0 then 
		SelectServer_Frame2_Sub1_Tip3:Hide();
		SelectServer_Frame2_Line2:Hide();
		SelectServer_Frame2_Line1_2:Hide();
		SelectServer_Frame2_Line3:Hide();
		return; 
	end
	
	SelectServer_Frame2_Sub1_Tip3:Show();
	SelectServer_Frame2_Line2:Show();
	SelectServer_Frame2_Line1_2:Show();
	SelectServer_Frame2_Line3:Show();
	
	--SelectServer2_Commendable_Text:Show();
	for index = 1,LOGIN_SERVER_TESTAREA_COUNT  do
 		if(index <= g_iCurTestAreaCount) then
			g_BntestArea[index1]:SetText(g_testAreaName[index]);
			g_BntestArea[index1]:SetToolTip(g_testAreaTip[index]);
			g_BntestArea[index1]:Show();
 		end;
		index1 = index1+1
 	end

	--调整网通大区位置
	--local vertCount = math.ceil(g_iCurAreaCount/4);
	--local strPos = string.format("{%f,%f}", 0.0, 335 - vertCount*24);
	--SelectServer2_Subarea_Frame:SetProperty("UnifiedYPosition", strPos);
end

function ShowAreaBn()
	local index;
	local index1 = 1;
	for index = CurPage*PageSize+1, (CurPage+1)*PageSize do

 		if(index <= g_iCurAreaCount) then
			g_BnArea[index1]:SetText(g_AreaName[index]);
			g_BnArea[index1]:SetToolTip(g_AreaTip[index]);
			g_BnArea[index1]:Show();
 		end;
		index1 = index1+1
 	end
end

--显示推荐大区按钮
function ShowRecommendAreaBn()
	local index;
	local index1 = 1;

	for index = 1,RECOMMEND_AREA_COUNT  do
 		if(index <= indexForRecommendArea) then
			g_RecommendAreaBtn[index1]:SetText(g_RecommendAreaName[index]);
			--g_RecommendAreaBtn[index1]:SetToolTip(g_testAreaTip[index]);
			g_RecommendAreaBtn[index1]:Show();
 		end;
		index1 = index1+1
 	end
end

-- 双击选择一个服务器。
function SelectServer_ConfirmSelectLine(index)
	-- 选中一个login server
	SelectServer_SelectLoginServer(index,0);

	-- 确认选择一个服务器
	SelectServer_SelectOk();

end;
-- 双击选择一个服务器。
function SelectServer_LastConfirmSelectLine()

	-- 选中一个login server
	SelectServer_SelectLastServer();

	-- 确认选择一个服务器
	SelectServer_SelectOk();

end;
-- 双击选择一个服务器。
function Commendable_ConfirmSelectLine(index)
	-- 选中一个login server
	Commendable_SelectLoginServer(index);

	-- 确认选择一个服务器
	SelectServer_SelectOk();

end;

function SelectServer_PageUp()
	CurPage = CurPage - 1
	ShowPage()
	SelectServer_SelectAreaServer(0);

end

function SelectServer_PageDown()
	CurPage = CurPage + 1
	ShowPage()
	SelectServer_SelectAreaServer(0);
end;

function ShowPage()
	--更新翻页按钮
	--UpdateUpAddDownButton();
	--hide all
	--HideAreaBn();
	--show
	--ShowAreaBn();
end;
function UpdateUpAddDownButton()
	--SelectServer_Subarea_PageUp:Hide();
	--SelectServer_Subarea_PageDown:Hide();
	--if(g_iCurAreaCount-CurPage*PageSize>PageSize)then
	--	SelectServer_Subarea_PageDown:Show()
	--end
	--if(CurPage>0)then
	--	SelectServer_Subarea_PageUp:Show()
	--end
end;

--申请帐号
function SelectServer_AccountReg()
    GameProduceLogin:StartAccountReg()
end

--帐号充值
function SelectServer_AccountChongZhi()
	if(Variable:GetVariable("System_CodePage") == "1258") then
    GameProduceLogin:OpenURL(GetWeblink("WEB_LOGON_VN"))
	else
    GameProduceLogin:OpenURL(GetWeblink("WEB_LOGON_MAIN"))
  end
end

function SelectServer_shangyibu_click()
	GameProduceLogin:GoToCampaignDlg();
end

function SelectServer_ReturnAreaSelect_click()
	ShowServerSelectSub1();
	if(g_iCurSelArea ~= -1)then
		if(g_iCurSelAreaType == 0) then
			if(g_iCurSelAreaIndex >= 0) then
				g_BnArea[g_iCurSelAreaIndex]:SetCheck(1);
			end
		else
			if(g_iCurSelAreaIndex >= 0) then
				g_BntestArea[g_iCurSelAreaIndex]:SetCheck(1);
			end
		end
	end
	ClearServerTextInfo();
end

function ShowServerSelectSub1()
	g_bSearch = 0;
	SelectServer_Frame2_Sub2:Hide();
	SelectServer_Frame2_Sub1:Show();
	SelectServer_fanhuidaqu:Hide();
	SelectServer_shangyibu:Show();
	ShowAreaBn();
	ShowTestAreaBn();
	--ShowRecommendAreaBn();
	g_iCurSelLoginServer =-1;
	g_iCurSelAreaName = "";
	SelectServer_Server_Lastarea:SetText("无");
	SelectServer_Server_Lastarea:SetCheck(0);
	GameProduceLogin:SetCurrentServerPage(1);
	SelectServer_Frame2_Sub1:StartFade(0,1,0.3);
end

function ShowServerSelectSub2()
	g_bSearch = 0;
	SelectServer_Frame2_Sub1:Hide();
	SelectServer_Frame2_Sub2:Show();
	SelectServer_shangyibu:Hide();
	SelectServer_fanhuidaqu:Show();
	SelectServer_Server_AreaNameShow:SetText(g_iCurSelAreaName);
	SelectServer_Server_Lastarea:SetText(g_iCurSelAreaName);
	SelectServer_Server_Lastarea:SetCheck(1);
	GameProduceLogin:SetCurrentServerPage(2);
	SelectServer_Frame2_Sub2:StartFade(0,1,0.3);
end


function SelectServer_CurSelectArea_MouseEnter()
	if(g_iCurSelAreaName~="") then
		SelectServer_Info:SetText(g_iCurSelAreaName);
	else
		SelectServer_Info:SetText("");
	end
end

function SelectServer_Payment_MouseEnter()
	SelectServer_Info:SetText("为您的账号充值");
end

function SelectServer_RequisitionID_MouseEnter()
	SelectServer_Info:SetText("申请一个新账号");
end

function SelectServer_ReturnAreaSelect_MouseEnter()
	SelectServer_Info:SetText("返回大区选择界面");
end

function SelectServer_shangyibu_MouseEnter()
	SelectServer_Info:SetText("返回活动日程界面");
end

--选择推荐大区
function SelectServer_RecommendArea(index)
	if(index > indexForRecommendArea) then
		return;
	end
	--如果推荐大区名字与普通大区相同
	for i = 1,g_iCurAreaCount do
		if(g_AreaName[i] == g_RecommendAreaName[index]) then
			SelectServer_SelectAreaServer(i-1);
		end
	end
end

--鼠标进入推荐大区按钮
function SelectServer_RecommendArea_MouseEnter(index)
	for i = 1,g_iCurAreaCount do
		if(g_AreaName[i] == g_RecommendAreaName[index]) then
			SelectServer_Info:SetText(g_AreaDis[i]);
		end
	end
end

--搜索按钮
function SelectServer_Search_OK()
	local szSearchName = SelectServer_Server_SearchName:GetText();
	--去除字符串首尾的空格
	szSearchName = string.gsub(szSearchName, "^%s*(.-)%s*$", "%1");
	SelectServer_Server_SearchName:SetText(szSearchName)
	if (szSearchName == "") then
		return;
	end
	local serverCount = GameProduceLogin:SetLoginServerKeyword(szSearchName);
	if (serverCount > LOGIN_SERVER_COUNT) then
		serverCount = LOGIN_SERVER_COUNT;
	end

	SelectServer_Frame2_Sub1:Hide();
	SelectServer_Frame2_Sub2:Show();
	SelectServer_shangyibu:Hide();
	SelectServer_fanhuidaqu:Show();
	SelectServer_Server_Lastarea:SetText("无");
	SelectServer_Server_Lastarea:SetCheck(1);
	GameProduceLogin:SetCurrentServerPage(2);
	SelectServer_Frame2_Sub2:StartFade(0,1,0.3);
	g_bSearch = 1;

	if ( serverCount == 0) then
		SelectServer_Server_AreaNameShow:SetText("未找到相匹配结果");
	else
		SelectServer_Server_AreaNameShow:SetText("搜索结果");
	end

	--隐藏所有服务器按钮
	SelectServer_HideLoginServerBn();

	for i = 1,indexForCommendable do
			g_CommendableBnLoginServer[i]:SetCheck(0)
	end;
	NotFlashAll();
	NotFlashAreaBtnAll();

	--显示之前将当前选择全部清空
	g_iCurSelArea = -1;
	g_iCurSelLoginServer = -1;
	g_iCurComSelLoginServer = -1;
	ClearServerTextInfo();

	for i = 1,serverCount do
		g_SearchServerName[i],
		g_SearchServerStatus[i],
		_,
		g_SearchServerIsNew[i],
		_,
		g_SearchServerAreaIndex[i],
		_,
		g_SearchServerIndex[i]
		 = GameProduceLogin:GetKeywordLoginServerInfo(i-1);

		g_BnLoginServer[i]:SetCheck(0);
		g_BnLoginServer[i]:Enable();
		g_BnLoginServer[i]:Show();

		--服务器处于未开放状态
		if(g_SearchServerStatus[i] == StatMax) then
			g_BnLoginServer[i]:Hide();
		end

		local strName = g_SearchServerName[i];
		if(g_SearchServerIsNew[i]==1)then
			strName = strName.."(新)";
		end;

		if(0 == g_SearchServerStatus[i]) then
			strName = "#cff0000#e010101"..strName.."#cffffff";
		elseif(1 == g_SearchServerStatus[i]) then
			strName = "#cff8a00#e010101"..strName.."#cffffff";
		elseif(2 == g_SearchServerStatus[i]) then
			strName = "#cECE58D#e010101"..strName.."#cffffff";
		elseif(3 == g_SearchServerStatus[i]) then
			strName = "#c4CFA4C#e010101"..strName.."#cffffff";
		else
			strName = "#c959595#e010101"..strName.."#cffffff";
			g_BnLoginServer[i]:Disable();
		end

		g_BnLoginServer[i]:SetText(strName);
	end
end

--清除下方选择服务器信息
function ClearServerTextInfo()

	SelectServer_Text1:SetText("");
	SelectServer_Text3:SetText("");

end

--刷新按钮
function SelectServer_FreshPage()
	GameProduceLogin:LoadLaunch();
end


--角色查询
function SelectServer_Forgotarea()
	--GameProduceLogin:OpenURL(GetWeblink("WEB_ROLE_INQUIRY"))
	LuaFindRoleByAcc()
end

--角色查询
function SelectServer_Forgotarea_MouseEnter()
	SelectServer_Info:SetText("#{JSCX_250507_03}"); --查看账号下所有角色所在的服务器
end
