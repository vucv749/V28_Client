local MAINMENUBAR_BUTTON_NUM = 30;
local MAINMENUBAR_PAGENUM = 0;	-- 0, 1, 2
local MAINMENUBAR_BUTTONS = {};
local g_switchmenpaiIdx = 0;

local bExchangeFlash = 0;
local iTeamInfoType = 0;	-- -1 : ????????
													-- 0  : ±íÊ¾´ò¿ª¶ÓÎéÐÅÏ¢
													-- 1  : ±íÊ¾ÓÐÈËÉêÇë¼ÓÈë¶ÓÎé,   ´ò¿ªÉêÇëÁÐ±í.
													-- 2  : ±íÊ¾ÓÐÈËÑûÇëÄã¼ÓÈë¶ÓÎé, ´ò¿ªÑûÇëÄãµÄ¶ÓÎéÁÐ±í.


local bTogleSelfEquip = 0;	-- 0 :?????????
														-- 1 £ºµ±Ç°×´Ì¬ÊÇ´ò¿ª½çÃæ
														-- 1 : µ±Ç°×´Ì¬ÊÇ´ò¿ª½çÃæ

local bTogleTeam			= 0;  -- 0 : ?????????
														-- 1 : µ±Ç°×´Ì¬ÊÇ´ò¿ª½çÃæ

local bIsTeamBnFlash	= 0;	-- 0 : ???????.
														-- 1 : ×é¶Ó°´Å¥ÉÁË¸.

local bIsPacketOpened = 0 --????(0??,1??)

local nMenpaiSkillId = {};
nMenpaiSkillId[1] = {281,291,295};
nMenpaiSkillId[2] = {311,321,325};
nMenpaiSkillId[3] = {341,351,355};
nMenpaiSkillId[4] = {371,381,385};
nMenpaiSkillId[5] = {401,404,415};
nMenpaiSkillId[6] = {431,441,445};
nMenpaiSkillId[7] = {461,471,475};
nMenpaiSkillId[8] = {491,501,505};
nMenpaiSkillId[9] = {521,522,535};
--10ÊÇÎÞÃÅÅÉ
nMenpaiSkillId[11] = {760,771,775};

local MAINMENUBAR_ACCKEY = {};
local g_CharcaterFlash = falas;
local MAINMENUBAR_DATA = {};
--¡¾¸½½ü¡¿
local MAINMENUBAR_DATA_NEAR =
	{
		"set:Buttons image:Channelvicinity_Normal", 		-- ????????
		"set:Buttons image:ChannelVicinity_Hover", 		-- ????????
		"set:Buttons image:ChannelVicinity_Pushed",		-- ????????
	};

--¡¾ÊÀ½ç¡¿
local MAINMENUBAR_DATA_SCENE =
	{
		"set:Buttons image:ChannelWorld_Normal",
		"set:Buttons image:ChannelWorld_Hover",
		"set:Buttons image:ChannelWorld_Pushed",
	};

--¡¾Ë½ÁÄ¡¿
local MAINMENUBAR_DATA_PRIVATE =
	{
		"set:Buttons image:ChannelPersonal_Normal",
		"set:Buttons image:ChannelPersonal_Hover",
		"set:Buttons image:ChannelPersonal_Pushed",
	};

--¡¾ÏµÍ³¡¿
local MAINMENUBAR_DATA_SYSTEM =
	{
		"set:Buttons image:ChannelPersonal_Normal",
		"set:Buttons image:ChannelPersonal_Hover",
		"set:Buttons image:ChannelPersonal_Pushed",
	};

--¡¾¶ÓÎé¡¿
local MAINMENUBAR_DATA_TEAM =
	{
		"set:Buttons image:ChannelTeam_Normal",
		"set:Buttons image:ChannelTeam_Hover",
		"set:Buttons image:ChannelTeam_Pushed",
	};

--¡¾×ÔÓÃ¡¿
local MAINMENUBAR_DATA_SELF =
	{
		"set:Buttons image:ChannelTeam_Normal",
		"set:Buttons image:ChannelTeam_Hover",
		"set:Buttons image:ChannelTeam_Pushed",
	};

--¡¾ÃÅÅÉ¡¿
local MAINMENUBAR_DATA_MENPAI =
	{
		"set:Buttons image:ChannelMenpai_Normal",
		"set:Buttons image:ChannelMenpai_Hover",
		"set:Buttons image:ChannelMenpai_Pushed",
	};

--¡¾°ï»á¡¿
local MAINMENUBAR_DATA_GUILD =
	{
		"set:Buttons image:ChannelCorporative_Normal",
		"set:Buttons image:ChannelCorporative_Hover",
		"set:Buttons image:ChannelCorporative_Pushed",
	};

--¡¾°ï»áÍ¬ÃË¡¿
local MAINMENUBAR_DATA_GUILD_LEAGUE =
	{
		"set:CommonFrame6 image:ChannelTongMeng_Normal",
		"set:CommonFrame6 image:ChannelTongMeng_Hover",
		"set:CommonFrame6 image:ChannelTongMeng_Pushed",
	};

--¡¾Í¬³Ç¡¿
local MAINMENUBAR_DATA_IPREGION =
	{
		"set:UIIcons image:ChannelCorporative_Normal",
		"set:UIIcons image:ChannelCorporative_Hover",
		"set:UIIcons image:ChannelCorporative_Pushed",
	};
--¡¾ËÎÁÉ¡¿
local MAINMENUBAR_DATA_SONGLIAO =
{ 	
	"set:SongLiao02 image:Zhan_Normal", 
	"set:SongLiao02 image:Zhan_Hover", 
	"set:SongLiao02 image:Zhan_Pushed",
};
	
--¡¾ÍÅ¶Ó¡¿
local MAINMENUBAR_DATA_RAID =
	{
		"set:Union1 image:Union_Channel_Normal",
		"set:Union1 image:Union_Channel_Hover",
		"set:Union1 image:Union_Channel_Pushed",
	};

--¡¾Ð¡¶Ó¡¿
local MAINMENUBAR_DATA_RAIDSQUAD =
	{
		"set:Buttons image:ChannelTeam_Normal",
		"set:Buttons image:ChannelTeam_Hover",
		"set:Buttons image:ChannelTeam_Pushed",
	};
	
local g_CurChannel = "near";
local g_CurChannelName = "";
local g_InputLanguageIcon = {};
local g_ChatBtn = {};

-- ±£´æË«ÈËÁÄÌì¶¯×÷×Ö·û´®ÐÅÏ¢
local g_ChatActionTxt = "";


function MainMenuBar_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("RECEIVE_EXCHANGE_APPLY");
	this:RegisterEvent("TEAM_NOTIFY_APPLY");				-- ????????????.

	this:RegisterEvent("HAVE_MAIL");

	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_MAX_EXP");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");

	this:RegisterEvent("CHAT_HISTORY_ACTION");
	this:RegisterEvent("CHAT_INPUTLANGUAGE_CHANGE");
	this:RegisterEvent("CHAT_TEXTCOLOR_SELECT");
	this:RegisterEvent("CHAT_FACEMOTION_SELECT");
	this:RegisterEvent("UPDATE_DUR");
	this:RegisterEvent("JOIN_NEW_MENPAI");
	this:RegisterEvent("ACTION_UPDATE");

	this:RegisterEvent("NEW_MISSION");

	this:RegisterEvent("UPDATESTATE_SUBMENUBAR");

	this:RegisterEvent("RESET_ALLUI");

	this:RegisterEvent("SHOW_GUILDWAR_ANIMI");
	this:RegisterEvent("UPDATE_GUILD_APPLY");
	this:RegisterEvent("BATTLE_SCOREFLASH");
	this:RegisterEvent("NOTIFY_NEW_SKILLS");
	this:RegisterEvent("UPDATE_DOUBLE_EXP")
	this:RegisterEvent("DETIME_UPDATE")

	--[xh 2009-07-09]Ö»ÓÐÔÚ°ïÅÉ ÷ÌÖÊ±²ÅÏÔÊ¾°ïÅÉ ÷ÌÖ»ý·Ö°´Å¥
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("FLASH_PACKET_BUTTON");
	this:RegisterEvent("PACKET_OPENED");

	this:RegisterEvent("OPEN_UP_BAR_2")
	--±äÉí¡¢
	this:RegisterEvent("SKILL_UPDATE",true)									--??????
	this:RegisterEvent("SWITCHMENPAI",true)									--??????
	this:RegisterEvent("SHOW_TRANSFIGURATION_SKILL",true);
	this:RegisterEvent("SKILL_UPDATE",true)
	
	this:RegisterEvent("NEWMSG_NOTIFY")
	this:RegisterEvent("MPCOMBO_SKILL",true)
	
	this:RegisterEvent("CHAT_ACCEPT_DOUBLE_ACTION_STRING");		-- ????????????????	
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_BAR");					-- ???????????????
	this:RegisterEvent("CLEAR_CHAT_ACTION_BAR");							-- ?????????????????
	this:RegisterEvent("UNFLASH_TEAM_BUTTON",true)									--??????
	this:RegisterEvent("RAID_UPDATE_INVITATION")
	this:RegisterEvent("SHOW_SECWEAPONFIGURATION_SKILL",true);
	this:RegisterEvent("SETORIGINALGAME", true)
	this:RegisterEvent("UPDATE_PET_PAGE");
