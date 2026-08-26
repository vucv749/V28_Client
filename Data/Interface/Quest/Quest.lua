local QUEST_STATE_EVENTLIST 				= 1;
local QUEST_STATE_MISSON_INFO 			= 2;
local QUEST_STATE_CONTINUE_DONE 		= 3;
local QUEST_STATE_CONTINUE_NOTDONE 	= 4;
local QUEST_STATE_AFTER_CONTINUE		= 5;
local g_nQuestState = 0;
local g_nRewardItemID = 0;

local bBeingRadio = 0;
local bRadioSelect = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

local Icon_Preference = {}
local g_Quest_Frame_UnifiedXPosition;
local g_Quest_Frame_UnifiedYPosition;

local g_Quest_IsCoupleZoneSpec = 0
local g_Quest_IsKFRCLTConfirm = 0

local g_Quest_CallbackData = {
	[891273] = {
		[15] = "#{WDZD_221208_05}",
		[16] = "#{WDZD_221208_06}"
	}
}

function Quest_PreLoad()
	this:RegisterEvent("QUEST_EVENTLIST");
	this:RegisterEvent("QUEST_INFO");
	this:RegisterEvent("QUEST_CONTINUE_DONE");
	this:RegisterEvent("QUEST_CONTINUE_NOTDONE");
	this:RegisterEvent("QUEST_AFTER_CONTINUE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("TOGLE_SKILLSTUDY");
	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("TOGLE_BIGBANK");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("OPEN_ACCOUNT_SAFE");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YUEKA_HELP")
	this:RegisterEvent("CCSHOP_HELP") 
	this:RegisterEvent("ZHOUHUIYUE_HELP") 
	this:RegisterEvent("QUEST_HELPINFO")
end

function Quest_OnLoad()

	Icon_Preference[1] = 3
	Icon_Preference[2] = 2
	Icon_Preference[3] = 4
	Icon_Preference[4] = 5
	Icon_Preference[5] = 6
	Icon_Preference[6] = 8
	Icon_Preference[7] = 9
	Icon_Preference[8] = 14
	Icon_Preference[9] = 12
	Icon_Preference[10] = 11
	Icon_Preference[11] = 13
	Icon_Preference[12] = 10
	Icon_Preference[13] = 1
	Icon_Preference[14] = 12
	Icon_Preference[15] = 18 
	Icon_Preference[16] = -1 
	Icon_Preference[17] = -1 
	Icon_Preference[18] = -1 
	Icon_Preference[19] = 7 
	
	g_Quest_Frame_UnifiedXPosition	= Quest_Frame:GetProperty("UnifiedXPosition");
	g_Quest_Frame_UnifiedYPosition	= Quest_Frame:GetProperty("UnifiedYPosition");

end

--=========================================================
-- ÊÂ¼ş´¦Àí
--=========================================================
function Quest_OnEvent(event)
	local objCared = tonumber(arg0);
	AxTrace(0, 0, "event = ".. event);
	--µÚÒ»´ÎºÍnpc¶Ô»°£¬µÃµ½npcËùÄÜ¼¤»îµÄ²Ù×÷
	if(event == "QUEST_EVENTLIST") then
		--¹ØĞÄNPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_EventListUpdate();


	--ÔÚ½ÓÈÎÎñÊ±£¬¿´µ½µÄÈÎÎñĞÅÏ¢
	elseif(event == "QUEST_INFO") then
		--¹ØĞÄNPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_QuestInfoUpdate()


	--½ÓÊÜÈÎÎñºó£¬ÔÙ´ÎºÍnpc¶Ô»°£¬ËùµÃµ½µÄÈÎÎñĞèÇóĞÅÏ¢£¬(ÈÎÎñÍê³É)
	elseif(event == "QUEST_CONTINUE_DONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(1);

	--½ÓÊÜÈÎÎñºó£¬ÔÙ´ÎºÍnpc¶Ô»°£¬ËùµÃµ½µÄÈÎÎñĞèÇóĞÅÏ¢£¬(ÈÎÎñÎ´Íê³É)
	elseif(event == "QUEST_CONTINUE_NOTDONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(0);

		--¹ØĞÄNPC
		BeginCareObject_Quest(objCared)

	--µã»÷¡°¼ÌĞøÖ®ºó¡±£¬½±Æ·Ñ¡Ôñ½çÃæ
	elseif(event == "QUEST_AFTER_CONTINUE") then
		--¹ØĞÄNPC
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionRewardUpdate();

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Quest_Close();

			--È¡Ïû¹ØĞÄ
			StopCareObject_Quest(objCared);
		end

	elseif (event == "TOGLE_SKILLSTUDY") then
		AxTrace(0,0,"Tá Khai H÷c T§p m£t biên, ğóng cØa Hoà NPCĞích ğ¯i thoÕi Khuông");
		Quest_Close();

		--È¡Ïû¹ØĞÄ
		StopCareObject_Quest(objCared);

	elseif (event == "TOGLE_BANK") then
		AxTrace(0,0,"Tá Khai ngân hàng m£t biên, ğóng cØa Hoà NPCĞích ğ¯i thoÕi Khuông");
		Quest_Close();

		--È¡Ïû¹ØĞÄ
		StopCareObject_Quest(objCared);
	elseif (event == "TOGLE_BIGBANK") then
		AxTrace(0,0,"Tá Khai ngân hàng m£t biên, ğóng cØa Hoà NPCĞích ğ¯i thoÕi Khuông");
		Quest_Close();

		--È¡Ïû¹ØĞÄ
		StopCareObject_Quest(objCared);
	elseif ( event == "REPLY_MISSION" ) then
		Quest_Close();

	-- ²¥·ÅÒôĞ§
	elseif ( event == "UI_COMMAND" ) then
		AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == 123 then
			PlaySoundEffect();
		elseif tonumber(arg0) == 124 then
			PlayBackSound()
		elseif tonumber(arg0) == 1000 then
			if g_Quest_IsCoupleZoneSpec == 1 then
				g_Quest_IsCoupleZoneSpec = 0
			end
			Quest_Close();
		elseif tonumber(arg0) == 0147005 then
			Quest_Close();
		elseif tonumber(arg0) == 0147006 then
			Quest_Close();
		elseif tonumber(arg0) == 20090715 then
			OpenUrl();
		elseif tonumber(arg0) == 20091019 then
			OpenUrl_BBHJ();
		elseif tonumber(arg0) == 20101121 then-- ???????-??
			--PlayEffectSound();
			PlayUISound();
		elseif tonumber(arg0) == 89335901 then
			OpenUrl_ZhouNianDaKaURL();
		elseif tonumber(arg0) == 88996156 then
			OpenZBSUrl_MatchWeb()
		elseif tonumber(arg0) == 88996157 then
			OpenZBSUrl_GuessWeb()
		elseif tonumber(arg0) == 99867701 then -- ?????
			OpenLongTaiTou_WXWeb()
		end

	-- ÇĞ»»³¡¾°
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Quest_Close();
		if objCared then
			StopCareObject_Quest(objCared);
		end
	elseif( event == "OPEN_ACCOUNT_SAFE") then
		Quest_Close();
	elseif (event == "ADJEST_UI_POS" ) then
		Quest_Frame_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Quest_Frame_ResetPos() 
	elseif (event == "YUEKA_HELP") then
		Quest_OpenYueKa_Help() 
	elseif (event == "CCSHOP_HELP") then
		Quest_HaoRen_Help(arg0)	 
	elseif (event == "ZHOUHUIYUE_HELP") then
		Quest_ZhouHuoYue_Help(arg0)	
	elseif (event == "QUEST_HELPINFO") then
		Quest_HelpMsg(arg0)
	end

end

--=========================================================
-- ÏÔÊ¾ÈÎÎñÁĞ±í
--=========================================================
function Quest_EventListUpdate()
	local nLevel = Player:GetData("LEVEL")
	if nLevel <= 10 then
		Icon_Preference[1] = 3
		Icon_Preference[2] = 2
	else
		Icon_Preference[1] = 2
		Icon_Preference[2] = 3
	end

	g_Quest_IsKFRCLTConfirm = 0

	local nEventListNum = DataPool:GetNPCEventList_Num();
	local i;
	local j =1;
	local k =1;
	local yy = 1;

	local canacceptArr ={}
	local cansubmitArr = {}
	local Sequence_OnefoldGenre = {}
	local Constitutes = {}
	local nTitleType = 0;
	for i=1, nEventListNum do
		local strType,strState,strScriptId,strExtra,strTemp = DataPool:GetNPCEventList_Item(i-1);
		AxTrace(0,0,"return single " .. strType);
		AxTrace(0,0,"return single " .. strState);
		AxTrace(0,0,"return single " .. strScriptId);
		AxTrace(0,0,"return single " .. strExtra);
		AxTrace(0,0,"return single " .. strTemp);

		AxTrace(0,0,"return ,,," .. strType..strState..strScriptId..strExtra..strTemp);
		
		if strScriptId == 998324 and strExtra == 40002 then
			g_Quest_IsCoupleZoneSpec = 1
		end
		if (strScriptId == 810153 and strExtra == 10001) then
			g_Quest_IsKFRCLTConfirm = 1
		end
		
		
		if(strType == "text") then
			QuestGreeting_Desc:AddTextElement(strTemp);
		elseif(strType == "id") then
			if strState <= 0 or strState > 19 then
				strState = 8
			end
			if( tonumber( strScriptId ) == 808007 ) then
				if( strTemp == "Ta nghî lâm th¶i Giäi Toä" ) then
					nTitleType = 1
				elseif( strTemp == "Ta nghî Thi«n Cá Giäi Toä" ) then
					nTitleType = 1
				elseif( strTemp == "Khóa toàn bµ" ) then
					nTitleType = 2
				elseif( strTemp == "Khóa ğ½n lë" ) then
					nTitleType = 2
				elseif( strTemp == "Xác nh§n" ) then
					nTitleType = 2
				end
			end


			strTemp = strTemp .. "&"
			strTemp = strTemp .. strScriptId
			strTemp = strTemp .. ","
			strTemp = strTemp .. strExtra
			strTemp = strTemp .. "$"
			strTemp = strTemp .. strState
			Constitutes = {strTemp,Icon_Preference[strState]}
			if table.getn(Sequence_OnefoldGenre) > 0 then
				local Inserted = 0
				for yy,eachConstitute in Sequence_OnefoldGenre do
					AxTrace(5,5,"yy="..yy)
					if not CompareTable_Quest(eachConstitute,Constitutes) then
						table.insert(Sequence_OnefoldGenre,yy,Constitutes)
						Inserted = 1
						break
					end
				end
				if Inserted == 0 then
					table.insert(Sequence_OnefoldGenre,Constitutes)
				end
			else
				table.insert(Sequence_OnefoldGenre,Constitutes)
			end

		end
	end


	for i,PerOption in ipairs(Sequence_OnefoldGenre) do
		QuestGreeting_Desc:AddOptionElement(PerOption[1]);
	end
	Sequence_OnefoldGenre = {};


	g_nQuestState = QUEST_STATE_EVENTLIST;
	Quest_Frame_Debug:SetText("#gFF0FA0"..Target:GetDialogNpcName());--get npc?name
	if( nTitleType == 1 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0Giäi Toä" );
	elseif( nTitleType == 2 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0Gia Toä" );
	end
	AxTrace( 8,0,"title="..Target:GetDialogNpcName() );
	Quest_Button_Continue:SetText("Tiªp tøc");--??
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("TÕm bi®t");--??

	if (g_Quest_IsKFRCLTConfirm > 0) then
		Quest_Button_Refuse:Disable()
		Quest_Close_Btn:Disable()
	else
		Quest_Button_Refuse:Enable()
		Quest_Close_Btn:Enable()
	end

end

--=========================================================
-- ÏÔÊ¾ÈÎÎñĞÅÏ¢
--=========================================================
function Quest_QuestInfoUpdate()
	local nTextNum, nBonusNum = DataPool:GetMissionInfo_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionInfo_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

--	QuestGreeting_Desc:AddTextElement("#Y½±Àø£º#W");
	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;

	for i=1, nBonusNum do
		--    ½±ÀøµÄÀàĞÍ£¬½±ÀøÎïÆ·ID£¬½±Àø¶àÉÙ¸ö
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money" and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end

			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "moneyjz" and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddJiaoZiElement(nNum);
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		elseif(strType == "itemrand") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			if (nRadio == 1) then
				nRadio = 0;
				QuestGreeting_Desc:AddTextElement("#YhOàn thành nhi®m vø H§u Khä Tuy¬n mµt cái làm ph¥n thß·ng: #W");
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		end
	end

	g_nQuestState = QUEST_STATE_MISSON_INFO
--	Quest_Frame_Debug:SetText("QUEST_STATE_MISSON_INFO");--get npcµÄname
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npcµÄname
	end

	Quest_Button_Continue:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "1" );
	Quest_Button_Accept:Enable();
	Quest_Button_Continue:SetText("Tiªp tøc");--??
	Quest_Button_Refuse:SetText("Hüy bö");--??
end

--=========================================================
--ContinueÈÎÎñµÄ¶Ô»°¿ò
--=========================================================
function Quest_MissionContinueUpdate(bDone)
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();
	local ActionID;
	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionDemand_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	if( nBonusNum>1 ) then
		QuestGreeting_Desc:AddTextElement("#Yc?n v§t ph¦m: #W");
	end

	for i=1, nBonusNum do
		--    ĞèÒªµÄÀàĞÍ£¬ĞèÒªÎïÆ·ID£¬ĞèÒª¶àÉÙ¸ö
		local nItemID, nNum = DataPool:GetMissionDemand_Item(i-1);
--		QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Demand(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end

	end

	if (bDone == 1) then
		g_nQuestState = QUEST_STATE_CONTINUE_DONE;
--		Quest_Frame_Debug:SetText("CONTINUE_DONE");--get npc name
		Quest_Button_Continue:Enable();
	else
		g_nQuestState = QUEST_STATE_CONTINUE_NOTDONE;
--		Quest_Frame_Debug:SetText("CONTINUE_NOTDONE");--get npc name
		Quest_Button_Continue:Disable();
	end

	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npcµÄname
	end

	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("Hüy bö");--??
	Quest_Button_Continue:SetText("Tiªp tøc");--??

end

--=========================================================
--Ê È¡½±ÀøÎïÆ·µÄ¶Ô»°¿ò
--=========================================================
function Quest_MissionRewardUpdate()
	g_nQuestState = QUEST_STATE_AFTER_CONTINUE;
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npcµÄname
	end
--	Quest_Frame_Debug:SetText("AFTER_CONTINUE");--get npc name

	Quest_Button_Continue:Enable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("Hüy bö");--??
	Quest_Button_Continue:SetText("Hoàn thành");--??

	local nTextNum, nBonusNum = DataPool:GetMissionContinue_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionContinue_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;

	bBeingRadio = 0;
	bRadioSelect = 0;
	for i=1, nBonusNum do
		--    ½±ÀøµÄÀàĞÍ£¬½±ÀøÎïÆ·ID£¬½±Àø¶àÉÙ¸ö
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money"  and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "moneyjz" and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddJiaoZiElement(nNum);
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		elseif(strType == "itemrand") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Yc ğ¸nh thß·ng cho: #W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			bBeingRadio = 1;
			if (nRadio == 1) then
				nRadio = 0;
				if nRadio_Necessary == 1 then
					QuestGreeting_Desc:AddTextElement("#YNHî có th¬ Thung dß¾i thß·ng cho trúng tuy¬n TrÕch hÕng nh¤t: #W");
				else
					QuestGreeting_Desc:AddTextElement("#YcÒn có th¬ Thung dß¾i thß·ng cho trúng tuy¬n TrÕch hÕng nh¤t: #W");
				end

			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 1);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 1);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		end
	end

end

--=========================================================
-- Ñ¡ÔñÒ»¸öÈÎÎñ
--=========================================================
function QuestOption_Clicked()

--	AxTrace(0,0,"click " .. arg0);
	--ÎÄ×ÖµÄ¸ñÊ½ÊÇ
	--QuestGreeting_option_03#211207,0
	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");

	local strOptionID = -1;
	local strOptionExtra1 = string.sub(arg0, pos2+1,pos3-1 );
	local strOptionExtra2 = string.sub(arg0, pos4+1);

--	AxTrace(0,0,"strOptionExtra1" .. strOptionExtra1);
--	AxTrace(0,0,"strOptionExtra2" .. strOptionExtra2);

--	AxTrace(0,0,"Ñ¡ÖĞID" .. tonumber(strOptionID));
--	AxTrace(0,0,"Ñ¡ÖĞ1Str" .. tonumber(strOptionExtra1));
--	AxTrace(0,0,"Ñ¡ÖĞ2Str" .. tonumber(strOptionExtra2));

	local option1 = tonumber(strOptionExtra1)
	local option2 = tonumber(strOptionExtra2)

	g_Quest_IsKFRCLTConfirm = 0

	-- µ¯¶ş´ÎÈ·ÈÏ¿ò
	if g_Quest_CallbackData[option1] and g_Quest_CallbackData[option1][option2] then
		PushEvent( "MENU_SHOWACCEPTCHANGEPVP", 4, g_Quest_CallbackData[option1][option2] )
		return
	end

	QuestFrameOptionClicked(tonumber(strOptionID), option1, option2)


end

--=========================================================
-- Ñ¡ÔñÒ»¸ö¶àÑ¡Ò»µÄ½±ÀøÎïÆ·
--=========================================================
function RewardItem_Clicked()
	--AxTrace(0, 1, "------------" .. arg0);
	local strRewardItemID = string.sub(arg0, -2, -1);
	g_nRewardItemID = tonumber(strRewardItemID);
	bRadioSelect = 1;
end

--=========================================================
-- Continue & Complete
--=========================================================
function MissionContinue_Clicked()
	if ( g_nQuestState == QUEST_STATE_CONTINUE_DONE ) then
		QuestFrameMissionContinue();
--		Quest_Close();
		--È¡Ïû¹ØĞÄ
--		StopCareObject_Quest(objCared);

	elseif( g_nQuestState == QUEST_STATE_AFTER_CONTINUE )then
		--AxTrace(0, 0, "MissionContinue_Clicked(" .. tostring(g_nRewardItemID) .. ")");
		if(bBeingRadio == 1) then
			if(bRadioSelect == 1)then
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--È¡Ïû¹ØĞÄ
				StopCareObject_Quest(objCared);
			else
				PushDebugMessage("Thïnh lña ch÷n thß·ng cho v§t ph¦m!");
			end
		else
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--È¡Ïû¹ØĞÄ
				StopCareObject_Quest(objCared);
		end
	end
end

--=========================================================
-- ½ÓÊÜÈÎÎñ
--=========================================================
function QuestAccept_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameAcceptClicked()
	end

	Quest_Close();
	--È¡Ïû¹ØĞÄ
	StopCareObject_Quest(objCared);
end

--=========================================================
--¾Ü¾øÈÎÎñ
--=========================================================
function QuestRefuse_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameRefuseClicked()
	end

	Quest_Close();
	--È¡Ïû¹ØĞÄ
	StopCareObject_Quest(objCared);

	NpcShop:Close();

end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_Quest(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Quest");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_Quest(objCaredId)
	this:CareObject(objCaredId, 0, "Quest");
	g_Object = -1;

end

--=========================================================
--²¥·ÅÒôĞ§
--=========================================================
function PlaySoundEffect()
	Sound:PlaySound( Get_XParam_INT(0), false );
end

--=========================================================
--²¥·Å±³¾°ÒôÀÖ
--=========================================================
function PlayBackSound()
	Sound:PlaySound( Get_XParam_INT(0),false );
end

--=========================================================
--²¥·Å¼¼ÄÜÒôÀÖ
--=========================================================
function PlayEffectSound()
	Sound:PlaySoundEffect( Get_XParam_INT(0),false );
end

--=========================================================
--²¥·ÅUIÒôÀÖ
--=========================================================
function PlayUISound()
	Sound:PlayUISound(Get_XParam_INT(0))
end -- end func PlayUISound()

function CompareTable_Quest(table_a,table_b)
	if table_a[2] <= table_b[2] then
		return true
	else
		return false
	end
end

function Quest_Open()

	if IsWindowShow("Valentine") or IsWindowShow("ValentineConfirm") then
		this:Hide()
		return
	end
	g_Quest_IsCoupleZoneSpec = 0
	g_Quest_IsKFRCLTConfirm = 0

	Quest_Button_Refuse:Enable()
	Quest_Close_Btn:Enable()

	this:Show();
end
function Quest_Close()
	if g_Quest_IsCoupleZoneSpec == 1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnCancelCloseCZone");
			Set_XSCRIPT_ScriptID(998324);
			Set_XSCRIPT_Parameter(0,-1)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT()
		g_Quest_IsCoupleZoneSpec = 0
	end

	if (g_Quest_IsKFRCLTConfirm > 0) then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(810153)
			Set_XSCRIPT_Function_Name("CCallBack_EnterCancel")
			Set_XSCRIPT_Parameter(0, 0)
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_Parameter(3, 12)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		g_Quest_IsKFRCLTConfirm = 0
	end

	Quest_Button_Refuse:Enable()
	Quest_Close_Btn:Enable()
	this:Hide();
end

function OpenUrl( )
	GameProduceLogin:OpenURL(GetWeblink("WEB_INVITE"))
end
--µã»÷±¦±´»Ø¼Ò¼Æ»®Á´½Ó
function OpenUrl_BBHJ()
	GameProduceLogin:OpenURL(GetWeblink("WEB_BAOBEIHUIJIA"))
end

function OpenUrl_ZhouNianDaKaURL()
	GameProduceLogin:OpenURL(GetWeblink("WEB_ZHOUNIANDAKA"))
end


function OpenZBSUrl_MatchWeb()
	GameProduceLogin:OpenURL(GetWeblink("WEB_ZBSZT"))
end

function OpenZBSUrl_GuessWeb()
	GameProduceLogin:OpenURL(GetWeblink("WEB_ZBSJC"))
end

function Quest_Frame_ResetPos()
	Quest_Frame:SetProperty("UnifiedXPosition", g_Quest_Frame_UnifiedXPosition);
	Quest_Frame:SetProperty("UnifiedYPosition", g_Quest_Frame_UnifiedYPosition);
end

function Quest_OpenYueKa_Help()
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Refuse:Disable();
	QuestGreeting_Desc:ClearAllElement();
	Quest_Frame_Debug:SetText("");
	
	QuestGreeting_Desc:AddTextElement( "#{HJYK_201223_14}" )
	this:Show()
end

-- ·â¸ö½Ó¿Ú 
function Quest_HaoRen_Help(nIndex)
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Refuse:Disable();
	QuestGreeting_Desc:ClearAllElement();
	Quest_Frame_Debug:SetText("");
	Quest_Button_Accept:SetProperty( "Flash", "0" );

	if nIndex == "1" then
		QuestGreeting_Desc:AddTextElement( "#{ZHY_210301_07}" )
	elseif nIndex == "2" then
		QuestGreeting_Desc:AddTextElement( "#{XSLDZ_180521_238}" )
	elseif nIndex == "3" then
		QuestGreeting_Desc:AddTextElement( "#{XSLDZ_180521_250}" )
	elseif nIndex == "4" then
		QuestGreeting_Desc:AddTextElement( "#{XSLDZ_180521_172}" )
	elseif nIndex == "5" then
		QuestGreeting_Desc:AddTextElement( "#{SHCX_20211229_39}" )
	elseif nIndex == "6" then
		QuestGreeting_Desc:AddTextElement( "#{JXGZ_220427_45}" )
	elseif nIndex == "8" then
		QuestGreeting_Desc:AddTextElement( "#{QQSD_220801_16}" )
	elseif nIndex == "9" then
		QuestGreeting_Desc:AddTextElement( "#{QQSD_220801_22}" )
	elseif nIndex == "12" then
		QuestGreeting_Desc:AddTextElement( "#{XMPWH_20220906_15}" )
	elseif nIndex == "13" then
		QuestGreeting_Desc:AddTextElement( "#{SWXT_221213_214}" )
	elseif nIndex == "14" then--?????????
		QuestGreeting_Desc:AddTextElement( "#{CCYR_221220_105}" )
	elseif nIndex == "15" then-- 2023Q2????-???? ???????
		QuestGreeting_Desc:AddTextElement( "#{SXZL_032901_152}" )
	elseif nIndex == "16" then
		QuestGreeting_Desc:AddTextElement( "#{JYHD_230331_148}" )
	elseif nIndex == "17" then
		QuestGreeting_Desc:AddTextElement( "#{QXFL_20230721_9}" )
	elseif nIndex == "18" then
		QuestGreeting_Desc:AddTextElement( "#{QXFL_20230721_10}" )
	elseif nIndex == "19" then
		QuestGreeting_Desc:AddTextElement( "#{QXFL_20230721_12}" )
	elseif nIndex == "20" then--2022Q3????
		QuestGreeting_Desc:AddTextElement( "#{SZTG_230825_3}" )
	elseif nIndex == "21" then--2023Q4??????
		QuestGreeting_Desc:AddTextElement( "#{SZSJ_231114_11}" )
	elseif nIndex == "22" then--
		QuestGreeting_Desc:AddTextElement( "#{ZLSJ_231106_84}" )
	elseif nIndex == "23" then
		QuestGreeting_Desc:AddTextElement( "#{DHSD_20240522_65}" )
	elseif nIndex == "24" then
		QuestGreeting_Desc:AddTextElement( "#{DHLS_240611_06}" )
	elseif nIndex == "25" then
		QuestGreeting_Desc:AddTextElement( "#{DHYR_240515_26}" )
	elseif nIndex == "26" then
		QuestGreeting_Desc:AddTextElement( "#{DHLS_240611_107}" )
	elseif nIndex == "40" then
		QuestGreeting_Desc:AddTextElement( "#Yv? Võ Cänh#r#r #WĞang vai di­n c¤p b§c ğÕt t¾i#G85#WC¤p Th¶i, có th¬ Ği¬m Kích Chü m£t biên cái nút: #GVõ Cänh L® Ğ°#Wtiªn hành Võ Cänh dçn ğß¶ng nhi®m vø, hoàn thành nhi®m vø H§u có th¬ m· ra Võ Cänh công nång. #r#r#cfabf8fv« Võ Cänh c¤p b§c#r#W Võ Cänh công nång m· ra H§u vai di­n Khä tång lên#GVõ Cänh c¤p b§c#W, V  Cänh c¤p b§c thông qua tiêu hao#GVõ Cänh kinh nghi®m#Wtång lên, Ğang Võ Cänh kinh nghi®m ğÕt t¾i c¥n Ğích s¯ lßşng Th¶i, Võ Cänh c¤p b§c Tß¾ng tñ ğµng tång lên. Võ Cänh c¤p b§c hÕn mÑc cao nh¤t Vi#G200#WC¤p, Võ Cänh c¤p b§c M²i Chu nhi«u nh¤t Khä tång lên#G7#WC¤p, Khä tång lên c¤p b§c Tß¾ng TÕi M²i#GChu Nh§t 24Th¶i#WTrùng Trí. #r#r#cfabf8fv« Võ Cänh c¤p b§c cung c¤p Ğích thuµc tính#r#W Võ Cänh c¤p b§c M²i tång lên#G1#WC¤p, vai di­n Quân Khä nh§n ğßşc thuµc tính, M²i#G20#WC¤p(1-C¤p 20, 21-C¤p 40……181-200C¤p) Tß¾ng dña theo dß¾i#Gc¯ ğ¸nh trình tñ#Wnh§n ğßşc thuµc tính: #r #G1, ngoÕi công công kích#r 2, ngoÕi công phòng ngñ#r 3, nµi công công kích#r 4, nµi công phòng ngñ#r 5, th¬ lñc#r 6, lñc lßşng#r 7, Linh Khí#r 8, ğ¸nh lñc#r 9, thân pháp#r 10, công kích Võ Quyªt Ği¬m#r 11, ngoÕi công công kích#r 12, ngoÕi công phòng ngñ#r 13, nµi công công kích#r 14, nµi công phòng ngñ#r 15, th¬ lñc#r 16, lñc lßşng#r 17, Linh Khí#r 18, ğ¸nh lñc#r 19, thân pháp#r 20, Thü Ngñ Võ Quyªt Ği¬m#W#r#r#cfabf8fv« Võ Cänh chân quyªt#r#W Võ Cänh chân quyªt chia làm#Gcông kích Võ Quyªt#WHoà#GThü Ngñ Võ Quyªt#W, công kích Võ Quyªt Hoà Thü Ngñ Võ Quyªt theo Võ Cänh c¤p b§c tång lên nhi«u nh¤t có th¬ lña ch÷n#G3#WCá môn phái có hi®u lñc, V¸ B¸ lña ch÷n Ğích môn phái T¡c không th¬ änh hß·ng. #r Ğang H² Tuy¬n Vi công kích Võ Quyªt Hoà Thü Ngñ Võ Quyªt môn phái Ğích song phß½ng tiªn hành PKTh¶i, Nhu Døng Nh¤t Phß½ng Ğích công kích Võ Quyªt Ği¬m Hoà mµt khác Phß½ng Ğích Thü Ngñ Võ Quyªt Ği¬m tiªn hành#GSai Tr¸ tính toán#W. #r Nhßşc Nh¤t Phß½ng Ğích#Gcông kích Võ Quyªt Ği¬m#WCao, T¡c M²i Cao#G1#WĞi¬m có ğúng không mµt khác Phß½ng tÕo thành Ğích thß½ng t±n gia tång#G1%#W, cao nh¤t gia tång#G5%#W. #r Nhßşc Nh¤t Phß½ng Ğích#GThü Ngñ Võ Quyªt Ği¬m#WCao, T¡c M²i Cao#G1#WĞi¬m có th¬ làm cho ğ¯i phß½ng Ğ¯i Dî Phß½ng tÕo thành Ğích thß½ng t±n giäm b¾t#G1%#W, cao nh¤t giäm b¾t#G5%#W. #r S· Tuy¬n môn phái Hoà Võ Quyªt Ği¬m Khä thông qua tiêu hao#G1#WCá#YVõ Quyªt d¸ch cân Ğan#WTrùng Trí.".."#r#r#cfabf8fv« Võ Cänh ğu±i theo#W#R t×ng phøc vø Khí Quân t°n tÕi#GVõ Cänh c¤p b§c#W, V  Cänh c¤p b§c theo#Gphøc vø Khí th¶i gian#WĞích chuy¬n d¶i Dã Tß¾ng#Gnh§n ğßşc l¾n d¥n#W, trß¾c m£t phøc vø Khí Võ Cänh c¤p b§c Khä ği trß¾c#GĞÕi Lı#{_INFOAIM217, 43, 2, Huy«n Trí pháp sß}#RHuy«n Trí pháp sß#WĞi¬m Kích v« Tuy¬n HÕng xem xét. Ğang thiªu hi®p tñ thân Võ Cänh c¤p b§c#GlÕc h§u Vu#Wphøc vø Khí Võ Cänh c¤p b§c Thß hoàn thành Li­u#GVõ Cänh L® Ğ° nhi®m vø#WTh¶i, TÕi tham dñ ğánh bÕi quái v§t nh§n ğßşc Võ Cänh kinh nghi®m Th¶i, Hµi thêm vào nh§n ğßşc nh¤t ğ¸nh Ğích Võ Cänh kinh nghi®m. Nhßşc thiªu hi®p trß¾c m£t b¸ vây#YVõ Linh Ğan#Whi®u quä HÕ, T¡c Khä hß·ng thø#G50%#WĞích#Gthêm vào gia t¯c hi®u quä#W. #r thiªu hi®p TÕi Võ Cänh ğu±i theo trÕng thái HÕ M²i Chu Võ Cänh c¤p b§c tång lên s¯ l¥n nhi«u nh¤t thêm vào gia tång#G3#WThÑ, nhi«u nh¤t có th¬ ğÕt t¾i#G10#WThÑ." )
	elseif nIndex == "41" then
		QuestGreeting_Desc:AddTextElement( "#Yv? Võ Cänh chân quyªt#r#r#W Võ Cänh chân quyªt chia làm#Gcông kích Võ Quyªt#WHoà#GThü Ngñ Võ Quyªt#W, cÔng kích Võ Quyªt Hoà Thü Ngñ Võ Quyªt theo Võ Cänh c¤p b§c tång lên nhi«u nh¤t có th¬ lña ch÷n#G3#WCá môn phái có hi®u lñc, V¸ B¸ lña ch÷n Ğích môn phái T¡c không th¬ änh hß·ng. #r Ğang H² Tuy¬n Vi công kích Võ Quyªt Hoà Thü Ngñ Võ Quyªt môn phái Ğích song phß½ng tiªn hành PKTh¶i, Nhu Døng Nh¤t Phß½ng Ğích công kích Võ Quyªt Ği¬m Hoà mµt khác Phß½ng Ğích Thü Ngñ Võ Quyªt Ği¬m tiªn hành#GSai Tr¸ tính toán#W. #r Nhßşc Nh¤t Phß½ng Ğích#Gcông kích Võ Quyªt Ği¬m#WCao, T¡c M²i Cao#G1#WĞi¬m có ğúng không mµt khác Phß½ng tÕo thành Ğích thß½ng t±n gia tång#G1%#W, cao nh¤t gia tång#G5%#W. #r Nhßşc Nh¤t Phß½ng Ğích#GThü Ngñ Võ Quyªt Ği¬m#WCao, T¡c M²i Cao#G1#WĞi¬m có th¬ làm cho ğ¯i phß½ng Ğ¯i Dî Phß½ng tÕo thành Ğích thß½ng t±n giäm b¾t#G1%#W, cao nh¤t giäm b¾t#G5%#W. #r S· Tuy¬n môn phái Hoà Võ Quyªt Ği¬m Khä thông qua tiêu hao#G1#WCá#YVõ Quyªt d¸ch cân Ğan#WTrùng Trí." )
	end

	this:Show()
end

function Quest_ZhouHuoYue_Help(nIndex)
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Refuse:Disable();
	QuestGreeting_Desc:ClearAllElement();
	Quest_Frame_Debug:SetText("");
	Quest_Button_Accept:SetProperty( "Flash", "0" );

	
	local nMissionHelp = Lua_GetZhouHuoYueMissionHelp(tonumber(nIndex))
	QuestGreeting_Desc:AddTextElement( nMissionHelp )
	

	this:Show()
end

function Quest_HelpMsg(msg)
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Refuse:Disable();
	QuestGreeting_Desc:ClearAllElement();
	Quest_Frame_Debug:SetText("");

	QuestGreeting_Desc:AddTextElement( msg )

	this:Show()
end

-- ÁúÌ§Í·»î¶¯
function OpenLongTaiTou_WXWeb()
	GameProduceLogin:OpenURL(GetWeblink("WEB_LTT"))
end
