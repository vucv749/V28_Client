local g_KeepHeight = 105; --????????????????
local g_MinHeight = 107; --?????????? --???????
local g_FenpingMinHeight = 112; --????????
local g_FenpingMaxHeight = 196; --????????
local g_MaxHeight = 449-28; --??????????
local g_MinWidth	=	320;	--??????????
local g_MaxWidth	=	800-180;	--??????????

local g_CurSpeakerZoneworldid = -1
local g_CurSpeakerDisplayName = "" --???@???

local g_MoveUpHeight = 70; --?????????????
local g_CurSpeakerName = "";
local channel_config = {};
local CHANNEL_DATA = {};

local channel_seltab = 0;		--????“??”
local channel_tab = {};
local CHANNEL_TAB_MAX = 7;	--???????Tab
local g_channel_fenping = 7; --??ID
local channel_tab_total = 4;	--???????Tab, 0 & 1

local channel_sendhis = 0;	--0 ?????????????
														--1 ÊÇ´Ó·¢ËÍÀúÊ·Àï»ñÈ¡µÄ×Ö´®
local channel_sendhis2 = 0;

local g_CurFlashTab = -1;

local channel_flash = {};

local g_bld_sceneId = 618
local g_mf_sceneId = 633
local g_yanmen_restsceneId = 644
local g_tsphoenixready_restsceneId = 681

local g_CurSecretType = -1
local g_CurSecretFlag = -1

local CHANNEL_DATA_NEAR = 
	{	
		"set:Buttons image:Channelvicinity_Normal", 		-- ????????
		"set:Buttons image:ChannelVicinity_Hover", 		-- ????????
		"set:Buttons image:ChannelVicinity_Pushed",		-- ????????
		"#cFFFFFF",									-- ??????
		"#e010101#cFFFFFF",						-- ??????
--		"#91#e010101#cFFFFFF",
	};
	
local CHANNEL_DATA_SCENE = 
	{
		"set:Buttons image:ChannelWorld_Normal", 
		"set:Buttons image:ChannelWorld_Hover", 
		"set:Buttons image:ChannelWorld_Pushed",
		"#cFFFFFF",
		"#e010101#c00FFCC",					--????
--		"#92#e010101#c00FF00",
	};
	
local CHANNEL_DATA_PRIVATE = 
	{
		"set:Buttons image:ChannelPersonal_Normal", 
		"set:Buttons image:ChannelPersonal_Hover", 
		"set:Buttons image:ChannelPersonal_Pushed",
		"#cFFFFFF",
		"#e010101#cFF7C80",					--????
--		"#98#e010101#c99CC00",
	};

local CHANNEL_DATA_SYSTEM = 
	{
		"set:Buttons image:ChannelPersonal_Normal", 
		"set:Buttons image:ChannelPersonal_Hover", 
		"set:Buttons image:ChannelPersonal_Pushed",
		"#cFF0000",
		"#e010101#cFF0000",					--????
--		"#96#e010101#cFFFF00",
	};
	
local CHANNEL_DATA_TEAM = 
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
		"#cFFFFFF",
		"#e010101#cCC99FF",					--????
--	"#93#e010101#cFFFF00",
	};

local CHANNEL_DATA_SELF =
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
		"#e010101#cFFFFFF",
--		"#e010101#cFFFF00",				--¡¾×ÔÓÃ¡¿
		"nouse",
	};
	
local CHANNEL_DATA_HELP =
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
		"#e010101#cFFFFFF",
--		"#e010101#cFFFF00",				--¡¾°ïÖú¡¿
		"nouse",
	};
	
local CHANNEL_DATA_MENPAI =
	{
		"set:Buttons image:ChannelMenpai_Normal", 
		"set:Buttons image:ChannelMenpai_Hover", 
		"set:Buttons image:ChannelMenpai_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--????
--		"#94#e010101#cFFFF00",
	};

local CHANNEL_DATA_GUILD = 
	{
		"set:Buttons image:ChannelCorporative_Normal", 
		"set:Buttons image:ChannelCorporative_Hover", 
		"set:Buttons image:ChannelCorporative_Pushed",
		"#cFFFFFF",
		"#e010101#cFFCC99",					--????
--		"#95#e010101#cFFFF00",
	};

local CHANNEL_DATA_GUILD_LEAGUE = 
	{
		"set:CommonFrame6 image:ChannelTongMeng_Normal", 
		"set:CommonFrame6 image:ChannelTongMeng_Hover", 
		"set:CommonFrame6 image:ChannelTongMeng_Pushed",
		"#cFFFFFF",
		"#e010101#c66c4fc",					--??????
--		"#95#e010101#cFFFF00",
	};

local CHANNEL_DATA_IPREGION =
	{
		"set:UIIcons image:ChannelCorporative_Normal", 
		"set:UIIcons image:ChannelCorporative_Hover", 
		"set:UIIcons image:ChannelCorporative_Pushed",
		"#e010101#cFFFFFF",
--		"#e010101#cFFFF00",				--¡¾Í¬³Ç¡¿
		"nouse",
	};
 

	local CHANNEL_DATA_SONGLIAO =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--????
--		"#94#e010101#cFFFF00",
	};

	local CHANNEL_DATA_TIANJICHENG =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--?????
--		"#94#e010101#cFFFF00",
	};
	
	local CHANNEL_DATA_MAKEFRIEND =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--????
--		"#94#e010101#cFFFF00",
	};
	
	local CHANNEL_DATA_YANMENREST =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--???????
--		"#94#e010101#cFFFF00",
	};
	local CHANNEL_DATA_PTDB =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--??????
--		"#94#e010101#cFFFF00",
	};
	local CHANNEL_DATA_KFRCBOSS =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--?????BOSS?
--		"#94#e010101#cFFFF00",
	};
	
	local CHANNEL_DATA_TSPHOENIX =
	{
		"set:SongLiao02 image:Zhan_Normal", 
		"set:SongLiao02 image:Zhan_Hover", 
		"set:SongLiao02 image:Zhan_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--????????
--		"#94#e010101#cFFFF00",
	};
	local CHANNEL_DATA_RAID =
		{
			"set:Union1 image:Union_Channel_Normal",
			"set:Union1 image:Union_Channel_Hover",
			"set:Union1 image:Union_Channel_Pushed",
			"#cFFFFFF",
			"#e010101#cff3300",					--????
		};
	
	local CHANNEL_DATA_RAIDSQUAD =
		{
			"set:Buttons image:ChannelTeam_Normal",
			"set:Buttons image:ChannelTeam_Hover",
			"set:Buttons image:ChannelTeam_Pushed",
			"#cFFFFFF",
			"#e010101#cCC99FF",					--????
		};

	local CHANNEL_DATA_TSPHOENIX_READY =
		{
			"set:SongLiao02 image:Zhan_Normal", 
			"set:SongLiao02 image:Zhan_Hover", 
			"set:SongLiao02 image:Zhan_Pushed",
			"#cFFFFFF",
			"#e010101#cFFFF00",					--???????
	--		"#94#e010101#cFFFF00",
		};
local g_theCurrentChannel = "near";
local g_theCurrentChannelName = "";
local g_MoveCtl = nil;
function ChatFrame_PreLoad()
	this:RegisterEvent("APPLICATION_INITED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHAT_MESSAGE");
	this:RegisterEvent("CHAT_CHANNEL_CHANGED");
	this:RegisterEvent("CHAT_CHANGE_PRIVATENAME");
	this:RegisterEvent("CHAT_TAB_CREATE_FINISH");
	this:RegisterEvent("CHAT_TAB_CONFIG_FINISH");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("CHAT_CONTEX_MENU");
	this:RegisterEvent("CHAT_ACTSET");
	this:RegisterEvent("CHAT_DOUBLE_ACTSET");				-- ??????
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("CHAT_LOAD_TAB_CONFIG");
	this:RegisterEvent("CHAT_MENUBAR_ACTION");
	this:RegisterEvent("RESET_ALLUI");
	this:RegisterEvent("SHOW_SPEAKER");
	this:RegisterEvent("FLASH_TAB");
	
	-- ×¢²áÍ¬³ÇÆµµÀÉÁË¸, µÇÂ¼ºóÉÁË¸XÃë
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("CHAT_FENPING_CREATE");
	this:RegisterEvent("CHAT_FENPING_CONFIG");
	this:RegisterEvent("CHAT_FENPING_CLOSE");
	this:RegisterEvent("OPEN_FENPING_DLG_CHATFRAME");
	this:RegisterEvent("SHOW_SECRETSPEAKER",true);
	