end

function MainMenuBar_OnLoad()
	MAINMENUBAR_BUTTONS[1] = Button_Action1;
	MAINMENUBAR_BUTTONS[2] = Button_Action2;
	MAINMENUBAR_BUTTONS[3] = Button_Action3;
	MAINMENUBAR_BUTTONS[4] = Button_Action4;
	MAINMENUBAR_BUTTONS[5] = Button_Action5;
	MAINMENUBAR_BUTTONS[6] = Button_Action6;
	MAINMENUBAR_BUTTONS[7] = Button_Action7;
	MAINMENUBAR_BUTTONS[8] = Button_Action8;
	MAINMENUBAR_BUTTONS[9] = Button_Action9;
	MAINMENUBAR_BUTTONS[10] = Button_Action10;

	MAINMENUBAR_BUTTONS[11] = Button_Action11;
	MAINMENUBAR_BUTTONS[12] = Button_Action12;
	MAINMENUBAR_BUTTONS[13] = Button_Action13;
	MAINMENUBAR_BUTTONS[14] = Button_Action14;
	MAINMENUBAR_BUTTONS[15] = Button_Action15;
	MAINMENUBAR_BUTTONS[16] = Button_Action16;
	MAINMENUBAR_BUTTONS[17] = Button_Action17;
	MAINMENUBAR_BUTTONS[18] = Button_Action18;
	MAINMENUBAR_BUTTONS[19] = Button_Action19;
	MAINMENUBAR_BUTTONS[20] = Button_Action20;

	MAINMENUBAR_BUTTONS[21] = Button_Action21;
	MAINMENUBAR_BUTTONS[22] = Button_Action22;
	MAINMENUBAR_BUTTONS[23] = Button_Action23;
	MAINMENUBAR_BUTTONS[24] = Button_Action24;
	MAINMENUBAR_BUTTONS[25] = Button_Action25;
	MAINMENUBAR_BUTTONS[26] = Button_Action26;
	MAINMENUBAR_BUTTONS[27] = Button_Action27;
	MAINMENUBAR_BUTTONS[28] = Button_Action28;
	MAINMENUBAR_BUTTONS[29] = Button_Action29;
	MAINMENUBAR_BUTTONS[30] = Button_Action30;

	MAINMENUBAR_BUTTONS[51] = Button_Action51;
	MAINMENUBAR_BUTTONS[52] = Button_Action52;
	MAINMENUBAR_BUTTONS[53] = Button_Action53;
	MAINMENUBAR_BUTTONS[54] = Button_Action54;
	MAINMENUBAR_BUTTONS[55] = Button_Action55;
	MAINMENUBAR_BUTTONS[56] = Button_Action56;
	MAINMENUBAR_BUTTONS[57] = Button_Action57;
	MAINMENUBAR_BUTTONS[58] = Button_Action58;
	MAINMENUBAR_BUTTONS[59] = Button_Action59;
	MAINMENUBAR_BUTTONS[60] = Button_Action60;

	MAINMENUBAR_ACCKEY["acc_selfequip"] = MainMenuBar_SelfEquip_Clicked;
	MAINMENUBAR_ACCKEY["acc_packet"] = MainMenuBar_Packet_Clicked;
	MAINMENUBAR_ACCKEY["acc_skill"] = MainMenuBar_Skill_Clicked;
	MAINMENUBAR_ACCKEY["acc_pet"] = MainMenuBar_Pet_Acced;
	MAINMENUBAR_ACCKEY["acc_quest"] = MainMenuBar_Mission_Clicked;
	MAINMENUBAR_ACCKEY["acc_friend"] = MainMenuBar_Friend_Clicked;
	MAINMENUBAR_ACCKEY["acc_team"] = MainMenuBar_Team_Clicked;
	MAINMENUBAR_ACCKEY["acc_exchange"] = MainMenuBar_Exchange_Clicked;
	MAINMENUBAR_ACCKEY["acc_guild"] = nil;	-- ????
	MAINMENUBAR_ACCKEY["acc_chatmod"] = MainMenuBar_ChatMood;			--????????
	MAINMENUBAR_ACCKEY["acc_face"] = MainMenuBar_SelectFaceMotion;	--??????

	MAINMENUBAR_ACCKEY["acc_MainMenuBarpageup"] = MainmenuBar_PageUp;	--???????
	MAINMENUBAR_ACCKEY["acc_MainMenuBarpagedown"] = MainmenuBar_PageDown;	--???????
	MAINMENUBAR_ACCKEY["acc_MainMenuBarPageOne"] = MainmenuBar_PageOne;	--??????
	MAINMENUBAR_ACCKEY["acc_MainMenuBarPageTwo"] = MainmenuBar_PageTwo;	--??????
	MAINMENUBAR_ACCKEY["acc_MainMenuBarPageThree"] = MainmenuBar_PageThree;	--??????

	MAINMENUBAR_DATA["near"] 		= MAINMENUBAR_DATA_NEAR;
	MAINMENUBAR_DATA["scene"] 	= MAINMENUBAR_DATA_SCENE;
	MAINMENUBAR_DATA["private"]	= MAINMENUBAR_DATA_PRIVATE;
	MAINMENUBAR_DATA["system"] 	= MAINMENUBAR_DATA_SYSTEM;
	MAINMENUBAR_DATA["team"] 		= MAINMENUBAR_DATA_TEAM;
	MAINMENUBAR_DATA["self"] 		= MAINMENUBAR_DATA_SELF;
	MAINMENUBAR_DATA["menpai"] 	= MAINMENUBAR_DATA_MENPAI;
	MAINMENUBAR_DATA["guild"] 	= MAINMENUBAR_DATA_GUILD;
	MAINMENUBAR_DATA["guild_league"] 	= MAINMENUBAR_DATA_GUILD_LEAGUE;
	MAINMENUBAR_DATA["ipregion"] 	= MAINMENUBAR_DATA_IPREGION;
	MAINMENUBAR_DATA["zhanchang"] = MAINMENUBAR_DATA_SONGLIAO
	MAINMENUBAR_DATA["raid"] = MAINMENUBAR_DATA_RAID;
	MAINMENUBAR_DATA["raidsquad"] = MAINMENUBAR_DATA_RAIDSQUAD;

	g_InputLanguageIcon[1] = "set:Button2 image:BtnE_Normal";
	g_InputLanguageIcon[2052] = "set:Buttons image:IME_Chinese";
	g_InputLanguageIcon[1033] = "set:Button2 image:BtnE_Normal";

	MainMenuBar_MainMenuBar_On:Show()
	MainMenuBar_MainMenuBar_Off:Hide()

	Button_ConfraternityPK_Ani:Hide();
	Button_GuildBattleScoreFlash:Hide();
end

