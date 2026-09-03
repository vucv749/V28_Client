-------------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿
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
local NetSpeed ={"#e010101T¯c ðµ: #c4CFA4CT¯t","#e010101T¯c ðµ: #c4CFA4CB§n rµn","#e010101T¯c ðµ: Chßa biªt", "#e010101T¯c ðµ mÕng: #cff0000T¡c ngh¨n" }
local PageSize = 24

-- ÇøÓò°´Å¥µÄ¸öÊý
local LOGIN_SERVER_AREA_COUNT = 16;
--Ä¿Ç°ÓÐÐ§µÄÇøÓò°´Å¥¸öÊý£¬ÓÉÓÚ½çÃæ¸Ä¶¯Ì«´ó£¬ÅÂÒÔºóÓÐÈËÓÖ·´»Ú£¬¼Ó â¸ö±äÁ¿£¬Ö÷ÒªÊÇ²»ÏëÈ¥µô·­Ò³´úÂë¡£
local EFFECT_LOGIN_SERVER_AREA_COUNT = 16;
-- ¹«²âÇøÓò°´Å¥µÄ¸öÊý
local LOGIN_SERVER_TESTAREA_COUNT = 16;
-- ÇøÓò°´Å¥
local g_BnArea = {};

-- ¹«²âÇøÓò°´Å¥
local g_BntestArea = {};

-- µ±Ç°Ñ¡ÔñµÄÇøÓò
local g_iCurSelArea = 0;
local g_iCurSelAreaType = 0;
local g_iCurSelAreaIndex = 0;
-- login server ¿Í»§¶ËË÷Òý
local g_AreaIndex ={};
-- login server Ãû×Ö
local g_AreaName = {};
-- login server Ãû×Ö
local g_AreaDis = {};
-- testlogin server ¿Í»§¶ËË÷Òý
local g_testAreaIndex ={};
-- login server Ãû×Ö
local g_testAreaName = {};
-- login server Ãû×Ö
local g_testAreaDis = {};
-- µ±Ç°Ñ¡ÔñµÄÇøÓòÃû×Ö
local g_iCurSelAreaName;
-- µ±Ç°Ñ¡ÔñµÄ·þÎñÆ÷Ãû×Ö
local g_iCurSelLoginServerName;

--ÇøÓòtips
local g_AreaTip = {};
local g_testAreaTip = {};



local g_idBackSound = -1;

-- ¼ÇÔØÍÆ¼ö·þÎñÆ÷µÄ¸öÊý
local indexForCommendable = 1;
------------------------------------------------------------------------------
--
-- login server ÐÅÏ¢
--

-- login server µÄ¸öÊý
--local LOGIN_SERVER_COUNT = 55;    -- modify by zchw 45-->55
local LOGIN_SERVER_COUNT = 85;    -- modify by zchw 45-->55

local COMMENDABLE_LOGIN_SERVER_COUNT = 12;

-- login server °´Å¥
local g_BnLoginServer = {};
-- login server ×´Ì¬
local g_LoginServerStatus = {};
-- login server Ãû×Ö
local g_LoginServerName = {};
-- login server ÍÆ¼öµÈ¼¶
local g_LoginServerCommendableLevel = {};
-- login server ÊÇ·ñÐÂ¿ª
local g_LoginServerIsNew = {};



-- ÍÆ¼ö·þÎñÆ÷°´Å¥
local g_CommendableBnLoginServer = {};
local g_CommendableBnLoginServerTuiJian = {};
-- ÍÆ¼ö·þÎñÆ÷Ãû×Ö
local g_CommendableLoginServerName = {};
-- ÍÆ¼ö·þÎñÆ÷Index
local g_CommendableLoginServerServerIndex = {};
-- ÍÆ¼ö·þÎñÆ÷ÇøÓòIndex
local g_CommendableLoginServerAreaIndex = {};
-- ÍÆ¼ö·þÎñÆ÷ÍÆ¼öµÈ¼¶
local g_CommendableLoginServerCommendableLevel = {};
-- ÍÆ¼ö·þÎñÆ÷ÊÇ·ñÐÂ·þ
local g_CommendableLoginServerIsNew = {};
-- ÍÆ¼ö·þÎñÆ÷ ×´Ì¬
local g_CommendableLoginServerStatus = {};
-- ÍÆ¼ö·þÎñÆ÷ÇøÓò ÀàÐÍ
local g_CommendableLoginServeAreaType = {};
-- ÍÆ¼ö·þÎñÆ÷ÇøÓò ÀàÐÍÄÚË÷Òý
local g_CommendableLoginServeAreaInnerIndex = {};