end
	
function ChatFrame_OnLoad()
	CHANNEL_DATA["near"] = CHANNEL_DATA_NEAR;
	CHANNEL_DATA["scene"] = CHANNEL_DATA_SCENE;
	CHANNEL_DATA["private"] = CHANNEL_DATA_PRIVATE;
	CHANNEL_DATA["system"] = CHANNEL_DATA_SYSTEM;
	CHANNEL_DATA["team"] = CHANNEL_DATA_TEAM;
	CHANNEL_DATA["self"] = CHANNEL_DATA_SELF;
	CHANNEL_DATA["menpai"] = CHANNEL_DATA_MENPAI;
	CHANNEL_DATA["guild"] = CHANNEL_DATA_GUILD;
	CHANNEL_DATA["guild_league"] = CHANNEL_DATA_GUILD_LEAGUE;
	CHANNEL_DATA["help"] = CHANNEL_DATA_HELP;
	CHANNEL_DATA["ipregion"] = CHANNEL_DATA_IPREGION;
	CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_SONGLIAO;
	CHANNEL_DATA["raid"] = CHANNEL_DATA_RAID;
	CHANNEL_DATA["raidsquad"] = CHANNEL_DATA_RAIDSQUAD;

	--TABÒ³µÄÅäÖÃÐÅÏ¢
	channel_tab[2] = Chat_SelfChk;
	channel_tab[3] = Chat_City;
	channel_tab[4] = Chat_CreateChk1;
	channel_tab[5] = Chat_CreateChk2;
	channel_tab[6] = Chat_CreateChk3;

	channel_flash[3] = Chat_City_Flash
	
	-- °´  GameDefine2.h ÖÐ ENUM_CHAT_TYPE Ë³Ðò
	channel_config[0] = {"T±ng hþp lÕi",1,1,1,1,1,1,1,1,0,1,0,0,1,0,1,1};
	channel_config[1] = {"HT",0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0};
	channel_config[2] = {"Cá nhân",0,1,0,1,0,0,1,0,0,0,0,0,1,0,1,1};
	channel_config[3] = {"Ð°ng Thành",0,1,0,1,0,0,1,0,0,0,0,1,1,0,0,0};
	channel_config[4] = {"",1,1,1,1,1,1,1,1,1,1,0,0,1,0,0,0};
	channel_config[5] = {"",1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1};
	channel_config[6] = {"",1,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1};
	--·ÖÆÁ
	channel_config[7] = {"",1,1,1,1,1,1,1,1,0,1,0,0,1,0,1,1};
	channel_config[8] = {"",0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0};
	
	--Òþ²ØÐ¡À®°È
	Chat_ChatSpeaker_StarWindow:SetText( "" );
	Chat_ChatSpeaker_StarWindow:SetProperty( "Name","" );
	Chat_ChatSpeaker_StarWindow:Hide();
	Chat_ChatSpeaker_StarWindow2:Hide();

	Chat_Frame_FenpingFrame:Hide();
	NotFlashAllTab()
end

function ChatFrame_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();
		--ÉèÖÃÀúÊ·ÏûÏ¢¼ÇÂ¼±£´æµÄ×î´óÖµ
		Talk:SetMaxSaveNumber(tonumber(Chat_Frame_History:GetProperty("ChatBoardNumber")));
		--ÉèÖÃÏµÍ³ÏûÏ¢µÄ×Ô¶¯ÏûÊ§Ê±¼ä¼ä¸ô
		Talk:SetDisappearTime(tonumber(Chat_Frame_History:GetProperty("BoardKillTimer")));
		Talk:SetCurTab(channel_seltab);

		ChatFrame_SetTabConfig( 0 );
		ChatFrame_SetTabConfig( 1 );
		ChatFrame_SetTabConfig( 2 );
		ChatFrame_SetTabConfig( 3 );
		channel_tab[3]:SetText("Ð°ng Thành");
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, g_theCurrentChannelName);
		if 548 == GetSceneID() then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_SONGLIAO
			Chat_City:SetText("Chiªn trß¶ng")
			channel_tab[3]:SetCheck(1);
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
		if g_bld_sceneId == GetSceneID() then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_TIANJICHENG
			Chat_City:SetText("#{BLDPVP_221214_180}")
			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
		if g_mf_sceneId == GetSceneID() then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_MAKEFRIEND
			Chat_City:SetText("#{JYHD_230331_93}")
			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
		
		if g_yanmen_restsceneId == GetSceneID() then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_YANMENREST
			Chat_City:SetText("#{YMMJ_230626_376}")
			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end

		if PTDB:LuaFnIsPTDBScene(GetSceneID()) > 0 then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_PTDB
			Chat_City:SetText("#{JYHD_230331_93}")
			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
		if KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) > 0 then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_KFRCBOSS
			Chat_City:SetText("#{JYHD_230331_93}")
			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
		if Lua_IsTSPhoenixScene(GetSceneID()) == 1 then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_TSPHOENIX
			Chat_City:SetText("#{BLDPVP_221214_180}") -- ??
			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
		if g_tsphoenixready_restsceneId == GetSceneID() then
			CHANNEL_DATA["zhanchang"] = CHANNEL_DATA_TSPHOENIX_READY
			-- â¸ö²»ÐèÒªÉèÖÃ£¬ÉèÖÃÒ²ÏÔÊ¾²»ÏÂ
			--Chat_City:SetText("#{YMMJ_230626_376}")

			channel_tab[3]:SetCheck(1)
			Chat_ChangeTabIndex(8)
			g_theCurrentChannel = "zhanchang"
			Chat_Frame_History:RemoveAllChatString();
			Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		end
	elseif (event == "CHAT_MESSAGE" ) then
		--ChatFrame_InsertChatContent(arg0, arg1, arg2);
	elseif (event == "CHAT_CHANNEL_CHANGED" ) then
		ChatFrame_ChannelChanged(arg0);
	elseif (event == "CHAT_TAB_CREATE_FINISH") then
		ChatFrame_CreateTabFinish(arg0,arg1,arg2);
	elseif (event == "CHAT_FENPING_CREATE") then
		ChatFrame_CreateFenping(arg0);
	elseif (event == "CHAT_FENPING_CLOSE") then
		ChatFrame_CloseFenping(arg0);
	elseif (event == "CHAT_FENPING_CONFIG") then
		ChatFrame_ConfigFenping(arg0);
	elseif (event == "OPEN_FENPING_DLG_CHATFRAME") then
		ChatFrame_OpenFenpingDlg(arg0);
	elseif (event == "CHAT_TAB_CONFIG_FINISH") then
		ChatFrame_ConfigTabFinish(arg0,arg1,arg2);
	elseif (event == "ACCELERATE_KEYSEND") then
		ChatFrame_HandleAccKey(arg0,arg1);
	elseif (event == "CHAT_CHANGE_PRIVATENAME") then
		ChatFrame_ChangePrivateName(arg0);
	elseif (event == "CHAT_CONTEX_MENU") then
		ChatFrame_ContexMenu_Open(arg0,arg1);
	elseif (event == "CHAT_ACTSET")	then							-- ??????
		ChatFrame_ActSetMessage(arg0, 1);
	elseif (event == "CHAT_DOUBLE_ACTSET")	then			-- ??????
		ChatFrame_ActSetMessage(arg0, 2);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		ChatFrame_AdjustMoveCtl(arg0, arg1);
	elseif (event == "CHAT_LOAD_TAB_CONFIG") then
		ChatFrame_LoadTabConfig(arg2,arg0,arg1);
	elseif (event == "CHAT_MENUBAR_ACTION") then
		ChatFrame_HandleMenuBarAction(arg0,arg1,arg2);
	elseif (event == "RESET_ALLUI") then
		-- Òþ²Ø¶àÓàµÄTab´°Ìå
		channel_tab_total = 4;
		for i= channel_tab_total, CHANNEL_TAB_MAX-1 do
			ChatFrame_SetTabMouseRButtonHollow(i, 1);
			channel_tab[i]:Hide();
		end
		g_theCurrentChannel = "near";
		g_theCurrentChannelName = "";
		channel_seltab = 0;
		--Òþ²ØÐ¡À®°È
		Chat_ChatSpeaker_StarWindow:SetText( "" );
		Chat_ChatSpeaker_StarWindow:SetProperty( "Name","" );
		Chat_ChatSpeaker_StarWindow:Hide();
		Chat_ChatSpeaker_StarWindow2:Hide();

		Chat_SystemChk : SetCheck(1)

		NotFlashAllTab()
	elseif (event == "SHOW_SPEAKER") then
		g_CurSecretType = -1
		g_CurSpeakerName = arg0;
		g_CurSpeakerContex = arg1;
		g_CurSpeakerDisplayName = g_CurSpeakerName
		g_CurSpeakerZoneworldid = tonumber(arg2)
		local selfZoneWorldID = DataPool:GetSelfZoneWorldID()

		
		if(Player:GetName() == g_CurSpeakerName and (selfZoneWorldID == g_CurSpeakerZoneworldid or selfZoneWorldID == -1 or g_CurSpeakerZoneworldid == -1) )then

			Chat_ChatSpeaker_StarWindow:SetText( "#e010101["..tostring( arg0 ).."]#W:"..tostring(arg1) );
		else
			if selfZoneWorldID ~= 0 and selfZoneWorldID ~= g_CurSpeakerZoneworldid and g_CurSpeakerZoneworldid ~= -1 then
				local serverName = DataPool:GetServerName( g_CurSpeakerZoneworldid )
				g_CurSpeakerDisplayName = g_CurSpeakerName.."@"..tostring(serverName)
				Chat_ChatSpeaker_StarWindow:SetText( "#e010101#c00ccff["..tostring( g_CurSpeakerDisplayName ).."]#W:"..tostring(arg1) )
			else
				Chat_ChatSpeaker_StarWindow:SetText( "#e010101#c00ccff["..tostring( arg0 ).."]#W:"..tostring(arg1) );
			end
		end
		
		Chat_ChatSpeaker_StarWindow:SetProperty( "Name","["..tostring(arg0).."@"..g_CurSpeakerZoneworldid.."]" );
		Chat_ChatSpeaker_StarWindow:SetProperty( "Reset","false" );
		Chat_ChatSpeaker_StarWindow2:SetProperty( "Reset","false" );
		Talk:HideContexMenu4Speaker();