-- OnEvent
function MainMenuBar_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();

		MainmenuBar_UpdateAll();
		local noChatActiveMode = Variable:GetVariable("NonChatActive");
		if(noChatActiveMode==nil or noChatActiveMode=="0") then
			MainMenuBar_EditBox:SetProperty("DefaultEditBox", "True");
		end
		MainMenuBar_InputLanguage_Changed();
		-- ÏÔÊ¾¾­Ñé
		MainMenuBar_ShowExperience();
		-- ÇÐ»»³¡¾°ºóÍ£Ö¹ÉÁË¸×é¶Ó°´Å¥
		MainMenuBar_Stop_Flash_Team_Button();

	elseif( event == "SETORIGINALGAME" ) then	
		MainMenuBar_Button_PetFight:Show()
	elseif( event == "UPDATESTATE_SUBMENUBAR" ) then
		local SubToolbarState = SystemSetup:GetSubMenubarState()
		if 0 == SubToolbarState then
			MainMenuBar_MainMenuBar_Off_Clk()
		else
			MainMenuBar_MainMenuBar_On_Clk()
		end
	elseif ( event == "SWITCHMENPAI" ) then
		g_switchmenpaiIdx = 1
	elseif ( event == "SKILL_UPDATE" and g_switchmenpaiIdx==1) then
		g_switchmenpaiIdx = 0
		local menpai = Player:GetData("MEMPAI") + 1;
		if menpai == 10 or menpai < 1 or menpai > 15 then
			return
		end
		PutSkillToMainmenuBar( nMenpaiSkillId[ menpai ][ 1 ],-1,-1,-1,-1,-1 );
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		local nIndex = tonumber(arg1);
		--AxTrace(0, 2, "changebar: index=" .. nIndex .. " page=" .. MAINMENUBAR_PAGENUM .. " id=" .. arg2);

		if nIndex <=0 or nIndex >30 then
			return
		end

		MAINMENUBAR_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
		MAINMENUBAR_BUTTONS[nIndex]:Bright();

		if arg3~=nil then

				local pet_num = tonumber(arg3);

				if pet_num >= 0 and pet_num < 6 then
					---AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
					local isPresent = Pet : IsPresent(pet_num)
					local isFighting = Pet : GetIsFighting(pet_num)
					if isPresent == true and isFighting == true then
							MAINMENUBAR_BUTTONS[nIndex] : Bright();
					else
							MAINMENUBAR_BUTTONS[nIndex] : Gloom();
					end

				end

		end

	elseif( event == "CHANGE_BAR" and arg0 == "tip") then
	  --¸Ä±ätip
	  local ButtonId = tonumber(arg1)
	  local key = tostring( arg2 )

	  MAINMENUBAR_BUTTONS[ButtonId]:SetProperty("CornerChar", key);
	  MAINMENUBAR_BUTTONS[ButtonId+10]:SetProperty("CornerChar", key);
	  MAINMENUBAR_BUTTONS[ButtonId+20]:SetProperty("CornerChar", key);
	elseif( event == "CHANGE_BAR" and arg0 == "ut") then
	--¸Ä±ätip
	  MainMenuBar_UpdateButtonTip();

	elseif ( event == "RECEIVE_EXCHANGE_APPLY" )  then
		-- ÉÁË¸½»Ò×°´Å¥, Í¨ÖªÓÐÈËÉêÇë½»Ò×
		MainMenuBar_Flash_Exchange();

	elseif( event == "TEAM_NOTIFY_APPLY" ) then

		iTeamInfoType = tonumber(arg0);
		if(iTeamInfoType == 1 or iTeamInfoType == 2 or iTeamInfoType == 5) then

			-- ÉÁË¸¶ÓÎé°´Å¥, Í¨ÖªÓÐÈËÉêÇë¼ÓÈë¶ÓÎé.
			MainMenuBar_Flash_Team_Button();

		end

	elseif( event == "UNIT_EXP" ) then

			-- ÏÔÊ¾¾­Ñé
			MainMenuBar_ShowExperience();
	elseif( event == "UNIT_LEVEL" ) then

			-- ÏÔÊ¾¾­Ñé
			MainMenuBar_ShowExperience();
	elseif( event == "UNIT_MAX_EXP" ) then

			-- ÏÔÊ¾¾­Ñé
			MainMenuBar_ShowExperience();
	elseif event =="HAVE_MAIL" then
		Sound:PlayUISound(27)
		MainMenuBar_UpdateFriendFlash()
	elseif event == "NEWMSG_NOTIFY" then
		MainMenuBar_UpdateFriendFlash()
	elseif(event == "UPDATE_GUILD_APPLY") then
		local type = arg0;
		if type == "show" then
			Button_Reputation : SetFlash(1);
		else
			Button_Reputation : SetFlash(0);
		end
	elseif( event == "BATTLE_SCOREFLASH") then
		local type = arg0;
		if(type == "show") then
			Button_GuildBattleScoreFlash:Show();
		else
			Button_GuildBattleScoreFlash:Hide();
		end
	elseif( event =="NEW_MISSION" ) then
		Button_Mission:SetFlash( 1 );
		local missname = DataPool:GetPlayerMission_Name(tonumber( arg0 ))
		if missname == "Mission:1414" then
			Button_Pet:SetFlash( 1 );
		end
	elseif( event == "ACCELERATE_KEYSEND" ) then

			-- ´¦Àí¼üÅÌ¿ì½Ý¼ü
			MainMenuBar_HandleAccKey(arg0);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		MainMenuBar_AdjustMoveCtl(arg0, arg1);
	elseif (event == "CHAT_INPUTLANGUAGE_CHANGE") then
		MainMenuBar_InputLanguage_Changed();
	elseif (event == "CHAT_HISTORY_ACTION") then
		MainMenuBar_HandleHistoryAction(arg0,arg1,arg2);
	elseif (event == "CHAT_TEXTCOLOR_SELECT") then
		MainMenuBar_SelectColorFaceFinish(arg0, arg1);
	elseif (event == "CHAT_FACEMOTION_SELECT") then
		MainMenuBar_SelectColorFaceFinish(arg0, arg1);
	elseif ( event == "UPDATE_DUR" ) then
		MainmenuBar_UpdateDur();
	elseif( event == "JOIN_NEW_MENPAI" ) then
		MainmenuBar_JoinMenpai();
	elseif( event == "ACTION_UPDATE" ) then
		MainmenuBar_ActionUpate();
	elseif(event == "RESET_ALLUI") then

		MainMenuBar_SetEditBoxTxt("");

		MainMenuBar_SetChannelSel("near","");
	elseif(event == "SHOW_GUILDWAR_ANIMI") then
		local type = arg0;
		if(arg0=="show")then
			if(Button_ConfraternityPK_Ani:IsVisible())then
				return
			end
			Button_ConfraternityPK_Ani:Show()
		else
			if(Button_ConfraternityPK_Ani:IsVisible())then
				Button_ConfraternityPK_Ani:Hide();
			end
		end
	elseif(event == "NOTIFY_NEW_SKILLS") then
		MainMenuBar_NotifyNewSkills(1);
	elseif(event == "SCENE_TRANSED") then
		Button_GuildBattleScore : Hide();
		local curSceneID = GetSceneID();
		if (curSceneID == 270) then
			Button_GuildBattleScore : Show();
		end
	elseif(event == "FLASH_PACKET_BUTTON") then
		if bIsPacketOpened == 0 then
			Button_Pack:SetFlash( 1);
		end
	elseif(event == "PACKET_OPENED") then
		bIsPacketOpened = tonumber(arg0)

	elseif(event == "UPDATE_DOUBLE_EXP" ) then

    local DT = SystemSetup : GetDoubleExp("remaintime");
		if DT > 0 then
			MainMenuBar_Doub_Watch:Show()
			MainMenuBar_Doub:Show()
			MainMenuBar_Doub_Watch:SetProperty("Timer",DT);
			MainMenuBar_EXP2:Hide()
			MainMenuBar_EXP3:Show()
			--MainMenuBar_DoubleExp_Flash:Show()
		else
			MainMenuBar_Doub:Hide()
			MainMenuBar_Doub_Watch:Hide()
			MainMenuBar_EXP2:Show()
			MainMenuBar_EXP3:Hide()
			--MainMenuBar_DoubleExp_Flash:Hide()
		end
		
	elseif event == "DETIME_UPDATE" then
		local nOldDT = MainMenuBar_Doub_Watch:GetProperty("Timer");
		SystemSetup : CheckDoubleExp(tonumber(nOldDT));
		
	elseif event == "SHOW_TRANSFIGURATION_SKILL" then
		if arg0 == "2" then
			MainmenuBar_ShowTransfigureSkill( 1 )
			if (IsWindowShow("MainMenuBar_2")) == true then
				MainMenuBar_MainMenuBar_Off:Disable()
				bMainMenuBar_2Open = 1
				TurnMenuBar("off")
			else
				MainMenuBar_MainMenuBar_On:Disable()
			end
			--MainMenuBar_MainMenuBar_On:Disable()
			--MainMenuBar_MainMenuBar_Off:Disable()
			MainMenuBar_ScrollBar_Up:Disable()
			MainMenuBar_ScrollBar_Down:Disable()
		elseif arg0 == "0" then
			MainmenuBar_ShowTransfigureSkill( 0 )
			if bMainMenuBar_2Open == 1 then
				MainMenuBar_MainMenuBar_Off:Enable()
				TurnMenuBar("on")
				bMainMenuBar_2Open = 0
			else
				MainMenuBar_MainMenuBar_On:Enable()
			end
			MainMenuBar_ScrollBar_Up:Enable()
			MainMenuBar_ScrollBar_Down:Enable()
		end
	elseif ( event == "SKILL_UPDATE" and g_switchmenpaiIdx==1) then
		g_switchmenpaiIdx = 0
		local menpai = Player:GetData("MEMPAI") + 1;
		if menpai == 10 or menpai < 1 or menpai > 14 then
			return
		end
		PutSkillToMainmenuBar( nMenpaiSkillId[ menpai ][ 1 ],-1,-1,-1,-1,-1 );
	elseif event == "MPCOMBO_SKILL" then
		local bookIndex = tonumber(arg0)
		local tempnum = tonumber(arg1)
		if tempnum == 1 then
			local skill1, skill2  = Player:GetMPComboBookInfo(bookIndex, "mpcomboskill");
			local CurCombo = tostring(arg2)
			if(CurCombo == "1") then
				ActiveComboSkillToMainmenuBar(skill1,skill2,1);
			elseif (CurCombo == "2") then
				ActiveComboSkillToMainmenuBar(skill2,skill1,2);
			end
		elseif tempnum == -1  then
			local skill1, skill2= Player:GetMPComboBookInfo(bookIndex, "mpcomboskill");
			ActiveComboSkillToMainmenuBar(skill2,skill1,0);
		end

	-- ´ÓÁÄÌìÀ¸ÀïÊäÈëË«ÈËÐÝÏÐ¶¯×÷×Ö·û´®µÄÏìÓ¦
	elseif(event == "CHAT_ACCEPT_DOUBLE_ACTION_STRING") then
		MainMenuBar_DoubleChatActionMessageSend(tonumber(arg0), tostring(arg1));

	-- Ð¶ÔØË«ÈËÐÝÏÐ¶¯×÷°üÊ±£¬Í¬Ê±É¾³ýÍÏ¶¯µ½MainMenuBarÉÏµÄ°´Å¥ÐÅÏ¢	
	elseif (event == "UNINSTALL_CHAT_ACTION_BAR") then
		MainMenuBar_UnInstallChatActionButton(tonumber(arg0));

	-- ÇåÀí¹ýÆÚµÄË«ÈËÐÝÏÐ¶¯×÷°üÔÚÖ÷²Ëµ¥ÉÏµÄ°´Å¥
	elseif (event == "CLEAR_CHAT_ACTION_BAR") and (tostring(arg0)== "MainMenuBar") then
		MainMenuBar_ClearChatActionButton(tonumber(arg1), tonumber(arg2), tonumber(arg3));
	elseif event == "UNFLASH_TEAM_BUTTON" then  --??????
		MainMenuBar_Stop_Flash_Team_Button()
	elseif event == "RAID_UPDATE_INVITATION" then
		MainMenuBar_Flash_Team_Button()	
	elseif event == "SHOW_SECWEAPONFIGURATION_SKILL" then
		if arg0 == "2" then
			MainmenuBar_ShowSecWeaponfigureSkill( 1 )
			if (IsWindowShow("MainMenuBar_2")) == true then
				MainMenuBar_MainMenuBar_Off:Disable()
				--bMainMenuBar_2Open = 1
				--TurnMenuBar("off")
			else
				MainMenuBar_MainMenuBar_On:Disable()
			end
			--MainMenuBar_MainMenuBar_On:Disable()
			--MainMenuBar_MainMenuBar_Off:Disable()
			MainMenuBar_ScrollBar_Up:Disable()
			MainMenuBar_ScrollBar_Down:Disable()
		elseif arg0 == "0" then
			MainmenuBar_ShowSecWeaponfigureSkill( 0 )
			if bMainMenuBar_2Open == 1 then
				MainMenuBar_MainMenuBar_Off:Enable()
				--TurnMenuBar("on")
				--bMainMenuBar_2Open = 0
			else
				MainMenuBar_MainMenuBar_On:Enable()
			end
			MainMenuBar_ScrollBar_Up:Enable()
			MainMenuBar_ScrollBar_Down:Enable()
		end
		
	end

	if "OPEN_UP_BAR_2" == event then
		if arg0 == "1" and arg1 == "MainBar" then
			MainMenuBar_MainMenuBar_On_Clk()
		end
	end
	
	if( event == "UPDATE_PET_PAGE")  then
		local nPetCount = Pet:GetPet_Count()
		if nPetCount <= 0 then
			MainMenuBar_Button_PetFightDisabled:Show()
			MainMenuBar_Button_PetFight:Hide()
		else
			MainMenuBar_Button_PetFightDisabled:Hide()
			MainMenuBar_Button_PetFight:Show()
		end
	end
	