-------------------------------------------------------------------------------
--
-- ÆäËûÐÅÏ¢
--

-- µ±Ç°Ñ¡ÔñµÄlogin server
local g_iCurSelLoginServer = -1;
-- µ±Ç°Ñ¡ÔñµÄÍÆ¼ölogin server index
local g_iCurComSelLoginServer = -1;

-- ÇøÓòµÄ¸öÊý
local g_iCurAreaCount = 0;
--¹«²âÇøÓò¸öÊý
local g_iCurTestAreaCount = 0;

local g_FirstLogin = 1;

--·þÎñÆ÷´¦ÓÚÎ¬»¤×´Ì¬
local StateStop = 4;
--²»ÏÔÊ¾×´Ì¬
local StatMax = 10;

local RECOMMEND_AREA_COUNT = 4;
--¼ÇÔØµçÐÅÍÆ¼ö´óÇøÊýÁ¿
local indexForRecommendArea = 0;
--ÍÆ¼öµçÐÅ´óÇø°´Å¥
local g_RecommendAreaBtn = {};
--ÍÆ¼öµçÐÅ´óÇøÃû×Ö
local g_RecommendAreaName = {};
--ÍÆ¼öµçÐÅ´óÇøÍÆ¼öµÈ¼¶
local g_RecommendAreaRecommendLevel = {};

-- ËÑË÷ÁÐ±í·þÎñÆ÷Index
local g_SearchServerIndex = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷´óÇøIndex
local g_SearchServerAreaIndex = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷Ãû³Æ
local g_SearchServerName = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷ÊÇ·ñÐÂ·þ
local g_SearchServerIsNew = {};
-- ËÑË÷ÁÐ±í·þÎñÆ÷×´Ì¬
local g_SearchServerStatus = {};
-- ÊÇ·ñÏÔÊ¾ËÑË÷Ò³Ãæ
local g_bSearch = 0;

-------------------------------------------------------------------------------------------------------------
--
-- º¯ÊýÇø.
--
--

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectServer_PreLoad()
	-- ´ò¿ªÑ¡Ôñ·þÎñÆ÷½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_SERVER");

	-- Ñ¡ÔñÇøÓò
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_SERVER");

	-- ´ò¿ªÑ¡Ôñ·þÎñÆ÷½çÃæ
	this:RegisterEvent("GAMELOGIN_SELECT_AREA");

	-- Ñ¡Ôñlogin
	this:RegisterEvent("GAMELOGIN_SELECT_LOGINSERVER");

	-- ×¢²áÑ¡ÔñÒ»¸ölogin serverÊÂ¼þ
	this:RegisterEvent("GAMELOGIN_SELECT_LOGIN_SERVER");

	-- Íæ¼Ò½øÈë³¡¾°
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	--ÉÏ´ÎµÇÂ¼µÄ·þÎñÆ÷
	this:RegisterEvent("GAMELOGIN_LASTSELECT_AREA_AND_SERVER");

	--½øÈë ËºÅÊäÈë½çÃæ
	this:RegisterEvent("GAMELOGIN_SERVER_SHOW_COUNTINPUT");

	--·µ»Ø·þÎñÆ÷Ñ¡ÔñSub1
	this:RegisterEvent("GAMELOGIN_SERVER_SHOW_SUB");

	--¸üÐÂ·þÎñÆ÷ÁÐ±íÐÅÏ¢
	this:RegisterEvent("GAMELOGIN_UPDATE_SERVERINFO");

end