--	È¡ÏûÃ¿´ÎÔÚÍ¬³Ç·¢ÑÔÖÐ³öÏÖ°´Å¥ÉÁË¸
--	elseif (event == "FLASH_TAB") then
--
--		local showTab = tonumber(arg0);
--		local isShow  = tonumber(arg1);
--		
--		if(showTab > 0 and showTab < CHANNEL_TAB_MAX -1) then
--			if(isShow > 0 ) then
--				FlashTab(showTab);
--			else
--				NotFlashTab(showTab);
--			end
--		end
	
	-- ÉÏÏßÍ¬³ÇÆµµÀÉÁË¸
	elseif (event == "UI_COMMAND") then
		if (tonumber( arg0 ) == 870001001) then
			FlashTab(3);
			SetTimer("ChatFrame","StopFlashCityChannel()", 5000);		--?????10??????
		end
	elseif (event == "SHOW_SECRETSPEAKER") then
		Chat_ChatSpeaker_StarWindow:SetProperty( "Font","SongTiBmp12" );
		g_CurSecretType = 1;
		g_CurSecretFlag = arg0;
		g_CurSpeakerContex = arg1;
		g_CurSpeakerZoneworldid = tonumber(arg2)
		local selfZoneWorldID = DataPool:GetSelfZoneWorldID()

		if (g_CurSecretFlag == "1") then
			Chat_ChatSpeaker_StarWindow:SetText( "#e010101#-63#GNHçm th§t là t¯t Hæu#W:"..tostring(arg1) );
		elseif (g_CurSecretFlag == "2") then
			Chat_ChatSpeaker_StarWindow:SetText( "#e010101#-60#cff0000Nhçm Ðích c×u nhân#W:"..tostring(arg1) );
		elseif	(g_CurSecretFlag == "3") then
			Chat_ChatSpeaker_StarWindow:SetText( "#e010101#-61#WNHçm Ðích tin tÑc#W:"..tostring(arg1) );
		else
			Chat_ChatSpeaker_StarWindow:SetText( "#e010101#-62#cbe38ffgiang h° kÏ vån#W:"..tostring(arg1) );
		end
		Chat_ChatSpeaker_StarWindow:SetProperty( "Name","[speaker]" );
		Chat_ChatSpeaker_StarWindow:SetProperty( "Reset","false" );
		Chat_ChatSpeaker_StarWindow2:SetProperty( "Reset","false" );
		Talk:HideContexMenu4Speaker();
	end
end

function StopFlashCityChannel()
	NotFlashTab(3);
	KillTimer("StopFlashCityChannel()");		--?????
end

function NotFlashTab(idx)
	for i =2, 6 do
		if(idx == i and channel_flash[i])then
			g_CurFlashTab = -1;
			channel_flash[i] : Play( false );
		end
	end  
end

function FlashTab(idx)
	for i =2, 6 do
		if(idx == i and channel_flash[i])then
			g_CurFlashTab = idx;
			channel_flash[i] : Play( true );
		end
	end  
end

function NotFlashAllTab()
	for i =2, 6 do
		if(channel_flash[i])then
			
			channel_flash[i] : Play( false );
		end
		
	end  

	g_CurFlashTab = -1;
end

function ChatFrame_TextAccepted(arg)
	--AxTrace(0,0,"ChatFrame_TextAccepted arg:"..arg);
	--local txt = arg;
	--local prvname = Talk:SendChatMessage(g_theCurrentChannel, txt);
	local prvname = arg;
	
	if("" ~= prvname) then
		Talk:HandleHistoryAction("editbox", prvname,"");
	else
		Talk:HandleHistoryAction("editbox", "","");
	end
end

function ChatFrame_ChannelSelect(pos)

	ChatFrame_ChannelSelect_ChangePosition(pos);
	Chat_Frame_ChannelFrame:Show();

	local nChannelNum = Talk:GetChannelNumber();
	Chat_Frame_Channel:ClearAllChannel();
	
	-- PushDebugMessage("ChannelNum:"..tostring(nChannelNum))
	
	local i=1;
	local FoundPrv=-1;
	while i<=nChannelNum do
		local strChannelType, strChannelName = Talk:GetChannel(i-1);
		if(strChannelType == "-" or CHANNEL_DATA[strChannelType] == nil) then
			return;
		end