end

function MainmenuBar_ActionUpate()
	for i=1,10 do
		MAINMENUBAR_BUTTONS[i]:SetNewFlash();
	end
end
--µ±¼ÓÈëÃÅÅÉºó£¬ÐèÒª½«3¸ö¼¼ÄÜ¼Óµ½¿ì½ÝÀ¸
function MainmenuBar_JoinMenpai()

	local menpai = Player:GetData("MEMPAI") + 1;
	--ÅÐ¶ÏÒª·Åµ½ÄÄ¸öÀ¸Àï
	PutSkillToMainmenuBar( nMenpaiSkillId[ menpai ][ 1 ],nMenpaiSkillId[ menpai ][ 2 ],nMenpaiSkillId[ menpai ][ 3 ] );



end
function MainMenuBar_SelfEquip_Clicked()

	-- ´ò¿ª×°±¸½çÃæ
	if(0 == bTogleSelfEquip) then

		bTogleSelfEquip = 1;
		OpenEquip(bTogleSelfEquip);

	elseif(1 == bTogleSelfEquip) then

		bTogleSelfEquip = 0;
		OpenEquip(bTogleSelfEquip);

	end
end

function MainMenuBar_Skill_Clicked()
	MainMenuBar_NotifyNewSkills(0);
	ToggleSkillBook();
end

function MainMenuBar_Packet_Clicked()
	Button_Pack:SetFlash( 0 );
	ToggleContainer();
end

function MainMenuBar_Mission_Clicked()
	Button_Mission:SetFlash( 0 );
	ToggleMission();
end

function MainMenuBar_Pet_Clicked()
	Button_Pet:SetFlash( 0 );
	TogglePetPage();
end

function MainMenuBar_Pet_Acced()
	Button_Pet:SetFlash( 0 );
end

function MainMenuBar_Booth_Clicked()

end

function MainMenuBar_Friend_Clicked()
	if DataPool:GetMailNumber() == 0 then
		if DataPool:HaveNewIMMsg() == 0 or IsWindowShow("FriendChat") then
			DataPool:OpenFriendList()
		else
			DataPool:OpenFirstFriendChatInMsgPool()
		end
	else
		if Variable:GetVariable("IsInfoBrowerShow") == "False" then
			DataPool:OpenMailRead()
		else
			if DataPool:HaveNewIMMsg() == 0 or IsWindowShow("FriendChat") then
				DataPool:OpenFriendList()
			else
				DataPool:OpenFirstFriendChatInMsgPool()
			end
		end
	end
