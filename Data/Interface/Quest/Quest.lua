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
-- 事件处理
--=========================================================
function Quest_OnEvent(event)
	local objCared = tonumber(arg0);
	AxTrace(0, 0, "event = ".. event);
	--第一次和npc对话，得到npc所能激活的操作
	if(event == "QUEST_EVENTLIST") then
		--关心NPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_EventListUpdate();


	--在接任务时，看到的任务信息
	elseif(event == "QUEST_INFO") then
		--关心NPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_QuestInfoUpdate()


	--接受任务后，再次和npc对话，所得到的任务需求信息，(任务完成)
	elseif(event == "QUEST_CONTINUE_DONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(1);

	--接受任务后，再次和npc对话，所得到的任务需求信息，(任务未完成)
	elseif(event == "QUEST_CONTINUE_NOTDONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(0);

		--关心NPC
		BeginCareObject_Quest(objCared)

	--点击“继续之后”，奖品选择界面
	elseif(event == "QUEST_AFTER_CONTINUE") then
		--关心NPC
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionRewardUpdate();

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Quest_Close();

			--取消关心
			StopCareObject_Quest(objCared);
		end

	elseif (event == "TOGLE_SKILLSTUDY") then
		AxTrace(0,0,"打开学习界面，关闭和NPC的对话框");
		Quest_Close();

		--取消关心
		StopCareObject_Quest(objCared);

	elseif (event == "TOGLE_BANK") then
		AxTrace(0,0,"打开银行界面，关闭和NPC的对话框");
		Quest_Close();

		--取消关心
		StopCareObject_Quest(objCared);
	elseif (event == "TOGLE_BIGBANK") then
		AxTrace(0,0,"打开银行界面，关闭和NPC的对话框");
		Quest_Close();

		--取消关心
		StopCareObject_Quest(objCared);
	elseif ( event == "REPLY_MISSION" ) then
		Quest_Close();

	-- 播放音效
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
		elseif tonumber(arg0) == 20101121 then-- 钟声悠然贺新年-移植
			--PlayEffectSound();
			PlayUISound();
		elseif tonumber(arg0) == 89335901 then
			OpenUrl_ZhouNianDaKaURL();
		elseif tonumber(arg0) == 88996156 then
			OpenZBSUrl_MatchWeb()
		elseif tonumber(arg0) == 88996157 then
			OpenZBSUrl_GuessWeb()
		elseif tonumber(arg0) == 99867701 then -- 龙抬头活动
			OpenLongTaiTou_WXWeb()
		end

	-- 切换场景
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
-- 显示任务列表
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
				if( strTemp == "我想临时解锁" ) then
					nTitleType = 1
				elseif( strTemp == "我想单个解锁" ) then
					nTitleType = 1
				elseif( strTemp == "全部加锁" ) then
					nTitleType = 2
				elseif( strTemp == "单个加锁" ) then
					nTitleType = 2
				elseif( strTemp == "确认" ) then
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
	Quest_Frame_Debug:SetText("#gFF0FA0"..Target:GetDialogNpcName());--get npc的name
	if( nTitleType == 1 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0解锁" );
	elseif( nTitleType == 2 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0加锁" );
	end
	AxTrace( 8,0,"title="..Target:GetDialogNpcName() );
	Quest_Button_Continue:SetText("继续");--继续
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("再见");--再见

	if (g_Quest_IsKFRCLTConfirm > 0) then
		Quest_Button_Refuse:Disable()
		Quest_Close_Btn:Disable()
	else
		Quest_Button_Refuse:Enable()
		Quest_Close_Btn:Enable()
	end

end

--=========================================================
-- 显示任务信息
--=========================================================
function Quest_QuestInfoUpdate()
	local nTextNum, nBonusNum = DataPool:GetMissionInfo_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionInfo_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

--	QuestGreeting_Desc:AddTextElement("#Y奖励：#W");
	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;

	for i=1, nBonusNum do
		--    奖励的类型，奖励物品ID，奖励多少个
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money" and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end

			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "moneyjz" and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddJiaoZiElement(nNum);
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
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
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			if (nRadio == 1) then
				nRadio = 0;
				QuestGreeting_Desc:AddTextElement("#Y完成任务后可选一个作为奖品:#W");
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
--	Quest_Frame_Debug:SetText("QUEST_STATE_MISSON_INFO");--get npc的name
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc的name
	end

	Quest_Button_Continue:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "1" );
	Quest_Button_Accept:Enable();
	Quest_Button_Continue:SetText("继续");--继续
	Quest_Button_Refuse:SetText("取消");--取消
end

--=========================================================
--Continue任务的对话框
--=========================================================
function Quest_MissionContinueUpdate(bDone)
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();
	local ActionID;
	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionDemand_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	if( nBonusNum>1 ) then
		QuestGreeting_Desc:AddTextElement("#Y需要物品:#W");
	end

	for i=1, nBonusNum do
		--    需要的类型，需要物品ID，需要多少个
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
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc的name
	end

	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("取消");--取消
	Quest_Button_Continue:SetText("继续");--继续

end

--=========================================================
--收取奖励物品的对话框
--=========================================================
function Quest_MissionRewardUpdate()
	g_nQuestState = QUEST_STATE_AFTER_CONTINUE;
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc的name
	end
--	Quest_Frame_Debug:SetText("AFTER_CONTINUE");--get npc name

	Quest_Button_Continue:Enable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("取消");--取消
	Quest_Button_Continue:SetText("完成");--完成

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
		--    奖励的类型，奖励物品ID，奖励多少个
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money"  and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "moneyjz" and nNum > 0) then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddJiaoZiElement(nNum);
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
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
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			bBeingRadio = 1;
			if (nRadio == 1) then
				nRadio = 0;
				if nRadio_Necessary == 1 then
					QuestGreeting_Desc:AddTextElement("#Y你可以从以下奖励中选择一项:#W");
				else
					QuestGreeting_Desc:AddTextElement("#Y还可以从以下奖励中选择一项:#W");
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
-- 选择一个任务
--=========================================================
function QuestOption_Clicked()

--	AxTrace(0,0,"click " .. arg0);
	--文字的格式是
	--QuestGreeting_option_03#211207,0
	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");

	local strOptionID = -1;
	local strOptionExtra1 = string.sub(arg0, pos2+1,pos3-1 );
	local strOptionExtra2 = string.sub(arg0, pos4+1);

--	AxTrace(0,0,"strOptionExtra1" .. strOptionExtra1);
--	AxTrace(0,0,"strOptionExtra2" .. strOptionExtra2);

--	AxTrace(0,0,"选中ID" .. tonumber(strOptionID));
--	AxTrace(0,0,"选中1Str" .. tonumber(strOptionExtra1));
--	AxTrace(0,0,"选中2Str" .. tonumber(strOptionExtra2));

	local option1 = tonumber(strOptionExtra1)
	local option2 = tonumber(strOptionExtra2)

	g_Quest_IsKFRCLTConfirm = 0

	-- 弹二次确认框
	if g_Quest_CallbackData[option1] and g_Quest_CallbackData[option1][option2] then
		PushEvent( "MENU_SHOWACCEPTCHANGEPVP", 4, g_Quest_CallbackData[option1][option2] )
		return
	end

	QuestFrameOptionClicked(tonumber(strOptionID), option1, option2)


end

--=========================================================
-- 选择一个多选一的奖励物品
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
		--取消关心
--		StopCareObject_Quest(objCared);

	elseif( g_nQuestState == QUEST_STATE_AFTER_CONTINUE )then
		--AxTrace(0, 0, "MissionContinue_Clicked(" .. tostring(g_nRewardItemID) .. ")");
		if(bBeingRadio == 1) then
			if(bRadioSelect == 1)then
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--取消关心
				StopCareObject_Quest(objCared);
			else
				PushDebugMessage("请选择奖励物品！");
			end
		else
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--取消关心
				StopCareObject_Quest(objCared);
		end
	end
end

--=========================================================
-- 接受任务
--=========================================================
function QuestAccept_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameAcceptClicked()
	end

	Quest_Close();
	--取消关心
	StopCareObject_Quest(objCared);
end

--=========================================================
--拒绝任务
--=========================================================
function QuestRefuse_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameRefuseClicked()
	end

	Quest_Close();
	--取消关心
	StopCareObject_Quest(objCared);

	NpcShop:Close();

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Quest(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Quest");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Quest(objCaredId)
	this:CareObject(objCaredId, 0, "Quest");
	g_Object = -1;

end

--=========================================================
--播放音效
--=========================================================
function PlaySoundEffect()
	Sound:PlaySound( Get_XParam_INT(0), false );
end

--=========================================================
--播放背景音乐
--=========================================================
function PlayBackSound()
	Sound:PlaySound( Get_XParam_INT(0),false );
end

--=========================================================
--播放技能音乐
--=========================================================
function PlayEffectSound()
	Sound:PlaySoundEffect( Get_XParam_INT(0),false );
end

--=========================================================
--播放UI音乐
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
--点击宝贝回家计划链接
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

-- 封个接口 
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
	elseif nIndex == "14" then--不老长春谷预热任务
		QuestGreeting_Desc:AddTextElement( "#{CCYR_221220_105}" )
	elseif nIndex == "15" then-- 2023Q2版本稳活-束脩之礼 二选一礼盒界面
		QuestGreeting_Desc:AddTextElement( "#{SXZL_032901_152}" )
	elseif nIndex == "16" then
		QuestGreeting_Desc:AddTextElement( "#{JYHD_230331_148}" )
	elseif nIndex == "17" then
		QuestGreeting_Desc:AddTextElement( "#{QXFL_20230721_9}" )
	elseif nIndex == "18" then
		QuestGreeting_Desc:AddTextElement( "#{QXFL_20230721_10}" )
	elseif nIndex == "19" then
		QuestGreeting_Desc:AddTextElement( "#{QXFL_20230721_12}" )
	elseif nIndex == "20" then--2022Q3时装团购
		QuestGreeting_Desc:AddTextElement( "#{SZTG_230825_3}" )
	elseif nIndex == "21" then--2023Q4时装随机宝箱
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
		QuestGreeting_Desc:AddTextElement( "#Y关于武境#r#r    #W当角色等级达到#G85#W级时，可以点击主界面按钮：#G武境砺途#W进行武境引导任务，完成任务后即可开启武境功能。#r#r#cfabf8f关于武境等级#r#W    武境功能开启后角色可提升#G武境等级#W，武境等级通过消耗#G武境经验#W提升，当武境经验达到需要的数量时，武境等级将自动提升。武境等级上限为#G200#W级，武境等级每周最多可提升#G7#W级，可提升等级将在每#G周日24时#W重置。#r#r#cfabf8f关于武境等级提供的属性#r#W    武境等级每提升#G1#W级，角色均可获得属性，每#G20#W级（1-20级、21-40级……181-200级）将按照以下#G固定顺序#W获得属性：#r    #G1、外功攻击#r    2、外功防御#r    3、内功攻击#r    4、内功防御#r    5、体力#r    6、力量#r    7、灵气#r    8、定力#r    9、身法#r    10、攻击武诀点#r    11、外功攻击#r    12、外功防御#r    13、内功攻击#r    14、内功防御#r    15、体力#r    16、力量#r    17、灵气#r    18、定力#r    19、身法#r    20、守御武诀点#W#r#r#cfabf8f关于武境真诀#r#W    武境真诀分为#G攻击武诀#W和#G守御武诀#W，攻击武诀和守御武诀随着武境等级提升最多可以选择#G3#W个门派生效，未被选择的门派则不受影响。#r    当互选为攻击武诀和守御武诀门派的双方进行PK时，需用一方的攻击武诀点和另一方的守御武诀点进行#G差值计算#W。#r    若一方的#G攻击武诀点#W高，则每高#G1#W点可对另一方造成的伤害增加#G1%#W，最高增加#G5%#W。#r    若一方的#G守御武诀点#W高，则每高#G1#W点可使对方对已方造成的伤害减少#G1%#W，最高减少#G5%#W。#r    所选门派和武诀点可通过消耗#G1#W个#Y武诀易筋丹#W重置。".."#r#r#cfabf8f关于武境追赶#W#r    每个服务器均存在#G武境等级#W，武境等级随着#G服务器时间#W的推移也将#G获得成长#W，当前服务器武境等级可前往#G大理#{_INFOAIM217,43,2,玄智法师}#R玄智法师#W点击关于选项查看。当少侠自身武境等级#G落后于#W服务器武境等级且完成了#G武境砺途任务#W时，在参与击败怪物获得武境经验时，会额外获得一定的武境经验。若少侠当前处于#Y武灵丹#W效果下，则可享受#G50%#W的#G额外加速效果#W。#r    少侠在武境追赶状态下每周武境等级提升次数最多额外增加#G3#W次，最多可达#G10#W次。" )
	elseif nIndex == "41" then
		QuestGreeting_Desc:AddTextElement( "#Y关于武境真诀#r#r#W    武境真诀分为#G攻击武诀#W和#G守御武诀#W，攻击武诀和守御武诀随着武境等级提升最多可以选择#G3#W个门派生效，未被选择的门派则不受影响。#r    当互选为攻击武诀和守御武诀门派的双方进行PK时，需用一方的攻击武诀点和另一方的守御武诀点进行#G差值计算#W。#r    若一方的#G攻击武诀点#W高，则每高#G1#W点可对另一方造成的伤害增加#G1%#W，最高增加#G5%#W。#r    若一方的#G守御武诀点#W高，则每高#G1#W点可使对方对已方造成的伤害减少#G1%#W，最高减少#G5%#W。#r    所选门派和武诀点可通过消耗#G1#W个#Y武诀易筋丹#W重置。" )
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

-- 龙抬头活动
function OpenLongTaiTou_WXWeb()
	GameProduceLogin:OpenURL(GetWeblink("WEB_LTT"))
end