--AxTrace(0,0, "i=" .. i .. "strChannelType=" .. strChannelType .. "strChannelName=" .. strChannelName);
		if(strChannelType ~= "private") then
			if( 548 == GetSceneID() and strChannelType ~= "ipregion" ) then
				Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName);
			elseif( g_bld_sceneId == GetSceneID() and strChannelType ~= "ipregion" ) then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "#{BLDPVP_221214_181}")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end
			elseif( g_mf_sceneId == GetSceneID() and strChannelType ~= "ipregion" ) then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "#{JYHD_230331_94}")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end
			elseif g_yanmen_restsceneId == GetSceneID()  and strChannelType ~= "ipregion" then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "#{YMMJ_230626_377}")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end
			elseif g_tsphoenixready_restsceneId == GetSceneID() and strChannelType ~= "ipregion" then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "#{YMMJ_230626_377}")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end			 
			elseif( PTDB:LuaFnIsPTDBScene(GetSceneID()) > 0 and strChannelType ~= "ipregion" ) then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "#{JYHD_230331_94}")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end
			elseif( KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) > 0 and strChannelType ~= "ipregion" ) then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "#{JYHD_230331_94}")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end
			elseif Lua_IsTSPhoenixScene(GetSceneID()) == 1 and strChannelType ~= "ipregion" then
				if strChannelType == "zhanchang" then
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], "Qu¥n hùng Trøc Lµc chiªn trß¶ng")
				else
					Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName)
				end
			elseif( 548 ~= GetSceneID() and g_bld_sceneId ~= GetSceneID() and g_mf_sceneId ~= GetSceneID() and g_yanmen_restsceneId ~= GetSceneID() and PTDB:LuaFnIsPTDBScene(GetSceneID()) < 1 and
				KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) < 1 and Lua_IsTSPhoenixScene(GetSceneID()) ~= 1) then
				Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName);
		    end
		else
			FoundPrv = i-1;
		end
		
		i = i+1;
	end

	-- Ë½ÁÄ¶ÔÏóÁÐ±í¼ÓÈë£¬todo_yangjun
	if(-1 ~= FoundPrv) then
		local strPrvType, strPrvName1, strPrvName2, strPrvName3 = Talk:GetChannel(FoundPrv);
		if(CHANNEL_DATA[strPrvType] == nil) then
			return;
		end
		if(strPrvName1 ~= "" and strPrvName1 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName1);
		end
		if(strPrvName2 ~= "" and strPrvName2 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName2);
		end
		if(strPrvName3 ~= "" and strPrvName3 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName3);
		end
	end
end

function ChatFrame_ChannelListSelect()
	Chat_Frame_ChannelFrame:Hide();

	local selCh = Chat_Frame_Channel:GetProperty("HoverChannel");
	local prv = Chat_Frame_Channel:GetHoverChannelName();
	
	ChatFrame_ChannelListChange( selCh, prv );
end

function ChatFrame_ChannelListChange( selChannel, prvtxt)

	--PushDebugMessage(selChannel.." - "..prvtxt)

	if(CHANNEL_DATA[selChannel] == nil) then
		return;
	end

	g_theCurrentChannel = selChannel;
	g_theCurrentChannelName = prvtxt;

	Talk:HandleHistoryAction("listChange", g_theCurrentChannel, g_theCurrentChannelName);
	Talk:HandleHistoryAction("modifyTxt", "","");
end

function ChatFrame_ChangePrivateName( newname )
	if(ChatFrame_IsNameMySelf(newname) > 0) then
		return;
	end

	Talk:HandleHistoryAction("privateChange", newname, "");
end

function ChatFrame_InsertChatContent(chatType, chatTalkerName, chatContent)
	if(CHANNEL_DATA[chatType] == nil) then
		return
	end
	
	--if(chatContent == "@" or chatContent == "*") then return; end
	
	local strFinal;
	local strHeader = Talk:GetChannelHeader(chatType, chatTalkerName);
	if(nil == strHeader) then
		--AxTrace(0,0,"Err!!! ChatFrame Type:"..chatType);
		return
	end
	if(chatTalkerName == "" and chatType ~= "self") then
		strFinal = CHANNEL_DATA[chatType][5];
		strFinal = strFinal .. "[" .. strHeader .. "]";
		strFinal = strFinal .. CHANNEL_DATA[chatType][4] ..chatContent;
	else
		if(chatType ~= "self") then
			strFinal = CHANNEL_DATA[chatType][5];
			if(string.byte(chatContent, 1) ~= 64 and string.byte(chatContent, 1) ~= 42) then -- '@' ??????
				strFinal = strFinal .. "[" .. strHeader .. "]";
				if(ChatFrame_IsNameMySelf(chatTalkerName) > 0) then
					strFinal = strFinal .. "#W[" .. chatTalkerName .. "]";
				else
					--strFinal = strFinal .. "#c00CCFF[#aB{" .. chatTalkerName .. "}" .. chatTalkerName .. "#aE]";
					strFinal = strFinal .. Talk:GetHyperLinkString(chatType,chatTalkerName);
				end
				strFinal = strFinal .. CHANNEL_DATA[chatType][4] .. ":" ..chatContent;
			else
				local strTemplate = Talk:GetTalkTemplateString(chatTalkerName, chatContent);
				strFinal = strFinal .. "[" .. strHeader .. "]";
				strFinal = strFinal .. strTemplate;
			end
		else
			strFinal = CHANNEL_DATA[chatType][4] .. chatContent;
		end
	end

	--AxTrace(0, 0, strFinal);
	--if( 0 == channel_seltab ) then
		Chat_Frame_History:InsertChatString(strFinal);
	--else
		--local pos = Talk:GetChannelType(chatType);
		-- todo_yangjun
		--if( 1 == channel_config[channel_seltab][pos+2]) then
			--Chat_Frame_History:InsertChatString(strFinal);
		--end
	--end
	
end

function ChatFrame_PrepareMove()
	g_MoveCtl = {
								frame = Chat_Frame,
								check = Chat_CheckBox_Frame,
								history = Chat_Frame_HistoryFrame,
								fenping = Chat_Frame_FenpingFrame,
								--nomove = Chat_Frame_NoMoveFrame,
							};
end

--ÉèÖÃÉÏÆÁ¸ß¶È
function ChatFrame_MoveCtl(dir)
	ChatFrame_PrepareMove();
	
	
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_MoveCtl.fenping:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local step;
	local bMoveFenping = 0;
	local bMoveFrame = 0;
	--×¢Òâ£¬²ß»®ÒªÇó£ºÉÏÏÂÁ½¸öÆÁ×ÜºÍÓÐ×î´óÖµ£¬
	--µ«ÊÇ ÉÏÏÂÁ½ÆÁµÄ×îÐ¡ÖµÊÇ·Ö¿ª
	if(dir > 0) then
		step = -28
		if(absFrameHeight-step > g_MaxHeight) then
			--³¬¹ý×î´óÖµ
			if g_MoveCtl.fenping:IsVisible() then
				--·ÖÆÁ¿ªÁË£¬ËõÐ¡·ÖÆÁ
				if absFenpingHeight + step < g_FenpingMinHeight then
					--ÏÂÃæµÄÆÁÒÑ¾­µ½×îÐ¡Öµ£¬²»ÔÙËõÐ¡
					return;
				else
					--ËõÐ¡ÏÂÃæµÄ£¬·Å´óÉÏÃæµÄ
					bMoveFenping = 1;
				end
			else
				--·ÖÆÁÃ»¿ª
				return
			end
		else
			bMoveFrame = 1;
		end
	else
		step = 28;
		bMoveFrame = 1;
		--×îÐ¡ÖµÅÐ¶ÏÊ¹ÓÃµ¥¶ÀµÄ¸ß¶È
		if(absHistoryHeight + absCheckHeight -step < g_MinHeight) then
			return;
		end
	end

	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	--AxTrace(0,0,"udimStr:"..udimStr);
	_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
	--AxTrace(0,0,"udimStr:"..udimStr.." udimScale:"..udimScale);
	_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	--AxTrace(0,0,"udimStr:"..udimStr.." udimFrameYPos:"..udimFrameYPos);
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos)+step; --????0,???????????

	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	
	--frame
	udimStr = string.format("{%f,%f}", udimScale,udimFrameYPos);
	if bMoveFrame == 1 then
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight-step);
	end

	if bMoveFenping == 1 then 
		g_MoveCtl.fenping:SetProperty("AbsoluteHeight", absFenpingHeight + step );
		local udimStr_fenping= string.format("{%f,%f}", 1.000000, -(absFenpingHeight+step));
		g_MoveCtl.fenping:SetProperty("UnifiedYPosition", udimStr_fenping);
		Chat_Frame_Fenping:ScrollToEnd();
	end
	absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");

--	udimStr = string.format("{%f,-%f}", udimScale,absCheckHeight + 100);

	--check
	g_MoveCtl.check:SetProperty("AbsoluteHeight", absCheckHeight);

	--bakimg
	--history
	g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight - step);
	g_MoveCtl.history:SetProperty("AbsoluteYPosition", absCheckHeight);

	local starPos;
	strPos = "{1.0,"..tostring( udimFrameYPos -83 )..".0}";
	AxTrace( 0,0,"Position="..tostring( strPos ) );
	Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos );

	
	Chat_Frame_History:ScrollToEnd();
end