end

function MainMenuBar_Friend_RBClicked()
	DataPool:OpenFriendList()
end


function MainMenuBar_Exchange_Clicked()

	if( bExchangeFlash == 0 ) then
		PrepearExchange();
		return;
	else
		Exchange:OpenExchangeFrame();
	end

	if ( Exchange:IsStillAnyAppInList() == false ) then
		MainMenuBar_Stop_Flash_Exchange()
	end

end

function PlayerExp_Update()
	PlayerExp, PlayerMaxExp = Player:GetExp();
	PlayerExp_Exp:SetProgress(PlayerExp, PlayerMaxExp);
end

function PlayerExp_Exp_Text_MouseEnter()
	PlayerExp_Exp_Text:SetText(PlayerExp .. "/" .. PlayerMaxExp);
end

function PlayerExp_Exp_Text_MouseLeave()
	PlayerExp_Exp_Text:SetText("");
end


function MainMenuBar_Team_Clicked()
	if Player:IsInRaid() == 1 then
		if Raid:GetApplicantCount() > 0 then
			ShowTeamInfoDlg(bIsTeamBnFlash)
		elseif IsWindowShow("UnionFrame") == true then
			CloseWindow("UnionFrame", true)
		else
			OpenWindow("UnionFrame")
		end
	elseif Raid:GetInvitationCount() > 0 or DataPool:GetInviteTeamCount() > 0 then
		if DataPool:GetInviteTeamCount() > 0 then
			ShowTeamInfoDlg(bIsTeamBnFlash)
		end
		if Raid:GetInvitationCount() > 0 then
			OpenWindow("UnionChoose")
		end
	else
		ShowTeamInfoDlg(bIsTeamBnFlash);
	end

	-- Í£Ö¹ÉÁË¸
	if(bIsTeamBnFlash) then

		MainMenuBar_Stop_Flash_Team_Button();
	end;

end

---------------------------------------------------------------------------------------------
-- ÉÁË¸¶ÓÎé°´Å¥
function MainMenuBar_Flash_Team_Button()
	Button_Team:SetFlash( 1 );
	bIsTeamBnFlash = 1;
end

---------------------------------------------------------------------------------------------
-- Í£Ö¹ÉÁË¸¶ÓÎé°´Å¥
function MainMenuBar_Stop_Flash_Team_Button()
	Button_Team:SetFlash( 0 );
	bIsTeamBnFlash = 0;
end

---------------------------------------------------------------------------------------------
-- ÉÁË¸½»Ò×ÇëÇó
function MainMenuBar_Flash_Exchange()
	Button_Exchange:SetFlash( 1 );
	bExchangeFlash = 1;

end

---------------------------------------------------------------------------------------------
-- Í£Ö¹ÉÁË¸½»Ò×ÇëÇó
function MainMenuBar_Stop_Flash_Exchange()
	Button_Exchange:SetFlash( 0 );
	bExchangeFlash = 0;
end

---------------------------------------------------------------------------------------------
-- ÏÔÊ¾¾­Ñé
function MainMenuBar_ShowExperience()

	-- µÃµ½µ±Ç°¾­Ñé
	local CurExperience = Player:GetData("EXP");

	-- µÃµ½Éý¼¶ÐèÒªµÄ¾­Ñé
	local RequireExperience = Player:GetData("NEEDEXP");

	-- ÏÔÊ¾½ø¶È
	MainMenuBar_EXP2:SetProgress(CurExperience / RequireExperience, 1.0);
	MainMenuBar_EXP3:SetProgress(CurExperience / RequireExperience, 1.0);

	--AxTrace( 0,0, "=================ÏÔÊ¾¾­Ñé½ø¶È=========================");

end



function MainMenuBar_ShowExpTooltip()

	local exp = Player:GetData( "EXP" );
	local maxexp = Player:GetData( "NEEDEXP" );
	MainMenuBar_EXP2:SetToolTip( tostring( exp ).."/"..tostring( maxexp ) );
	MainMenuBar_EXP3:SetToolTip( tostring( exp ).."/"..tostring( maxexp ) );
end

function MainMenuBar_HideExpTooltip()
end


function MainMenuBar_Setup_Clicked()

	SystemSetup:OpenSetup();

end

function MainMenuBar_HandleAccKey( op )
	if(MAINMENUBAR_ACCKEY[op] ~= nil) then
		MAINMENUBAR_ACCKEY[op]();
		--AxTrace(0,0,"Acckey: MainMenuBar.lua "..op);
	end
end

function MainMenuBar_Clicked(nIndex)

	local isCanDo = DataPool:IsCanDoAction()
	if isCanDo == true then
		MAINMENUBAR_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("Các hÕ không ðßþc làm nhß v§y.")
		return;
	end

end

function MainMenuBar_AdjustMoveCtl( screenWidth, screenHeight )
	--local currWidth = MainMenuBar:GetProperty("AbsoluteWidth");
	--if(tonumber(screenWidth) < 1080) then
		--MainMenuBar:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
	--else
		--MainMenuBar:SetProperty("UnifiedXPosition", "{0.0,297}");
	--end
end

--ÁÄÌìÏà¹ØµÄ¹¦ÄÜ°´Å¥
function MainMenuBar_extendRegionTest()
	Talk:HandleMainBarAction("extendRegion", "");
end

function MainMenuBar_SaveTabTalkHistory()
	Talk:HandleMainBarAction("saveChatLog", "");
end

function MainMenuBar_PrepareBtnCtl()
	g_ChatBtn = {
								ime			= MainMenuBar_Chat_IME,
								color		= MainMenuBar_Chat_LetterColor,
								face		= MainMenuBar_Chat_Face,
								action	= MainMenuBar_Chat_Action,
								pingbi	= MainMenuBar_Chat_Screen,
								create	= MainMenuBar_Chat_User,
								config	= MainMenuBar_Chat_Config,

								select	= MainMenuBar_ChannelSelecter,
							};
end

function MainMenuBar_GetBtnScreenPos(btn)
	MainMenuBar_PrepareBtnCtl();
	local barxpos = MainMenuBar:GetProperty("AbsoluteXPosition");
	local barmxpos = MainMenuBar_Center:GetProperty("AbsoluteXPosition");
	local btnxpos = g_ChatBtn[btn]:GetProperty("AbsoluteXPosition");

	return barxpos+btnxpos+barmxpos;
end

function MainMenuBar_SelectTextColor()
	Talk:SelectTextColor("select", MainMenuBar_GetBtnScreenPos("color"));
end

function MainMenuBar_SelectFaceMotion()
	Talk:SelectFaceMotion("select", MainMenuBar_GetBtnScreenPos("face"));
end

function MainMenuBar_ChatMood()
	Talk:ShowChatMood(MainMenuBar_GetBtnScreenPos("action"));
end

function MainMenuBar_PingBi()
	Talk:ShowPingBi(MainMenuBar_GetBtnScreenPos("pingbi"));
end

function MainMenuBar_CreateTab()
	Talk:HandleMainBarAction("createTab",MainMenuBar_GetBtnScreenPos("create"));
end

function MainMenuBar_ConfigTab()
	if 548 == GetSceneID() then
		PushDebugMessage("#{XSLDZ_210128_33}")
		return
	end
	if 618 == GetSceneID() then
		PushDebugMessage("#{BLDPVP_221214_148}")
		return
	end
	if 633 == GetSceneID() then
		PushDebugMessage("#{JYHD_230331_95}")
		return
	end
	if 644 == GetSceneID()  then
		PushDebugMessage("#{YMMJ_230626_378}")
		return
	end
	if PTDB:LuaFnIsPTDBScene(GetSceneID()) > 0 then
		PushDebugMessage("#{PTDB_231225_133}")
		return
	end
	if KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) > 0 then
		PushDebugMessage("#{PTDB_231225_133}")
		return
	end
	if Lua_IsTSPhoenixScene(GetSceneID()) == 1 then
		PushDebugMessage("Qu¥n hùng Trøc Lµc chiªn trß¶ng không th¬ T¯ ThØ thao tác")
		return
	end
	if 681 == GetSceneID() then
		PushDebugMessage("#{YMMJ_230626_378}")
		return
	end
	
	Talk:HandleMainBarAction("configTab",MainMenuBar_GetBtnScreenPos("config"));