function LoginSelectServer_OnLoad()

	-- µÃµ½ÇøÓò°´Å¥
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

	--µÃµ½ÍÆ¼ö·þÎñÆ÷ÁÐ±í
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

	--µÃµ½ÍÆ¼ö´óÇøÁÐ±í
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
	 	-- Login server °´Å¥

	 	g_CommendableBnLoginServer[i]:SetProperty("CheckMode", "1");
		-- login server Ãû×Ö
		g_CommendableLoginServerName[i] = "";
		--login server index
		g_CommendableLoginServerIndex[i]=-1;
	end
	-- µÃµ½·þÎñÆ÷°´Å¥
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
	 	-- Login server °´Å¥
	 	g_BnLoginServer[i]:SetProperty("CheckMode", "1");

		-- login server ×´Ì¬
		g_LoginServerStatus[i] = 0;

		-- login server Ãû×Ö
		g_LoginServerName[i] = "";

		g_LoginServerCommendableLevel[i]="";
	end
	-- Òþ²ØËùÓÐÍÆ¼ö·þÎñÆ÷
	HideAllCommendableBn();
	--ÏÈÒþ²ØÍÆ¼ö´óÇø°´Å¥
	HideRecommendAreaBn();
	-- µÃµ½·þÎñÆ÷ÐÅÏ¢
	LoginSelectServer_GetServerInfo();

	local strNormalColor = "#cFFF263";
	SelectServer_Help_Text1:SetText(	strNormalColor.."#e010101#cff0000Ðö: Ð¥y#cffffff" );
	SelectServer_Help_Text2:SetText(	strNormalColor.."#e010101#cECE58DNhÕt: T¯t#cffffff" );
	SelectServer_Help_Text3:SetText(	strNormalColor.."#e010101#c959595Xám: Bäo trì#cffffff" );
	SelectServer_Help_Text4:SetText(	strNormalColor.."#e010101#cff8a00Cam: S¡p ð¥y#cffffff" );
	SelectServer_Help_Text5:SetText(	strNormalColor.."#e010101#c4CFA4CLøc: R¤t t¯t#cffffff" );


	-- ´ò¿ª½çÃæ
	SelectServer_Frame:SetProperty("AlwaysOnTop", "True");

	-- ÏÈÒþ²ØËùÓÐ°´Å¥¡£
	HideAreaBn();
	-- ÏÈÒþ²ØËùÓÐ°´Å¥¡£
	HideTestAreaBn();

end

function HideAllCommendableBn()
	for i = 1,COMMENDABLE_LOGIN_SERVER_COUNT do
		g_CommendableBnLoginServer[i]:Hide();
	end;
end
--ÊÇ·ñ×Ô¶¯°ÑÑ¡ÔñµÄ·þÎñÆ÷ÐòºÅ±ä³É0£¬·ÀÖ¹.txtÎÄ¼þÓÐ´óµÄ±ä¶¯
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
		-- ÏÔÊ¾´æÔÚµÄÇøÓò°´Å¥¡£
		--ShowAreaBn();
		--ShowTestAreaBn();
		--ÏÔÊ¾ÉÏÏÂ·­Ò³
		UpdateUpAddDownButton();
		ShowServerSelectSub1();

		-- ²¥·Å±³¾°ÒôÀÖ
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
           -- GameProduceLogin:ShowMessageBox( "    Ä¿Ç°Ö»¿ª·ÅÁËÒ»Ì¨ÍøÍ¨·þÎñÆ÷ÓÃÓÚ²âÊÔ£¬Èç¹ûÄúÊÇµçÐÅµÄÓÃ»§£¬ÇëÔÚ·þÎñÆ÷Ñ¡Ôñ½çÃæµÄÓÒ±ßÑ¡Ôñ¡°µçÐÅ¡±½øÐÐµÇÂ¼£¬ âÑù²ÅÄÜÊ¹ÓÃ»¥Áª»¥Í¨¹¦ÄÜÒÔ±£Ö¤ÄúµÄÁ¬½ÓËÙ¶È¡£", "OK", "1" );
		    --g_FirstLogin = 0
		--end

		return;
	end


	-- ¹Ø± ½çÃæ
	if( event == "GAMELOGIN_CLOSE_SELECT_SERVER") then
		NotFlashAreaBtnAll();
		this:Hide();
		return;
	end

	-- Ñ¡ÔñÒ»¸ölogin server
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

	-- Ñ¡ÔñÇøÓò
	if( event == "GAMELOGIN_SELECT_AREA") then
		--Èç¹û´Ó ËºÅÊäÈë½çÃæ·µ»Ø´óÇø½çÃæ
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
		--ÍêÈ«Ã»ÓÐ Òµ½£¬ËµÃ÷ÎÄ¼þÓÐÁË´óµÄ±ä»¯
		CurPage = 0;
		autoZero = 1;
		SelectServer_SelectAreaServer(1 - CurPage*PageSize -1);
		return;
	end;

	-- Ñ¡Ôñlogin
	if( event == "GAMELOGIN_SELECT_LOGINSERVER") then
		--Èç¹û´Ó ËºÅÊäÈë½çÃæ·µ»Ø´óÇø½çÃæ
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

	-- ½øÈë³¡¾°£¬Í£Ö¹±³¾°ÒôÀÖ
	if( event == "PLAYER_ENTERING_WORLD") then
		if(g_idBackSound ~= -1) then
			Sound:StopSound(g_idBackSound);
			g_idBackSound = -1;
		end
	end
	
	--ÉÏ´ÎµÇÂ¼·þÎñÆ÷
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
				--ÅÐ¶ÏÉÏ´ÎµÇÂ¼·þÎñÆ÷ÊÇ·ñ´¦ÓÚÎ¬»¤×´Ì¬ tt69698
				if (g_LastServerState == StateStop) then
					SelectServer_Server_Last:SetCheck(0);
					SelectServer_Server_Last:Disable();
				else
					SelectServer_Server_Last:Enable();
					--if(g_iCurSelArea == g_LastArea and g_LastServer ==g_iCurSelLoginServer)then
						SelectServer_Server_Last:SetCheck(1);
					--end
				end
				--»ñÈ¡Ñ¡Ôñ´óÇø
				SelectServer_Server_AreaNameShow:SetText(g_iCurSelAreaName);
				if g_iCurSelAreaName ~= "" then
					SelectServer_Server_Lastarea:SetText(g_iCurSelAreaName);
				else
					SelectServer_Server_Lastarea:SetText("Không");
				end
				SelectServer_Server_Lastarea:Enable();
			else
				SelectServer_Server_Last:SetText("Không");
				SelectServer_Server_Last:SetCheck(0);
				SelectServer_Server_Last:Disable();
			end
		else
			SelectServer_Server_Last:SetText("Không");
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
		-- Òþ²ØËùÓÐÍÆ¼ö·þÎñÆ÷
		HideAllCommendableBn();
		--ÏÈÒþ²ØÍÆ¼ö´óÇø°´Å¥
		HideRecommendAreaBn();
		-- µÃµ½·þÎñÆ÷ÐÅÏ¢
		LoginSelectServer_GetServerInfo();
			-- ÏÈÒþ²ØËùÓÐ°´Å¥¡£
		HideAreaBn();
		-- ÏÈÒþ²ØËùÓÐ°´Å¥¡£
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
-- µÃµ½·þÎñÆ÷ÐÅÏ¢
--