--ÉèÖÃÏÂÆÁ¸ß¶È
function ChatFrame_MoveCtl_Fenping(dir)
	ChatFrame_PrepareMove();
	
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_MoveCtl.fenping:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	
	local step;
	--ÏÂÃæ3Î»±íÊ¾ÊÇ·ñÐèÒªÒÆ¶¯¿Ø¼þµÄÎ»ÖÃ
	local bMoveFrame = 0
	local bMoveHistory = 0
	local bMoveFenping = 0
	--×¢Òâ£¬²ß»®ÒªÇó£ºÉÏÏÂÁ½¸öÆÁ×ÜºÍÓÐ×î´óÖµ£¬ÏÂÃæÆÁµÄ×î´ó¸ß¶ÈÎªg_FenpingMaxHeight,µ±Á½ÆÁ×ÜºÍ´ïµ½×î´óÖµµÄÊ±ºò£¬ÏÂÃæµÄÆÁ»á¶¥¿ªÉÏÃæµÄÆÁ
	if(dir > 0) then
		step = -28
		if absFenpingHeight - step > g_FenpingMaxHeight then
			--ÏÂÆÁµÄ¸ß¶È³¬¹ý×î´óÖµ£¬Ëõ»ØÔ­ÓÐÖµ
			step = g_FenpingMaxHeight - g_FenpingMinHeight;
			bMoveFrame = 1;
			bMoveFenping = 1;
		else
			--ÏÂÆÁ¸ß¶ÈÃ»³¬¹ý×î´óÖµ
			if absFrameHeight -step > g_MaxHeight then
				--Á½ÆÁ×ÜºÍ³¬¹ý×î´óÖµ£¬ËõÐ¡ÉÏÆÁ
				bMoveHistory = 1;
				bMoveFenping = 1;
			else
				--Á½ÆÁ×ÜºÍÎª´ïµ½×î´óÖµ£¬Ö±½Ó½«ÏÂÃæÔö´ó
				bMoveFrame = 1;
				bMoveFenping = 1;
			end
		end
	else
		step = 28;
		--×îÐ¡ÖµÅÐ¶ÏÊ¹ÓÃµ¥¶ÀµÄ¸ß¶È
		if(absFenpingHeight - step < g_FenpingMinHeight ) then
			return;
		end
	end

	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos)+step; --????0,???????????

	--frame
	udimStr = string.format("{%f,%f}", udimScale,udimFrameYPos);
	if bMoveFrame == 1 then
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight-step);

		local starPos;
		strPos = "{1.0,"..tostring( udimFrameYPos -83 )..".0}";
		AxTrace( 0,0,"Position="..tostring( strPos ) );
		Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos );
	end

	--·ÖÆÁ×óÉÏ½ÇYÖµ
	udimStr = string.format("{%f,%f}", 1.000000 , -(absFenpingHeight - step));

	--bakimg
	if bMoveFenping == 1 then
		g_MoveCtl.fenping:SetProperty("AbsoluteHeight", absFenpingHeight - step);
		g_MoveCtl.fenping:SetProperty("UnifiedYPosition", udimStr);
	end

	if bMoveHistory == 1 then
		g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight + step);
	end

	Chat_Frame_History:ScrollToEnd();
	Chat_Frame_Fenping:ScrollToEnd();
end

--ÉèÖÃÁ½ÆÁµÄ¿í¶È
function ChatFrame_WidthCtl(dir)
	ChatFrame_PrepareMove();
	local absFrameWidth = g_MoveCtl.frame:GetProperty("AbsoluteWidth");
	
	local step;
	if(dir > 0) then
		step = -18
		if(absFrameWidth-step > g_MaxWidth) then
			return;
		end
	else
		step = 18;
		if(absFrameWidth-step < g_MinWidth) then
			return;
		end
	end

	--frame
	g_MoveCtl.frame:SetProperty("AbsoluteWidth", absFrameWidth-step);
	absFrameWidth = g_MoveCtl.frame:GetProperty("AbsoluteWidth");
	
	--history
	g_MoveCtl.history:SetProperty("AbsoluteWidth", absFrameWidth);
	g_MoveCtl.fenping:SetProperty("AbsoluteWidth", absFrameWidth);

	Chat_Frame_History:ScrollToEnd();
	Chat_Frame_Fenping:ScrollToEnd();
end

function ChatFrame_AdjustMoveCtl( screenWidth, screenHeight )
	ChatFrame_PrepareMove();
	Chat_Frame_ChannelFrame:Hide();
	
	local tolHeight = tonumber(screenHeight);
	if(tolHeight < 480) then return end
	
	local absMoveUpHeight = 0;
	--if(tonumber(screenWidth) < 1080) then
		absMoveUpHeight = g_MoveUpHeight;
	--end
	
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	
	--½çÃæÏÖÔÚµÄ¸ß¶ÈÊÇ²»ÊÇ³¬³öÏÔÊ¾·¶Î§ÁË¡£
	
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos); --????0,???????????
	
	if((absFrameHeight + g_KeepHeight + absMoveUpHeight) > tolHeight) then	
		local newFrameYPos = (tolHeight - g_KeepHeight - absMoveUpHeight)*-1;
		local newFrameHeight = tolHeight - g_KeepHeight - absMoveUpHeight;
		--frame
		udimStr = string.format("{%f,%f}", udimScale,newFrameYPos);
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", newFrameHeight);
	else
		local newFrameYPos = (absFrameHeight + absMoveUpHeight)*-1;
		--frame
		udimStr = string.format("{%f,%f}", udimScale,newFrameYPos);
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
	end

	--ÉèÖÃ×Ó´°ÌåµÄÎ»ÖÃ
	absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	--check
	if(tonumber(absCheckHeight) ~=0) then
		g_MoveCtl.check:SetProperty("AbsoluteHeight", absCheckHeight);
	end
	
	--bakimg
	
	--history
	--g_MoveCtl.history:SetProperty("AbsoluteHeight", absFrameHeight-absCheckHeight);
	g_MoveCtl.history:SetProperty("AbsoluteYPosition", absCheckHeight);

	Chat_Frame_History:ScrollToEnd();
end

function ChatFrame_AskFrameSizeUP()
	ChatFrame_MoveCtl(1);
end

function ChatFrame_AskFrameSizeDown()
	ChatFrame_MoveCtl(-1);
end

function ChatFrame_AskFrameWidthUP()
	ChatFrame_WidthCtl(1);
end

function ChatFrame_AskFrameWidthDown()
	ChatFrame_WidthCtl(-1);
end

function ChatFrame_ChannelChanged(force)
	if(force == "force_near") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_team" and g_theCurrentChannel == "team") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_menpai" and g_theCurrentChannel == "menpai") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_guild" and g_theCurrentChannel == "guild") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_guild_league" and g_theCurrentChannel == "guild_league") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(g_theCurrentChannel == "private") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_ipregion" and g_theCurrentChannel == "ipregion") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_raid" and g_theCurrentChannel == "raid") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_raid" and g_theCurrentChannel == "raidsquad") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "open_zhanchang") then
		Chat_City:SetText("Chiªn trß¶ng")
		channel_tab[3]:SetCheck(1);
		Chat_ChangeTabIndex(8)
		g_theCurrentChannel = "zhanchang"
		Chat_Frame_History:RemoveAllChatString();
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_zhanchang" ) then
		Chat_Frame_History:RemoveAllChatString();
		Chat_SystemChk:SetCheck(1);
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
		Chat_ChangeTabIndex(0);
	end
end

-- Ñ¡ÖÐÄ³Ò»¸öTab¶ÔÓ¦µÄÆµµÀ
function Chat_ChangeTabIndex( nIndex )
	if (548 == GetSceneID() or g_bld_sceneId == GetSceneID() or g_mf_sceneId == GetSceneID() or g_yanmen_restsceneId == GetSceneID() or 
		g_tsphoenixready_restsceneId == GetSceneID() or 
		PTDB:LuaFnIsPTDBScene(GetSceneID()) > 0 or KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) > 0 or Lua_IsTSPhoenixScene(GetSceneID()) == 1) and nIndex == 3 then
		nIndex = 8
	end

	Chat_Frame_History:RemoveAllChatString();
	channel_seltab = nIndex;
	Talk:SetCurTab(channel_seltab);
	
	if channel_config[nIndex] == nil then
		Talk:InsertHistory( nIndex, "" );
	else
		local i = 2;
		local strConfig = "";
		while channel_config[nIndex][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[nIndex][i]);
			i = i+1;
		end
		Talk:InsertHistory( nIndex, strConfig);
	end
	
	Chat_Frame_History:ScrollToEnd();

	if(g_CurFlashTab == channel_seltab and channel_seltab > 0)then
		NotFlashTab(g_CurFlashTab);
	end