end

function MainMenuBar_AskFrameSizeUP()
	Talk:HandleMainBarAction("sizeUp","");
end

function MainMenuBar_AskFrameSizeDown()
	Talk:HandleMainBarAction("sizeDown","");
end

function MainMenuBar_AskFrameWidthUP()
	Talk:HandleMainBarAction("widthUp","");
end

function MainMenuBar_AskFrameWidthDown()
	Talk:HandleMainBarAction("widthDown","");
end

function MainMenuBar_ChannelSelect()
	Talk:HandleMainBarAction("channelSelect",MainMenuBar_GetBtnScreenPos("select"));
end

function MainMenuBar_TextAccepted()

	-- µÃµ½ÊäÈëµÄ×Ö·û´®
	local txt = MainMenuBar_EditBox:GetItemElementsString();
	
	-- Ô¤ÏÈÅÐ¶ÏÊäÈë×Ö·û´®ÊÇ²»ÊÇÓÐÐ§µÄË«ÈËÁÄÌì¶¯×÷
	local bChatAction = Talk : IsValidChatActionString(g_CurChannel, txt);
	
	-- ÓÐÐ§µÄË«ÈËÁÄÌì¶¯×÷
	if (bChatAction == 1) then
		-- Ñ¯ÎÊ¶Ô·½ÊÇ·ñ¿ÉÒÔ×ö¶¯×÷£¨ÔÝ²»·¢ËÍÁÄÌìÐÅÏ¢×Ö·û´®£¬Ò²²»¼ÇÂ¼ÀúÊ·ÁÄÌì¼ÇÂ¼£©
		g_ChatActionTxt = txt							-- ?????????????
		MainMenuBar_SetEditBoxTxt("")			-- ?????
		Talk : CanDoDoubleAction_Bar()
	
	-- ÎÞÐ§µÄË«ÈËÁÄÌì¶¯×÷
	elseif (bChatAction == 2) then
		-- ²»·¢ËÍÁÄÌìÐÅÏ¢×Ö·û´®£¬Ò²²»¼ÇÂ¼ÀúÊ·ÁÄÌì¼ÇÂ¼£¬Ö»µ¯ÌáÊ¾ÐÅÏ¢
		g_ChatActionTxt = ""							-- ?????????
		MainMenuBar_SetEditBoxTxt("")			-- ?????

	-- µ¥ÈËÁÄÌì¶¯×÷»ò ßÆ Í¨ÁÄÌìÏûÏ¢
	elseif (bChatAction == 0) then		
		-- ·¢ËÍÆ Í¨ÁÄÌìÐÅÏ¢
		local prvname,perColor = Talk : SendChatMessage(g_CurChannel, txt);
		if(nil == prvname ) then prvname = ""; end
		if(nil == perColor ) then perColor = ""; end
		local str = "";
		if(prvname == "")then
			str = str..perColor;
		else
			str = str.."/"..prvname.." "..perColor;
		end
		Talk : HandleMainBarAction("txtAccept", str);
	end	
end

-- ·¢ËÍË«ÈËÁÄÌì¶¯×÷ÐÅÏ¢
function MainMenuBar_DoubleChatActionMessageSend(bEnable, talker)

	--  Ò²»µ½Ëµ»° ß
	if (talker == "") then
		return
	end

	-- Ëµ»°µÄ²»ÊÇ×Ô¼º
	local myName = Player:GetName()	
	if (myName ~= talker) then
		return
	end

	-- ¶Ô·½¿ªÆôÁËÁÄÌì¶¯×÷ÉèÖÃ
	if (bEnable == 1) then
		local prvname,perColor = Talk : SendChatMessage(g_CurChannel, g_ChatActionTxt);
		g_ChatActionTxt = "";

		if (nil == prvname ) then prvname = ""; end
		if( nil == perColor ) then perColor = ""; end
		local str = "";
		if (prvname == "")then
			str = str..perColor;
		else
			str = str.."/"..prvname.." "..perColor;
		end

		Talk : HandleMainBarAction("txtAccept", str);
	end

end

function MainMenuBar_JoinItemElementFailure()
	PushDebugMessage("Thêm tin v§t ph¦m th¤t bÕi.");
end

function MainMenuBar_ItemElementFull()
	PushDebugMessage("Không th¬ tång nhi«u tin v§t ph¦m.");
end

function MainMenuBar_HandleHistoryAction(op,arg0,arg1)
	if(op == "editbox") then
		MainMenuBar_SetEditBoxTxt(arg0);
	elseif(op == "listChange") then
		MainMenuBar_SetChannelSel(arg0,arg1);
	elseif(op == "modifyTxt") then
		MainMenuBar_ModifyTxt();
	elseif(op == "privateChange") then
		MainMenuBar_ChangePrivateName(arg0);
	elseif(op == "changMsg") then
		MainMenuBar_ChangeTxt(arg0);
	end
end

function MainMenuBar_InputLanguage_Changed()

	local langId = Talk:GetCurInputLanguage();

	if(g_InputLanguageIcon[langId] == nil)then
		MainMenuBar_Chat_IME:SetProperty("NormalImage", g_InputLanguageIcon[1]);
		MainMenuBar_Chat_IME:SetProperty("HoverImage", g_InputLanguageIcon[1]);
		MainMenuBar_Chat_IME:SetProperty("PushedImage", g_InputLanguageIcon[1]);
	else
		MainMenuBar_Chat_IME:SetProperty("NormalImage", g_InputLanguageIcon[langId]);
		MainMenuBar_Chat_IME:SetProperty("HoverImage", g_InputLanguageIcon[langId]);
		MainMenuBar_Chat_IME:SetProperty("PushedImage", g_InputLanguageIcon[langId]);
	end
end

function MainMenuBar_SetEditBoxTxt(txt)
		MainMenuBar_EditBox:SetProperty("ClearOffset", "True");
		MainMenuBar_EditBox:SetItemElementsString(txt);
		MainMenuBar_EditBox:SetProperty("CaratIndex", 1024);
end

function MainMenuBar_SetChannelSel(channel, channelname)
	--AxTrace(0,0,"MainMenuBar channel:"..channel.." channnelname:"..channelname);
	if(MAINMENUBAR_DATA[channel] == nil) then
		return;
	end

	g_CurChannel = channel;
	g_CurChannelName = channelname;

	if 618 == GetSceneID() and channel == "zhanchang" then
		g_CurChannelName = "#{BLDPVP_221214_180}"
	end

	MainMenuBar_ChannelSelecter:SetProperty("NormalImage", MAINMENUBAR_DATA[channel][1]);
	MainMenuBar_ChannelSelecter:SetProperty("HoverImage", MAINMENUBAR_DATA[channel][2]);
	MainMenuBar_ChannelSelecter:SetProperty("PushedImage", MAINMENUBAR_DATA[channel][3]);
end

function MainMenuBar_ModifyTxt()
	local curtxt = MainMenuBar_EditBox:GetItemElementsString();
	local facetxt = Talk:ModifyChatTxt(g_CurChannel, g_CurChannelName, curtxt);
	MainMenuBar_SetEditBoxTxt(facetxt);
end

function MainMenuBar_ChangePrivateName(name)
	local curtxt = MainMenuBar_EditBox:GetItemElementsString();
	local facetxt = Talk:ModifyChatTxt("private", name, curtxt);
	MainMenuBar_SetEditBoxTxt(facetxt);
end

function MainMenuBar_ChangeTxt(msg)
	--AxTrace(0,0,"MainMenuBar msg:"..msg);
	local txt = MainMenuBar_EditBox:GetItemElementsString();
	Talk:SaveOldTalkMsg(g_CurChannel, txt);
	MainMenuBar_SetEditBoxTxt(msg);
end

function MainMenuBar_SelectColorFaceFinish(act, strResult)
	if(act == "sucess") then
		local txt = MainMenuBar_EditBox:GetItemElementsString();
		local facetxt = txt .. strResult;
		MainMenuBar_SetEditBoxTxt(facetxt);
	end