function LoginSelectServer_GetServerInfo()

	 	local iCurAreaCount = GameProduceLogin:GetServerAreaCount();
	 	local strAreaName = "Không có máy chü";
		local iLoginServerCount = -1;
		local ServerName;
		local ServerStatus;
		--ÍÆ¼öµÈ¼¶
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
	 		-- µÃµ½ÇøÓòÃû×Ö.
			local i = string.find(areaname,"-");
			if(i~=nil and i<string.len(areaname)) then
				if(string.sub(areaname,1,i-1)=="Võng Thông" and testindex<LOGIN_SERVER_TESTAREA_COUNT)then
					testindex = testindex +1;
					g_testAreaName[testindex] = string.sub(areaname,i+1);
					g_testAreaDis[testindex] = GameProduceLogin:GetServerAreaDis(index);
					g_testAreaIndex[testindex] = index;
					tuijian = 1;
					g_testAreaTip[testindex] = GameProduceLogin:GetServerAreaDis(index);
					bAreaType = 1
					nAreaInnerIndex = testindex
				elseif(string.sub(areaname,1,i-1)=="Công Tr¡c" and nomalindex< EFFECT_LOGIN_SERVER_AREA_COUNT) then
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
	 		-- ÉèÖÃÃû×Ö.
			iLoginServerCount = GameProduceLogin:GetAreaLoginServerCount(index);
			if(iLoginServerCount > LOGIN_SERVER_COUNT) then
				iLoginServerCount=LOGIN_SERVER_COUNT;
			end
			--µÃµ½ÍÆ¼ö´óÇøÁÐ±í
			local areaRecommendLevel = GameProduceLogin:GetServerAreaRecommendLevel(index);
			if(areaRecommendLevel > 0)  then
				if(i~=nil and i<string.len(areaname)) then
					if(string.sub(areaname,1,i-1)=="Công Tr¡c" and indexForRecommendArea< RECOMMEND_AREA_COUNT) then
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

			--µÃµ½ÍÆ¼ö·þÎñÆ÷ÁÐ±í
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
						-- ÍÆ¼ö·þÎñÆ÷id
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
		--°´ÐòÏÔÊ¾ÍÆ¼ö´óÇø
		if(indexForRecommendArea>=1)then
			SortRecommendArea();
			for i = 1,indexForRecommendArea do
				g_RecommendAreaBtn[i]:Show();
				g_RecommendAreaBtn[i]:SetText( g_RecommendAreaName[i]);
				g_RecommendAreaBtn[i]:SetCheck(0);
			end
		end
		--°´ÐòÏÔÊ¾ÍÆ¼ö·þÎñÆ÷
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
					if(string.sub(tmpAreaName,1,_i-1)=="Công tr¡c" or string.sub(tmpAreaName,1,_i-1)=="Võng Thông")then
						tmpAreaName = string.sub(tmpAreaName,_i+1);
						bIsOriServer = 1;
					end
				end
				strName =tmpAreaName.."-"..g_CommendableLoginServerName[i];
				if(g_CommendableLoginServerIsNew[i]~=0)then
					strName =strName.."(Tân)";
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