end
-- ²¶×½Tab°´Å¥Ê§°ÜÊ±µÄ²Ù×÷
-- add by WTT 2009.4.20
-- ½â¾ö TT£º47859	¡¾ÆµµÀ¡¿×óÏÂ·½4¸öÆµµÀÀ¸£¬×ó¼ü°´×¡Ò»¸öÆµµÀÀ¸±êÌâ£¬ÍÏ¶¯µ½·ÇÆµµÀÀ¸±êÌâºóËÉÊÖ£¬ÆµµÀÀ¸±êÌâ¸Ä±ä£¬ÄÚÈÝ²»±ä
function Chat_OnTabCaptureLost (nIndex)
	if nIndex ~= channel_seltab then
		Chat_ChangeTabIndex(nIndex);
	end
end

function ChatFrame_CreateTab(pos)
	if(channel_tab_total+1 > CHANNEL_TAB_MAX) then
		PushDebugMessage("Không th¬ sáng tÕo nhi«u h½n kênh");
	else
		--channel_tab_total = channel_tab_total + 1;
		Talk:CreateTab(pos);
		--AxTrace(0, 0, "createTab");
	end
end

function ChatFrame_CreateTabFinish(tabName,tabCfg, strFlg)
	if(tabName == nil or tabCfg == nil or strFlg == nil) then
		--channel_tab_total = channel_tab_total - 1;
		return;
	end
	
	if(strFlg == "cancel") then
		--channel_tab_total = channel_tab_total - 1;
	elseif(strFlg == "sucess") then
		channel_tab_total = channel_tab_total + 1;
		if(tabName == "") then
			tabName = "Tñ Kiªn" .. tostring(channel_tab_total - 4);
		end

		
		
		channel_seltab = channel_tab_total-1;
		ChatFrame_ChangeTabConfig(tabCfg);
		channel_config[channel_seltab][1] = tabName;
		
		--AxTrace(0, 0, "CreateTabFinish Index: " .. tostring(channel_seltab).."Name: "..tostring(channel_config[channel_seltab][1]).." "..tabCfg);
		--±£´æÅäÖÃ
		Talk:SaveTab(channel_seltab, tabName, tabCfg);
		ChatFrame_SetTabConfig(channel_seltab);
		
		--AxTrace(0, 0, "createTabFinish");
		ChatFrame_SetTabMouseRButtonHollow(channel_seltab, 0);
		channel_tab[channel_seltab]:Show();
		channel_tab[channel_seltab]:SetCheck(1);
		channel_tab[channel_seltab]:SetText(channel_config[channel_seltab][1]);
		Chat_ChangeTabIndex(channel_seltab);
	end
end

function ChatFrame_ConfigTab(pos)
	if(channel_seltab == 0 or channel_seltab == 1) then
		PushDebugMessage("ThØ kênh không th¬ ph¯i trí");
		--AxTrace(0, 0, "´ËÆµµÀ²»ÄÜÅäÖÃ");
		return;
	end
		
	-- »ñµÃµ±Ç°ÅäÖÃ
	local i = 2;
	local strConfig = "";
	--AxTrace(0,0,"channel_config xxxx"..tostring(table.getn(channel_config[channel_seltab])));
	while channel_config[channel_seltab][i] ~= nil do
		strConfig = strConfig .. tostring(channel_config[channel_seltab][i]);
		i = i+1;
	end
	
	ChatFrame_PrintTabConfig(channel_seltab);
	
	--AxTrace(0, 0, "configTab Index: " .. tostring(channel_seltab));
	--AxTrace(0, 0, "configTab: " .. strConfig .. " " .. tostring(channel_seltab) );
	-- Í¨Öª³ÌÐò¿ªÊ¼ÅäÖÃ
	Talk:ConfigTab( channel_config[channel_seltab][1],strConfig,pos);
end

function ChatFrame_ConfigTabFinish(tabName, tabCfg, strFlg)
	if(tabName == nil or tabCfg == nil or strFlg == nil) then
		return;
	end
	
	if(strFlg == "cancel") then
	elseif(strFlg == "delete") then
		Chat_DestoryTabIndex(channel_seltab);
	elseif(strFlg == "sucess") then
		if(channel_seltab ~= 0) then
			ChatFrame_ChangeTabConfig(tabCfg);
			--Chat_ChangeTabIndex(channel_seltab);
			
			--±£´æÅäÖÃ
			Talk:SaveTab(channel_seltab, channel_config[channel_seltab][1], tabCfg);
			ChatFrame_SetTabConfig(channel_seltab);
		end
	end
end

-- ¸ü¸ÄÁÄÌìÒ³ÃæTabÅäÖÃ
function ChatFrame_ChangeTabConfig( tabCfg )
	local k = 1;
	--AxTrace(0,0,".....config:"..tostring(tabCfg).."!!!");
	--AxTrace(0,0,".....tabn:"..tostring(channel_config[channel_seltab]).."!!!");
	for i = 2, table.getn(channel_config[channel_seltab]) do
		if(string.byte(tabCfg, k) == 48) then -- 0
			channel_config[channel_seltab][i] = 0;
		elseif(string.byte(tabCfg, k) == 49) then -- 1
			channel_config[channel_seltab][i] = 1;
		else
			channel_config[channel_seltab][i] = 0;
		end

		k = k+1;
	end
	ChatFrame_PrintTabConfig(channel_seltab);
end

-- É¾³ýÁÄÌìÒ³ÃæTab
function Chat_DestoryTabIndex( nIndex )
	if( nIndex <= 3 ) then
		PushDebugMessage("ThØ kênh không th¬ xóa bö");
		return;
	end
	
	if(channel_tab_total-1 == 3) then
		return;
	end
	
	channel_tab_total = channel_tab_total - 1;
	--AxTrace(0, 0, "Chat_DestoryTabIndex Index: " .. tostring(nIndex) .. " TotalIndex: " .. tostring(channel_tab_total));
	
	-- ÏòÇ°¿½±´ÅäÖÃ
	if( channel_tab_total ~= 3 ) then
		local i;
		for i=nIndex, channel_tab_total do
			local k=1;
			while channel_config[i][k] ~= nil and channel_config[i+1][k] ~= nil and i+1 < CHANNEL_TAB_MAX do
				channel_config[i][k] = channel_config[i+1][k];
				k = k+1;
			end
			--±£´æÅäÖÃ
			local xxi = 2;
			local strConfig = "";
			while channel_config[i][xxi] ~= nil do
				strConfig = strConfig .. tostring(channel_config[i][xxi]);
				xxi = xxi+1;
			end
			--AxTrace(0, 0, "SaveTab Index: " .. tostring(i).."Name: "..tostring(channel_config[i][1]).." "..strConfig);
			if(nil ~= channel_config[i][1]) then
				Talk:SaveTab(i, channel_config[i][1], strConfig);
				ChatFrame_SetTabConfig(i);
			end
			--¸Ä±äÎÄ×Ö
			channel_tab[i]:SetText(channel_config[i][1]);
		end
	
		if(channel_seltab == channel_tab_total) then
			channel_seltab = channel_seltab - 1;
		end	
		
		if(1 < channel_seltab) then
			channel_tab[channel_seltab]:SetText(channel_config[channel_seltab][1]);
			channel_tab[channel_seltab]:SetCheck(1);
		end
	else
		channel_seltab = 0;
		Chat_CommonChk:SetCheck(1);
	end

	-- Òþ²Ø¶àÓàµÄTab´°Ìå
	for i=channel_tab_total, CHANNEL_TAB_MAX-1 do
		ChatFrame_SetTabMouseRButtonHollow(i, 1);
		channel_tab[i]:Hide();
	end	
	Talk:ClearTab(channel_tab_total);
	
	-- ¸üÐÂChatHistoryÀïµÄÄÚÈÝ
	Talk:MoveTabHisQue(nIndex, channel_tab_total);
	Chat_ChangeTabIndex(channel_seltab);