end

--´ò¿ªµÚ¶þ¸ö¹¤¾ßÌõ
function MainMenuBar_MainMenuBar_On_Clk()
	TurnMenuBar("on")

	local Upbar2State = SystemSetup:GetUpBar2State()
	if 1 == Upbar2State then
		PushEvent("OPEN_UP_BAR_2", 1, "UpBar2")
	end

	PushEvent("SWITCH_MENU_BUTTON", 1)

	MainMenuBar_MainMenuBar_On:Hide()
	MainMenuBar_MainMenuBar_Off:Show()

	SystemSetup:SetSubMenubarState( 1 )
end

--¹Ø± µÚ¶þ¸ö¹¤¾ßÌõ
function MainMenuBar_MainMenuBar_Off_Clk()
	TurnMenuBar("off")

	PushEvent("OPEN_UP_BAR_2", 0, "UpBar2")

	PushEvent("SWITCH_MENU_BUTTON", 0)

	MainMenuBar_MainMenuBar_On:Show()
	MainMenuBar_MainMenuBar_Off:Hide()

	SystemSetup:SetSubMenubarState( 0 )
end


function MainmenuBar_UpdateDur()
	AxTrace( 0,0, "MainmenuBar_UpdateDur()");
	local i = 1;
	local bFlash = false;
	for i=1,9 do
		local ActionIndex = EnumAction( i, "equip");
		if( ActionIndex:GetEquipDur() < 0.1 ) then
			bFlash = true;
		end
	end
	if( g_Character == bFlash ) then
		return;
	else
		if( bFlash ) then
			Button_Character:SetFlash( true );
		else
			Button_Character:SetFlash( flash );
		end
	end
	g_Character = bFlash;

end

function MainmenuBar_PageUp()

	if MAINMENUBAR_PAGENUM == 0 then
		MAINMENUBAR_PAGENUM = 2;
	elseif MAINMENUBAR_PAGENUM == 1 then
		MAINMENUBAR_PAGENUM = 0;
	elseif MAINMENUBAR_PAGENUM == 2 then
		MAINMENUBAR_PAGENUM = 1;
	end

	MainmenuBar_UpdateAll();
end

function MainmenuBar_PageDown()

	if MAINMENUBAR_PAGENUM == 0 then
		MAINMENUBAR_PAGENUM = 1;
	elseif MAINMENUBAR_PAGENUM == 1 then
		MAINMENUBAR_PAGENUM = 2;
	elseif MAINMENUBAR_PAGENUM == 2 then
		MAINMENUBAR_PAGENUM = 0;
	end

	MainmenuBar_UpdateAll();
end

function MainmenuBar_UpdateAll()
	MainMenuBar_ScrollBar_Number:SetText(tostring(MAINMENUBAR_PAGENUM+1));

	for i=0,2 do
		local bShow = (i==MAINMENUBAR_PAGENUM);
		for j=1,10 do
			if i==MAINMENUBAR_PAGENUM then
				MAINMENUBAR_BUTTONS[i*10+j]:Show();
			else
				MAINMENUBAR_BUTTONS[i*10+j]:Hide();
			end
		end
	end

	for k=1,10 do
		MAINMENUBAR_BUTTONS[50+k]:Hide();
	end

	SetMenuBarPageNumber(MAINMENUBAR_PAGENUM);

	for j=1,10 do
		PutActionToMainmenuBar( 50 + j - 1, 0, 0 )
	end
	
	MainMenuBar_UpdateButtonTip();
	if bMainMenuBar_2Open == 1 then
		MainMenuBar_MainMenuBar_Off:Enable()
	else
		MainMenuBar_MainMenuBar_On:Enable()
	end
	MainMenuBar_ScrollBar_Up:Enable()
	MainMenuBar_ScrollBar_Down:Enable()
end

-- ´¦ÀíCtrl+1¿ì½Ý¼ü
function MainmenuBar_PageOne()
	MAINMENUBAR_PAGENUM = 0;
	--AxTrace(0,2,"MAINMENUBAR_PAGENUM -"..MAINMENUBAR_PAGENUM);
	MainmenuBar_UpdateAll();
end

-- ´¦ÀíCtrl+2¿ì½Ý¼ü
function MainmenuBar_PageTwo()
	MAINMENUBAR_PAGENUM = 1;
	--AxTrace(0,2,"MAINMENUBAR_PAGENUM -"..MAINMENUBAR_PAGENUM);
	MainmenuBar_UpdateAll();
end

-- ´¦ÀíCtrl+3¿ì½Ý¼ü
function MainmenuBar_PageThree()
	MAINMENUBAR_PAGENUM = 2;
	--AxTrace(0,2,"MAINMENUBAR_PAGENUM -"..MAINMENUBAR_PAGENUM);
	MainmenuBar_UpdateAll();
end

function MainMenuBar_OpenSpeakerBox()
	Talk : OpenSpeakerDlg();
end

function MainMenuBar_UpdateButtonTip()
	local tip,str
	local AcceArryEx = 10   --??????????11???????????
	for i=1,10 do
	   str = SystemSetup:GetAcceTip(i + AcceArryEx);
	   tip = string.format( "TopRight %s", str )
	   MAINMENUBAR_BUTTONS[i]:SetProperty("CornerChar", tip);
	   MAINMENUBAR_BUTTONS[i+10]:SetProperty("CornerChar", tip);
	   MAINMENUBAR_BUTTONS[i+20]:SetProperty("CornerChar", tip);
	   MAINMENUBAR_BUTTONS[i+50]:SetProperty("CornerChar", tip);
	end
end

function MainMenuBar_BattleScore_Clicked()
	City:AskGuildBattleScore();
end


function MainMenuBar_NotifyNewSkills( flag )
	if (flag == 1 ) then
		Button_Skills:SetFlash( 1 );
	else
		Button_Skills:SetFlash( 0 );
	end
end

function MainMenuBar_Open_Fenping_Config()
	Talk:OpenFenpingConfigDlgChatFrame();
end


function MainMenuBar_UnInstallChatActionButton(index)

	if (index < 0) or (index > 3) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);

	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- Çå¿ ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, MAINMENUBAR_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = MAINMENUBAR_BUTTONS[i]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- ±éÀúµ±Ç°¶¯×÷°üÖÐµÄÃ¿Ò»¸öActionItem£¬¿´¿´ÊÇ·ñÓÐºÍµ±Ç°ActionItemµÄIDÏàµÈµÄ¡£
		  	for j = 1, actionCount do
					local theAction = nil
					if actionType == 2 then
						theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					else 
						theAction = Talk : EnumChatMood(actionMinIndex + j - 2);
					end
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						MAINMENUBAR_BUTTONS[i] : SetActionItem(-1);						-- ??????ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i-1);			-- ??MainMenuBar????ActionItem????(????DragName)
					end
				end
		  end
		end
	end

	-- ½Ó×ÅÉ¾³ý MainMenuBar_2 ½çÃæÉÏµÄ¿Ø¼þ
	DataPool : UnInstall_RMB_ChatAction(index , 2)

end

function MainMenuBar_ClearChatActionButton(index, nID, nData)

	if (index < 0) or (index > 3) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);

	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- Çå¿ ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, MAINMENUBAR_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = MAINMENUBAR_BUTTONS[i]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- ±éÀúµ±Ç°¶¯×÷°üÖÐµÄÃ¿Ò»¸öActionItem£¬¿´¿´ÊÇ·ñÓÐºÍµ±Ç°ActionItemµÄIDÏàµÈµÄ¡£
		  	for j = 1, actionCount do
					local theAction = nil
					if actionType == 2 then
						theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					else 
						theAction = Talk : EnumChatMood(actionMinIndex + j - 2);
					end
					local theActionID = theAction:GetID()
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						MAINMENUBAR_BUTTONS[i] : SetActionItem(-1);						-- ??????ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i-1);			-- ??MainMenuBar????ActionItem????(????DragName)
					end
				end
		  end
		end
	end

	-- ¼ÌÐøÇåÀí MainMenuBar_2 ½çÃæÉÏµÄ¶¯×÷°ü°´Å¥
	DataPool : Clear_ChatAction_Bar("MainMenuBar_2", index, nID, nData);