--ÅÅÐòÍÆ¼ö´óÇø£¬´ÓÐ¡µ½´ó
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

--ÅÅÐòÁÐ£¬´ÓÐ¡µ½´ó
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
-- Ñ¡ÔñÒ»¸ö¹«²âÇøÓò
--
function SelectServer_SelectTestAreaServer(index)
	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄÇøÓòË÷Òý.
	g_iCurSelArea = g_testAreaIndex[index+1];
	g_iCurSelAreaType = 1
	g_iCurSelAreaIndex = index+1

	-- ÉèÖÃÑ¡ÔñµÄÃû×Ö
	g_iCurSelAreaName = g_testAreaName[index+1];

	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	g_BntestArea[index+1]:SetCheck(1);

	-- Òþ²ØÇøÓò°´Å¥.
	SelectServer_HideLoginServerBn();

	-- µÃµ½login serverµÄÐÅÏ¢
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
-- Ñ¡ÔñÒ»¸öÇøÓò
--
function SelectServer_SelectAreaServer(index)

	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄÇøÓòË÷Òý.
	g_iCurSelArea = g_AreaIndex[index+CurPage*PageSize+1];
	g_iCurSelAreaType = 0
	g_iCurSelAreaIndex = index+CurPage*PageSize+1

	-- ÉèÖÃÑ¡ÔñµÄÃû×Ö
	g_iCurSelAreaName = g_AreaName[index+CurPage*PageSize+1];

	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	g_BnArea[index+1]:SetCheck(1);

	-- Òþ²ØÇøÓò°´Å¥.
	SelectServer_HideLoginServerBn();

	-- µÃµ½login serverµÄÐÅÏ¢
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
-- ´ÓÍÆ¼öÁÐ±íÀïÑ¡ÔñÒ»¸ölogin server
--
--------------------------------------------------------------------------------------------------------------
function Commendable_SelectLoginServer(index)
	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	if(g_CommendableBnLoginServer[index]:GetProperty("Disabled")=="True") then
		return;
	end

	g_iCurComSelLoginServer = index;

	g_CommendableBnLoginServer[index]:SetCheck(1);

	--Modify by ChengJianCai 2010/03/04
	g_iCurSelArea = g_CommendableLoginServerAreaIndex[index];
	g_iCurSelLoginServer = g_CommendableLoginServerServerIndex[index];
	g_iCurSelLoginServerName = GameProduceLogin:GetAreaLoginServerInfo(g_iCurSelArea, g_iCurSelLoginServer);
	--´óÇø°´Å¥ÉÁË¸Ð§¹û
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
	--Í¬Ê±¸üÐÂÏÂÃæµÄ·þÎñÆ÷ºÍserver
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
	--µÃµ½ÍÆ¼ö·þÎñÆ÷´óÇøÃû×Ö
	local tmpAreaName = GameProduceLogin:GetServerAreaName(g_CommendableLoginServerAreaIndex[index]);
	local _i = string.find(tmpAreaName,"-");
	if(_i~=nil and _i<string.len(tmpAreaName)) then
		if(string.sub(tmpAreaName,1,_i-1)=="Công tr¡c" or string.sub(tmpAreaName,1,_i-1)=="Võng Thông")then
			tmpAreaName = string.sub(tmpAreaName,_i+1);
		end
	end
	g_iCurSelAreaName = tmpAreaName;

	local strLoginServerStatus = "???";

	if(0 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff0000Ð¥y#cffffff";
	elseif(1 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cff8a00S¡p ð¥y#cffffff";
	elseif(2 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#cECE58DT¯t#cffffff";
	elseif(3 == g_CommendableLoginServerStatus[index]) then

		strLoginServerStatus = "#e010101#c4CFA4CR¤t t¯t#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595Bäo trì#cffffff";
	end

	-- ÉèÖÃÐÅÏ¢
	SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_CommendableLoginServerName[index], strLoginServerStatus);
end


-- Ñ¡ÔñÒ»¸ölogin server
--
function SelectServer_SelectLoginServer(index,flash)
	if(g_BnLoginServer[index+1]:GetProperty("Disabled")=="True") then
		return;
	end
	--Èç¹û´¦ÓÚËÑË÷ÏÔÊ¾Ò³Ãæ
	if(g_bSearch == 1) then
		g_iCurSelArea = g_SearchServerAreaIndex[index+1];
		g_iCurSelLoginServer = 	g_SearchServerIndex[index+1];
		g_BnLoginServer[index+1]:SetCheck(1);

		local strSearchServerStatus = "???";

		if(0 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#cff0000Ð¥y#cffffff";
		elseif(1 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#c9E5705S¡p ð¥y#cffffff";
		elseif(2 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#cECE58DT¯t#cffffff";
		elseif(3 == g_SearchServerStatus[index+1]) then

			strSearchServerStatus = "#e010101#c4CFA4CR¤t t¯t#cffffff";
		else

			strSearchServerStatus = "#e010101#c959595Bäo trì#cffffff";
		end

		g_iCurSelAreaType = 0;
		local tmpAreaName = GameProduceLogin:GetServerAreaName(g_iCurSelArea);
		local _i = string.find(tmpAreaName,"-");
		if(_i~=nil and _i<string.len(tmpAreaName)) then
			if(string.sub(tmpAreaName,1,_i-1)=="Công tr¡c" or string.sub(tmpAreaName,1,_i-1)=="Võng Thông")then
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
		-- ÉèÖÃÐÅÏ¢
		SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_SearchServerName[index+1], strSearchServerStatus);

		return;
	end

	--EnableSelect();
	-- ¼ÇÂ¼µ±Ç°Ñ¡ÔñµÄlogin server
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

	-- ÉèÖÃ°´Å¥Ñ¡ÖÐ×´Ì¬.
	g_BnLoginServer[index+1]:SetCheck(1);
	local strLoginServerStatus = "???";

	if(0 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cff0000Ð¥y#cffffff";
	elseif(1 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c9E5705S¡p ð¥y#cffffff";
	elseif(2 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#cECE58DT¯t#cffffff";
	elseif(3 == g_LoginServerStatus[index+1]) then

		strLoginServerStatus = "#e010101#c4CFA4CR¤t t¯t#cffffff";
	else

		strLoginServerStatus = "#e010101#c959595Bäo trì#cffffff";
	end

	-- ÉèÖÃÐÅÏ¢
	SelectServer_ShowServerInfo(g_iCurSelAreaName.."  "..g_LoginServerName[index+1], strLoginServerStatus);

	--¸üÐÂÍÆ¼ö·þÎñÆ÷
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
-- µÃµ½Ò»¸ölogin serverÐÅÏ¢²¢ÏÔÊ¾
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
		strName = strName.."(M¾i)";
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
-- Òþ²Ølogin server °´Å¥
--
function SelectServer_HideLoginServerBn()

	local index;
	for index = 1, LOGIN_SERVER_COUNT  do
 		g_BnLoginServer[index]:Hide();
 	end

end

--------------------------------------------------------------------------------------------------------------
--
-- Òþ²Ølogin server °´Å¥
--
function SelectServer_ShowServerInfo(ServerName, ServerStatus)

	SelectServer_Text1:SetText("#e010101Máy chü: #cFFFF00"..ServerName);

	SelectServer_Text3:SetText("#e010101TrÕng thái: "..ServerStatus);

end

---------------------------------------------------------------------------------------------------------------
--
--  È·¶¨Ñ¡ÔñÒ»¸ö·þÎñÆ÷
--
function SelectServer_SelectOk()

	-- Á¬½Óµ½login server
	--Í¯Ï²£¬²»Ê¹ÓÃ´úÀí,´«Èë·þÎñÆ÷¹©Ó¦ÉÌ

	--Ñ¡ÔñLast·þÎñÆ÷ Modify by ChengJiancai 2010/03/10
	if(g_iCurSelArea == -1 or g_iCurSelLoginServer == -1) and g_LastServerState ~= StateStop then
		GameProduceLogin:SelectLoginServer(g_LastArea, g_LastServer, 3);
	else
		GameProduceLogin:SelectLoginServer(g_iCurSelArea, g_iCurSelLoginServer, 3);
	end
	return;
end

---------------------------------------------------------------------------------------------------------------
--
--   ×Ô¶¯Ñ¡ÔñÒ»¸ö·þÎñÆ÷
--
function SelectServer_SelectAuto()
	GameProduceLogin:AutoSelLoginServer(3);
end

---------------------------------------------------------------------------------------------------------------
--
--   ÍË³öÓÎÏ·
--
function SelectServer_Exit()
	QuitApplication("quit");
end

---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëÍÆ¼ö·þÎñÆ÷
--
function Commendable_LoginServer_MouseEnter(index)

	SelectServer_Info:SetText(g_CommendableLoginServerName[index]..tostring(" Máy chü"));
end

---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëÇøÓò°´Å¥
--
function SelectServer_LoginServer_MouseEnter(index)
	if (g_bSearch == 1 ) then
		SelectServer_Info:SetText(g_SearchServerName[index+1]..tostring(" Máy chü"));
	else
		SelectServer_Info:SetText(g_LoginServerName[index+1]..tostring(" Máy chü"));
	end
end

---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëÇøÓò°´Å¥
--
function SelectServer_LastServer_MouseEnter()
	if(g_LastServerName~="") then
		SelectServer_Info:SetText(g_LastServerName..tostring(" Máy chü"));
	else
		SelectServer_Info:SetText("");
	end
end
---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ªÇøÓò°´Å¥
--
function SelectServer_LastServer_MouseLeave()

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ªÇøÓò°´Å¥
--
function SelectServer_LoginServer_MouseLeave(index)

	SelectServer_Info:SetText("");
end
---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê¹«²âÇøÓò °´Å¥
--
function SelectServer_TestArea_MouseEnter(index)

	SelectServer_Info:SetText(g_testAreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ª¹«²âÇøÓò °´Å¥
--
function SelectServer_TestArea_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


---------------------------------------------------------------------------------------------------------------
--
-- Êó±ê½øÈëlogin server °´Å¥
--
function SelectServer_Area_MouseEnter(index)

	SelectServer_Info:SetText(g_AreaDis[index+1]);
end


---------------------------------------------------------------------------------------------------------------
--
-- Êó±êÀë¿ªlogin server °´Å¥
--
function SelectServer_Area_MouseLeave(index)

	SelectServer_Info:SetText("");
end;


function SelectServer_Accept_MouseEnter()

	SelectServer_Info:SetText("Nh¤p vào giao di®n ch÷n máy chü ðång nh§p");
end;

function SelectServer_MouseLeave()

	SelectServer_Info:SetText("");

end;

function SelectServer_Automatic_MouseEnter()

	SelectServer_Info:SetText("Giúp các hÕ ch÷n máy chü t¯t nh¤t");
end;


function SelectServer_Cancel_MouseEnter()

	SelectServer_Info:SetText("Thoát");
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

--Òþ²ØÍÆ¼ö´óÇø°´Å¥
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

	--µ÷ ûÍøÍ¨´óÇøÎ»ÖÃ
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

--ÏÔÊ¾ÍÆ¼ö´óÇø°´Å¥
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

-- Ë«»÷Ñ¡ÔñÒ»¸ö·þÎñÆ÷¡£
function SelectServer_ConfirmSelectLine(index)
	-- Ñ¡ÖÐÒ»¸ölogin server
	SelectServer_SelectLoginServer(index,0);

	-- È·ÈÏÑ¡ÔñÒ»¸ö·þÎñÆ÷
	SelectServer_SelectOk();

end;
-- Ë«»÷Ñ¡ÔñÒ»¸ö·þÎñÆ÷¡£
function SelectServer_LastConfirmSelectLine()

	-- Ñ¡ÖÐÒ»¸ölogin server
	SelectServer_SelectLastServer();

	-- È·ÈÏÑ¡ÔñÒ»¸ö·þÎñÆ÷
	SelectServer_SelectOk();

end;
-- Ë«»÷Ñ¡ÔñÒ»¸ö·þÎñÆ÷¡£
function Commendable_ConfirmSelectLine(index)
	-- Ñ¡ÖÐÒ»¸ölogin server
	Commendable_SelectLoginServer(index);

	-- È·ÈÏÑ¡ÔñÒ»¸ö·þÎñÆ÷
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
	--¸üÐÂ·­Ò³°´Å¥
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

--ÉêÇë ÊºÅ
function SelectServer_AccountReg()
    GameProduceLogin:StartAccountReg()
end

-- ÊºÅ³äÖµ
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
	SelectServer_Server_Lastarea:SetText("Không");
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
	SelectServer_Info:SetText("NÕp vào tài khoän cüa các hÕ");
end

function SelectServer_RequisitionID_MouseEnter()
	SelectServer_Info:SetText("Ðång ký tài khoän m¾i");
end

function SelectServer_ReturnAreaSelect_MouseEnter()
	SelectServer_Info:SetText("Tr· v« giao di®n ch÷n khu");
end

function SelectServer_shangyibu_MouseEnter()
	SelectServer_Info:SetText("Tr· v« giao di®n l¸ch trình hoÕt ðµng");
end

--Ñ¡ÔñÍÆ¼ö´óÇø
function SelectServer_RecommendArea(index)
	if(index > indexForRecommendArea) then
		return;
	end
	--Èç¹ûÍÆ¼ö´óÇøÃû×ÖÓëÆ Í¨´óÇøÏàÍ¬
	for i = 1,g_iCurAreaCount do
		if(g_AreaName[i] == g_RecommendAreaName[index]) then
			SelectServer_SelectAreaServer(i-1);
		end
	end
end

--Êó±ê½øÈëÍÆ¼ö´óÇø°´Å¥
function SelectServer_RecommendArea_MouseEnter(index)
	for i = 1,g_iCurAreaCount do
		if(g_AreaName[i] == g_RecommendAreaName[index]) then
			SelectServer_Info:SetText(g_AreaDis[i]);
		end
	end
end

--ËÑË÷°´Å¥
function SelectServer_Search_OK()
	local szSearchName = SelectServer_Server_SearchName:GetText();
	--È¥³ý×Ö·û´®Ê×Î²µÄ¿ ¸ñ
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
	SelectServer_Server_Lastarea:SetText("Không");
	SelectServer_Server_Lastarea:SetCheck(1);
	GameProduceLogin:SetCurrentServerPage(2);
	SelectServer_Frame2_Sub2:StartFade(0,1,0.3);
	g_bSearch = 1;

	if ( serverCount == 0) then
		SelectServer_Server_AreaNameShow:SetText("Chßa tìm ðßþc kªt quä tß½ng Ñng");
	else
		SelectServer_Server_AreaNameShow:SetText("Kªt quä");
	end

	--Òþ²ØËùÓÐ·þÎñÆ÷°´Å¥
	SelectServer_HideLoginServerBn();

	for i = 1,indexForCommendable do
			g_CommendableBnLoginServer[i]:SetCheck(0)
	end;
	NotFlashAll();
	NotFlashAreaBtnAll();

	--ÏÔÊ¾Ö®Ç°½«µ±Ç°Ñ¡ÔñÈ«²¿Çå¿ 
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

		--·þÎñÆ÷´¦ÓÚÎ´¿ª·Å×´Ì¬
		if(g_SearchServerStatus[i] == StatMax) then
			g_BnLoginServer[i]:Hide();
		end

		local strName = g_SearchServerName[i];
		if(g_SearchServerIsNew[i]==1)then
			strName = strName.."(M¾i)";
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

--Çå³ýÏÂ·½Ñ¡Ôñ·þÎñÆ÷ÐÅÏ¢
function ClearServerTextInfo()

	SelectServer_Text1:SetText("");
	SelectServer_Text3:SetText("");

end

--Ë¢ÐÂ°´Å¥
function SelectServer_FreshPage()
	GameProduceLogin:LoadLaunch();
end


--½ÇÉ«²éÑ¯
function SelectServer_Forgotarea()
	--GameProduceLogin:OpenURL(GetWeblink("WEB_ROLE_INQUIRY"))
	LuaFindRoleByAcc()
end

--½ÇÉ«²éÑ¯
function SelectServer_Forgotarea_MouseEnter()
	SelectServer_Info:SetText("#{JSCX_250507_03}"); --???????????????
end