end

function ChatFrame_HandleAccKey( op, msg )
	if( nil == op ) then
		return;
	end
	
	--AxTrace(0, 0, op .. " " .. msg);
	if(channel_sendhis == 0 and op == "save_old") then
	elseif( op == "shift_up" or op == "shift_down") then
		Talk:HandleHistoryAction("changMsg", msg,"");
	elseif( op == "acc_prevchannel") then
		ChatFrame_ChangeCurrentChannel(1); --?????????
	elseif( op == "acc_nextchannel") then
		ChatFrame_ChangeCurrentChannel(-1);	--?????????
	elseif( op == "acc_clearchat" ) then
		ChatFrame_extendRegionTest();
	end
end

function ChatFrame_extendRegionTest()
	Chat_Frame_History:ExtendClearRegion();
end

function ChatFrame_ClearSendHis()
	if(1 ~= channel_sendhis2) then
		channel_sendhis = 0;
	end
	
	channel_sendhis2 = 0;
end

function ChatFrame_ChangeCurrentChannel( dir )
	local newtype, newname = Talk:ChangeCurrentChannel( g_theCurrentChannel, g_theCurrentChannelName, dir );
	ChatFrame_ChannelListChange(newtype, newname);
end

function ChatFrame_ContexMenu_Open( strLink,msgid )
	if(nil == strLink or ChatFrame_IsNameMySelf(strLink)>0) then
		return;
	end
	
	Talk:ShowContexMenu( strLink,tonumber(msgid) );
end


function ChatFrame_ActSetMessage( strAct, type )

	if(strAct == nil or strAct == "") then
		return;
	end
	
	if (type <= 0) or (type > 2) then
	  return;
	end

	local strKey = "";
	if ( type == 1 ) then
		strKey = "*" .. strAct;					-- ??????		
	elseif ( type ==2 ) then
		strKey = "*@" .. strAct;				-- ??????(?????"**",??'*'????‘*’?? )		
	end

	Talk : SendChatMessage(g_theCurrentChannel, strKey);	

end

function ChatFrame_IsNameMySelf( strName )
	if( strName == nil or strName == "") then
		return -1;
	end
	
	local myselfName = Player:GetName();
	if( myselfName == strName) then
		return 1;
	else
		return -1;
	end
end

function ChatFrame_LoadTabConfig(tabIdx, tabName, tabConfig)
	if(nil == tabIdx or nil == tabName or nil == tabConfig) then
		return;
	end
	--PushDebugMessage("tabIdx"..tabIdx.."tabName"..tabName.."tabConfig"..tabConfig);
	local selbak = channel_seltab;
	
	local tabId = tonumber(tabIdx);
	if(tabId > 0 and tabId < CHANNEL_TAB_MAX) then
		channel_seltab = tabId;
		ChatFrame_ChangeTabConfig(tabConfig);
		channel_config[channel_seltab][1] = tabName;

		ChatFrame_SetTabMouseRButtonHollow(channel_seltab, 0);
		if(channel_seltab == 3) then	--????????
			if 548 == GetSceneID() then
				channel_tab[channel_seltab]:SetText("Chiªn trß¶ng");
			elseif g_bld_sceneId == GetSceneID() then
				channel_tab[channel_seltab]:SetText("#{BLDPVP_221214_180}")
			elseif g_mf_sceneId == GetSceneID() then
				channel_tab[channel_seltab]:SetText("#{JYHD_230331_93}")
			elseif g_yanmen_restsceneId == GetSceneID() then
				channel_tab[channel_seltab]:SetText("#{YMMJ_230626_376}")
			elseif g_tsphoenixready_restsceneId == GetSceneID() then
				channel_tab[channel_seltab]:SetText("#{YMMJ_230626_376}")				
			elseif PTDB:LuaFnIsPTDBScene(GetSceneID()) > 0 then
				channel_tab[channel_seltab]:SetText("#{JYHD_230331_93}")
			elseif KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) > 0 then
				channel_tab[channel_seltab]:SetText("#{JYHD_230331_93}")
			elseif Lua_IsTSPhoenixScene(GetSceneID()) == 1 then
				channel_tab[channel_seltab]:SetText("#{BLDPVP_221214_180}") -- ??
			else 
				channel_tab[channel_seltab]:SetText("Ð°ng Thành");
			end
		else
			channel_tab[channel_seltab]:SetText(channel_config[channel_seltab][1]);
		end
		channel_tab[channel_seltab]:Show();
		if(tabId > 3) then channel_tab_total = channel_tab_total + 1; end
		ChatFrame_SetTabConfig( tabId );
	elseif tabId == g_channel_fenping then
		--·ÖÆÁÉèÖÃload
		Talk:CreateFenping(tabConfig)
	end
	
	channel_seltab = selbak;
end

function ChatFrame_SetTabConfig( tabIdx )
	if( (548 == GetSceneID() or g_bld_sceneId == GetSceneID() or g_mf_sceneId == GetSceneID() or g_yanmen_restsceneId == GetSceneID()
		or g_tsphoenixready_restsceneId == GetSceneID() 
		or PTDB:LuaFnIsPTDBScene(GetSceneID()) > 0 or KFRCBOSS:LuaFnIsCKFRCBOSSScene(GetSceneID()) > 0 or Lua_IsTSPhoenixScene(GetSceneID()) == 1) and tabIdx == 3 ) then
		tabIdx = 8
	end
	if(channel_config[tabIdx] ~= nil) then
		local i = 2;
		local strConfig = "";
		while channel_config[tabIdx][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[tabIdx][i]);
			i = i+1;
		end
		Talk:SetTabCfg(tabIdx, strConfig);
	end
end

function ChatFrame_SetTabMouseRButtonHollow( tabIdx, op )
	if(nil == tabIdx or tabIdx < 3 or tabIdx >= CHANNEL_TAB_MAX) then return end;

	if(0 == tonumber(op)) then
		channel_tab[tabIdx]:SetProperty("MouseRButtonHollow", "False");
	elseif(1 == tonumber(op)) then
		channel_tab[tabIdx]:SetProperty("MouseRButtonHollow", "True");
	end
end

function ChatFrame_HandleMenuBarAction(op,arg,new)
	if(op == "extendRegion") then
		ChatFrame_extendRegionTest();
	elseif(op == "createTab") then
		ChatFrame_CreateTab(arg);
	elseif(op == "configTab") then
		ChatFrame_ConfigTab(arg);
	elseif(op == "sizeUp") then
		ChatFrame_AskFrameSizeUP();
	elseif(op == "sizeDown") then
		ChatFrame_AskFrameSizeDown();
	elseif(op == "widthUp") then
		ChatFrame_AskFrameWidthUP();
	elseif(op == "widthDown") then
		ChatFrame_AskFrameWidthDown();
	elseif(op == "channelSelect") then
		ChatFrame_ChannelSelect(arg);
	elseif(op == "txtAccept") then
		ChatFrame_TextAccepted(arg);
	elseif(op == "saveChatLog") then
		Talk:SaveChatHistory(channel_seltab);
	elseif(op == "chatbkg") then
		ChatFrame_ChangeChatBkgAlpha(arg);
	elseif(op == "infochannel") then
		ChatFrame_ChannelListChange(arg,new);
	end
end

function ChatFrame_ChannelSelect_ChangePosition(pos)
	Chat_Frame_Channel:SetProperty("AnchorPosition", "x:"..tostring(pos-2).." y:23.0");
end

function ChatFrame_ChangeChatBkgAlpha(val)
	--AxTrace(0,0,"ChatFrame_ChangeChatBkgAlpha val:"..val);
	--Chat_CheckBox_Frame:SetProperty("Alpha", val);
	Chat_Frame_HistoryFrame:SetProperty( "Alpha", val );
	Chat_Frame_FenpingFrame:SetProperty( "Alpha", val );
	--Chat_Frame_ChannelFrame:SetProperty( "Alpha", val );