end

function MainMenuBar_TimeReach()
	MainMenuBar_Doub:Hide()
	MainMenuBar_Doub_Watch:Hide()
	MainMenuBar_EXP2:Show()
	MainMenuBar_EXP3:Hide()
end

function MainMenuBar_ShowWatchTooltip()
	MainMenuBar_Doub_Watch:SetToolTip( "#{IM2BEI_141114_02}" );
end

function MainmenuBar_ShowTransfigureSkill( flag )

	if flag == 1 then
		for j=1,10 do
			MAINMENUBAR_BUTTONS[50+j]:Show();
			MAINMENUBAR_BUTTONS[50+j]:SetActionItem(-1);
			for i=0,2 do
				MAINMENUBAR_BUTTONS[i*10+j]:Hide();
			end
		end
		local count =Transfiguration:GetTransfigeActionItemCount()
		local canbeCancel = Transfiguration:TransfigeActionCanbeCancel()
		if canbeCancel == 1 then
			if count >= 2 then --??????2,?????????BUFF???
				local lastAction = count
				count = count - 1--???????MAINMENUBAR_BUTTONS[60]??,???????action
				if(count > 9)then
					count = 9
				end
				local idx = 1;
				for i=0,count-1 do
					local act = Transfiguration:EnumTransfigeAction(tonumber(i));
					if act and act:GetID() ~= 0 then
						MAINMENUBAR_BUTTONS[idx + 50]:SetActionItem(act:GetID());
						MAINMENUBAR_BUTTONS[idx + 50]:Bright()
						PutActionToMainmenuBar( idx + 50 - 1, act:GetID(), 1 )
						idx = idx +1;
						if(idx>9)then
							break;
						end
					end
				end
				--MAIN_4_BUTTONS[60]Î»ÖÃÌØÊâ´¦Àí
				if lastAction > 10 then
					lastAction = 10
				end
				local action = Transfiguration:EnumTransfigeAction(tonumber(lastAction) - 1);
				if action and action:GetID() ~= 0 then
					MAINMENUBAR_BUTTONS[60]:SetActionItem(action:GetID());
					MAINMENUBAR_BUTTONS[60]:Bright()
					PutActionToMainmenuBar( 59, action:GetID(), 1 )
				end
				SetMenuBarPageNumber(5);--??
			end
		else
			if (count <=0) then
				--
			else
				if(count > 10)then
						count = 10
				end
		--		local nSelfZoneWorldID = DataPool:GetSelfZoneWorldID();
				local idx = 1;
				for i=0,count-1 do
					local act = Transfiguration:EnumTransfigeAction(tonumber(i));
					if act and act:GetID() ~= 0 then
			--			if ( nSelfZoneWorldID == 9031 or nSelfZoneWorldID == 9015 ) then
			--				-- ÁúÃÅÌØÐ´ [¾Û±¦Åè:±äÉí¿ó¹¤BUFFµÄÈ¡Ïû±äÉí¼¼ÄÜ·Åµ½F10µÄÎ»ÖÃ]
			--				if ( act:GetDefineID() == 3109 ) then
			--					MAINMENUBAR_BUTTONS[60]:SetActionItem(act:GetID());
			--					MAINMENUBAR_BUTTONS[60]:Bright()
			--					PutActionToMainmenuBar( 59, act:GetID(), 1 )
			--				else
			--					MAINMENUBAR_BUTTONS[idx + 50]:SetActionItem(act:GetID());
			--					MAINMENUBAR_BUTTONS[idx + 50]:Bright()
			--					PutActionToMainmenuBar( idx + 50 - 1, act:GetID(), 1 )
			--					idx = idx +1;
			--					if(idx>10)then
			--						break;
			--					end
			--				end
			--			else
							MAINMENUBAR_BUTTONS[idx + 50]:SetActionItem(act:GetID());
							MAINMENUBAR_BUTTONS[idx + 50]:Bright()
							PutActionToMainmenuBar( idx + 50 - 1, act:GetID(), 1 )
							idx = idx +1;
							if(idx>10)then
								break;
							end
			--			end
					end
					SetMenuBarPageNumber(5);--??
				end
			end
		end
	else
		for j=1,10 do
			PutActionToMainmenuBar( 50 + j - 1, 0, 0 )
		--	MAINMENUBAR_BUTTONS[50+j]:Hide();
		end
		MainmenuBar_UpdateAll();
	end

	MainMenuBar_UpdateButtonTip();
--	MainMenuBar_CleanComboFlash();
end


function MainmenuBar_ShowSecWeaponfigureSkill( flag )
	if flag == 1 then
		for j=1,10 do
			MAINMENUBAR_BUTTONS[50+j]:Show();
			MAINMENUBAR_BUTTONS[50+j]:SetActionItem(-1);
			for i=0,2 do
				MAINMENUBAR_BUTTONS[i*10+j]:Hide();
			end
		end
		local count =SecWeaponfiguration:GetSecWeaponfigeActionItemCount()
		local canbeCancel = SecWeaponfiguration:SecWeaponfigeActionCanbeCancel()
		if canbeCancel == 1 then
			if count >= 2 then --??????2,????????????
				local lastAction = count
				count = count - 1--???????MAINMENUBAR_BUTTONS[60]??,???????action
				if(count > 9)then
					count = 9
				end
				local idx = 1;
				for i=0,count-1 do
					local act = SecWeaponfiguration:EnumSecWeaponfigeAction(tonumber(i));
					if act and act:GetID() ~= 0 then
						MAINMENUBAR_BUTTONS[idx + 50]:SetActionItem(act:GetID());
						MAINMENUBAR_BUTTONS[idx + 50]:Bright()
						PutActionToMainmenuBar( idx + 50 - 1, act:GetID(), 1 )
						idx = idx +1;
						if(idx>9)then
							break;
						end
					end
				end
				--MAIN_4_BUTTONS[60]Î»ÖÃÌØÊâ´¦Àí
				if lastAction > 10 then
					lastAction = 10
				end
				local action = SecWeaponfiguration:EnumSecWeaponfigeAction(tonumber(lastAction) - 1);
				if action and action:GetID() ~= 0 then
					MAINMENUBAR_BUTTONS[60]:SetActionItem(action:GetID());
					MAINMENUBAR_BUTTONS[60]:Bright()
					PutActionToMainmenuBar( 59, action:GetID(), 1 )
				end
				SetMenuBarPageNumber(5);--??
			end
		end
	else
		for j=1,10 do
			PutActionToMainmenuBar( 50 + j - 1, 0, 0 )
		--	MAINMENUBAR_BUTTONS[50+j]:Hide();
		end
		MainmenuBar_UpdateAll();
	end

	MainMenuBar_UpdateButtonTip();
end

--function MainMenuBar_CleanComboFlash()
--	for i=1,30 do
--	   	COMBOSKILL_FLASH_JUNIOR[i]:Hide()
--		COMBOSKILL_FLASH_SENIOR[i]:Hide()
--	end
--end

function MainMenuBar_UpdateFriendFlash()

	if DataPool:GetMailNumber() ~= 0 then
		Button_Friend:SetFlash(1)
		return
	end
	
	if DataPool:HaveNewIMMsg() == 1 then
		Button_Friend:SetFlash(1)
		return
	end
	
	Button_Friend:SetFlash(0)

end

-- Í¨ÖªÍÏ×§ @WAYLEE
function NotifyDragDropDragged(cSourceName, nSourceIndex, cTargetType, nTargetIndex)
	-- PushDebugMessage(" æÔª "..cSourceName.." "..nSourceIndex.." "..cTargetType.." "..nTargetIndex)
end
function MainMenuBar_Button_PetFight_MouseEnter()
	DataPool:SetPetFightList_Show1(1)
	PushEvent("OPEN_PETFIGHT_LIST",1)
end

function MainMenuBar_Button_PetFight_MouseLeave()
	DataPool:SetPetFightList_Show1(0)
	PushEvent("OPEN_PETFIGHT_LIST",0)
end