end

function ChatFrame_PrintTabConfig(idx)
	if(idx == nil or idx < 0 or idx > 7) then
		return;
	end	
	
	--channel_config[5] = {"",1,1,1,1,0,1,1,1,1};
	local strMsg = "ChatTabConfig idx:"..tostring(idx).." config:";
	for i = 2, table.getn(channel_config[idx]) do
		strMsg = strMsg..tostring(channel_config[idx][i]);
	end
	--AxTrace(0,0,strMsg);
	--PushDebugMessage(strMsg)
end

function Chat_ChatSpeaker_NameLClick()
	if (g_CurSecretType == 1) then
		return;
	end
	
	ChatFrame_ChangePrivateName( g_CurSpeakerDisplayName );
end
function Chat_ChatSpeaker_NameRClick()
	if (g_CurSecretType == 1 ) then
		if (g_CurSecretFlag ~="3") then
			Talk:ShowContexMenu4SecretSpeaker( g_CurSpeakerContex, g_CurSpeakerZoneworldid);
		end
	else
		if(nil == g_CurSpeakerName or ChatFrame_IsNameMySelf(g_CurSpeakerName)>0) then
			return;
		end
		Talk:ShowContexMenu4Speaker( g_CurSpeakerName, g_CurSpeakerContex, g_CurSpeakerZoneworldid);
	end
end

--´´½¨·ÖÆÁ added by zhanglei 
--strCfg ·ÖÆÁÊôÐÔ
function ChatFrame_CreateFenping(strCfg)
	ChatFrame_PrepareMove();

	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_FenpingMinHeight;
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	if tonumber(absFrameHeight) < g_FenpingMinHeight + absHistoryHeight then
		--·ÖÆÁÃ»ÓÐÏÔÊ¾³öÀ´£¬Èç¹ûÏÔÊ¾³öÀ´ËµÃ÷ÊÇÍæ¼Ò ¸ ²ÅÑ¡Ôñ¡°·µ»ØµÇÂ¼½çÃæµ¼ÖÂµÄ¡±
		--µ÷ û¸÷¸ö¿Ø¼þ´óÐ¡
		--frame µ÷ ûframeµÄÎ»ÖÃ
		if absFenpingHeight + absFrameHeight > g_MaxHeight then
			--³¬¹ýframeµÄ×î´óÖµÁË£¬ËõÐ¡HistoryµÄ´óÐ¡ ²»¸Ä¶¯FrameµÄ´óÐ¡
			local step = math.ceil((absFrameHeight + absFenpingHeight - g_MaxHeight)/28)*28;
			local udimScale;
			local udimFrameYPos;
			_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
			_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
			udimScale = tonumber(udimScale);

			udimFrameYPos = tonumber(udimFrameYPos) - (absFenpingHeight - step); --????0,???????????
			g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight + absFenpingHeight -step);
			udimStr = string.format("{%f,%f}", udimScale,udimFrameYPos);
			g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
			g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight - step);
		else
			--Ã»ÓÐ³¬¹ý£¬Ö±½Ócreate³öÀ´
			local udimScale;
			local udimFrameYPos;
			_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
			_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
			udimScale = tonumber(udimScale);

			udimFrameYPos = tonumber(udimFrameYPos)-absFenpingHeight; --????0,???????????
			g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight + absFenpingHeight);
			udimStr = string.format("{%f,%f}", udimScale,udimFrameYPos);
			g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);

			g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight);
			local starPos;
			strPos = "{1.0,"..tostring( udimFrameYPos -83 )..".0}";
			Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos );
		end

		g_MoveCtl.fenping:SetProperty("AbsoluteHeight", absFenpingHeight );
		local udimStr_fenping= string.format("{%f,%f}", 1.000000, -absFenpingHeight);
		g_MoveCtl.fenping:SetProperty("UnifiedYPosition", udimStr_fenping);
		g_MoveCtl.fenping:Show();
	end

	ChatFrame_FenpingCreateConfig(strCfg);

	Chat_Frame_History:ScrollToEnd();
	Chat_Frame_Fenping:ScrollToEnd();
end

--·ÖÆÁ´´½¨µÄÊ±ºòÉèÖÃµÄ±£´æ£¬ÀúÊ·Êý¾ÝµÄÐ´Èë
function ChatFrame_FenpingCreateConfig(tabCfg)
		local tabName = "FP";
		local old_channel = channel_seltab;
		channel_seltab = g_channel_fenping;
		ChatFrame_ChangeTabConfig(tabCfg);
		channel_config[channel_seltab][1] = tabName;
		
		--±£´æÅäÖÃ
		Talk:SaveTab(channel_seltab, tabName, tabCfg);
		ChatFrame_SetTabConfig(channel_seltab);
		
		ChatFrame_AddFenpingMsg(channel_seltab);

		channel_seltab = old_channel;
end

-- ·ÖÆÁ¶ÔÀúÊ·Êý¾ÝµÄ´¦Àí
-- ½«ÀúÊ·ÐÅÏ¢ÏÔÊ¾µ½·ÖÆÁ
function ChatFrame_AddFenpingMsg(nIndex)
	Chat_Frame_Fenping:RemoveAllChatString();
	
	if channel_config[nIndex] == nil then
		Talk:InsertHistory( nIndex, "" );
	else
		local i = 2;
		local strConfig = "";
		while channel_config[nIndex][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[nIndex][i]);
			i = i+1;
		end
		Talk:InsertHistory( nIndex, strConfig);
	end
	
	Chat_Frame_Fenping:ScrollToEnd();
end
--ÉèÖÃ·ÖÆÁÊôÐÔ added by zhanglei 
--strCfg ·ÖÆÁÊôÐÔ
function ChatFrame_CloseFenping(strCfg)
	ChatFrame_PrepareMove();

	--ÏÈ¹Ø± ·ÖÆÁ
	g_MoveCtl.fenping:Hide();

	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	local absHistoryHeight = g_MoveCtl.history:GetProperty("AbsoluteHeight");
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFenpingHeight = g_MoveCtl.fenping:GetProperty("AbsoluteHeight");
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);

	udimFrameYPos = tonumber(udimFrameYPos)+absFenpingHeight; --????0,???????????

	--µ÷ û¸÷¸ö¿Ø¼þ´óÐ¡
	g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight - absFenpingHeight);
	g_MoveCtl.history:SetProperty("AbsoluteHeight", absHistoryHeight );
	--frame µ÷ ûframeµÄÎ»ÖÃ
	udimStr = string.format("{%f,%f}", udimScale,udimFrameYPos);
	g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
	
	local starPos;
	strPos = "{1.0,"..tostring( udimFrameYPos -83 )..".0}";
	AxTrace( 0,0,"Position="..tostring( strPos ) );
	Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos );

	Talk:ClearTab(g_channel_fenping);

	-- ¸üÐÂChatHistoryÀïµÄÄÚÈÝ
	Talk:ClearFenpingHisQue();
	Chat_Frame_History:ScrollToEnd();
end

--¸Ä±ä·ÖÆÁÏÔÊ¾ÉèÖÃ
function ChatFrame_ConfigFenping(tabCfg)
	if(tabCfg == nil ) then
		return;
	end
	local old_channel = channel_seltab;
	channel_seltab = g_channel_fenping --??ID
	ChatFrame_ChangeTabConfig(tabCfg);

	--±£´æÅäÖÃ
	Talk:SaveTab(channel_seltab, channel_config[channel_seltab][1], tabCfg);
	ChatFrame_SetTabConfig(channel_seltab);

	channel_seltab = old_channel;
end

function ChatFrame_OpenFenpingDlg(isFenpingOpen)
	if tonumber(isFenpingOpen) == 0 then
		Talk:OpenFenpingConfigDlg("");
	else
		-- »ñµÃµ±Ç°ÅäÖÃ
		local i = 2;
		local strConfig = "";
		while channel_config[g_channel_fenping][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[g_channel_fenping][i]);
			i = i+1;
		end
		Talk:OpenFenpingConfigDlg(strConfig);
	end
end
