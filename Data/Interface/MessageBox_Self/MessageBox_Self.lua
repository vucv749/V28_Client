local g_InitiativeClose = 0;
local g_currentList = 0;
local g_currentIndex = 0;
-- °ÚÌ¯µØ×âÌáÊ¾´°¿Ú£¬ÔÚ âÀïÓÐ·¢ËÍ¸ø·þÎñÆ÷µÄÈ·¶¨¿ªÊ¼°ÚÌ¯µÄÏûÏ¢
local Recycle_Type = -1;
local Recycle_CurSelectItem = -1
local g_FrameInfo = -1;
local g_CurUintType = {
	YuanBao 	= 0,
	Bind		= 1,
}
local g_CurUint = g_CurUintType.YuanBao;
local g_MessageBox_Self_Frame_UnifiedPosition;

local g_newName = ""
local g_msgFrameVar = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}

local FrameInfoList = {
	STALL_RENT_FRAME			= 1,
	DISCARD_ITEM_FRAME			= 2,
	CANNT_DISCARD_ITEM			= 3,
	TEAM_ASKJOIN				= 4,	--?????????
    TEAM_MEMBERINVERT			= 5,	--???????????????
    TEAM_SOMEASK				= 6,	--????????
    TEAM_FOLLOW		 			= 7,	--????????
    FRAME_AFFIRM_SHOW 			= 8,	--??????????
    GUILD_CREATE_CONFIRM		= 9, 	--????????
    SYSTEM_TIP_INFO 			= 10,	--?????????
    GUILD_QUIT_CONFIRM 			= 11,	--????????
    GUILD_DESTORY_CONFIRM		= 12,	--????????
    CALL_OF						= 13,	--??
    NET_CLOSE_MESSAGE			= 14,	--????
    PET_FREE_CONFIRM			= 15,	--??????
    CITY_CONFIRM				= 16,	--??????
    SAVE_STALL_INFO				= 17,	--??????
    PET_SYNC_CONFIRM			= 18,	--??????
    QUIT_GAME					= 19,	--???????
    EQUIP_ITEM					= 20,	--????
    YUANBAO_BUY_ITEM		= 21, --??????????
    CONFIRM_REMOVE_STALL	= 22,--???? add by zchw
    PET_PROCREATE_PROMPT			= 23, -- ?????? zchw

	-- â¸ö24Ò»¶¨²»ÄÜ¸Ä£¬¸ÄÁË³ö´íµÄ£¡£¡£¡£¡£¡Chris
	SERVER_CONTROL				= 24,	--Server????????
	DELETE_FRIEND_MESSAGE		= 25,	--??????????

		GUILD_DIS_FIRSTMAN    =87,  --?????????
    GEM_COMBINED_CONFIRM		= 88,	-- ??????
   	ENCHASE_CONFIRM					= 99,	-- ????
   	ENCHASE_FOUR_CONFIRM		= 100,	-- add:lby20080527??4??

   	--CARVE_CONFIRM				= 102,	-- È·ÈÏµñ×Á



    PS_RENAME_MESSAGE			= 116,	--????????
    PS_READ_MESSAGE				= 117,	--????????(??)
    PS_ADD_BASE_MONEY			= 118,	--????
    PS_ADD_GAIN_MONEY			= 119,	--?????
    PS_DEC_GAIN_MONEY			= 120,	--?????
    PS_ADD_STALL				= 121,	--????
    PS_DEL_STALL				= 122,	--????
    PS_INFO_PANCHU				= 123,	--????
    PS_INFO_PANRU				= 124,	--????
    PS_INFO_MODIFY_TYPE			= 125,	--??????
    PS_INFO_PANCHU_YB				= 126,	--???????????
    FREEFORALL					= 201,	--FREEFORALL: ????
    FREEFORTEAM					= 202,	--FREEFORTEAM: ????
    FREEFORGUILD				= 203,	-- FREEFORGUILD:????
    MAKESUREPVPCHALLENGE		= 204,
    EXCHANGE_MONEY_OVERFLOW			= 205, --?????????????????

    GUILD_DEMIS_CONFIRM		= 206, 			--????

    COMMISION_BUY = 208, 							--????????

    Player_Give_Rose		= 209,
    RECYCLE_DEL_ITEM		=210, 				--??????

    OPEN_IS_SELL_TO_RECSHOP	= 211, 		--??????

    CONFIRM_STENGTH = 212,

    CHAR_RANAME_CONFIRM = 213,

    CITY_RANAME_CONFIRM = 214,

    CONFIRM_RE_IDENTIFY = 215,

    KICK_MEMBER_MSGBOX = 216,

		SAFEBOX_LOCK_CONFIRM = 217,						--????????
		SAFEBOX_UNLOCK_CONFIRM = 218,					--????????

		LOCK_ITEM_CONFIRM_FRAME = 219,        --	????
    GUILD_LEAGUE_QUIT_CONFIRM = 220,			--	????????
    GUILD_LEAGUE_CREATE_CONFIRM = 221,		--	????????
		PET_SKILL_STUDY_CONFIRM = 222,				--	????????
		EXCHANGE_BANGGONG = 223,							--	???????
		PUT_GUILDMONEY = 224,									--	??????
		TLZ_CONFIRM_SETPOS = 225,							--	?????????

		DISMISS_TEAM = 226,										--	????						WTT		20090212
		DART_ADJUST = 227,	-- ??????   Vega 20090422
		TRUST_FRIEND = 228,
		NEED_USE_CONFIRM_ITEM = 229,
		GONGLIDAN_USE_CONFIRM = 230, -- ??????? fsy 20091027
		KFS_RESET_GROWRATE = 231,
		UNINSTALL_EMO = 232 ,	--???????
		TEAMBOARD_OPEN_DEL_CHECK = 233,
		UNINSTALL_CHAT_ACTION = 234 ,					--	?????????
		--add by FengLiang
		SERVER_CONTROL_EXT		= 255,  --Server????????????
		CHANGE_NAME_CONFIRM = 258,
		FREEFORRAID = 259,
		CHANGE_NAME_RETOK = 261,						-- ??????
		SONGLIAOWAR_XXS_CANCELBUF_CONFIRM 	= 262, 	--???????buf??
		SONGLIAOWAR_REST_EXIT_CONFIRM 		= 263, 	--?????????
		AUTOMOVE_CONFIRM_NOPKVALUE	   = 300,		--??????-??????
		AUTOMOVE_CONFIRM_UPPKVALUE     = 301,       --??????-?????
		MESSAGE_AND_QUIT     = 302,       --???????
		MESSAGE_MONTH_CARD     = 303,       --??
		HEROS_RETURNS_CONFIRM	 = 304,			-- ??????

		HEXINCHUN_YBCONFIRM	 = 305,			--??-??????-???????
		ROSERANK_EXCHANGE_CONFIRM = 306, 					--	2015????????????
		RONGYU_BUY_ITEM		= 307, --??? ????
		WHWG_ACTIVE_CONFIRM = 308,			--????????
		QIXIRANK_EXCHANGE_CONFIRM = 342, --2015?????????
		CONFIRM_IMMIGRATION  = 352,				 -- ??
		CONFIRM_CANCEL_IMMIGRATION  = 353,				 -- ????

		CONFIRM_QIXI_QUEQIANG		= 354, -- ???? ????
		CONFIRM_KAIYANXI_DUIHUAN		= 355, --????????-2021?-by yuanpeilong

		EXTERIOR_RIDE_EQUIP_CONFIRM = 356,
		EXTERIOR_RIDE_ITEM_CONFIRM = 357,

		QINGRENJIERANK_EXCHANGE_CONFIRM = 356, --???????
		CONFIRM_FESTIVAL_SHOP			= 357,	--??????
		CONFIRM_EXTERIOR_FASHION001		= 358,	--??????
		CONFIRM_EXTERIOR_FASHION002		= 359,	--??????

		PETSOUL_ADDLIFE_CONFIRM = 360,
		PETSOUL_SMASH_CONFIRMLEVEL = 361,
		PETSOUL_SMASH_CONFIRMQUAL = 362,
		CONFIRM_QTESIGNIN_CLOSE = 363,	-- 22Q1????
		CONFIRM_2022_PETYURE = 364, --//2022??????-ypl

		FANLI_SHOP_CONFIRM		= 372,

		BUY_PLAYERSHOP_SECOND_CONFIRM = 373, --??????????

		UNLOCK_EXTERIOR_POSS_CONFIRM = 375,

		PETSOUL_LEVELDOWN_CONFIRM = 376,

		DISCARD_QUAL8ITEM_FRAME = 377,

		EXTERIOR_WEAPON_ITEM_CONFIRM = 378,

		QIXIDAKA_MISSIN_ABANDON = 379,

		JIYUAN_SHOP_CONFIRM		= 380,

		CONFIRM_ENTERDIGONG		= 381,

		CONFIRM_GUARDCONFIRM		= 382,-- [2022Q3]????????--????
		CONFIRM_SHAXINGGIVEUP		= 383,-- ?????????
		CONFIRM_SECKILLCARDOPEN		= 384,-- ??????????1??2??

		MISSION_XIULIAN_CONFIRM = 385,

		CONFIRM_EXTERIOR_REPLACE = 387,	--????????
		ZHANLING_CONFIRM = 388,

		SHENGWANGJOIN_CONFIRM = 389,
		CONFIRM_COLLECT_CRYSTAIL = 390,

		SHENGWANG_YB_SHOP_CONFIRM		= 391,

		YJFS_LEAVE_CONFIRM = 393,
		MAAN_EX_CONFIRM		= 394, --??????????
		WEEDING_PLANE_CONFIRM	= 395, --????
		CHAI_JIE_DIAO_WEN = 396, --????

		MK_EXPRESSING_EMOTIONS=397,

		COUPLE_FASHION_ADD_CONFIRM = 398,
		COUPLE_FASHION_MOVE_CONFIRM = 399,

		COUPLE_VAULT_ADD_CONFIRM = 401,
		CLOSE_COUPLEZONE_VAULT = 402,
		DOUBLEGAME_DESC = 403,
		CONFIRM_WENHUOSXZL = 404,-- 2023Q2????-???? ????
		DLZX_FLAG_CHANGEPKMODE = 405,
		WHQ_CONFIRM_BWZQ_SELECTLOVE = 406, --??????????
		JINGJINMISSION2_LEAVE	 = 407,			--?????2??
		JINGJINMISSION3_LEAVE	 = 408,			--?????3??
		ACTIVITY_WABAO_23Q3 = 409,				--2023Q3??-???-????

		QIANGHUALU_EX_CONFIRM = 412, --???????????
		JINGGANGCUO_EX_CONFIRM = 413, --?????????
		
		SHENGWANG_SAODANG_CONFIRM = 414,
		
		SHENBING_TRANSITION_CONFIRM = 415,
		SHENBING_LEVELUP_BIND_CONFIRM = 416,
		SHENBING_TRANSITION_BIND_CONFIRM = 417,
		SHENBING_SKILL_ACTIVE_BIND_CONFIRM = 418,
		SHENBING_SKILL_LEVELUP_BIND_CONFIRM = 419,
		
		RIDE_CARD_USE_CONFIRM = 420,
		BUY_YUEKA_CONFIRM = 421,
		BUY_YUEKA_PROGRESS_CONFIRM = 422,
		MESSAGE_MONTH_CARD2     = 423,       --??
		BUY_SUPERASS_FASHION_CONFIRM = 424,		--???B????
		
		RMB_EMO_INSTALL_CONFIRM = 425,
		CONFIRM_RELIVE_SPECIALITEM = 426, --30007044??????

		CONFIRM_DAHUAQIXI_BUYITEM = 427, -- ??????:????????
		CONFIRM_DAHUAQIXI_LIXIA = 428, -- ??????:????
		CONFIRM_DAHUAQIXI_BUYDAIBI = 429, -- ??????:????????
		DISCARD_GUILD					= 430,	--????

};

local PVPFLAG = { FREEFORALL = 201, FREEFORTEAM = 202, FREEFORGUILD = 203, MAKESUREPVPCHALLENGE = 204, ACCEPTDUEL = 205, DuelGUID = 0, DuelName = "", FREEFORRAID = 259 }
--FREEFORALL: ¸öÈË»ì ½ FREEFORTEAM£º ×é¶Ó»ì ½ FREEFORGUILD£º°ïÅÉ»ì ½

--
local g_szData;
local g_nData;
local g_nData1
--

local Quest_Number;
local Pet_Number;
local Server_Script_Function_Set = {};
local Server_Script_ID = "";
local Server_Return_1 = 0;
local Server_Return_2 = 0;
local Server_Return_3 = 0;

local g_CityData = {};						--??upvalue???,??????????????

local strMessageString = "";		--?????
local strMessageData   = 0;			--?????,??????????
local strMessageArgs = 0;				--????
local strMessageType = "Normal";--????
local strMessageArgs_2 = 0			--????2

local GemCombinedData = {}

local EnchaseData = {}

local SplitData = {}

local CarveData = {}

local CommisionBuyData = {}  --????????????

local MAX_OBJ_DISTANCE = 3.0;

local Client_ItemIndex = -1

local Dart_Data = {}			--????
local KFS_Data = {}         --????
local g_MessageBoxSelf_Data={0,0,0,0}
local g_BaoTuInfo = {targetId = -1, itemId = -1}
local g_HeXinChun_Data = 0--??-??????-???????
local g_KaiYanXiDuiHuan_Data = 0 --????????-2021?-by yuanpeilong
local g_2022PetYuRe_Data = 0 --//2022??????-ypl
local NeedUseConfirmItemData = {}	--???????????
local UseConfirmItemShowTxt = {
	{idx = 30900074, txt = "#{QNG_XML_9}"}, --???
	{idx = 38000009, txt = "#{LYGL_090810_01}"}, --?????
	{idx = 30900078, txt = "#{QNG_XML_9}"}, -- ????
}

local g_TeamBoardWindow = -1; --???????,????
local POS_GUILD_CHIEF = 9

--add by FengLiang ÐèÒª·µ»Ø¸ø·þÎñÆ÷¶ËµÄ ûÐÎ²ÎÊýÁÐ±í
--Ë³ÐòÊÇ targetId, param1, param2.....
local Server_Return_Params = {}
local g_LastEvent = ""--???????
local g_ImmigrationData ={}
g_ImmigrationData[0] = 0 --obj
g_ImmigrationData[1] = 0 --spouseobj
g_ImmigrationData[2] = 0 --?????

local g_MK_EP_EM_N = 0
local g_MK_EP_EM_M = 0
local g_MK_EP_EM_STR = ""
function CancelLastOp(str)
	if(this:IsVisible() and str ~= g_FrameInfo) then
		MessageBox_Self_Cancel_Clicked(0);
	end
end
--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_PreLoad()
	--this:RegisterEvent("MSGBOX_ACCEPTDUEL");
	this:RegisterEvent("MSGBOX_MAKESUREPVPCHALLENGE");
    this:RegisterEvent("MENU_SHOWACCEPTCHANGEPVP");
	this:RegisterEvent("OPEN_STALL_RENT_FRAME");
	this:RegisterEvent("OPEN_DISCARD_ITEM_FRAME");
	this:RegisterEvent("OPEN_CANNT_DISCARD_ITEM");
	this:RegisterEvent("AFFIRM_SHOW");
	this:RegisterEvent("NET_CLOSE");
	this:RegisterEvent("DELETE_FRIEND");
	this:RegisterEvent("TIME_UPDATE");
	this:RegisterEvent("PET_PROCREATE_PROMPT"); -- zchw pet procreate
	this:RegisterEvent("CONFIRM_BWZQ_SELECTLOVE")
	-- zchw fix Transfer bug
	this:RegisterEvent("OBJECT_CARED_EVENT");
	---- ÓÐÈËÑûÇëÄã¼ÓÈë¶ÓÎé
	--this:RegisterEvent("SHOW_TEAM_YES_NO");
	---- ¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄãÍ¬Òâ.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	---- Ä³ÈËÉêÇë¼ÓÈë¶ÓÎé.
	--this:RegisterEvent("TEAM_APPLY");
	---- ¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½
	--this:RegisterEvent("TEAM_FOLLOW_INVITE");

	-- ´´½¨°ï»áÈ·ÈÏ
	this:RegisterEvent("GUILD_CREATE_CONFIRM");
	-- É¾³ý°ï»áÈ·ÈÏ
	this:RegisterEvent("GUILD_DESTORY_CONFIRM");
	-- ÍË³ö°ï»áÈ·ÈÏ
	this:RegisterEvent("GUILD_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_CREATE_CONFIRM");

	this:RegisterEvent("PET_FREE_CONFIRM");

	this:RegisterEvent("OPEN_PS_MESSAGE_FRAME");

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("CITY_CONFIRM");
	--add by zchw
	this:RegisterEvent("OPEN_REMOVE_STALL");
	this:RegisterEvent("OPEN_SAVE_STALL_INFO");

	this:RegisterEvent("PET_SYNC_CONFIRM");
	this:RegisterEvent("QUEST_QUIT_GAME");

	this:RegisterEvent( "MESSAGE_BOX" );

	this:RegisterEvent( "GEM_COMBINED_CONFIRM" );
	this:RegisterEvent( "ENCHASE_CONFIRM" );
	this:RegisterEvent( "ENCHASE_FOUR_CONFIRM" );-- add:lby20080527??4??

	--this:RegisterEvent( "CARVE_CONFIRM" );
	this:RegisterEvent( "EXCHANGE_MONEY_OVERFLOW" );
	this:RegisterEvent( "GUILD_DEMIS_CONFIRM" );
	this:RegisterEvent("YUANBAO_BUY_ITEM_CONFIRM");

	this:RegisterEvent("JIYUAN_BUY_ITEM_CONFIRM");

	this:RegisterEvent("FANLI_BUY_ITEM_CONFIRM");

	this:RegisterEvent("CONFIRM_COMMISION_BUY"); --????????

	this:RegisterEvent("PLAYER_GIVE_ROSE");

	this:RegisterEvent( "RECYCLE_DEL_ITEM" );

	this:RegisterEvent( "OPEN_IS_SELL_TO_RECSHOP" );

	this:RegisterEvent( "CLOSE_PS_CHANGETYPE_MSG" );

	this:RegisterEvent( "CONFIRM_STENGTH" );

	this:RegisterEvent( "EXCHANGE_BANGGONG" );

	this:RegisterEvent( "PUT_GUILDMONEY" );

	this:RegisterEvent( "CLOSE_STRENGTH_MSGBOX" );

	this:RegisterEvent( "CLOSE_RECYCLESHOP_MSG" );

	this:RegisterEvent( "ENCHASE_CLOSE_MSGBOX" );

	this:RegisterEvent( "CITY_RANAME_CONFIRM" );

	this:RegisterEvent( "CHAR_RANAME_CONFIRM" );

	--µ±logon´ò¿ªµÄÊ±ºò£¬¹Ø± ËùÓÐMessageBox
	this:RegisterEvent( "GAMELOGIN_OPEN_COUNT_INPUT" );

	this:RegisterEvent( "CONFIRM_RE_IDENTIFY" );

	this:RegisterEvent( "CLOSE_RE_IDENTIFY_MSGBOX" );

	this:RegisterEvent( "KICK_MEMBER_MSGBOX" );

	this:RegisterEvent( "CLOSE_KICK_MEMBER_MSGBOX" );

	--±£Ï ÏäËø¶¨È·ÈÏ¿ò
	this:RegisterEvent( "SAFEBOX_LOCK_CONFIRM" );

	--±£Ï Ïä½âËøÈ·ÈÏ¿ò
	this:RegisterEvent( "SAFEBOX_UNLOCK_CONFIRM" );

	this:RegisterEvent( "CLOSE_SAFEBOX_CONFIRM" );

	--¼ÓËøÈ·ÈÏ
	this:RegisterEvent( "LOCK_ITEM_CONFIRM" );
	this:RegisterEvent( "OPEN_PETSKILLSTUDY_MSGBOX" );
	this:RegisterEvent( "CLOSE_PETSKILLSTUDY_MSGBOX" );
	--ÍÁÁéÖé¶¨Î»È·ÈÏ
	this:RegisterEvent( "CONFIRM_SETPOS_TLZ" );

	-- µ¯³ö½âÉ¢¶ÓÎéµÄ¶þ´ÎÈ·ÈÏ´°¿Ú			add by WTT	20090212
	this:RegisterEvent( "OPNE_DISMISS_TEAM_MSGBOX" );

	this:RegisterEvent("PACKAGE_ITEM_CHANGED");

	-- ÐÅÈÎ»ï°éÉ¾³ýÈ·ÈÏ
	this:RegisterEvent("TRUST_FRIEND_OPEN_DEL_CHECK");

	this:RegisterEvent("SET_GUILD_FIRSTMAN_NAME");

	-- µ¯³öÎïÆ·Ê¹ÓÃÈ·ÈÏ´°¿Ú
	this:RegisterEvent("NEED_USE_CONFIRM_ITEM");
	--Ð¶ÔØÊ ·Ñ±íÇéÈ·ÈÏ
	this:RegisterEvent("UNINSTALL_EMO_CONFIRM");
	--Ð¶ÔØÊ ·ÑÐÝÏÐ¶¯×÷È·ÈÏ
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_CONFIRM");

	this:RegisterEvent("TEAMBOARD_OPEN_DEL_CHECK");
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	-- ½»Ò×³É¹¦
	this:RegisterEvent("SUCCEED_EXCHANGE_CLOSE")
	this:RegisterEvent("AUTOMOVE_CONFIRM_NOPKVALUE")
	this:RegisterEvent("AUTOMOVE_CONFIRM_UPPKVALUE")
	-- ½ÇÉ«¸ÄÃû
	this:RegisterEvent("CHANGE_NAME_CONFIRM",true);
	--ÓëÒÂ¹ñ½çÃæ»¥³â
	this:RegisterEvent("YIGUI_OPEN",true);

	this:RegisterEvent("OPEN_EXTERIOR_CONFORM",true);

	this:RegisterEvent("ROSERANK_EXCHANGE_CONFIRM",true);
	this:RegisterEvent("QINGRENJIERANK_EXCHANGE_CONFIRM",true);
	--this:RegisterEvent("QIXIRANK_EXCHANGE_CONFIRM",true);
	this:RegisterEvent("RONGYU_BUY_ITEM_CONFIRM")
	this:RegisterEvent("CONFIRM_QIXI_QUEQIANG")
	this:RegisterEvent("CONFIRM_RELIVE_SPECIALITEM")
	this:RegisterEvent("SPRINGFESTIVAL_SHOP_CONFIRM")
	this:RegisterEvent("EXTERIOR_FASHION_CONFIRM")
	this:RegisterEvent("ACT_QTE_SIGNIN_CONFIRM")
	this:RegisterEvent("CLOSE_PETSOULADDLIFE_MSGBOX")
	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("SHENGWANG_CHOOSE_CONFIRM")

	
	
	this:RegisterEvent("SHENGWANG_YB_BUY_ITEM_CONFIRM")

	this:RegisterEvent("COUPLE_FASHION_ADD_CONFIRM");
	this:RegisterEvent("COUPLE_FASHION_MOVE_CONFIRM");

	this:RegisterEvent("COUPLE_VAULT_ADD_CONFIRM")
	this:RegisterEvent("COUPLE_VAULT_OUT_CONFIRM")
	this:RegisterEvent("DOUBLEGAME_GAMEDESC")
	this:RegisterEvent("PETSOUL_RANSE_CLOSE")
	this:RegisterEvent("CLOSE_MESSAGEBOX")

	this:RegisterEvent("DAHUASHOP_BUYITEM_CONFIRM")
	this:RegisterEvent("DAHUASHOP_BUYDAIBI_CONFIRM")
	this:RegisterEvent("CLOSE_DAHUAQIXI_SHOP_MSGBOX")
end

--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_OnLoad()
  g_MessageBox_Self_Frame_UnifiedPosition=MessageBox_Self_Frame:GetProperty("UnifiedPosition");
end

function  MessageBox_Self_UpdateRect()

	local nWidth, nHeight = MessageBox_Self_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBox_Self_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end
--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEventEx(event)
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		MessageBox_Self_Frame_On_ResetPos()
		return 0
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MessageBox_Self_Frame_On_ResetPos()
		return 0
	end

	local objCaredID = -1; -- zchw fix Transfer bug
	if(event == "QUEST_QUIT_GAME") then
		if GameProduceLogin:IsYunGameMobileClient() then
			EnterQuitWait(0)
			this:Hide()
			return 0
		end
		this:Show();
		g_FrameInfo = FrameInfoList.QUIT_GAME;
	-- add by zchw
	elseif event == "OPEN_REMOVE_STALL" then
		CancelLastOp(FrameInfoList.CONFIRM_REMOVE_STALL);
		g_FrameInfo = FrameInfoList.CONFIRM_REMOVE_STALL;
	-- zchw for pet procreate
	elseif event == "PET_PROCREATE_PROMPT" then
		CancelLastOp(FrameInfoList.PET_PROCREATE_PROMPT);
		g_FrameInfo = FrameInfoList.PET_PROCREATE_PROMPT;
	--ÆßÏ¦ÈµÇÅ
	elseif event == "CONFIRM_QIXI_QUEQIANG" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.CONFIRM_QIXI_QUEQIANG and this:IsVisible())then
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			CancelLastOp(FrameInfoList.CONFIRM_QIXI_QUEQIANG);
			g_FrameInfo = FrameInfoList.CONFIRM_QIXI_QUEQIANG;
		end
	elseif event == "CONFIRM_RELIVE_SPECIALITEM" then 
		CancelLastOp(FrameInfoList.CONFIRM_RELIVE_SPECIALITEM);
		g_FrameInfo = FrameInfoList.CONFIRM_RELIVE_SPECIALITEM;
	elseif event == "OPEN_SAVE_STALL_INFO"    then
		CancelLastOp(FrameInfoList.SAVE_STALL_INFO);
		g_FrameInfo = FrameInfoList.SAVE_STALL_INFO;
	elseif event == "YUANBAO_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM and this:IsVisible())then
			--Èç¹ûÊÇ¹ØÓÚ¹ºÎïµ¯³öµÄ´°¿Ú£¬²Å¹Ø± 
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg2);	--??????
			g_CityData[2] = tonumber(arg3);	--??????
			g_CityData[3] = arg1;	--????

			if ( arg4 == "bind" ) then
				g_CurUint = g_CurUintType.Bind;
			else
				g_CurUint = g_CurUintType.YuanBao;
			end
			CancelLastOp(FrameInfoList.YUANBAO_BUY_ITEM);
			g_FrameInfo = FrameInfoList.YUANBAO_BUY_ITEM;
		end
	elseif event == "JIYUAN_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.JIYUAN_SHOP_CONFIRM and this:IsVisible())then
			--Èç¹ûÊÇ¹ØÓÚ¹ºÎïµ¯³öµÄ´°¿Ú£¬²Å¹Ø± 
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg1);	--itemid
			g_CityData[2] = tonumber(arg2);	--yuanbao
			g_CityData[3] = tonumber(arg3);	--targetid
			CancelLastOp(FrameInfoList.JIYUAN_SHOP_CONFIRM);
			g_FrameInfo = FrameInfoList.JIYUAN_SHOP_CONFIRM;
			local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_CityData[1])
			local szInfo = "Mua"..item_name.."C¥n tiêu phí"..tostring(g_CityData[2]).."Cá nguyên bäo, Nhî xác nh§n Ma?";
			MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
			MessageBox_Self_Text:SetText(szInfo);
			this:Show();
		end

	elseif event == "SHENGWANG_YB_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM and this:IsVisible())then
			--Èç¹ûÊÇ¹ØÓÚ¹ºÎïµ¯³öµÄ´°¿Ú£¬²Å¹Ø± 
				g_msgFrameVar = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_msgFrameVar = {};
			g_msgFrameVar[1] = tonumber(arg1);	--itemid
			g_msgFrameVar[2] = tonumber(arg2);	--yuanbao
			g_msgFrameVar[3] = tonumber(arg3);	--nCamp
			g_msgFrameVar[4] = tonumber(arg4);	--targetid
			CancelLastOp(FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM);
			g_FrameInfo = FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM;
			local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_msgFrameVar[1])
			local szInfo = "Mua"..item_name.."C¥n tiêu phí"..tostring(g_msgFrameVar[2]).."Cá nguyên bäo, Nhî xác nh§n Ma?";
			MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
			MessageBox_Self_Text:SetText(szInfo);
			this:Show();
		end

	elseif event == "FANLI_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.FANLI_SHOP_CONFIRM and this:IsVisible())then
			--Èç¹ûÊÇ¹ØÓÚ¹ºÎïµ¯³öµÄ´°¿Ú£¬²Å¹Ø± 
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg1);	--itemid
			g_CityData[2] = tonumber(arg2);	--yuanbao
			g_CityData[3] = tonumber(arg3);	--targetid
			CancelLastOp(FrameInfoList.FANLI_SHOP_CONFIRM);
			g_FrameInfo = FrameInfoList.FANLI_SHOP_CONFIRM;
			local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_CityData[1])
			local szInfo = "Mua"..item_name.."Nhu tiêu phí"..tostring(g_CityData[2]).."Nguyên bäo, Nhçm xác nh§n Ma?";
			MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
			MessageBox_Self_Text:SetText(szInfo);
			this:Show();
		end
	elseif event == "RONGYU_BUY_ITEM_CONFIRM" then

		g_CityData = {};
		g_CityData[1] = tonumber(arg1);	--??????
		g_CityData[2] = tonumber(arg2);	--??????
		g_CityData[3] = arg0;	--????


		CancelLastOp(FrameInfoList.RONGYU_BUY_ITEM);
		g_FrameInfo = FrameInfoList.RONGYU_BUY_ITEM;

	elseif( event == "PET_SYNC_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		CancelLastOp(FrameInfoList.PET_SYNC_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SYNC_CONFIRM;
	--¼ÄÊÛÉÌµê¹ºÂòÈ·ÈÏÏûÏ¢
	elseif event == "CONFIRM_COMMISION_BUY" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.COMMISION_BUY and this:IsVisible())then
			--Èç¹ûÊÇ¼ÄÊÛÉÌµêÈ·ÈÏ¿ò£¬²Å¹Ø± 
				CommisionBuyData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			CommisionBuyData = {};
			CommisionBuyData[1] = arg1;	--????
			CommisionBuyData[2] = arg2;	--??
			CancelLastOp(FrameInfoList.COMMISION_BUY);
			g_FrameInfo = FrameInfoList.COMMISION_BUY;
		end
	elseif event == "TIME_UPDATE" then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.STALL_RENT_FRAME ) then
			local xNow, yNow;
			xNow, yNow = Player:GetPos();

			local askPosX = Variable:GetVariable("AskBaiTanPosX");
			local askPosY = Variable:GetVariable("AskBaiTanPosY");

			if(tostring(xNow) ~= askPosX or tostring(yNow) ~= askPosY) then
				MessageBox_Self_Cancel_Clicked(1);
			end
		end

		return -1;
	end
	if g_FrameInfo == FrameInfoList.QUIT_GAME   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Nhçm xác ð¸nh phäi r¶i khöi Tân Thiên Long Bát Bµ trò ch½i thª gi¾i Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "RECYCLE_DEL_ITEM" ) then
		Recycle_Type = tonumber(arg0);
		Recycle_CurSelectItem = tonumber(arg1);
		CancelLastOp(FrameInfoList.RECYCLE_DEL_ITEM);
		g_FrameInfo = FrameInfoList.RECYCLE_DEL_ITEM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Nhçm xác ð¸nh mu¯n l¤y Tiêu l¥n này thu mua Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "OPEN_IS_SELL_TO_RECSHOP" ) then
		Recycle_Bag_idx = tonumber(arg0);
		Recycle_Shop_idx = tonumber(arg1);
		Recycle_Shop_Num =  tonumber(arg2);
		Recycle_Shop_AllPrice =  tonumber(arg3);
		CancelLastOp(FrameInfoList.OPEN_IS_SELL_TO_RECSHOP);
		g_FrameInfo = FrameInfoList.OPEN_IS_SELL_TO_RECSHOP;
		local name = PlayerShop:GetRecycleItem(Recycle_Shop_idx,3,"name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#WNHçm Yêu bán ra Ðích tài li®u Vi#G"..name.."#W, s lßþng Vi"..Recycle_Shop_Num.."#W, tHu hoÕch ti«n tài Vi#Y#{_MONEY"..Recycle_Shop_AllPrice.."}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	if ( event == "CONFIRM_STENGTH" ) then
		Stength_Equip_Idx = tonumber(arg0);
		Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_STENGTH);
		g_FrameInfo = FrameInfoList.CONFIRM_STENGTH;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		-- local msg = "Ç¿»¯Ê±½«ÓÅÏÈ¿Û³ýÎïÆ·À¸ÒÑ°ó¶¨µÄÇ¿»¯¾«»ª£¬Ç¿»¯ºóµÄ×°±¸Ò²½«ÓëÄú°ó¶¨£¬È·¶¨Òª¼ÌÐøÇ¿»¯Âð£¿#rÌáÊ¾£ºÈç¹û²»Ïë½«Ç¿»¯ºóµÄ×°±¸°ó¶¨£¬Çë½«±³°üÖÐÒÑ°ó¶¨µÄÇ¿»¯¾«»ª·ÅÈë²Ö¿âÔÙÀ´Ç¿»¯¡£";
		MessageBox_Self_Text:SetText("#{CLXZ_220623_7}");
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "EXCHANGE_BANGGONG" ) then
		BangGong_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --????????GetNPCIDByServerID?
		if ObjCaredID ~= -1 then
			--¿ªÊ¼¹ØÐÄNPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local extravalue = math.floor(BangGong_Value*0.1)
		CancelLastOp(FrameInfoList.EXCHANGE_BANGGONG);
		g_FrameInfo = FrameInfoList.EXCHANGE_BANGGONG;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BGCH_8922_28}"..BangGong_Value.."#{BGCH_8922_29}"..extravalue.."#{BGCH_8922_30}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "PUT_GUILDMONEY" ) then
		GuildMoney_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --????????GetNPCIDByServerID?
		if ObjCaredID ~= -1 then
		--¿ªÊ¼¹ØÐÄNPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local value = math.floor(GuildMoney_Value*0.9)
		CancelLastOp(FrameInfoList.PUT_GUILDMONEY);
		g_FrameInfo = FrameInfoList.PUT_GUILDMONEY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BPZJ_0801014_008}#{_EXCHG"..GuildMoney_Value.."}#{BPZJ_0801014_009}#{_EXCHG"..value.."}#{BPZJ_0801014_013}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "CONFIRM_RE_IDENTIFY" ) then
		RID_Equip_Idx = tonumber(arg0);
		--Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_RE_IDENTIFY);
		g_FrameInfo = FrameInfoList.CONFIRM_RE_IDENTIFY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "Mµt l¥n næa xem xét trang b¸ tß ch¤t Th¶i Tß¾ng ßu tiên kh¤u tr× v§t ph¦m Lan Trung Dî Bäng Ð¸nh Ðích Kim Cß½ng Sa Ho£c Kim Cß½ng Toä, mµt l¥n næa xem xét tß ch¤t H§u Ðích trang b¸ Dã Tß¾ng Dß Nhçm Bäng Ð¸nh, xác ð¸nh Yêu tiªp tøc xem xét Ma? #r#GnÊu lên: Nªu không nghî xem xét H§u Ðích trang b¸ Bäng Ð¸nh, Thïnh Tß¾ng tay nãi Trung Dî Bäng Ð¸nh Ðích Kim Cß½ng Sa Hoà Kim Cß½ng Toä ð¬ vào kho hàng lÕi ðªn xem xét. #W";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "KICK_MEMBER_MSGBOX" ) then
		Member_Idx = tonumber(arg0);
		Member_Name = arg1;
		CancelLastOp(FrameInfoList.KICK_MEMBER_MSGBOX);
		g_FrameInfo = FrameInfoList.KICK_MEMBER_MSGBOX;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#cfff263Nhî xác ð¸nh phäi ngß¶i ch½i#G"..Member_Name.."#cfff263khai tr× Xu¤t bang hµi Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	---È·¶¨¿ªÊ¼×Ô¶¯Ñ°Â·Ã´£¿
	if ( event == "AUTOMOVE_CONFIRM_NOPKVALUE" ) then
	    MessageBox_Self_Text:SetText( tostring(arg0) )
        MessageBox_Self_DragTitle:SetText("#gFF0FA0tñ ðµng tìm ðß¶ng");
		MessageBox_Self_UpdateRect();
		g_FrameInfo = FrameInfoList.AUTOMOVE_CONFIRM_NOPKVALUE
		this:Show();
	end

	---È·¶¨¿ªÊ¼×Ô¶¯Ñ°Â·Ã´£¿
	if( event == "AUTOMOVE_CONFIRM_UPPKVALUE") then
	    MessageBox_Self_Text:SetText( tostring(arg0) )
        MessageBox_Self_DragTitle:SetText("#gFF0FA0tñ ðµng tìm ðß¶ng");
		MessageBox_Self_UpdateRect();
		g_FrameInfo = FrameInfoList.AUTOMOVE_CONFIRM_UPPKVALUE
	end

	--2015ÇéÈË½ÚÅÅÐÐ°ñ¶Ò»»¶þ´ÎÈ·ÈÏ
	if ( event == "ROSERANK_EXCHANGE_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("");			-- ????
		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );
		MessageBox_Self_Text:SetText(g_msgFrameVar[3]);
		g_FrameInfo = FrameInfoList.ROSERANK_EXCHANGE_CONFIRM;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
	end

	--2015ÆßÏ¦ÇéÈË½ÚÅÅÐÐ°ñ¶Ò»»¶þ´ÎÈ·ÈÏ
	if ( event == "QIXIRANK_EXCHANGE_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("");			-- ????
		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );
		MessageBox_Self_Text:SetText(g_msgFrameVar[3]);
		g_FrameInfo = FrameInfoList.QIXIRANK_EXCHANGE_CONFIRM;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
	end

	--ÇéÈË½ÚÅÅÐÐ°ñ¶Ò»»¶þ´ÎÈ·ÈÏ
	if ( event == "QINGRENJIERANK_EXCHANGE_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("");			-- ????
		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );
		MessageBox_Self_Text:SetText(g_msgFrameVar[3]);
		g_FrameInfo = FrameInfoList.QINGRENJIERANK_EXCHANGE_CONFIRM;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
	end

	-- ¹²ÏíÊ±×°
	if event == "COUPLE_FASHION_ADD_CONFIRM" then
		MessageBox_Self_DragTitle:SetText("");

		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );

		local str = ScriptGlobal_Format("#{FQYG_20230410_15}", g_msgFrameVar[3])
		MessageBox_Self_Text:SetText( str )
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();

		CancelLastOp(FrameInfoList.COUPLE_FASHION_ADD_CONFIRM);
		g_FrameInfo = FrameInfoList.COUPLE_FASHION_ADD_CONFIRM

		MessageBox_Self_UpdateRect()
		this:Show()
	end

	if event == "COUPLE_FASHION_MOVE_CONFIRM" then
		MessageBox_Self_DragTitle:SetText("");

		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );

		local str = ScriptGlobal_Format("#{FQYG_20230410_20}", g_msgFrameVar[3])
		MessageBox_Self_Text:SetText( str )
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();

		CancelLastOp(FrameInfoList.COUPLE_FASHION_MOVE_CONFIRM);
		g_FrameInfo = FrameInfoList.COUPLE_FASHION_MOVE_CONFIRM

		MessageBox_Self_UpdateRect()
		this:Show()
	end

	if event == "COUPLE_VAULT_ADD_CONFIRM" then
		MessageBox_Self_DragTitle:SetText("");

		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );

		local str = ""

		if g_msgFrameVar[1] == 0 then
			str = ScriptGlobal_Format( "#{YYJG_20230407_73}", tostring(g_msgFrameVar[2]) )
		else
			str = ScriptGlobal_Format( "#{YYJG_20230407_61}", tostring(g_msgFrameVar[2]) )
		end

		MessageBox_Self_Text:SetText( str )
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();

		CancelLastOp(FrameInfoList.COUPLE_VAULT_ADD_CONFIRM);
		g_FrameInfo = FrameInfoList.COUPLE_VAULT_ADD_CONFIRM

		MessageBox_Self_UpdateRect()
		this:Show()
	end

	if event == "COUPLE_VAULT_OUT_CONFIRM" then
		MessageBox_Self_DragTitle:SetText("");

		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );

		local str = ""

		if g_msgFrameVar[1] == 0 then
			str = ScriptGlobal_Format( "#{YYJG_20230407_74}", tostring(g_msgFrameVar[2]) )
		else
			str = ScriptGlobal_Format( "#{YYJG_20230407_68}", tostring(g_msgFrameVar[2]) )
		end

		MessageBox_Self_Text:SetText( str )
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();

		CancelLastOp(FrameInfoList.COUPLE_VAULT_OUT_CONFIRM);
		g_FrameInfo = FrameInfoList.COUPLE_VAULT_OUT_CONFIRM

		MessageBox_Self_UpdateRect()
		this:Show()
	end
	if event == "CONFIRM_BWZQ_SELECTLOVE" then
		MessageBox_Self_DragTitle:SetText("");
		g_msgFrameVar[1] = tonumber( arg0 );
		MessageBox_Self_Text:SetText( "#{BWZQ_20230329_148}" )
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();

		CancelLastOp(FrameInfoList.WHQ_CONFIRM_BWZQ_SELECTLOVE);
		g_FrameInfo = FrameInfoList.WHQ_CONFIRM_BWZQ_SELECTLOVE

		MessageBox_Self_UpdateRect()
		this:Show()
	end
	if (event == "DOUBLEGAME_GAMEDESC") then
		MessageBox_Self_DragTitle:SetText("")
		local gameType = tonumber(arg0)
		local msg = ""
		if (gameType == 1) then
			-- Ñ° ÒÓÎÏ·
			msg = "#{SRWF_230329_33}"
		elseif (gameType == 2) then
			-- ËãÊõÓÎÏ·
			msg = "#{SRWF_230329_32}"
		elseif (gameType == 3) then
			-- ¶ã±ÜÓÎÏ·
			msg = "#{SRWF_230329_34}"
		end

		MessageBox_Self_Text:SetText(msg)
		MessageBox_Self_OK_Button:Show()
		MessageBox_Self_Cancel_Button:Show()

		CancelLastOp(FrameInfoList.DOUBLEGAME_DESC)
		g_FrameInfo = FrameInfoList.DOUBLEGAME_DESC

		MessageBox_Self_UpdateRect()
		this:Show()
	end

	return 1;
end

--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEvent(event)
	if ( event == "PLAYER_LEAVE_WORLD" ) then
		return
	end

	-- Ä¬ÈÏÒþ²Ø°´Å¥
	if  MessageBox_Self_CheckClient:IsVisible() then
		MessageBox_Self_CheckClient:Show()
		MessageBox_Self_CheckBtn:Show()
		MessageBox_Self_CheckText:Show()
	else
		MessageBox_Self_CheckClient:Hide()
		MessageBox_Self_CheckBtn:Hide()
		MessageBox_Self_CheckText:Hide()
	end


	if event == "GEM_COMBINED_CONFIRM" then

		GemCombinedData[1] = tonumber( arg0 )
		GemCombinedData[2] = tonumber( arg1 )
		GemCombinedData[3] = tonumber( arg2 )
		GemCombinedData[4] = tonumber( arg3 )
		GemCombinedData[5] = tonumber( arg4 )
		GemCombinedData[6] = tonumber( arg5 )
		GemCombinedData[7] = arg6
		CancelLastOp(FrameInfoList.GEM_COMBINED_CONFIRM);
		g_FrameInfo = FrameInfoList.GEM_COMBINED_CONFIRM
		MessageBox_Self_UpdateFrame()
		return
	end

	if event == "EXCHANGE_MONEY_OVERFLOW" then
		MessageBox_Self_Text:SetText( "#YNHçm Ðích Ti«n ðã t¾i hÕn mÑc cao nh¤t, Thïnh mau chóng xØ lý, lúc này trong lúc không c¥n T¯#Rlogout ho£c là d¶i ði trß¶ng cänh Ðích thao tác, #Ynªu không Hµi khiªn cho vßþt qua hÕn mÑc cao nh¤t Ðích ti«n tài biªn m¤t." );

		MessageBox_Self_UpdateRect();
		CancelLastOp(FrameInfoList.EXCHANGE_MONEY_OVERFLOW);
		g_FrameInfo = FrameInfoList.EXCHANGE_MONEY_OVERFLOW

		this:Show();
	end

	if (event == "PETSOUL_RANSE_CLOSE") then
		this:Hide();
		return
	end

	if event == "GUILD_DEMIS_CONFIRM" then
		local TargetName = tostring( arg0 );
		local bType = tonumber(arg1);
		if bType == 0 then
			PushDebugMessage("#{BHCR_090727_01}")
			this:Hide();
			return
		elseif bType == 1 then
			MessageBox_Self_Text:SetText( "#{BHCR_090713_09}"..TargetName.."#{BHCR_090713_10}" );
		elseif bType == 2 then
			MessageBox_Self_Text:SetText( "Nhî xác ð¸nh phäi bang chü Ðích chÑc v¸ nhß¶ng ngôi C¤p"..TargetName.."Ma? Thi«n H§u cüa ngß½i chÑc v¸ Tß¾ng Vi Phó bang chü." );
		end
		MessageBox_Self_UpdateRect();
		CancelLastOp(FrameInfoList.GUILD_DEMIS_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DEMIS_CONFIRM
		this:Show();
	end

	if event == "ENCHASE_CONFIRM" then
		MessageBox_Self_Text:SetText( "Không có ð£c thù tài li®u Hµi làm cho ðßþc khäm th¤t bÕi lúc sau bäo thÕch biªn m¤t. Nhçm xác ð¸nh Yêu tiªp tøc ðßþc khäm Ma?" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_CONFIRM
		this:Show();
	end

	if ( event == "SET_GUILD_FIRSTMAN_NAME" ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0#{BHCR_xml_XX(01)}");													-- ????
		local szMsg = Guild:GetMyGuildInfo("FirstManName");
		if szMsg ~= "" then
			MessageBox_Self_Text:SetText( "#{BHCR_090713_08}"..szMsg);	-- ????
		else
			MessageBox_Self_Text:SetText( "#{BHCR_090713_07}");
		end
		--MessageBox_Self_Text:SetText(szMsg);
		MessageBox_Self_UpdateRect();																-- ???????????
		CancelLastOp(FrameInfoList.SET_GUILD_FIRSTMAN_NAME);
		g_FrameInfo = FrameInfoList.SET_GUILD_FIRSTMAN_NAME;
		this:Show();
		--g_currentIndex = tonumber( arg0 );
		return;
	end

	if event == "ENCHASE_FOUR_CONFIRM" then  -- add:lby20080527??4??
		MessageBox_Self_Text:SetText( "Không có ð£c thù tài li®u Hµi làm cho ðßþc khäm th¤t bÕi lúc sau bäo thÕch biªn m¤t. Nhçm xác ð¸nh Yêu tiªp tøc ðßþc khäm Ma?" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_FOUR_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_FOUR_CONFIRM
		this:Show();
	end

	-- ´ò¿ª äÊÞ¼¼ÄÜÑ§Ï°µÄ¶þ´ÎÈ·ÈÏ½çÃæ
	if event == "OPEN_PETSKILLSTUDY_MSGBOX" then
		MessageBox_Self_Text:SetText( "Cüa ngß½i Trân Thú s¡p nh§n ðßþc hai cái Thü Ðµng kÛ nång, này thao tác c¥n tiêu phí#{_EXCHG990000}, Nhî xác ð¸nh Ma?" );
		CancelLastOp(FrameInfoList.PET_SKILL_STUDY_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SKILL_STUDY_CONFIRM
		this:Show();
	end

	-- ¹Ø±  äÊÞ¼¼ÄÜÑ§Ï°µÄ¶þ´ÎÈ·ÈÏ½çÃæ
	if(event == "CLOSE_PETSKILLSTUDY_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

--	if event == "CARVE_CONFIRM" then
--		MessageBox_Self_Text:SetText( "×¢Òâ£¡#ÄúÒªµñ×ÁµÄ±¦Ê¯»òµñ×Á·ûÎªÒÑ°ó¶¨ÎïÆ·£¬µñ×ÁºóµÄ±¦Ê¯Ò²½«ÓëÄú°ó¶¨£¬È·ÈÏÒª¼ÌÐøµñ×ÁµÄ»°ÇëÔÙ´Îµã»÷µñ×Á°´Å¥¡£" );
--		CarveData[1] = tostring( arg0 )
--		CarveData[2] = tonumber( arg1 )
--		CarveData[3] = tonumber( arg2 )
--		CarveData[4] = tonumber( arg3 )
--		CarveData[5] = tonumber( arg4 )
--		CancelLastOp(FrameInfoList.CARVE_CONFIRM);
--		g_FrameInfo = FrameInfoList.CARVE_CONFIRM
--		this:Show();
--	end

	if(event == "OPEN_STALL_RENT_FRAME") then
		CancelLastOp(FrameInfoList.STALL_RENT_FRAME);
		--¼ÇÂ¼µ±Ç°Î»ÖÃ
		local xPos, yPos;
		xPos, yPos = Player:GetPos();
		Variable:SetVariable("AskBaiTanPosX", tostring(xPos), 1);
		Variable:SetVariable("AskBaiTanPosY", tostring(yPos), 1);

		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.STALL_RENT_FRAME;


	elseif ( event == "MSGBOX_MAKESUREPVPCHALLENGE" ) then
	    local TargetName = tostring( arg0 )
	    --AxTrace(0,0,"MSGBOX_MAKESUREPVPCHALLENGE");
		CancelLastOp(FrameInfoList.MAKESUREPVPCHALLENGE);
		g_FrameInfo = FrameInfoList.MAKESUREPVPCHALLENGE;
		local sceneLogicID = GetSceneID()
		if sceneLogicID == 602 or sceneLogicID == 603 or sceneLogicID == 604 or sceneLogicID == 605 then
			local str  = ScriptGlobal_Format("#{MJXZ_210510_232}", TargetName)
			MessageBox_Self_Text:SetText( str );
		else
			MessageBox_Self_Text:SetText( "Nhçm xác nh§n Hß¾ng"..TargetName.."Ðßa ra tuyên chiªn Ma? Giªt chªt ð¯i phß½ng lúc sau Hµi gia tång Nhçm Ðích sát khí Tr¸, sát khí Cao Li­u nhân v§t tØ vong tình hình ð£c bi®t lúc ¤y làm cho thêm vào t±n th¤t" );
		end
		MessageBox_Self_UpdateRect();
		this:Show();

	elseif ( event == "MENU_SHOWACCEPTCHANGEPVP" ) then
		local Mode = tonumber( arg0 )
		local ModeText = ""
		if( 1 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORALL);
		    --AxTrace(0,0,FrameInfoList.FREEFORALL);
		    g_FrameInfo = FrameInfoList.FREEFORALL;
		    ModeText = "ThØ hình thÑc HÕ s¨ công kích Tr× chính mình · ngoài Ðích t¤t cä ngß¶i ch½i, Thïnh xác nh§n m· ra"
		end
		if( 2 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORTEAM);
		    --AxTrace(0,0,FrameInfoList.FREEFORTEAM);
		    g_FrameInfo = FrameInfoList.FREEFORTEAM;
		    ModeText = "ThØ hình thÑc HÕ s¨ công kích Tr× Ðµi Hæu · ngoài Ðích t¤t cä ngß¶i ch½i, Thïnh xác nh§n m· ra"
		end
		if( 3 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORGUILD)
		    --AxTrace(0,0,FrameInfoList.FREEFORGUILD);
		    g_FrameInfo = FrameInfoList.FREEFORGUILD;
		    ModeText = "#{TM_20080311_18}"
		elseif 4 == Mode then
			CancelLastOp(FrameInfoList.MISSION_XIULIAN_CONFIRM)
		    g_FrameInfo = FrameInfoList.MISSION_XIULIAN_CONFIRM
			MessageBox_Self_Text:SetText( arg1 )
			if arg1 == "#{WDZD_221208_05}" then
				g_msgFrameVar[1] = 15
			elseif arg1 == "#{WDZD_221208_06}" then
				g_msgFrameVar[1] = 16
		end
		if( 6 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORRAID)
		   g_FrameInfo = FrameInfoList.FREEFORRAID;
		   ModeText = "#{TDGZ_100809_70}"
		end
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		end
		if( (Mode >= 1 and Mode <= 3) or 6 == Mode ) then
		    MessageBox_Self_Text:SetText( ModeText );
			MessageBox_Self_UpdateRect();
		    this:Show();
		end

	elseif ( event == "MSGBOX_ACCEPTDUEL" ) then
	    local Name = tostring( arg0 )
	    local GUID = tostring( arg1 )
	    PVPFLAG.DuelName = Name
	    PVPFLAG.DuelGUID = GUID
	    g_FrameInfo = PVPFLAG.ACCEPTDUEL;
	    local MsgText = Name.."Hß¾ng Nhçm ðßa ra quyªt ð¤u, Nhçm có ð°ng ý hay không? Chú ý: TÕi quyªt ð¤u Trung tØ vong s¨ Hæu tr×ng phÕt."
	    MessageBox_Self_Text:SetText( MsgText )
		MessageBox_Self_UpdateRect();
	    this:Show();

	elseif(event == "OPEN_DISCARD_ITEM_FRAME") then
		argDISCARD_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.DISCARD_ITEM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.DISCARD_ITEM_FRAME;

	elseif(event == "OPEN_CANNT_DISCARD_ITEM") then
		argCANNT_DISCARD_ITEM0 = arg0
		CancelLastOp(FrameInfoList.CANNT_DISCARD_ITEM);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.CANNT_DISCARD_ITEM;

	elseif(event == "LOCK_ITEM_CONFIRM") then
		argLOCK_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.LOCK_ITEM_CONFIRM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.LOCK_ITEM_CONFIRM_FRAME;

	elseif(event == "AFFIRM_SHOW") then
		this:Show();
		g_InitiativeClose = 0;
		Quest_Number = tonumber(arg2);
		argFRAME_AFFIRM_SHOW0 = arg0;
		CancelLastOp(FrameInfoList.FRAME_AFFIRM_SHOW);
		g_FrameInfo = FrameInfoList.FRAME_AFFIRM_SHOW;


	-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
	elseif ( event == "GUILD_CREATE_CONFIRM" ) then
		argCREATE_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_CREATE_CONFIRM;
		MessageBox_Self_Text:SetText("Là mu¯n sáng tÕo" .. argCREATE_CONFIRM0 .. "Ma?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- °ï»áÉ¾³ýÐèÍæ¼ÒÈ·ÈÏ
	elseif ( event == "GUILD_DESTORY_CONFIRM" ) then
		argDESTORY_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_DESTORY_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DESTORY_CONFIRM;
		MessageBox_Self_Text:SetText("Là mu¯n xóa bö" .. argDESTORY_CONFIRM0 .. "Ma?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- °ï»áÍË³öÐèÍæ¼ÒÈ·ÈÏ
	elseif ( event == "GUILD_QUIT_CONFIRM" ) then
		argQUIT_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_QUIT_CONFIRM;
		MessageBox_Self_Text:SetText("Là mu¯n r¶i khöi" .. argQUIT_CONFIRM0 .. "Ma?");
		MessageBox_Self_UpdateRect();
		this:Show();

	--°ï»áÍ¬ÃËÍË³öÈ·ÈÏ
	elseif event == "GUILD_LEAGUE_QUIT_CONFIRM" then
		argQUIT_LEAGUE_CONFIRM0 = arg0;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM
		MessageBox_Self_Text:SetText( "Nhî xác ð¸nh Yêu r¶i khöi"..argQUIT_LEAGUE_CONFIRM0.."Ð°ng minh Ma?" );
		MessageBox_Self_UpdateRect();
		this:Show();

	--°ï»áÍ¬ÃË´´½¨È·ÈÏ
	elseif event == "GUILD_LEAGUE_CREATE_CONFIRM" then
		argCREATE_LEAGUE_CONFIRM0 = arg0;
		argCREATE_LEAGUE_CONFIRM1 = arg1;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM
		MessageBox_Self_Text:SetText( "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}" );
		MessageBox_Self_UpdateRect();
		this:Show();


	-- ·þÎñÆ÷¶ÏÁË
	elseif ( event == "NET_CLOSE" ) then
		argNET_CLOSE0 = arg0
		CancelLastOp(FrameInfoList.NET_CLOSE_MESSAGE);
		g_FrameInfo = FrameInfoList.NET_CLOSE_MESSAGE;
		g_LastEvent = event
		this:Show();

	elseif ( event == "PET_FREE_CONFIRM") then
		Pet_Number = tonumber(arg0);
		CancelLastOp(FrameInfoList.PET_FREE_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_FREE_CONFIRM;
		this:Show();
	elseif ( event == "OPEN_PS_MESSAGE_FRAME" )  then


		AxTrace(0,0,"arg0 = " .. arg0);


		if( arg0 == "name" )    then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_RENAME_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_RENAME_MESSAGE;

		elseif( arg0 == "ad" )  then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_READ_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_READ_MESSAGE;

		elseif( arg0 == "immitbase" )		then -- ??
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_BASE_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_BASE_MONEY;

		elseif( arg0 == "immit" )				then -- ?????
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_GAIN_MONEY;

		elseif( arg0 == "draw" )				then -- ?????
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_DEC_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_DEC_GAIN_MONEY;

		elseif( arg0 == "add_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_ADD_STALL);
			g_FrameInfo = FrameInfoList.PS_ADD_STALL;


		elseif( arg0 == "del_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_DEL_STALL);
			g_FrameInfo = FrameInfoList.PS_DEL_STALL;


		elseif( arg0 == "sale" )     	then 	-- ??
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU;
		elseif( arg0 == "saleYB" )     	then 	-- ????
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU_YB);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU_YB;


		elseif( arg0 == "back" )     	then	-- ????
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANRU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANRU;

		elseif( arg0 == "ps_type" )		then	-- ?????????????
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_MODIFY_TYPE);
			g_FrameInfo = FrameInfoList.PS_INFO_MODIFY_TYPE;
		elseif (arg0 == "ps_buy") then
			g_FrameInfo = FrameInfoList.BUY_PLAYERSHOP_SECOND_CONFIRM
			local bSaleType = tonumber(arg1)
			local nSaleOutMoney = tonumber(arg2)
			local szName = tostring(arg3)
			local shopIndex = tonumber(arg4)
			local str1 = ""
			if bSaleType == 0 then
				local gold = math.floor(nSaleOutMoney / 10000)
				local copper = math.mod(nSaleOutMoney, 100)
				local silver = math.mod(math.floor(nSaleOutMoney/100), 100)
				str1 = ScriptGlobal_Format("#{RCYH_180606_120}", gold, silver, copper, szName, shopIndex)
			elseif bSaleType == 1 then
				str1 = ScriptGlobal_Format("#{RCYH_180606_119}",nSaleOutMoney, szName, shopIndex)
			end
			MessageBox_Self_DragTitle:SetText("");
			MessageBox_Self_Text:SetText(str1)
			MessageBox_Self_UpdateRect()
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
		end
	elseif ( event == "UI_COMMAND" ) then
		--AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == FrameInfoList.SERVER_CONTROL then
				CancelLastOp(FrameInfoList.SERVER_CONTROL);
				g_FrameInfo = FrameInfoList.SERVER_CONTROL;
				if ( Get_XParam_INT_Count() > 1 ) then  --TT65894
					-- zchw fix Transfer bug
					local xx = Get_XParam_INT(1);
					ObjCaredID = DataPool : GetNPCIDByServerID(xx);
					if ObjCaredID ~= -1 then
						--¿ªÊ¼¹ØÐÄNPC
						this:CareObject(ObjCaredID, 1, "MsgBox");
					end
				end

				--¿ç³¡¾°Ñ°Â·ÒÑ¾­´¦Àí¹ýµ¯´°ÁË
				if (Get_XParam_INT(0) == 400999 and IsAcrossSceneMoveto() == 1) then
						Clear_XSCRIPT();
							Set_XSCRIPT_Function_Name(Get_XParam_STR(0));
							Set_XSCRIPT_ScriptID(Get_XParam_INT(0));
							Set_XSCRIPT_Parameter(0,Get_XParam_INT(1));
							Set_XSCRIPT_Parameter(1,Get_XParam_INT(2));
							Set_XSCRIPT_ParamCount(2);
						Send_XSCRIPT();
					return
				end
		-- °ï»á½âÉ¢È·ÈÏ
		elseif(tonumber(arg0) == 20250829) then
			g_newName = Get_XParam_STR(0)
			CancelLastOp(FrameInfoList.DISCARD_GUILD);
			g_FrameInfo = FrameInfoList.DISCARD_GUILD
			MessageBox_Self_Text:SetText( "Nhî xác ð¸nh Yêu giäi tán"..tostring(g_newName).."Bang hµi Ma?" );		
			MessageBox_Self_UpdateRect();	
			this:Show();
			return
		elseif tonumber(arg0) == 8092720 then --???????
			MessageBox_Self_OnConfirmChaiJieDW()
			return
		elseif (tonumber(arg0) == 300039 ) then   --??UI_COMMAND
			CancelLastOp(FrameInfoList.SERVER_CONTROL);
			g_FrameInfo = FrameInfoList.SERVER_CONTROL;
		elseif tonumber(arg0) == 332207 then
			g_FrameInfo = FrameInfoList.DART_ADJUST
			Dart_Data = {}
			Dart_Data[1] = Get_XParam_INT(0)
			Dart_Data[2] = Get_XParam_INT(1)
			MessageBox_Self_ShowDart()
			return
		elseif (tonumber(arg0) == 805047 ) then
			Guild:AskGuildFirstManName();
			this:Hide();
			return;
		elseif (tonumber(arg0) == 805048 ) then
			local myPos = Guild:GetMyPosition();
			if POS_GUILD_CHIEF ~= myPos	then
				PushDebugMessage("#{BHCR_090713_06}") --????????????
				this:Hide();
				return
			else
				argGUILD_DIS_FIRSTMAN0 = arg0
				CancelLastOp(FrameInfoList.GUILD_DIS_FIRSTMAN);
				g_FrameInfo = FrameInfoList.GUILD_DIS_FIRSTMAN;
				MessageBox_Self_Text:SetText("Nhî xác ð¸nh Yêu huÖ bö thÑ nh¤t ngß¶i th×a kª Ma?");
				MessageBox_Self_UpdateRect();
				this:Show()
			end
		elseif (tonumber(arg0) == 335815 ) then
			CancelLastOp(FrameInfoList.GONGLIDAN_USE_CONFIRM);
			g_FrameInfo = FrameInfoList.GONGLIDAN_USE_CONFIRM;
			local nPower =  Player:GetData("POWER");
			local txt = "#{XLGLZHF_20091021_04}" .. nPower .. "/100".. "#{XLGLZHF_20091021_05}";
			MessageBox_Self_Text:SetText(txt);
			MessageBox_Self_DragTitle:SetText("#{QNG_XML_10}");
			MessageBox_Self_UpdateRect();
			this:Show();
			return;
        elseif (tonumber(arg0) == 809270 ) then--??????
			g_FrameInfo = FrameInfoList.KFS_RESET_GROWRATE
			KFS_Data = {}
			KFS_Data[1] = Get_XParam_INT(0)
			KFS_Data[2] = Get_XParam_INT(1)
			if KFS_Data[1] == 1 then
				MessageBox_Self_Text:SetText( "#{WHXCZL_091026_09}" );--????
			elseif KFS_Data[1] == 2 then
				MessageBox_Self_Text:SetText( "#{WHXCZL_091026_10}" );--????
			end
			MessageBox_Self_DragTitle:SetText("");
			MessageBox_Self_UpdateRect();

			this:Show();
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show();
			return
		elseif (tonumber(arg0) == 20150309) then
			CancelLastOp(FrameInfoList.MESSAGE_AND_QUIT);
			g_FrameInfo = FrameInfoList.MESSAGE_AND_QUIT;

			local nKckType = Get_XParam_INT(0)
			if (1 == nKckType) then		-- ???1.5???
				MessageBox_Self_Text:SetText("#{CMXT_191210_05}")
			elseif (2 == nKckType) then		-- ????10??
				MessageBox_Self_Text:SetText("#{CMXT_191210_11}")
			elseif (3 == nKckType) then	--GM???????
				MessageBox_Self_Text:SetText("#{YCTS_20200721_01}")
			elseif (4 == nKckType) then	--CTU???????
				MessageBox_Self_Text:SetText("#{CTU_20200916_01}")
			end

			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Hide()
			MessageBox_Self_UpdateRect()
			this:Show();
			return
		elseif tonumber(arg0) == 5426 then
			g_FrameInfo = FrameInfoList.CHANGE_NAME_RETOK;
			g_newName = Get_XParam_STR(0)
			MessageBox_Self_UpdateFrame()
			return
		elseif tonumber(arg0) == 99826501 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_FrameInfo = FrameInfoList.MAAN_EX_CONFIRM
			g_msgFrameVar[1] = Get_XParam_INT(0)
			local ObjCaredID = DataPool : GetNPCIDByServerID(g_msgFrameVar[1]);
			if ObjCaredID ~= -1 then
				--¿ªÊ¼¹ØÐÄNPC
				this:CareObject(ObjCaredID, 1, "MsgBox");
			end
			MessageBox_Self_Text:SetText("#{HJMAYH_230228_9}")
			MessageBox_Self_DragTitle:SetText("#{HJMAYH_230228_8}")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
			return
		elseif tonumber(arg0) == FrameInfoList.SERVER_CONTROL_EXT then
			CancelLastOp(FrameInfoList.SERVER_CONTROL_EXT);
			g_FrameInfo = FrameInfoList.SERVER_CONTROL_EXT;
			--Èç¹ûÓÐµÚ¶þ¸ö ûÐÎ²ÎÊý£¬±íÃ÷ÓÐÐèÒª¹ØÐÄµÄNPC
			if  Get_XParam_INT_Count() > 1  then
				local npcId = Get_XParam_INT(1);
				local ObjCaredID = DataPool : GetNPCIDByServerID(npcId);
				if ObjCaredID ~= -1 then
					this:CareObject(ObjCaredID, 1, "MsgBox");
				end
			end
		elseif (tonumber(arg0) == 89022301) then
			CancelLastOp(FrameInfoList.YJFS_LEAVE_CONFIRM);
			g_FrameInfo = FrameInfoList.YJFS_LEAVE_CONFIRM;
			local tabletype = Get_XParam_INT(0)
			local curcount = Get_XParam_INT(1)
			local str = "#{YJFS_20221227_130}"
			if curcount > 0 then
				str = ScriptGlobal_Format( "#{YJFS_20221227_43}", curcount)
			end
			MessageBox_Self_Text:SetText(str)
			MessageBox_Self_DragTitle:SetText("");
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return
		elseif (tonumber(arg0) == 89022302 ) then
			if(this:IsVisible() and g_FrameInfo == FrameInfoList.YJFS_LEAVE_CONFIRM)then
				this:Hide();
			end
			return;
		elseif (tonumber(arg0) == 89266601) then
			CancelLastOp(FrameInfoList.MESSAGE_MONTH_CARD);
			g_FrameInfo = FrameInfoList.MESSAGE_MONTH_CARD;
			MessageBox_Self_Text:SetText("#{HJYK_201223_05}")
			MessageBox_Self_DragTitle:SetText("#{HJYK_201223_47}");
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return
		elseif (tonumber(arg0) == 89266699) then
			CancelLastOp(FrameInfoList.MESSAGE_MONTH_CARD2);
			g_FrameInfo = FrameInfoList.MESSAGE_MONTH_CARD2;
			MessageBox_Self_Text:SetText("#{HJYK_201223_05}")
			MessageBox_Self_DragTitle:SetText("#{HJYK_201223_47}");
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return
		elseif (tonumber(arg0) == 80811033) then
			CancelLastOp(FrameInfoList.HEROS_RETURNS_CONFIRM);
			g_FrameInfo = FrameInfoList.HEROS_RETURNS_CONFIRM;
			local strMsg = Get_XParam_STR(0)
			g_MessageBoxSelf_Data[1] = Get_XParam_INT(0);
			MessageBox_Self_Text:SetText( strMsg )
			MessageBox_Self_DragTitle:SetText("#gFF0FA0");
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return
		elseif (tonumber(arg0) == 807012 ) then--??
			g_FrameInfo = FrameInfoList.CONFIRM_IMMIGRATION;
			ImmigArg0 = Get_XParam_INT(0)
			ImmigArg1 = Get_XParam_INT(1)
			ImmigArg2 = Get_XParam_INT(2)
			local targetName = Get_XParam_STR(0);
			local targetServerName = Get_XParam_STR(1)	;
			local msg =ScriptGlobal_Format( "#{FWQYM_160531_240}", targetName,targetServerName)
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_DragTitle:SetText("Vþ ch°ng di dân");
			MessageBox_Self_UpdateRect();
		elseif (tonumber(arg0) == 20160601 ) then--????

			g_FrameInfo = FrameInfoList.CONFIRM_CANCEL_IMMIGRATION;
			ImmigArg0  = Get_XParam_INT(0)
			ImmigArg1  = Get_XParam_INT(1)
			ImmigArg2  = Get_XParam_INT(2)
			local targetName = Get_XParam_STR(0)
			local targetServerName = Get_XParam_STR(1)
			local msg =ScriptGlobal_Format( "#{FWQYM_160601_252}", targetName,targetServerName)
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_DragTitle:SetText("Vþ ch°ng di dân");
			MessageBox_Self_UpdateRect();

		elseif (tonumber(arg0) == 892663) then-- ??-??????-???????
			CancelLastOp(FrameInfoList.HEXINCHUN_YBCONFIRM);
			g_FrameInfo = FrameInfoList.HEXINCHUN_YBCONFIRM;
			g_HeXinChun_Data = Get_XParam_INT(0);
			local strMsg = Get_XParam_STR(0)
			MessageBox_Self_DragTitle:SetText("#{CJYJ_201222_03}");
			MessageBox_Self_Text:SetText( strMsg )
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return

		--ÖÜÄêÎÈ»îÔÂ¿ªÑçÏ¯-2021Äê-by yuanpeilong
		elseif (tonumber(arg0) == 891176) then
			CancelLastOp(FrameInfoList.CONFIRM_KAIYANXI_DUIHUAN);
			g_FrameInfo = FrameInfoList.CONFIRM_KAIYANXI_DUIHUAN;
			g_KaiYanXiDuiHuan_Data = Get_XParam_INT(1);
			local need_daibi = Get_XParam_INT(0)
			local strMsg = Get_XParam_STR(0)
			MessageBox_Self_DragTitle:SetText("#{KYX_20210715_04}");
			MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{KYX_20210715_61}",need_daibi,strMsg) )
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return

		--//2022ÊÞ»ê°æ±¾Ô¤ÈÈ-ypl
		elseif (tonumber(arg0) == 893108) then
			CancelLastOp(FrameInfoList.CONFIRM_2022_PETYURE);
			g_FrameInfo = FrameInfoList.CONFIRM_2022_PETYURE;
			g_2022PetYuRe_Data = Get_XParam_INT(0);
			MessageBox_Self_DragTitle:SetText("");
			MessageBox_Self_Text:SetText( "#{YRJDE_20220309_41}" )
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return

		elseif tonumber(arg0) == 5020192 then
			CancelLastOp(-1)

			MessageBox_Self_Text:SetText("#{XSLDZ_180424_10}")
			MessageBox_Self_UpdateRect()
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			g_FrameInfo = FrameInfoList.SONGLIAOWAR_REST_EXIT_CONFIRM
		elseif tonumber(arg0) == 88880005 then
			g_FrameInfo = FrameInfoList.WHWG_ACTIVE_CONFIRM
			Dart_Data = {}
			Dart_Data[1] = Get_XParam_INT(0)
			MessageBox_Self_WHWG_Active_Confirm()
			return
		elseif tonumber(arg0) == 88881805 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0)
			MessageBox_Self_BuyFashionCloth_Confirm()
			return
		elseif tonumber(arg0) == 99980101 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --itemid
			g_msgFrameVar[3] = Get_XParam_INT(2) --ExteriorID
			g_msgFrameVar[4] = Get_XParam_INT(3) --oriTime
			g_msgFrameVar[5] = Get_XParam_INT(4) --addTime
			MessageBox_Self_ExteriorRide_Confirm(0)
		elseif tonumber(arg0) == 99990101 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --itemid
			g_msgFrameVar[3] = Get_XParam_INT(2) --ExteriorID
			g_msgFrameVar[4] = Get_XParam_INT(3) --oriTime
			g_msgFrameVar[5] = Get_XParam_INT(4) --addTime
			MessageBox_Self_ExteriorRide_Confirm(1)
		elseif tonumber(arg0) == 99990501 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --itemid
			MessageBox_Self_RideCard_Confirm()
		elseif tonumber(arg0) == 80012713 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --targetId
			g_msgFrameVar[2] = Get_XParam_INT(1) --BagIndex
			g_msgFrameVar[3] = Get_XParam_INT(2) --
			MessageBox_Self_PetSoulAddlife_Confirm()
		elseif tonumber(arg0) == 80012716 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --
			g_msgFrameVar[3] = Get_XParam_INT(2) --
			g_msgFrameVar[4] = Get_XParam_INT(3) --
			MessageBox_Self_PetPetSoulSmash_ConfirmLevel()
		elseif tonumber(arg0) == 80012726 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --
			g_msgFrameVar[3] = Get_XParam_INT(2) --
			g_msgFrameVar[4] = Get_XParam_INT(3) --
			MessageBox_Self_PetPetSoulSmash_ConfirmQual()
		elseif tonumber(arg0) == 80012717 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --
			g_msgFrameVar[3] = Get_XParam_INT(2) --
			g_msgFrameVar[4] = Get_XParam_INT(3) --
			MessageBox_Self_PetPetSoulLevelDown_Confirm()
		elseif tonumber(arg0) == 89008601 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --
			g_msgFrameVar[3] = Get_XParam_INT(2) --
			g_msgFrameVar[4] = Get_XParam_INT(3) --
			g_msgFrameVar[5] = Get_XParam_INT(4) --
			MessageBox_Self_ShengWangSaoDang_Confirm()
		elseif tonumber(arg0) == 20211201 then
			MessageBox_Self_DragTitle:SetText("#{CJDB_211122_18}");			-- ????
			local index = Get_XParam_INT(0);
			local targetId = Get_XParam_INT(1);
			iteminfo = DataPool:TBSearch_Index_EQU("DBC_FESTIVAL_SHOP_ITEM",index+1)

			g_msgFrameVar[1] = tonumber(index+1)
			g_msgFrameVar[2] = tonumber(targetId)

			local nID = DataPool : GetNPCIDByServerID( targetId )
			this:CareObject(nID, 1, "MsgBox");

			MessageBox_Self_Text:SetText(ScriptGlobal_Format("#{CJDB_211122_19}",
				DataPool:LuaFnGetItemNameByTableIndex(iteminfo.nItemID),iteminfo.nPrice));
			CancelLastOp(FrameInfoList.CONFIRM_FESTIVAL_SHOP);
			g_FrameInfo = FrameInfoList.CONFIRM_FESTIVAL_SHOP
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect();
			this:Show();
			return
		elseif tonumber(arg0) == 89000601 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --itemid
			g_msgFrameVar[3] = Get_XParam_INT(2) --emoid
			g_msgFrameVar[4] = Get_XParam_INT(3) --isHave
			g_msgFrameVar[5] = Get_XParam_INT(4) --lefttime
			g_msgFrameVar[6] = Get_XParam_INT(5) --addHour
			
			MessageBox_Self_UseEmo_Confirm()
			
			return
		elseif tonumber(arg0) == 99990302 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --PossID
			MessageBox_Self_UnlockExteriorPoss_Confirm()
		elseif tonumber(arg0) == 99990401 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --BagIndex
			g_msgFrameVar[2] = Get_XParam_INT(1) --itemid
			g_msgFrameVar[3] = Get_XParam_INT(2) --ExteriorID
			g_msgFrameVar[4] = Get_XParam_INT(3) --oriTime
			g_msgFrameVar[5] = Get_XParam_INT(4) --addTime
			MessageBox_Self_ExteriorWeapon_Confirm()
		elseif tonumber(arg0) == 89324501 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --???????
			MessageBox_Self_QixidakaAbandon_Confirm()
		elseif tonumber(arg0) == 89331301 then-- ?????????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.CONFIRM_SHAXINGGIVEUP
			MessageBox_Self_Text:SetText("#{XSX_220705_109}");	-- ????
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 89119501 then-- ??????????1??2??
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.CONFIRM_SECKILLCARDOPEN
			MessageBox_Self_DragTitle:SetText("#{TQJF_221108_31}")
			if g_msgFrameVar[1] == 1 then
				MessageBox_Self_Text:SetText("#{TQJF_221108_32}");	-- ????
			else
				MessageBox_Self_Text:SetText("#{TQJF_221108_34}");	-- ????
			end
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 88816001 then-- [2022Q3]????????--????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_msgFrameVar[2]  = Get_XParam_INT(1)
			g_msgFrameVar[3]  = Get_XParam_INT(2)
			g_FrameInfo = FrameInfoList.CONFIRM_GUARDCONFIRM
			MessageBox_Self_Text:SetText(Get_XParam_STR(0));	-- ????
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 99827002 then-- 2023Q2????-???? ????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.CONFIRM_WENHUOSXZL
			if g_msgFrameVar[1] == 1 then
				MessageBox_Self_Text:SetText("#{SXZL_032901_177}");	-- ????
				MessageBox_Self_DragTitle:SetText("#{SXZL_032901_176}")
			elseif g_msgFrameVar[1] == 2 then
				MessageBox_Self_Text:SetText("#{SXZL_032901_164}");	-- ????
				MessageBox_Self_DragTitle:SetText("#{SXZL_032901_163}")
			end
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 2505531 then-- 2023Q3??-???-????
			MessageBox_Self_OnConfirmGetMap()
			return
		elseif tonumber(arg0) == 89337901 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_msgFrameVar[2]  = Get_XParam_INT(1)
			g_msgFrameVar[3]  = Get_XParam_INT(2)
			g_msgFrameVar[4]  = Get_XParam_INT(3)
			g_msgFrameVar[5]  = Get_XParam_INT(4)

			g_FrameInfo = FrameInfoList.CONFIRM_ENTERDIGONG
			if g_msgFrameVar[1] == 1 then
				MessageBox_Self_Text:SetText( "#{MJXZ_210510_199}" );	-- ????
			elseif g_msgFrameVar[1] == 2 then
				MessageBox_Self_Text:SetText( "#{MJXZ_210510_167}" );	-- ????
			else
				return
			end
			MessageBox_Self_DragTitle:SetText("")

			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 89021502 then-- ????????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_FrameInfo = FrameInfoList.ZHANLING_CONFIRM
			MessageBox_Self_Text:SetText("#{SWXT_221213_54}");	-- ????
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 99852601 then-- ????????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_FrameInfo = FrameInfoList.BUY_YUEKA_CONFIRM
			MessageBox_Self_Text:SetText(Get_XParam_STR(0));	-- ????
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 99852602 then-- ??????????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.BUY_YUEKA_PROGRESS_CONFIRM
			MessageBox_Self_Text:SetText(Get_XParam_STR(0));	-- ????
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
			
		elseif tonumber(arg0) == 20221226 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_msgFrameVar[2]  = Get_XParam_INT(1)


			g_FrameInfo = FrameInfoList.CONFIRM_COLLECT_CRYSTAIL
			if g_msgFrameVar[1] >=5 then
				MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{CJWK_221220_27}",5) );	-- ????
			elseif g_msgFrameVar[2] >= 5 then
				MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{CJWK_221220_28}",5) );	-- ????
			else
				MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{CJWK_221220_28}",g_msgFrameVar[1],5-g_msgFrameVar[1]) );	-- ????
			end
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()

		elseif tonumber(arg0) == 80602104 then-- ????????
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_msgFrameVar[2]  = Get_XParam_INT(1)
			g_msgFrameVar[3]  = Get_XParam_INT(2)
			g_msgFrameVar[4]  = Get_XParam_INT(3)
			g_msgFrameVar[5]  = Get_XParam_INT(4)

			g_FrameInfo = FrameInfoList.WEEDING_PLANE_CONFIRM

			local needItem = {
				[0] = 30505106,
				[1] = 30505106,
				[2] = 30505079,
				[3] = 38002832,
			}

			local strNeedItemName = PlayerPackage:GetItemName( needItem[ g_msgFrameVar[2] ] )
			local text = ""

			if g_msgFrameVar[5] == 806021 then
				if g_msgFrameVar[1] == 4 then
					text = "#{BWZQ_20230329_332}"
				elseif g_msgFrameVar[2] == 3 then
					text = ScriptGlobal_Format("#{JHYH_230330_277}", strNeedItemName)
				else
					text = ScriptGlobal_Format("#{JHYH_230330_134}", g_msgFrameVar[3], strNeedItemName)
				end

			else
				text = ScriptGlobal_Format("#{JHYH_230330_283}", strNeedItemName)
			end

			MessageBox_Self_Text:SetText( text ); -- ????

			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif (tonumber(arg0) == 99834801) then
			-- µÛÁêÔÙÏÖ ¶áÆì ¸Ä±äPKÄ£Ê½
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)

			g_FrameInfo = FrameInfoList.DLZX_FLAG_CHANGEPKMODE

			MessageBox_Self_Text:SetText("#{DLZX_230518_31}") -- ????

			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif (tonumber(arg0) == 99836101) then-- ?????2??????
			CancelLastOp(FrameInfoList.JINGJINMISSION2_LEAVE);
			g_FrameInfo = FrameInfoList.JINGJINMISSION2_LEAVE;
			local strMsg = Get_XParam_STR(0)
			MessageBox_Self_DragTitle:SetText("");
			MessageBox_Self_Text:SetText( strMsg )
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return
		elseif (tonumber(arg0) == 99836401) then-- ?????3??????
			CancelLastOp(FrameInfoList.JINGJINMISSION3_LEAVE);
			g_FrameInfo = FrameInfoList.JINGJINMISSION3_LEAVE;
			local strMsg = Get_XParam_STR(0)
			MessageBox_Self_DragTitle:SetText("");
			MessageBox_Self_Text:SetText( strMsg )
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show();
			return

		elseif tonumber(arg0) == 99826502 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0)
			local type = Get_XParam_INT(1)

			local ObjCaredID = DataPool : GetNPCIDByServerID(g_msgFrameVar[1]);
			if ObjCaredID ~= -1 then
				--¿ªÊ¼¹ØÐÄNPC
				this:CareObject(ObjCaredID, 1, "MsgBox");
			end

			if type == 1 then
				
				g_FrameInfo = FrameInfoList.QIANGHUALU_EX_CONFIRM
				MessageBox_Self_Text:SetText("#{TGQH_20230802_17}")
				MessageBox_Self_DragTitle:SetText("#{TGQH_20230802_16}")
				MessageBox_Self_OK_Button:Show();
				MessageBox_Self_Cancel_Button:Show()
				MessageBox_Self_UpdateRect()

			else

				g_FrameInfo = FrameInfoList.JINGGANGCUO_EX_CONFIRM
				MessageBox_Self_Text:SetText("#{TGQH_20230802_12}")
				MessageBox_Self_DragTitle:SetText("#{TGQH_20230802_11}")
				MessageBox_Self_OK_Button:Show();
				MessageBox_Self_Cancel_Button:Show()
				MessageBox_Self_UpdateRect()

			end
			this:Show()
			return
		elseif tonumber(arg0) == 88881209 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --target
			g_msgFrameVar[2] = Get_XParam_INT(1) --fromBagIndex
			g_msgFrameVar[3] = Get_XParam_INT(2) --toBagIndex
			MessageBox_Self_ShenBing_Transition_Confirm()
		elseif tonumber(arg0) == 88881203 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --target
			g_msgFrameVar[2] = Get_XParam_INT(1) --bagIndex
			MessageBox_Self_ShenBing_LevelUp_Bind_Confirm()
		elseif tonumber(arg0) == 88881204 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --target
			g_msgFrameVar[2] = Get_XParam_INT(1) --fromBagIndex
			g_msgFrameVar[3] = Get_XParam_INT(2) --toBagIndex
			MessageBox_Self_ShenBing_Transition_Bind_Confirm()
		elseif tonumber(arg0) == 88881504 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --target
			g_msgFrameVar[2] = Get_XParam_INT(1) --bagIndex
			g_msgFrameVar[3] = Get_XParam_INT(2) --SkillIndex
			MessageBox_Self_ShenBing_SkillActive_Bind_Confirm()
		elseif tonumber(arg0) == 88881505 then
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = Get_XParam_INT(0) --target
			g_msgFrameVar[2] = Get_XParam_INT(1) --bagIndex
			g_msgFrameVar[3] = Get_XParam_INT(2) --SkillIndex
			MessageBox_Self_ShenBing_SkillLevelUp_Bind_Confirm()
		elseif (tonumber(arg0) == 99929902) then -- ??????
			CancelLastOp(FrameInfoList.CONFIRM_DAHUAQIXI_LIXIA);
			g_FrameInfo = FrameInfoList.CONFIRM_DAHUAQIXI_LIXIA
			MessageBox_Self_ClearVar()
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_Text:SetText("#{DHSD_20240522_81}")
			MessageBox_Self_OK_Button:Show()
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
			return
		else
			return
		end
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if g_FrameInfo == FrameInfoList.DART_ADJUST then
			Dart_Data = {}
			this:Hide()
			return
		elseif g_FrameInfo == FrameInfoList.KFS_RESET_GROWRATE then
			KFS_Data = {}
			this:Hide()
			return
		else
			return
		end
	-- zchw fix Transfer bug
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if ObjCaredID ~= -1 then
				this:CareObject(ObjCaredID, 0, "MsgBox");
			end
			this:Hide();
		end
	elseif( event == "DELETE_FRIEND" ) then
		g_currentList = tonumber(arg0);
		g_currentIndex = tonumber(arg1);
		CancelLastOp(FrameInfoList.DELETE_FRIEND_MESSAGE);
		g_FrameInfo = FrameInfoList.DELETE_FRIEND_MESSAGE;
	elseif( event == "CITY_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		g_CityData[3] = arg2;
		g_CityData[4] = arg3;
		g_CityData[5] = arg4;
		g_CityData[6] = arg5;
		g_CityData[7] = arg6;
		g_CityData[8] = arg7;
		CancelLastOp(FrameInfoList.CITY_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_CONFIRM;
	elseif( event == "MESSAGE_BOX" ) then
		MeesageBox_Init();
		return;
	elseif(event == "PLAYER_GIVE_ROSE")then
		g_RoseArg0 = arg0;
		g_RoseArg1 = arg1;
		g_RoseArg2 = arg2;
		g_RoseArg3 = arg3;
		g_RoseArg4 = arg4;
		if(g_RoseArg0==nil or g_RoseArg1 == nil )then
			return;
		end
		CancelLastOp(FrameInfoList.Player_Give_Rose);
		g_FrameInfo = FrameInfoList.Player_Give_Rose;
		MessageBox_Self_Text:SetText("#cFFF263hay không T¯ng#c00ff00999Ðoá hoa h°ng#cFFF263C¤p#c00ff00"..g_RoseArg0.."#cFFF263?");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	elseif( event == "NEED_USE_CONFIRM_ITEM" ) then
		NeedUseConfirmItemData[1] = arg0; --??objID
		NeedUseConfirmItemData[2] = arg1; --??x??
		NeedUseConfirmItemData[3] = arg2; --??y??
		NeedUseConfirmItemData[4] = arg3; --??????
		NeedUseConfirmItemData[5] = arg4; --??????
		if(NeedUseConfirmItemData[1] == nil)then
			return;
		end

		local itemTableIdx = tonumber(NeedUseConfirmItemData[5]);
		--»ñÈ¡ÏÔÊ¾ÄÚÈÝ
		local txt = MessageBox_GetNeedUseConfirmItemShowTxt( itemTableIdx );
		if (txt == nil) then
			return;
		end
		CancelLastOp(FrameInfoList.NEED_USE_CONFIRM_ITEM);
		g_FrameInfo = FrameInfoList.NEED_USE_CONFIRM_ITEM;
		MessageBox_Self_Text:SetText(txt);
		MessageBox_Self_DragTitle:SetText("#{QNG_XML_10}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "CLOSE_PS_CHANGETYPE_MSG" ) then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE)then
			this:Hide();
		end
		return;
	end
	if(event == "CLOSE_STRENGTH_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_STENGTH  then
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.SERVER_CONTROL or g_FrameInfo == FrameInfoList.SERVER_CONTROL_EXT then
				this:Hide();
			end
		end
		return;
	end

	if(event == "CLOSE_RE_IDENTIFY_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY  then
				this:Hide();
			end
		end
		return;
	end

	if(event == "CLOSE_KICK_MEMBER_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX  then
				this:Hide();
			end
		end
		return;
	end

	if(event == "CLOSE_SAFEBOX_CONFIRM" ) then
		if(this:IsVisible()) then
			if (g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM or g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM) then
				this:Hide();
			end
		end
		return;
	end


	if(event == "CLOSE_RECYCLESHOP_MSG" ) then
		if(this:IsVisible()) then

			if g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM  then
				CancelLastOp(-1);
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP then
				CancelLastOp(-1);
				this:Hide();
			end
		end
		return;
	end

	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end



	-- add:lby20080527È·ÈÏ4ÏâÇ¶ENCHASE_FOUR_CONFIRM
	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "CHAR_RANAME_CONFIRM" ) then
		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0vai di­n cäi danh");
		MessageBox_Self_Text:SetText("Chú ý, Nhçm chï có mµt l¥n cäi danh Ðích c½ hµi. #rNhçm xác nh§n Yêu sØa chæa tên Vi#G"..g_arg_chrc.."#cFFF263Ma?");
		CancelLastOp(FrameInfoList.CHAR_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CHAR_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "CITY_RANAME_CONFIRM" ) then
		g_arg_circ = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0bang hµi cäi danh");
		MessageBox_Self_Text:SetText("Chú ý, Nhçm chï có mµt l¥n cäi danh Ðích c½ hµi. #rNhçm xác nh§n Yêu sØa chæa bang hµi tên là#G"..g_arg_circ.."#cFFF263Ma?");
		CancelLastOp(FrameInfoList.CITY_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if ( event == "CLOSE_PETSOULADDLIFE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PETSOUL_ADDLIFE_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return
	end

	if(event == "GAMELOGIN_OPEN_COUNT_INPUT") then
		if(this:IsVisible()) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "SAFEBOX_LOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_LOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_LOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0tü s¡t b¸ khóa");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_10}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "SAFEBOX_UNLOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_UNLOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_UNLOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0tü s¡t Giäi Toä");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_07}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if (event == "CONFIRM_SETPOS_TLZ") then
		local itemIdx = tonumber(arg0)
		local szSceneName = tostring(arg1);
		local iPosX = tonumber(arg2);
		local iPosZ = tonumber(arg3);

		CancelLastOp(FrameInfoList.TLZ_CONFIRM_SETPOS);
		g_FrameInfo = FrameInfoList.TLZ_CONFIRM_SETPOS;

		Client_ItemIndex = itemIdx

		if (szSceneName ~= "") then
			if Client_ItemIndex == 30505288 then
				MessageBox_Self_Text:SetText("#{SFDJ_240117_169}"..szSceneName.."("..iPosX..","..iPosZ..")".."#{TLZ_081114_2}")
			else
				MessageBox_Self_Text:SetText("#{TLZ_081114_1}"..szSceneName.."("..iPosX..","..iPosZ..")".."#{TLZ_081114_2}")
			end
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			MessageBox_Self_OK_Clicked()
			this:Hide()
			return
		end

	end

	-- µ¯³ö½âÉ¢¶ÓÎéµÄ¶þ´ÎÈ·ÈÏ´°¿Ú			add by WTT	20090212
	if (event == "OPNE_DISMISS_TEAM_MSGBOX")	then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0giäi tán ðµi ngû");			-- ????
		MessageBox_Self_Text:SetText( "#{TeamDismiss_090912_1}" );	-- ????
		CancelLastOp(FrameInfoList.DISMISS_TEAM);
		g_FrameInfo = FrameInfoList.DISMISS_TEAM;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
		return;
	end

	if ( event == "TRUST_FRIEND_OPEN_DEL_CHECK" ) then
		MessageBox_Self_DragTitle:SetText("#{XRHB_09515_14}");													-- ????
		MessageBox_Self_Text:SetText( "#{XRHB_09515_15}"..arg1.."#{XRHB_09515_16}");	-- ????
		CancelLastOp(FrameInfoList.TRUST_FRIEND);
		g_FrameInfo = FrameInfoList.TRUST_FRIEND;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
		g_currentIndex = tonumber( arg0 );
		return;
	end

	-- Ð¶ÔØÊ ·Ñ±íÇéÈ·ÈÏ
	if event == "UNINSTALL_EMO_CONFIRM" then
		MessageBox_Self_DragTitle:SetText("#{BQB_XML_10}")												-- ????
		g_currentIndex = tonumber(arg0)
		local emo_package_id, emo_valid_date, emo_count = DataPool:LuaFnEnumEmoInfo(g_currentIndex)
		local emo_set_name = DataPool:LuaFnGetEmoSetName(emo_package_id)
		MessageBox_Self_Text:SetText("#{BQB_091026_8}"..tostring(emo_set_name).."#{BQB_091026_9}") -- ??????&U?????
		g_FrameInfo = FrameInfoList.UNINSTALL_EMO
		MessageBox_Self_UpdateRect()															-- ???????????
		this:Show()
		return
	end

	-- Ð¶ÔØÊ ·ÑÐÝÏÐ¶¯×÷È·ÈÏ
	if ( event == "UNINSTALL_CHAT_ACTION_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("#{BQB_XML_10}");					-- ????:????
		g_currentIndex = tonumber( arg0 );
		local actionID , actionValidDate , actionCount, actionMinIndex, actionType = DataPool:Get_RMB_ChatActionInfo(g_currentIndex )
		local actionName = DataPool : Get_RMB_ChatActionName(actionID)
		MessageBox_Self_Text : SetText( "#{SRDZ_20221107_07}"..tostring(actionName).."#{SRDZ_20221107_08}" );		-- ??????XXX?????#G(??????????????)
		g_FrameInfo = FrameInfoList.UNINSTALL_CHAT_ACTION;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
		return;
	end

	if ( event == "TEAMBOARD_OPEN_DEL_CHECK" ) then
		g_TeamBoardWindow = tonumber(arg0);
		MessageBox_Self_DragTitle:SetText("#{ZDPT_XML_24}");													-- ????
		MessageBox_Self_Text:SetText( "#{ZDPT_XML_25}");	-- ????
		g_FrameInfo = FrameInfoList.TEAMBOARD_OPEN_DEL_CHECK;
		MessageBox_Self_UpdateRect();																-- ???????????
		this:Show();
		return;
	end

	if ( event == "SUCCEED_EXCHANGE_CLOSE" ) then	--for TT:70792
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "CHANGE_NAME_CONFIRM" ) then
		ObjCaredID = tonumber(arg2);
		if ObjCaredID ~= -1 then
			--¿ªÊ¼¹ØÐÄNPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end

		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#{GMT_20100811_3}"); -- #gFF0FA0????
		local textStr = string.format("#{GMT_20100811_19}%s#{GMT_20100811_20}",g_arg_chrc)
		MessageBox_Self_Text:SetText(textStr);
		CancelLastOp(FrameInfoList.CHANGE_NAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CHANGE_NAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event =="YIGUI_OPEN") then
		if (g_FrameInfo == FrameInfoList.SERVER_CONTROL) and  (Server_Script_ID == 162)  then
			this:Hide();
		end
		return;
	end

	if(event =="OPEN_EXTERIOR_CONFORM") then
		MessageBox_Self_Text:SetText("#{GRYM_221213_09}");
		g_msgFrameVar[1] = tonumber(arg0)
		CancelLastOp(FrameInfoList.CONFIRM_EXTERIOR_REPLACE);
		g_FrameInfo = FrameInfoList.CONFIRM_EXTERIOR_REPLACE
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end


	if (event == "SPRINGFESTIVAL_SHOP_CONFIRM") then
		MessageBox_Self_DragTitle:SetText("#{CJDB_211122_18}");			-- ????
		local name = tostring( arg0 );
		local prize = tonumber(arg1)
		g_msgFrameVar[1] = tonumber(arg2)
		MessageBox_Self_Text:SetText(ScriptGlobal_Format("#{CJDB_211122_19}",name,prize));
		CancelLastOp(FrameInfoList.CONFIRM_FESTIVAL_SHOP);
		g_FrameInfo = FrameInfoList.CONFIRM_FESTIVAL_SHOP
		MessageBox_Self_UpdateRect();
		this:Show();
		return
	end

	if event == "EXTERIOR_FASHION_CONFIRM" then
		if tonumber(arg0) == 1 or tonumber(arg0) == 2 then
			-- È«²¿±£´æ
			CancelLastOp(FrameInfoList.CONFIRM_EXTERIOR_FASHION001);
			g_FrameInfo = FrameInfoList.CONFIRM_EXTERIOR_FASHION001

			MessageBox_Self_Text:SetText("#{WGJM_210104_34}")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show();
			MessageBox_Self_UpdateRect()
			this:Show()
		end
		if tonumber(arg0) == 1000 then
			CancelLastOp(FrameInfoList.CONFIRM_EXTERIOR_FASHION002);
			g_FrameInfo = FrameInfoList.CONFIRM_EXTERIOR_FASHION002
			g_msgFrameVar[1]  = tonumber(arg1)
			g_msgFrameVar[2]  = tonumber(arg2)
			g_msgFrameVar[3]  = tonumber(arg3)
			g_msgFrameVar[4]  = tonumber(arg4)

			MessageBox_Self_Text:SetText("#{WGJM_210104_26}")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show();
			MessageBox_Self_UpdateRect()
			this:Show()
		end
	end


	if event == "ACT_QTE_SIGNIN_CONFIRM" then
		MessageBox_Self_QTESignInClose_Confirm()
	end

	if (event == "SHENGWANG_CHOOSE_CONFIRM") then

		CancelLastOp(FrameInfoList.SHENGWANGJOIN_CONFIRM);
		g_FrameInfo = FrameInfoList.SHENGWANGJOIN_CONFIRM
		local nIndex = tonumber( arg0 );

		local stTtilerList =
		{
			[1]="#{ZYXZ_230104_3}",
			[2]="#{ZYXZ_230104_2}",
			[3]="#{ZYXZ_230104_4}",
		}

		local strTitle = stTtilerList[nIndex]
		if strTitle == nil then
			return
		end

		MessageBox_Self_DragTitle:SetText(strTitle);			-- ????

		local strList =
		{
			[1]="#{ZYXZ_230104_9}",
			[2]="#{ZYXZ_230104_10}",
			[3]="#{ZYXZ_230104_11}",
		}

		local str = strList[nIndex]
		if str == nil then
			return
		end
		MessageBox_Self_Text:SetText(str);
		MessageBox_Self_UpdateRect();
		this:Show();
		return
	end

	if event == "CLOSE_MESSAGEBOX" then
		local message_id = tonumber(arg0)
		if g_FrameInfo == message_id then
			this:Hide()
		end
		return
	end
	
	if event == "DAHUASHOP_BUYITEM_CONFIRM" then
		MessageBox_Self_Text:SetText(tostring(arg0))
		CancelLastOp(FrameInfoList.CONFIRM_DAHUAQIXI_BUYITEM)
		g_FrameInfo = FrameInfoList.CONFIRM_DAHUAQIXI_BUYITEM
		this:Show()
		MessageBox_Self_UpdateRect()
		return
	end
	
	if event == "DAHUASHOP_BUYDAIBI_CONFIRM" then
		MessageBox_Self_Text:SetText(tostring(arg0))
		CancelLastOp(FrameInfoList.CONFIRM_DAHUAQIXI_BUYDAIBI)
		g_FrameInfo = FrameInfoList.CONFIRM_DAHUAQIXI_BUYDAIBI
		this:Show()
		MessageBox_Self_UpdateRect()
		return
	end
	
	-- ¹Ø± ´ó»°ÆßÏ¦¹ºÂòµÄ¶þ´ÎÈ·ÈÏ½çÃæ
	if(event == "CLOSE_DAHUAQIXI_SHOP_MSGBOX" ) then
		if(this:IsVisible() and (g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_BUYDAIBI
		or g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_BUYITEM
		or g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_LIXIA)) then
			CancelLastOp(-1)
			this:Hide()
		end
		return
	end

	if(MessageBox_Self_OnEventEx(event) > 0) then
		MessageBox_Self_UpdateFrame();
	end
	if( event == "MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM" ) then
		g_MK_EP_EM_STR = tostring(arg0);
		g_MK_EP_EM_N = tonumber(arg1);
		g_MK_EP_EM_M = tonumber(arg2);
		MessageBox_Self_DragTitle:SetText("#{JYHD_230331_151}");
		CancelLastOp(FrameInfoList.MK_EXPRESSING_EMOTIONS);
		g_FrameInfo = FrameInfoList.MK_EXPRESSING_EMOTIONS;
		MessageBox_Self_Text:SetText( g_MK_EP_EM_STR );
		MessageBox_Self_UpdateRect();
		this:Show()
		return
	end

end

function MeesageBox_Init()
	strMessageString = tostring( arg0 );
	strMessageData	= tostring( arg1 );
	strMessageArgs = tostring(arg2);
	strMessageType	= tostring(arg3);
	strMessageArgs_2 = tostring(arg4)
	CancelLastOp(FrameInfoList.EQUIP_ITEM);
	g_FrameInfo = FrameInfoList.EQUIP_ITEM;

	if strMessageData == "YiGuiDressBind" then     --????NPC??
		ObjCaredID = tonumber(strMessageArgs_2)
		if ObjCaredID ~= -1 then
			--¿ªÊ¼¹ØÐÄNPC
			this:CareObject(ObjCaredID, 1, "MsgBox")
		end
	end

	MessageBox_Update();
end

function MessageBox_Update()
	this:Show();
	MessageBox_Self_OK_Button:Hide();
	MessageBox_Self_Cancel_Button:Hide();
	MessageBox_Self_Text:SetText( strMessageString );
	MessageBox_Self_DragTitle:SetText("#gFF0FA0#gFF0FA0? ?")
	if( strMessageType == "Normal" ) then
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "OK" ) then
		MessageBox_Self_OK_Button:Show();
	elseif( strMessageType == "Cancel" ) then
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "NoButton" ) then
	elseif( strMessageType == "Hide" ) then
		this:Hide();
	end
	MessageBox_Self_UpdateRect();
end
function MessageBox_Self_City_UpdateFrame()
	--AxTrace(0,0,"MessageBox_Self_City_UpdateFrame:"..tostring(g_CityData[1]));
	--È¡Ïûµ±Ç°½¨Éè½¨ÖþÎïµÄÈ·ÈÏÐÅÏ¢
	if(g_CityData[1] == 0) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0hüy bö trß¾c m£t kiªn thiªt");
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		local szExist = City:GetBuildingInfo(bId, "exist");
		if(tonumber(szExist) > 0) then szExist = "Thång c¤p"; else szExist = "Tu kiªn"; end
		local szCurPro = tostring(City:GetCityManageInfo("CurProgress"));
		local szAttr = (City:GetBuildingInfo(bId, "condattrname"));

		local msg = "Bän bang trß¾c m¡t ðang ·"..szExist..szName.."Trung, ðã hoàn thành Li­u tiªn ðµ"..szCurPro..". Ngßng hÆn H§u,";
		msg = msg..szExist.."Tß¾ng th¤t bÕi, t¤t cä tiªn ðµ Tß¾ng Vi 0, không lùi Hoàn gì Bang tài chính Hoà"..szAttr..", Nhî xác ð¸nh Yêu ngßng hÆn trß¾c m£t Ðích";
		msg = msg..szExist.."Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ÉêÇëÁìµØÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 1) then
		local szPortName = City:GetPortInfo(g_CityData[2], "Name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0xin lãnh ð¸a");
		--ÄãÈ·¶¨ÒªÉêÇëËùÔÚÓÚAAµÄ¡°BB¡±ÁìµØÂð£¿ âÏîÐÐÎªÐèÒªÏûºÄ1000¸ö½ð±Ò¡£
		local msg = "#cFFF263Nhî xác ð¸nh Yêu xin ch², n½i Vu#cFE7E82"..tostring(szPortName).."#cFFF263Ðích#H"..g_CityData[3].."#cFFF263";
		msg = msg.."Lãnh ð¸a Ma? Cái này hành vi c¥n tiêu hao 1000#-14ho£c là mµt kh¯i Kiªn Thành Linh Bài.";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ÐÞ½¨»òÉý¼¶½¨ÖþÎï
	elseif(g_CityData[1] == 2 or g_CityData[1] == 3) then
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		if(bLevel == -1 or bId == -1) then
			local szExist = "";
			if(g_CityData[1] == 2) then
				MessageBox_Self_DragTitle:SetText("#gFF0FA0kiªn thiªt Tân kiªn trúc");
				szExist = "Tu kiªn";
			else
				MessageBox_Self_DragTitle:SetText("#gFF0FA0thång c¤p kiªn trúc");
				szExist = "Thång c¤p";
			end

			local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
			--½¨ÉèÌõ¼þ
			local cd = {City:GetBuildingInfo(g_CityData[2], "condition")};
			--0.½ðÇ®
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.ÏûºÄÖµ
			local szAttr = (City:GetBuildingInfo(g_CityData[2], "condattrname"));
			local szAttrVal = tostring(cd[4]);
			--2.ÈÎÎñÊý
			local mn = tostring(cd[2]);

			local msg = szExist..szName.."C¥n Bang tài chính"..money..", tiêu hao"..szAttr..szAttrVal;
			msg = msg.."Ði¬m, ð°ng th¶i tuyên b¯ nhi®m vø"..mn.."Cá, Nhî xác ð¸nh Ma?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(0);	--???????????
		end
	--½µ¼¶»ò²ð»Ù½¨ÖþÎï
	elseif(g_CityData[1] == 4 or g_CityData[1] == 5) then
		local szExist = "";
		if(g_CityData[1] == 4) then
			MessageBox_Self_DragTitle:SetText("#gFF0FA0giáng c¤p kiªn trúc");
			szExist = "Giáng c¤p";
		else
			MessageBox_Self_DragTitle:SetText("#gFF0FA0phá hüy kiªn trúc");
			szExist = "Phá hüy";
		end

		local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
		local szPreAttr = "";
		_,szPreAttr = City:GetBuildingInfo(g_CityData[2], "condattrname");
		local msg = szExist..szName.."S¨ SÑ kiªn trúc công nång Dß tác døng giäm b¾t, Thß không lùi Hoàn gì Bang tài chính Dß";
		msg = msg..szPreAttr..", Nhî xác ð¸nh Yêu làm nhß v§y Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--ÐÞ¸Ä³ÇÊÐ·´ ¹Ç÷ÊÆÁùÂÊÖµ
	elseif(g_CityData[1] == 6) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa chæa phát tri¬n phß½ng hß¾ng");
		local msg = "SØa chæa phát tri¬n phß½ng hß¾ng s¨ tiêu hao bang hµi tài chính 50#-02, Nhî xác ð¸nh Yêu làm nhß v§y Ma?"
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--È¡ÏûÑÐ¾¿µÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 7) then
		local rName, _, rIdx = City:GetResearchInfo("CurResearch");
		local szCurPro = tostring(City:GetResearchInfo("ResearchProcess"));

		MessageBox_Self_DragTitle:SetText("#gFF0FA0ngßng hÆn nghiên cÑu");
		local msg = "Bän bang trß¾c m¡t ðang · nghiên cÑu"..rName.."Trung, ðã hoàn thành Li­u tiªn ðµ"..szCurPro..". Ngßng hÆn H§u,";
		msg = msg.."Nghiên cÑu Tß¾ng th¤t bÕi, t¤t cä tiªn ðµ Tß¾ng Vi 0, không lùi Hoàn gì Bang tài chính Hoà thuµc tính Tr¸, Nhî xác ð¸nh Yêu ngßng hÆn trß¾c m£t Ðích nghiên cÑu Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--¿ªÊ¼ÑÐ¾¿µÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 8) then
		local rName = City:GetResearchInfo("CurResearch");
		if("" == rName) then
			local bIdx = tonumber(g_CityData[2]);
			local rIdx = tonumber(g_CityData[3]);
			MessageBox_Self_DragTitle:SetText("#gFF0FA0nghiên cÑu ph¯i phß½ng");
			local szResearchName = City:GetResearchInfo("ResearchName", bIdx, rIdx);
			--½¨ÉèÌõ¼þ
			local cd = {City:GetResearchInfo("ResearchCondition", bIdx, rIdx)};
			--0.½ðÇ®
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.ËùÐèÖµ
			local szAttr = City:GetResearchInfo("RCAttrName", bIdx, rIdx);
			local szAttrVal = tostring(cd[4]);
			--2.ÈÎÎñÊý
			local mn = tostring(cd[2]);
			local msg = "Nghiên cÑu"..szResearchName.."C¥n Bang tài chính"..money..", tiêu hao";
			msg = msg..szAttr..szAttrVal..", ð°ng th¶i tuyên b¯ nhi®m vø"..mn.."Cá, Nhî xác ð¸nh Ma?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(7);	--???????????
		end
	--´´½¨ÉÌÒµÂ·ÏßµÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 9) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0sáng tÕo buôn bán lµ tuyªn");
		local msg = "ThØ thao tác Tß¾ng Dß ðánh s¯ Vi"..tostring(g_CityData[2]).."Ðích bang hµi thành l§p Thß½ng Tuyªn, chï có song phß½ng H² Kiªn Thß½ng Tuyªn, Thß½ng Tuyªn m¾i có th¬ có hi®u lñc, Nhî xác ð¸nh Yêu thành l§p Ma?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--È¡ÏûÉÌÒµÂ·ÏßµÄÈ·ÈÏÐÅÏ¢
	elseif(g_CityData[1] == 10) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0hüy bö buôn bán lµ tuyªn");
		local dt = {City:GetCityRoadInfo("RoadDetail", g_CityData[2])};
		local msg = "";
		if(dt[4]) then
			msg = "ThØ thao tác Tß¾ng SÑ bän bang Dß ð¯i phß½ng bang hµi Ðích buôn bán hành vi ð½n phß½ng ngßng hÆn, Nhî xác ð¸nh Yêu tiªp tøc tiªn hành thao tác Ma?";
		else
			msg = "ThØ thao tác Tß¾ng SÑ bän bang Dß ð¯i phß½ng bang hµi s¨ không lÕi có H² Kiªn Thß½ng Tuyªn Ðích có th¬, Nhî xác ð¸nh Yêu tiªp tøc tiªn hành thao tác Ma?";
		end
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
end

function MessageBox_Self_City_OK_Clicked()
	if(g_CityData[1] == 0) then
		local nBuildingId;
		_,_,nBuildingId = City:GetCityManageInfo("CurBuilding");
		City:DoBuilding(nBuildingId, "cancelup");
	elseif(g_CityData[1] == 1) then
		City:CreateCity(g_CityData[2],g_CityData[3]);
	elseif(g_CityData[1] == 2) then
		City:DoBuilding(g_CityData[2], "create");
	elseif(g_CityData[1] == 3) then
		City:DoBuilding(g_CityData[2], "up");
	elseif(g_CityData[1] == 4) then
		City:DoBuilding(g_CityData[2], "down");
	elseif(g_CityData[1] == 5) then
		City:DoBuilding(g_CityData[2], "destory");
	elseif(g_CityData[1] == 6) then
		local k;
		local valTab = {};
		for k = 2, 8 do
			valTab[k-1] = tonumber(g_CityData[k]);
		end
		City:FixCityTrend(
												valTab[1],valTab[2],valTab[3],valTab[4],
												valTab[5],valTab[6],valTab[7],valTab[8]
										 );
	elseif(g_CityData[1] == 7) then
		local rName, bIdx, rIdx = City:GetResearchInfo("CurResearch");
		City:DoResearch(bIdx, rIdx, "cancelresearch");
	elseif(g_CityData[1] == 8) then
		City:DoResearch(tonumber(g_CityData[2]), tonumber(g_CityData[3]), "research");
	elseif(g_CityData[1] == 9) then
		City:DoCityRoad("create", g_CityData[2]);
	elseif(g_CityData[1] == 10) then
		City:DoCityRoad("cancel", g_CityData[2]);
	end
	g_CityData = {};
end

function MessageBox_Self_City_Cancel_Clicked()
	g_CityData = {};
end


--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrameEx()

	if( g_FrameInfo==FrameInfoList.SAVE_STALL_INFO) then

		MessageBox_Self_DragTitle:SetText("#gFF0FA0bäo t°n qu¥y hàng thiªt trí");
		local szInfo;
		szInfo = "#{INTERFACE_XML_681}";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- add by zchw
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Thu Than");
		local szInfo;
		szInfo = "Nhî th§t sñ Yêu Thu Than Ma?";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- zchw for pet procreate
	elseif (g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0chú ý");
		MessageBox_Self_Text:SetText("#{PET_FANZHI_20080313_01}");
		this:Show();
	--ÆßÏ¦ÈµÇÅ
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_QIXI_QUEQIANG) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0chú ý");
		MessageBox_Self_Text:SetText("#{QXWH_20210616_69}");
		this:Show();
	--»¹»êÁéÂ¶¸´»î
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_RELIVE_SPECIALITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0s¯ng lÕi");
		MessageBox_Self_Text:SetText("#{SFDJ_240117_163}");
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
		local szInfo;
		if ( g_CurUint == g_CurUintType.YuanBao ) then
			szInfo = "Mua"..g_CityData[3].."C¥n tiêu phí"..tostring(g_CityData[2]).."Cá nguyên bäo, Nhî xác nh§n Ma?";
		elseif ( g_CurUint == g_CurUintType.Bind ) then
			szInfo = "#{BDYB_090720_01}"..g_CityData[3].."#{BDYB_090720_02}"..tostring(g_CityData[2]).."#{BDYB_090720_03}";
		end
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();

	elseif(g_FrameInfo == FrameInfoList.RONGYU_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
		local szInfo;
			szInfo = "Mua"..g_CityData[3].."C¥n tiêu phí"..tostring(g_CityData[2]).."Vinh dñ Tr¸, Nhî xác nh§n Ma?";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
		local szInfo;
		szInfo = "Mua"..CommisionBuyData[1].."C¥n tiêu phí"..CommisionBuyData[2]..", Nhî xác nh§n Ma?";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.DISCARD_GUILD) then
		--Í¨Öª½â³ýËø¶¨
		MessageBox_Self_DragTitle:SetText("#gFF0FA0giäi tán bang hµi");
		local szStr = "Nhî th§t sñ Yêu giäi tán[".. tostring(g_newName) .."]bang hµi?"
		MessageBox_Self_Text:SetText(szStr);
	end

end

--===============================================
-- UpdateTitle
--===============================================
function UpdateTitle()
    --ÒòÎªÔÚMessageBox_Self_UpdateFrameº¯ÊýÖÐ,"upvalue"ÑÏÖØ³¬Ô±,Ôö¼ÓÁË â¸öº¯ÊýÓÃÀ´¸ü¸ÄmsgboxµÄ±êÌâ
    if ( PVPFLAG.FREEFORALL == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa ð±i PKhình thÑc");
    elseif ( PVPFLAG.FREEFORTEAM == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa ð±i PKhình thÑc");
    elseif ( PVPFLAG.FREEFORGUILD == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa ð±i PKhình thÑc");
    elseif ( PVPFLAG.MAKESUREPVPCHALLENGE == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0tuyên chiªn xác nh§n");
	elseif g_FrameInfo == FrameInfoList.SONGLIAOWAR_REST_EXIT_CONFIRM then
		MessageBox_Self_DragTitle:SetText("#{XSLDZ_180521_338}")
	elseif ( PVPFLAG.FREEFORRAID == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa ð±i PKhình thÑc");

	end
	MessageBox_Self_UpdateRect();

end

--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrame()

	MessageBox_Self_DragTitle:SetText("#gFF0FA0");
	UpdateTitle()

	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		this : Show()
		MessageBox_Self_Text : SetText( GemCombinedData[7] )
		MessageBox_Self_UpdateRect();
		return
	end

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--ÌáÊ¾±¾µÄ·ÑÓÃ
		local nPosTax = StallSale:GetPosTax();
		local nTradeTax = StallSale:GetTradeTax();

		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(nPosTax);

		local szMoneyPosTax = "";
		if(nGoldCoin ~= 0)   then
		 	szMoneyPosTax = tostring(nGoldCoin) .. "#-14";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoneyPosTax = szMoneyPosTax .. tostring(nSilverCoin) .. "#-15";
		end
		if(nCopperCoin ~= 0)   then
			szMoneyPosTax = szMoneyPosTax .. tostring(nCopperCoin) .. "#-16";
		end

		local nCoinType = StallSale:GetStallType()
		if (nCoinType == 1) then --????
			local szInfo = "#{YBBT_081031_1}".. szMoneyPosTax .."#{YBBT_081031_2}1#{YBBT_081031_3}";
			MessageBox_Self_Text:SetText(szInfo);
		else
			local szInfo = "#{YBBT_081031_4}".. szMoneyPosTax .."#{YBBT_081031_5}".. tostring(nTradeTax) .."#{YBBT_081031_6}";
			MessageBox_Self_Text:SetText(szInfo);
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--Í¨Öª½â³ýËø¶¨
		MessageBox_Self_DragTitle:SetText("#gFF0FA0tiêu hüy v§t ph¦m");
		local szStr = "Nhî th§t sñ Yêu tiêu hüy".. argDISCARD_ITEM_FRAME0 .."?"
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.DISCARD_QUAL8ITEM_FRAME) then
		--Í¨Öª½â³ýËø¶¨
		MessageBox_Self_DragTitle:SetText("#gFF0FA0tiêu hüy v§t ph¦m");
		MessageBox_Self_Text:SetText(ScriptGlobal_Format("#{YZZBMD_220627_04}",g_msgFrameVar[1]))
		MessageBox_Self_CheckClient:Show()
		MessageBox_Self_CheckBtn:Show()
		MessageBox_Self_CheckText:Show()
		MessageBox_Self_CheckText:SetText("#{YZZBMD_240419_1}")
		MessageBox_Self_CheckBtn:SetCheck( 0 );	

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0tiêu hüy v§t ph¦m");
		local szStr = argCANNT_DISCARD_ITEM0.."Th¸ nhi®m vø v§t ph¦m, không th¬ tiêu hüy";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Gia Toä");
		local szStr = "".."#cff0000chú ý! #r#YvÌ bäo hµ Nhçm Ðích tài sän an toàn, mµt khi v§t ph¦m Ho£c Trân Thú thành công B¸ Gia Toä, lÕi Giäi Toä T¡c c¥n ch¶ ðþi#G3Thiên#Y, NHçm xác ð¸nh Yêu tiªp tøc Gia Toä Ma?";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0vÑt bö nhi®m vø");
		if Quest_Number==888767 then
			MessageBox_Self_Text:SetText("#{GEHJ_211015_22}");
		elseif Quest_Number==888779 then
			MessageBox_Self_Text:SetText("#{CCYXN_20211202_27}");
		elseif Quest_Number==998269 then-- 2023Q2????-????
			MessageBox_Self_Text:SetText("#{SXZL_032901_67}");
		elseif Quest_Number==893122 then
			local curDay = tonumber(DataPool:GetServerDayTime());
			if DataPool:GetPlayerMission_DataRound(710) == curDay then
				MessageBox_Self_Text:SetText("#{FYH_220407_52}");
		else
				MessageBox_Self_Text:SetText("#{FYH_220407_120}");
			end
		elseif Quest_Number==893186 or Quest_Number==893187 or Quest_Number==893188 or Quest_Number==893189 then
			MessageBox_Self_Text:SetText("#{ZQSS_220429_7}");
		elseif Quest_Number==893196 or Quest_Number==893197 or Quest_Number==893198 or Quest_Number==893199 then
			MessageBox_Self_Text:SetText("#{XZDZ_220428_7}");
		elseif Quest_Number==893206 or Quest_Number==893207 or Quest_Number==893208 or Quest_Number==893209 then
			MessageBox_Self_Text:SetText("#{LNQZ_220429_7}");
		elseif Quest_Number==893176 then
			MessageBox_Self_Text:SetText("#{XRDK_220428_167}");
		elseif Quest_Number==893177 then
			MessageBox_Self_Text:SetText("#{XRDK_220428_227}");
		elseif Quest_Number==893178 then
			MessageBox_Self_Text:SetText("#{XRDK_220428_228}");
		elseif Quest_Number==893179 then
			MessageBox_Self_Text:SetText("#{XRDK_220428_229}");
		elseif Quest_Number==893180 then
			MessageBox_Self_Text:SetText("#{XRDK_220428_230}");
		elseif Quest_Number==893181 then
			MessageBox_Self_Text:SetText("#{XRDK_220428_231}");
		elseif Quest_Number==893359 then
			MessageBox_Self_Text:SetText("#{ZNXY_220624_41}");
		elseif Quest_Number==250553 then
			MessageBox_Self_Text:SetText("#{ZNWB_230625_51}");
		elseif Quest_Number==893302 then
			MessageBox_Self_Text:SetText("#{ZNSC_220624_50}");
		elseif Quest_Number==810115 then
			MessageBox_Self_Text:SetText("#{CJDG_221110_58}");
		elseif Quest_Number==890143 then--2023Q1?????????1
			MessageBox_Self_Text:SetText("#{CCYR_221220_108}");
		elseif Quest_Number==890144 then--2023Q1?????????2
			MessageBox_Self_Text:SetText("#{CCYR_221220_111}");
		elseif Quest_Number==890145 then--2023Q1?????????3
			MessageBox_Self_Text:SetText("#{CCYR_221220_112}");
		elseif Quest_Number==890146 then--2023Q1?????????4
			MessageBox_Self_Text:SetText("#{CCYR_221220_113}");
		elseif Quest_Number==998695 then--2024Q1preheat
			MessageBox_Self_Text:SetText("#{SFYR_240104_95}");
		elseif Quest_Number==998696 then--2024Q1preheat
			MessageBox_Self_Text:SetText("#{SFYR_240104_23}");
		elseif Quest_Number==998697 then--2024Q1preheat
			MessageBox_Self_Text:SetText("#{SFYR_240104_24}");
		elseif Quest_Number==998698 then--2024Q1preheat
			MessageBox_Self_Text:SetText("#{SFYR_240104_25}");
		elseif Quest_Number==998812 then--2024Q2newWENHUO
			MessageBox_Self_Text:SetText("#{XRBG_20240412_83}");
		elseif Quest_Number==998819 then
			MessageBox_Self_Text:SetText("#{HZLH_20240415_110}");
		else
			local szStr = "#cFFF263Nhî th§t sñ Yêu vÑt bö#RnHi®m vø:"..argFRAME_AFFIRM_SHOW0.."#cFFF263Ma?";
			MessageBox_Self_Text:SetText(szStr);
		end
	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		MessageBox_Self_DragTitle:SetText("#gFF0FA0bang hµi thành l§p");
		local szStr = "Nhî xác nh§n sáng tÕo" .. argCREATE_CONFIRM0 .. "Bang hµi Ma?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0bang hµi giäi tán");
		local szStr = "Nhî xác nh§n xóa bö" .. argDESTORY_CONFIRM0 .. "Bang hµi Ma?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DIS_FIRSTMAN) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0#{BHCR_xml_XX(04)}");
		local szStr = "Nhî xác ð¸nh Yêu huÖ bö thÑ nh¤t ngß¶i th×a kª Ma?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0bang hµi r¶i khöi");
		local szStr = "Nhî xác nh§n r¶i khöi" .. argQUIT_CONFIRM0 .. "Bang hµi Ma?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ð°ng minh r¶i khöi");
		local szStr = "Nhî xác nh§n r¶i khöi" .. argQUIT_LEAGUE_CONFIRM0 .. "Ð°ng minh Ma?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0ð°ng minh sáng tÕo");
		local szStr = "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		MessageBox_Self_Text:SetText(argNET_CLOSE0);
	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Trân Thú phóng sinh");
		local petname = Pet:GetPetList_Appoint(Pet_Number) ;
		local strname, pettype = Pet:GetName(Pet_Number);
		local szStr = "Hay không xác nh§n phóng sinh["..petname.."]("..pettype..")?" ;
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa chæa Ðiªm Danh");
		--Íæ¼ÒÉÌµê¸üÃûÐèÒªµÄ½ðÇ®Êý×Ö
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "SØa chæa Ðiªm Danh c¥n ti«n trä bäng hi®u chæ vàng Phí 2".."#-02".. "×buôn bán luÛ th×a, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor().."C¥n ti«n trä"..szMoney..", Nhî xác ð¸nh Yêu sØa chæa Ma?"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--Íæ¼ÒÉÌµê¸ü¸ü¸ÄÉÌµêËµÃ÷ÐèÒªµÄ½ðÇ®Êý×Ö
		MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa chæa cØa hàng miêu tä");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "SØa chæa Ðiªm miêu tä c¥n ti«n trä vån chß½ng Phí".."50#-03".. "×buôn bán luÛ th×a, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor().."C¥n ti«n trä"..szMoney..", Nhî xác ð¸nh Yêu sØa chæa Ma?"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Sung Nh§p ti«n v¯n");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Nhî Tß¾ng Sung Nh§p" .. szMoney .. ", h® th¯ng còn nghî thu Nhî 3%Ðích ð¥u tß Thuª, Nhî Tß¾ng c¥n thêm vào ti«n trä" .. szMoney1 .. ", Nhî xác ð¸nh Yêu Sung Nh§p Ma?";

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Sung Nh§p lþi nhu§n Kim");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Nhî Tß¾ng Sung Nh§p" .. szMoney .. ", h® th¯ng còn nghî thu Nhî 3%Ðích ð¥u tß Thuª, Nhî Tß¾ng c¥n thêm vào ti«n trä" .. szMoney1 .. ", Nhî xác ð¸nh Yêu Sung Nh§p Ma?";

		MessageBox_Self_Text:SetText(szInfo);



	elseif(g_FrameInfo == FrameInfoList.PS_DEC_GAIN_MONEY)    then

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Server_Script_Function_Set[1]  = Get_XParam_STR(0);
		Server_Script_ID = Get_XParam_INT(0);
		Server_Return_1 = Get_XParam_INT(1);
		Server_Return_2 = Get_XParam_INT(2);

		MessageBox_Self_Text:SetText(Get_XParam_STR(1));

		if Get_XParam_STR(2) ~= "" then
			Server_Script_Function_Set[2] = Get_XParam_STR(2)
		else
			Server_Script_Function_Set[2] = nil
		end

	elseif g_FrameInfo == FrameInfoList.SERVER_CONTROL_EXT then

		--ÉèÖÃ·þÎñÆ÷´«¹ýÀ´µÄ×Ö·û´®²ÎÊý
		Server_Script_Function_Set[1] = Get_XParam_STR(0)
		Server_Script_Function_Set[2] = nil
		MessageBox_Self_Text:SetText(Get_XParam_STR(1))

		--ÉèÖÃ·þÎñÆ÷´«¹ýÀ´µÄ ûÐÎ²ÎÊý£¬ âÐ©²ÎÊý»á±»´«»Ø·þÎñÆ÷
		Server_Script_ID = Get_XParam_INT(0)
		local count = Get_XParam_INT_Count()
		Server_Return_Params[0]=count
		for i=1, count do
			Server_Return_Params[i] = Get_XParam_INT(i)
		end

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0khuªch trß½ng qu¥y");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Khuªch trß½ng qu¥y c¥n ti«n trä 30#-02×buôn bán luÛ th×a ×2×103%, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor() ..", c¥n ti«n trä" .. szMoney .. ", Nhî xác ð¸nh Yêu khuªch trß½ng Ma?"

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0giäm b¾t qu¥y");
		MessageBox_Self_Text:SetText("#{SJGT_090825_01}");

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Bàn nhân viên chÕy hàng Phô");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Bàn nhân viên chÕy hàng Phô c¥n ti«n trä 15#-02×buôn bán luÛ th×a, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor() ..", c¥n ti«n trä" .. szMoney .. ", Nhî xác ð¸nh Yêu Bàn nhân viên chÕy hàng Phô Ma?"
		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU_YB)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Bàn nhân viên chÕy hàng Phô");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Bàn nhân viên chÕy hàng Phô c¥n ti«n trä 15#-02×buôn bán luÛ th×a, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor() ..", c¥n ti«n trä" .. szMoney .. ", Nhî xác ð¸nh Yêu Bàn nhân viên chÕy hàng Phô Ma?"
		MessageBox_Self_Text:SetText(szInfo);
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)  then   --??

		MessageBox_Self_DragTitle:SetText("#gFF0FA0Bàn Nh§p cØa hàng");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "Hüy bö Bàn Xu¤t qu¥y c¥n ti«n trä 5#-02×buôn bán luÛ th×a, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor() ..", c¥n ti«n trä" .. szMoney .. ", Nhî xác ð¸nh Yêu Bàn Nh§p cØa hàng Ma?"

		MessageBox_Self_Text:SetText(szInfo);

	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0sØa chæa cØa hàng loÕi hình");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);
		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "SØa chæa Ðiªm loÕi hình c¥n ti«n trä khuân vác Phí: 5#-02 ×buôn bán luÛ th×a, trß¾c m£t Ðích buôn bán luÛ th×a Vi".. PlayerShop:GetCommercialFactor() ..", c¥n ti«n trä" .. szMoney .. ", Nhî xác ð¸nh Yêu sØa chæa Ma?"

		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0xóa bö xác nh§n");
		local szInfo;
		local relationtype = DataPool:GetFriend(g_currentList,g_currentIndex, "RELATION_TYPE" )
		if relationtype == 7 then
			szInfo = "#cFFF263Nhî xác ð¸nh Yêu xóa bö".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."Ma? Xóa bö H§u Tß¾ng không th¬ Dß ð¯i phß½ng tiªn hành gì th¥y trò tß½ng quan Ðích hoÕt ðµng.";
		else
			szInfo = "#cFFF263Nhî xác ð¸nh Yêu xóa bö".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."Sao?";
		end
		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_UpdateFrame();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Trân Thú hþp thành");
		local msg = "Nhî xác ð¸nh Tß¾ng Giá hai Trân Thú hþp thành làm mµt Chích Ma?";
		MessageBox_Self_Text:SetText(msg);
	elseif( g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0Bang C¯ng Bài ð±i");
	elseif( g_FrameInfo == FrameInfoList.PUT_GUILDMONEY ) then
		MessageBox_Self_DragTitle:SetText("#{BPZJ_0801014_020}");
	elseif( g_FrameInfo == FrameInfoList.CHANGE_NAME_RETOK ) then
		MessageBox_Self_DragTitle:SetText("#{GMT_20100811_3}");
		local changenameMsg = string.format("#{GMT_20100811_29}%s#{GMT_20100811_30}",g_newName)
		MessageBox_Self_Text:SetText(changenameMsg);
	elseif( g_FrameInfo == FrameInfoList.HEXINCHUN_YBCONFIRM ) then-- ??-??????-???????
		MessageBox_Self_DragTitle:SetText("#{CJYJ_201222_03}");
	elseif( g_FrameInfo == FrameInfoList.CONFIRM_KAIYANXI_DUIHUAN ) then	--????????-2021?-by yuanpeilong
		MessageBox_Self_DragTitle:SetText("#{KYX_20210715_04}");
	elseif( g_FrameInfo == FrameInfoList.CONFIRM_2022_PETYURE ) then	--//2022??????-ypl
		MessageBox_Self_DragTitle:SetText("");
	elseif( g_FrameInfo == FrameInfoList.JIYUAN_SHOP_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
	elseif( g_FrameInfo == FrameInfoList.FANLI_SHOP_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
	elseif( g_FrameInfo == FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0mua thß½ng ph¦m");
	end

	MessageBox_Self_UpdateFrameEx();
	MessageBox_Self_UpdateRect();
	this:Show();
end

--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function MessageBox_Self_OK_Clicked_Ex()
    AxTrace( 0, 0, "MessageBox_OnOKClick" )
	if( g_FrameInfo == FrameInfoList.FREEFORALL ) then --????????
        AxTrace( 0, 0, "FrameInfoList.FREEFORALL" )
        Player:ChangePVPMode( 1 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORTEAM ) then --????????
        AxTrace( 0, 0, "FrameInfoList.FREEFORTEAM" )
        Player:ChangePVPMode( 3 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORGUILD ) then  --????????
        AxTrace( 0, 0, "FrameInfoList.FREEFORGUILD" )
        Player:ChangePVPMode( 4 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORRAID ) then  --????????
        Player:ChangePVPMode( 5 );
    end
    if( g_FrameInfo == FrameInfoList.MAKESUREPVPCHALLENGE ) then  --????
        AxTrace( 0, 0, "FrameInfoList.MAKESUREPVPCHALLENGE" )
        Player:PVP_Challenge( 2 );     --2??????????
    end

    if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
        DuelAccept( tostring( PVPFLAG.DuelName ),tostring( PVPFLAG.DuelGUID ), 1 )
    end


	if( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		StallSale:CloseStall("ok");
	-- add by zchw
		StallSale:CloseStallMessage();
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		StallSale:CloseStall("ask");
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		PushEvent(462, 0); --PETPROCREATE_KEY_STATE
		Pet:ConfirmPetProcreate(1);
	--ÆßÏ¦ÈµÇÅ È·ÈÏ
	elseif g_FrameInfo == FrameInfoList.CONFIRM_QIXI_QUEQIANG then
		PushEvent("RESET_QIXI_QUEQIANG");--??
	--»¹»êÁéÂ¶¸´»î
	elseif g_FrameInfo == FrameInfoList.CONFIRM_RELIVE_SPECIALITEM then
		Player:SendReliveMessage_Relive();--??
	elseif  g_FrameInfo == FrameInfoList.QUIT_GAME  then
		EnterQuitWait(0);
		--QuitApplication("quit");
	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)    then
		PlayerShop:ChangeShopNum("del_ok");
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)    then
		PlayerShop:Transfer("apply", "sale", g_nData, 0);--0?????
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU_YB)    then
		PlayerShop:Transfer("apply", "sale", g_nData, 1);--1?????
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)    then
		PlayerShop:Transfer("apply", "back", g_nData);
	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		PlayerShop:ModifySubType("ps_type_ok", tonumber(g_nData));
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		DataPool:DelFriend( g_currentList, g_currentIndex );
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_OK_Clicked();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_PetSyn_OK_Clicked();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_DEMIS_CONFIRM) then
		Guild:DemisGuildOK();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		GuildLeague:Quit();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		local r=GuildLeague:Create(argCREATE_LEAGUE_CONFIRM0,argCREATE_LEAGUE_CONFIRM1)
		if r==-1 then
			PushDebugMessage("#{TM_20080311_05}")
		elseif r==-2 then
			PushDebugMessage("#{TM_20080311_07}")
		end
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		NpcShop:BulkBuyItem(g_CityData[1],1);
	elseif(g_FrameInfo == FrameInfoList.RONGYU_BUY_ITEM) then
		RongYuUI:DoRongYuShopBuy(g_CityData[1], 1)
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		CommisionShop:OnBuyConfrimed();
	end
	if( FrameInfoList.Player_Give_Rose == g_FrameInfo ) then
		Player:UseRose(tonumber(g_RoseArg1),tonumber(g_RoseArg2),tonumber(g_RoseArg3),tonumber(g_RoseArg4))
	end
	if( FrameInfoList.NEED_USE_CONFIRM_ITEM == g_FrameInfo ) then
		Player:UseItem(
		tonumber(NeedUseConfirmItemData[1]), --??objID
		tonumber(NeedUseConfirmItemData[2]), --??x??
		tonumber(NeedUseConfirmItemData[3]), --??y??
		tonumber(NeedUseConfirmItemData[4]), --??????
		tonumber(NeedUseConfirmItemData[5])  --??????
		);
	end

	if(g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM) then
		if(Recycle_Type<0 or Recycle_CurSelectItem<0) then
			return
		end
		PlayerShop:SendCancelRecItemMsg(Recycle_Type,Recycle_CurSelectItem);
		Recycle_Type =-1;
		Recycle_CurSelectItem = -1;
	end

	if(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx<0 or Recycle_Shop_idx<0) then
			return
		end
		PlayerShop:SendSellItem2RecycleShopMsg(Recycle_Bag_idx,Recycle_Shop_idx);
		Recycle_Bag_idx =-1;
		Recycle_Shop_idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_STENGTH) then
		if(Stength_Equip_Idx<0 or Stength_Item_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishEnhance");
			Set_XSCRIPT_ScriptID(809262);
			Set_XSCRIPT_Parameter(0,tonumber(Stength_Equip_Idx));
			Set_XSCRIPT_Parameter(1,tonumber(Stength_Item_Idx));
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		Stength_Equip_Idx =-1;
		Stength_Item_Idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG) then
		if(BangGong_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("BanggongExchange");
			Set_XSCRIPT_ScriptID(805009);
			Set_XSCRIPT_Parameter(0,BangGong_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		BangGong_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.PUT_GUILDMONEY) then
		if(GuildMoney_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PutGuildMoney");
			Set_XSCRIPT_ScriptID(805012);
			Set_XSCRIPT_Parameter(0,GuildMoney_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		GuildMoney_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY) then
		if(RID_Equip_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishReAdjust");
			Set_XSCRIPT_ScriptID(809261);
			Set_XSCRIPT_Parameter(0,tonumber(RID_Equip_Idx));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		RID_Equip_Idx =-1;
	end
	if(g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX) then
		if(Member_Idx < 0) then
			return
		end
		Guild:SureKickGuild(tonumber(Member_Idx));
		Member_Idx =-1;
		Member_Name = "";
	end

	if (g_FrameInfo == FrameInfoList.TLZ_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(330001);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end

	if( g_FrameInfo == FrameInfoList.GONGLIDAN_USE_CONFIRM ) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnSetPower");
			Set_XSCRIPT_ScriptID(335815);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end

	--É¾³ýÊ ·Ñ±íÇé
	if g_FrameInfo == FrameInfoList.UNINSTALL_EMO then
		DataPool:LuaFnUnInstallEmo(g_currentIndex, 1)
		g_currentIndex = 0
		return
	end

	--É¾³ýÊ ·ÑÐÝÏÐ¶¯×÷°ü
	if (g_FrameInfo == FrameInfoList.UNINSTALL_CHAT_ACTION) then
		DataPool : UnInstall_RMB_ChatAction(g_currentIndex , 1)
		g_currentIndex = 0
		return
	end

	--È·ÈÏ¿ªÊ¼×Ô¶¯Ñ°Â·
	if(g_FrameInfo == FrameInfoList.AUTOMOVE_CONFIRM_NOPKVALUE) then
		StartAutoMove()
		this:Hide()
	end


	--È·ÈÏ¿ªÊ¼×Ô¶¯Ñ°Â·
	if(g_FrameInfo == FrameInfoList.AUTOMOVE_CONFIRM_UPPKVALUE) then
		StartAutoMove()
		this:Hide()
	end

	if( g_FrameInfo == FrameInfoList.ROSERANK_EXCHANGE_CONFIRM ) then
		if g_msgFrameVar[1] == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
				Set_XSCRIPT_ScriptID( 891056 )
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
		elseif g_msgFrameVar[1] == 2 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "Chiqingyu_Exchange" )
				Set_XSCRIPT_ScriptID( 891056 )
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
		end
	end

	--2015ÆßÏ¦ÇéÈË½ÚÅÅÐÐ°ñ¶Ò»»¶þ´ÎÈ·ÈÏ
	if( g_FrameInfo == FrameInfoList.QIXIRANK_EXCHANGE_CONFIRM ) then
		if g_msgFrameVar[1] == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
				Set_XSCRIPT_ScriptID( 891396 )
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
		end
	end

	--ÇéÈË½ÚÅÅÐÐ°ñ¶Ò»»¶þ´ÎÈ·ÈÏ
	if( g_FrameInfo == FrameInfoList.QINGRENJIERANK_EXCHANGE_CONFIRM ) then
		if g_msgFrameVar[1] == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "Qingrenjie_Exchange" )
				Set_XSCRIPT_ScriptID( 892974 )
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
		end
	end

	if(g_FrameInfo == FrameInfoList.YJFS_LEAVE_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("LeaveTable");
			Set_XSCRIPT_ScriptID(890223);
			Set_XSCRIPT_Parameter(0, 1);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end

	--ÔÂ¿¨
	if(g_FrameInfo == FrameInfoList.MESSAGE_MONTH_CARD) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnUseMonthCard");
			Set_XSCRIPT_ScriptID(892666);
			Set_XSCRIPT_Parameter(0, 1);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	
	--ÔÂ¿¨
	if(g_FrameInfo == FrameInfoList.MESSAGE_MONTH_CARD2) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnUseMonthCard2");
			Set_XSCRIPT_ScriptID(892666);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end

	--»ØÁ÷Ó¢ÐÛÖØ·µ
	if(g_FrameInfo == FrameInfoList.HEROS_RETURNS_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name( "OnBuyShopItem" )
			Set_XSCRIPT_ScriptID(808110)
			Set_XSCRIPT_Parameter(0,g_MessageBoxSelf_Data[1])
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end

	-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
	if(g_FrameInfo == FrameInfoList.HEXINCHUN_YBCONFIRM) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetReward")
			Set_XSCRIPT_ScriptID(892663)
			Set_XSCRIPT_Parameter(0,g_HeXinChun_Data)
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

	--ÖÜÄêÎÈ»îÔÂ¿ªÑçÏ¯-2021Äê-by yuanpeilong
	if(g_FrameInfo == FrameInfoList.CONFIRM_KAIYANXI_DUIHUAN) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DuiHuan_True")
			Set_XSCRIPT_ScriptID(891176)
			Set_XSCRIPT_Parameter(0,g_KaiYanXiDuiHuan_Data)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end

	--//2022ÊÞ»ê°æ±¾Ô¤ÈÈ-ypl
	if(g_FrameInfo == FrameInfoList.CONFIRM_2022_PETYURE) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnTwoSubmit")
			Set_XSCRIPT_ScriptID(893108)
			Set_XSCRIPT_Parameter(0,g_2022PetYuRe_Data)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end

	if (g_FrameInfo == FrameInfoList.CHANGE_NAME_RETOK ) then
		EnterQuitWait(1);
		return
	end
	
	if g_FrameInfo == FrameInfoList.BUY_SUPERASS_FASHION_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("BuyFashionCloth")
			Set_XSCRIPT_ScriptID(888818)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.WHWG_ACTIVE_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ActiveWg")
			Set_XSCRIPT_ScriptID(888800)
			Set_XSCRIPT_Parameter(0, Dart_Data[1])
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
	if g_FrameInfo == FrameInfoList.BUY_PLAYERSHOP_SECOND_CONFIRM then
		PlayerShop:BuyShop()
	end

	if g_FrameInfo == FrameInfoList.EXTERIOR_RIDE_EQUIP_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirm")
			Set_XSCRIPT_ScriptID(999801)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1,g_msgFrameVar[2])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.EXTERIOR_RIDE_ITEM_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirm")
			Set_XSCRIPT_ScriptID(999901)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1,g_msgFrameVar[2])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end
	
	if g_FrameInfo == FrameInfoList.RIDE_CARD_USE_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirm")
			Set_XSCRIPT_ScriptID(999905)
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.PETSOUL_ADDLIFE_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 800127 )
			Set_XSCRIPT_Function_Name( "OnPetSoulAddlife" )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_Parameter(3, g_msgFrameVar[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.PETSOUL_SMASH_CONFIRMLEVEL then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 800128 )
			Set_XSCRIPT_Function_Name( "OnPetSoulSmash" )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.PETSOUL_SMASH_CONFIRMQUAL then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 800128 )
			Set_XSCRIPT_Function_Name( "OnPetSoulSmash" )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_Parameter(3, 1)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.PETSOUL_LEVELDOWN_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 800128 )
			Set_XSCRIPT_Function_Name( "OnPetSoulLevelDown" )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[3])
			Set_XSCRIPT_Parameter(3, 1)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
		this:Hide()
	end
	
	
	if g_FrameInfo == FrameInfoList.SHENGWANG_SAODANG_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 890086 )
			Set_XSCRIPT_Function_Name( "SaoDangConfirm" )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[3])
			Set_XSCRIPT_Parameter(3, g_msgFrameVar[4])
			Set_XSCRIPT_Parameter(4, g_msgFrameVar[5])
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.CONFIRM_QTESIGNIN_CLOSE then
		PushEvent("UI_COMMAND", 89308904)
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.UNLOCK_EXTERIOR_POSS_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("UnlockExteriorPoss")
			Set_XSCRIPT_ScriptID(999903)
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

	if g_FrameInfo == FrameInfoList.EXTERIOR_WEAPON_ITEM_CONFIRM then
		Exterior:LuaFnSetShowShowWeaponChatMoodTips(true)
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirm")
			Set_XSCRIPT_ScriptID(999904)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1,g_msgFrameVar[2])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.QIXIDAKA_MISSIN_ABANDON then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnAbandonConfirm")
			Set_XSCRIPT_ScriptID(893245)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		this:Hide()
	end
	-- [2022Q3]À­ïÚÖÜ³£»î¶¯Éè¼Æ--ÔËïÚÈ·ÈÏ
	if g_FrameInfo == FrameInfoList.CONFIRM_GUARDCONFIRM then
		if g_msgFrameVar[1] == 1 then--??
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("AskAccept")
				Set_XSCRIPT_ScriptID(888160)
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_Parameter(1,g_msgFrameVar[3])
				Set_XSCRIPT_Parameter(2,1)
				Set_XSCRIPT_ParamCount(3)
			Send_XSCRIPT()
		elseif g_msgFrameVar[1] == 2 then--??
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("AskSubmit")
				Set_XSCRIPT_ScriptID(888160)
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_Parameter(1,1)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		end
		this:Hide()
	end
	-- 2023Q2°æ±¾ÎÈ»î-ÊøÃ‘Ö®Àñ ¶þ´ÎÈ·ÈÏ
	if g_FrameInfo == FrameInfoList.CONFIRM_WENHUOSXZL then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetPrize")
			Set_XSCRIPT_ScriptID(998270)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end
	-- »Æ½ðÂí°°¶Ò»»¶þ´ÎÈ·ÈÏ
	if g_FrameInfo == FrameInfoList.MAAN_EX_CONFIRM then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("OnConfirmGet")
				Set_XSCRIPT_ScriptID(998265)
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
		this:Hide()
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_SHAXINGGIVEUP then
		-- ÐÂÉ±ÐÇ·ÅÆú¶þ´ÎÈ·ÈÏ
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GiveUpTheBoss" )
			Set_XSCRIPT_ScriptID( 893311)
			Set_XSCRIPT_Parameter( 0 ,g_msgFrameVar[1])
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_SECKILLCARDOPEN then
		-- É¨µ´ÌØÈ¨¿ª¿¨¶þ´ÎÈ·ÈÏ1ÔÂ¿¨2È ¿¨
		if g_msgFrameVar[1] == 1 then
			--ÔÂ¿¨
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "ConfirmOpenTeQuan" )
				Set_XSCRIPT_ScriptID( 891194)
				Set_XSCRIPT_ParamCount( 0 )
			Send_XSCRIPT()
		else
			--È ¿¨
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "ConfirmOpenTeQuan" )
				Set_XSCRIPT_ScriptID( 891195)
				Set_XSCRIPT_ParamCount( 0 )
			Send_XSCRIPT()
		end
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_ENTERDIGONG then
		Clear_XSCRIPT()
			if g_msgFrameVar[1] == 1 then
				Set_XSCRIPT_Function_Name("EnterScene")
				Set_XSCRIPT_ScriptID(893379)
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2] )
				Set_XSCRIPT_Parameter(1,g_msgFrameVar[3] )
				Set_XSCRIPT_Parameter(2,g_msgFrameVar[4] )
				Set_XSCRIPT_Parameter(3,g_msgFrameVar[5] )
				Set_XSCRIPT_Parameter(4,0 )
				Set_XSCRIPT_ParamCount(5)
			elseif g_msgFrameVar[1] == 2 then
				Set_XSCRIPT_Function_Name("EnterSceneSiCeng")
				Set_XSCRIPT_ScriptID(893379)
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2] )
				Set_XSCRIPT_Parameter(1,g_msgFrameVar[3] )
				Set_XSCRIPT_Parameter(2,g_msgFrameVar[4] )
				Set_XSCRIPT_Parameter(3,g_msgFrameVar[5] )
				Set_XSCRIPT_Parameter(4,0 )
				Set_XSCRIPT_ParamCount(5)
			else
				return
			end
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.ZHANLING_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("BuyZhanLing")
			Set_XSCRIPT_ScriptID(890215)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		this:Hide()
	end
	
	if g_FrameInfo == FrameInfoList.BUY_YUEKA_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ActiveYueKa")
			Set_XSCRIPT_ScriptID(998526)
			Set_XSCRIPT_Parameter(0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		this:Hide()
	end
	
	if g_FrameInfo == FrameInfoList.BUY_YUEKA_PROGRESS_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("AskAddProgress")
			Set_XSCRIPT_ScriptID(998526)
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1] )
			Set_XSCRIPT_Parameter(1, 1 )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end
	
	if g_FrameInfo == FrameInfoList.MK_EXPRESSING_EMOTIONS then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ExpressingEmotions")
			Set_XSCRIPT_ScriptID(018114)
			Set_XSCRIPT_Parameter(0, g_MK_EP_EM_N )
			Set_XSCRIPT_Parameter(1, g_MK_EP_EM_M )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_COLLECT_CRYSTAIL then
		Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("ClientConfirm")
				Set_XSCRIPT_ScriptID(292005)
				Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.WEEDING_PLANE_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnSelectPlane")
			Set_XSCRIPT_ScriptID(g_msgFrameVar[5] )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[4] )
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[1] )
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[2] )
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.COUPLE_FASHION_ADD_CONFIRM then
		Exterior:LuaFnExteriorAddCoupleFashion(g_msgFrameVar[1])
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.COUPLE_FASHION_MOVE_CONFIRM then
		Exterior:LuaFnExteriorMoveCoupleFashion(g_msgFrameVar[1])
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.COUPLE_VAULT_ADD_CONFIRM then
		CoupleZone:LuaFnCoupleInYBOrMoney( g_msgFrameVar[1], g_msgFrameVar[2], g_msgFrameVar[3], 1 )
		this:Hide()
	end

	if g_FrameInfo == FrameInfoList.COUPLE_VAULT_OUT_CONFIRM then
		CoupleZone:LuaFnCoupleOutYBOrMoney( g_msgFrameVar[1], g_msgFrameVar[2], g_msgFrameVar[3], 1 )
		this:Hide()
	end
	if g_FrameInfo == FrameInfoList.WHQ_CONFIRM_BWZQ_SELECTLOVE then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "BWZQSelectLove" )
			Set_XSCRIPT_ScriptID( 792102 )
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
		this:Hide()
	end
	if (g_FrameInfo == FrameInfoList.DLZX_FLAG_CHANGEPKMODE) then
		Player:ChangePVPMode(4)
		this:Hide()
	end

	-- ÎäµÀÈýÈÎÎñ2Àë¿ª¸±±¾
	if(g_FrameInfo == FrameInfoList.JINGJINMISSION2_LEAVE) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ConfimLeave")
			Set_XSCRIPT_ScriptID(998361)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
		-- ÎäµÀÈýÈÎÎñ3Àë¿ª¸±±¾
	if(g_FrameInfo == FrameInfoList.JINGJINMISSION3_LEAVE) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ConfimLeave")
			Set_XSCRIPT_ScriptID(998364)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end


	--Ç¿»¯Â¶¶Ò»»¶þ´ÎÈ·ÈÏ
	if g_FrameInfo == FrameInfoList.QIANGHUALU_EX_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirmJingHua")
			Set_XSCRIPT_ScriptID(998265)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		this:Hide()
	end


	--½ð¸ ï±¶Ò»»¶þ´ÎÈ·ÈÏ
	if g_FrameInfo == FrameInfoList.JINGGANGCUO_EX_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirmJinGangSha")
			Set_XSCRIPT_ScriptID(998265)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		this:Hide()
	end
	
	if g_FrameInfo == FrameInfoList.SHENBING_TRANSITION_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888812)
			Set_XSCRIPT_Function_Name("ShenBingTransition")
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_Parameter(4, 1)
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.SHENBING_LEVELUP_BIND_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888812)
			Set_XSCRIPT_Function_Name("ShenBingLevelUp")
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.SHENBING_TRANSITION_BIND_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888812)
			Set_XSCRIPT_Function_Name("ShenBingTransition")
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_Parameter(4, 0)
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.SHENBING_SKILL_ACTIVE_BIND_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888815)
			Set_XSCRIPT_Function_Name("ShenBingUnlockSkill")
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.SHENBING_SKILL_LEVELUP_BIND_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(888815)
			Set_XSCRIPT_Function_Name("ShenBingSkillUp")
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_Parameter(2, g_msgFrameVar[3])
			Set_XSCRIPT_Parameter(3, 0)
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.RMB_EMO_INSTALL_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("InstallOnConfirm")
			Set_XSCRIPT_ScriptID(890006)
			Set_XSCRIPT_Parameter(0, g_msgFrameVar[1])
			Set_XSCRIPT_Parameter(1, g_msgFrameVar[2])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_BUYITEM then
		PushEvent("DAHUASHOP_BUYITEM_ONCONFIRMED")
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_BUYDAIBI then
		PushEvent("DAHUASHOP_BUYDAIBI_ONCONFIRMED")
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_LIXIA then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "BuyLiHe" )
			Set_XSCRIPT_ScriptID(999299)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end
end

function MessageBox_OnOKClick()
	if( strMessageData == "EquipBind" ) then -- ??
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end

	if( strMessageData == "DressProtected" ) then -- ??
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end

	if(strMessageData == "YiGuiDressBind" ) then
	    YiGui:EquipDressWithoutAskBind(tonumber( strMessageArgs ))
	end

	this:Hide();
end
--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function MessageBox_Self_OK_Clicked()

	if g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM then
		SafeBox("reallock");
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM then
		SafeBox("realunlock");
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.CITY_RANAME_CONFIRM then
		Guild : SendCityRnameMsg( g_arg_circ )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.CHAR_RANAME_CONFIRM then
		Target : SendCharRnameMsg( g_arg_chrc )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.CHANGE_NAME_CONFIRM then
		Target : SendChangeNameMsg( g_arg_chrc )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		LifeAbility : Do_Combine( GemCombinedData[1], GemCombinedData[2],
			GemCombinedData[3], GemCombinedData[4],
			GemCombinedData[5], GemCombinedData[6], 1 )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM then
		LifeAbility : Do_Enchase( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

-- add:lby20080527È·ÈÏ4ÏâÇ¶ENCHASE_FOUR_CONFIRM
	if g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM then
		LifeAbility : Do_Enchase_Four( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

	-- ³èÎïÑ§Ï°¼¼ÄÜÈ·ÈÏ£ºÁ½¸öÊÖ¶¯¼¼ÄÜÑ§Ï°
	if g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM then
		Pet:ConfirmPetSkillStudy()
		this:Hide()
		return
	end

--	if g_FrameInfo == FrameInfoList.CARVE_CONFIRM then
--	  Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name(CarveData[1]);
--		Set_XSCRIPT_ScriptID(CarveData[2]);
--		Set_XSCRIPT_Parameter(0,CarveData[3]);
--		Set_XSCRIPT_Parameter(1,CarveData[4]);
--		Set_XSCRIPT_ParamCount(CarveData[5]);
--	  Send_XSCRIPT();
--		this:Hide()
--		return
--	end


	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--Í¨Öª·þÎñÆ÷¾ö¶¨¿ªÊ¼ÔÚ âÀï°ÚÌ¯
		StallSale:AgreeBeginStall();

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--Í¨ÖªÏú»ÙÎïÆ·
		local equipQual = DiscardEquipQual() --???? ?????0
		local equipStar = equipQual

		local nNeedQueRen = DataPool:GetDestroyErciQueRen()
		if equipStar >= 7 and nNeedQueRen ~= 0 then
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = equipStar
			g_FrameInfo=FrameInfoList.DISCARD_QUAL8ITEM_FRAME
			MessageBox_Self_UpdateFrame()
			return
		else
			--Í¨ÖªÏú»ÙÎïÆ·
			DiscardItem();
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_QUAL8ITEM_FRAME) then
		local nNeedQueRen = MessageBox_Self_CheckBtn:GetCheck()
		-- ÉèÖÃ±ê¼Ç£¬Ö®ºó²»ÔÙµ¯¶þ´ÎÈ·ÈÏ´°
		if nNeedQueRen > 0 then
			DataPool:SetDestroyErciQueRen()
		end

		DiscardItem();
	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		--ÈÎÎñÎïÆ·²»ÄÜÏú»Ù
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		--Í¨Öª¼ÓËøÎïÆ·
		LockAfterConfirm();

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		--·ÅÆúÈÎÎñ
		if(Quest_Number > -1) then
			QuestFrameMissionAbnegate(Quest_Number);
		end
		g_InitiativeClose = 1;
		this:Hide();


	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		Guild:CreateGuildConfirm(1);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		Guild:CreateGuildConfirm(2);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DIS_FIRSTMAN) then
		-- ³·ÏúµÚÒ»¼Ì³ÐÈËÈ·ÈÏ
		Guild:UnSetFirstMan();
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		-- °ï»á³ÉÁ¢ÐèÍæ¼ÒÈ·ÈÏ
		Guild:CreateGuildConfirm(3);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		Pet : Go_Free(Pet_Number);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		--Íæ¼ÒÉÌµê¸üÃûÐèÒªµÄ½ðÇ®Êý×Ö
		PlayerShop:Modify("name_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--Íæ¼ÒÉÌµê¸ü¸ü¸ÄÉÌµêËµÃ÷ÐèÒªµÄ½ðÇ®Êý×Ö
		PlayerShop:Modify("ad_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		PlayerShop:ApplyMoney("immitbase_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		PlayerShop:ApplyMoney("immit_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name(Server_Script_Function_Set[1])
			Set_XSCRIPT_ScriptID(Server_Script_ID);
			Set_XSCRIPT_Parameter(0,Server_Return_1);
			Set_XSCRIPT_Parameter(1,Server_Return_2);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL_EXT)    then
		local count = Server_Return_Params[0]
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(Server_Script_ID)
			Set_XSCRIPT_Function_Name(Server_Script_Function_Set[1])
			Set_XSCRIPT_ParamCount(count)
			for i=1, count do
				Set_XSCRIPT_Parameter(i-1,Server_Return_Params[i])
			end
		Send_XSCRIPT()

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)    then
		PlayerShop:ChangeShopNum("add_ok");
	end

	if( g_FrameInfo == FrameInfoList.EQUIP_ITEM ) then
		MessageBox_OnOKClick();
		return;
	end

	if g_FrameInfo == FrameInfoList.JIYUAN_SHOP_CONFIRM then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("buyitem")
		Set_XSCRIPT_ScriptID( 893113 )
		Set_XSCRIPT_Parameter( 0, g_CityData[3] );
		Set_XSCRIPT_Parameter( 1, g_CityData[1]  );
		Set_XSCRIPT_ParamCount( 2 );
		Send_XSCRIPT()
	end


	if g_FrameInfo == FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("YBbuyitem")
		Set_XSCRIPT_ScriptID( 890063 )
		Set_XSCRIPT_Parameter( 0, g_msgFrameVar[4] );
		Set_XSCRIPT_Parameter( 1, g_msgFrameVar[3] );
		Set_XSCRIPT_Parameter( 2, g_msgFrameVar[1]  );
		Set_XSCRIPT_ParamCount( 3 );
		Send_XSCRIPT()
	end

	if g_FrameInfo == FrameInfoList.FANLI_SHOP_CONFIRM then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("buyitem")
		Set_XSCRIPT_ScriptID( 181000 )
		Set_XSCRIPT_Parameter( 0, g_CityData[3] );
		Set_XSCRIPT_Parameter( 1, g_CityData[1]  );
		Set_XSCRIPT_ParamCount( 2 );
		Send_XSCRIPT()
	end

	-- È·ÈÏ½âÉ¢¶ÓÎé			add by WTT	20090212
	if g_FrameInfo == FrameInfoList.DISMISS_TEAM then
		Player:ConfirmDismissTeam()
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.DART_ADJUST then
		if IsWindowShow("AnqiShuxing") or IsWindowShow("AnqiShuxingNEW") then
			MessageBox_Self_AdjustDart()
		end
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.TRUST_FRIEND then
		DataPool : DelTrustFriend( g_currentIndex );
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.TEAMBOARD_OPEN_DEL_CHECK then
		if g_TeamBoardWindow ~= -1 then
			TeamBoardDataPool:DelInfo(g_TeamBoardWindow);
			if g_TeamBoardWindow == 1 then
				CloseWindow("TeamPTZhaomuWindow")
			else
				CloseWindow("TeamPTFindWindow")
			end
		end
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.KFS_RESET_GROWRATE then
		if IsWindowShow("WuhunSkillStudy") then
			if KFS_Data[1] == 1 then
				PlayerPackage:Kfs_Op_Do(11 , KFS_Data[2],0,1)
			elseif KFS_Data[1] == 2 then
				PlayerPackage:Kfs_Op_Do(12 , KFS_Data[2],0,1)
			end
		end
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.SONGLIAOWAR_XXS_CANCELBUF_CONFIRM then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CancelImpact");
			Set_XSCRIPT_ScriptID(502019);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.SONGLIAOWAR_REST_EXIT_CONFIRM then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ExitRest")
			Set_XSCRIPT_ScriptID(502019)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT();
		this:Hide()
		return
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION)    then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpouseImmigrationCallBack")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,ImmigArg1)
		Set_XSCRIPT_Parameter(1,ImmigArg2)
		Set_XSCRIPT_Parameter(2,1)
		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_CANCEL_IMMIGRATION)    then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpuoseCancelImmg_confirm")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,ImmigArg1)
		Set_XSCRIPT_Parameter(1,ImmigArg2)
		Set_XSCRIPT_Parameter(2,1)
		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif g_FrameInfo == FrameInfoList.MISSION_XIULIAN_CONFIRM then
		QuestFrameOptionClicked( -1, 891273, g_msgFrameVar[1])
		g_msgFrameVar[1] = 0
	elseif g_FrameInfo == FrameInfoList.CHAI_JIE_DIAO_WEN then
		PushEvent("SURE_DWCHAIJIE")
	elseif g_FrameInfo == FrameInfoList.ACTIVITY_WABAO_23Q3 then
		if g_BaoTuInfo.targetId >= 0 then
			if g_BaoTuInfo.itemId == 8513 or g_BaoTuInfo.itemId == 8514 then
				Clear_XSCRIPT()
					Set_XSCRIPT_Function_Name("OnAcceptZDH")
					Set_XSCRIPT_ScriptID(893185)
					Set_XSCRIPT_Parameter(0, g_BaoTuInfo.targetId)
					Set_XSCRIPT_Parameter(1, g_BaoTuInfo.itemId)
					Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT()
			elseif g_BaoTuInfo.itemId >= 0 then
				Clear_XSCRIPT()
					Set_XSCRIPT_Function_Name("OnGetBaoTu")
					Set_XSCRIPT_ScriptID(250553)
					Set_XSCRIPT_Parameter(0, g_BaoTuInfo.targetId)
					Set_XSCRIPT_Parameter(1, g_BaoTuInfo.itemId)
					Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT()
			end
			g_BaoTuInfo.targetId = -1
			g_BaoTuInfo.itemId = -1
		end
	end

	if g_FrameInfo == FrameInfoList.CONFIRM_FESTIVAL_SHOP then

		Player:Lua_AskBuyFestivalShopItem(tonumber(g_msgFrameVar[1]),1,g_msgFrameVar[2])
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_EXTERIOR_FASHION001 then
		Exterior:LuaFnSaveExteriorAllChange(0)
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_EXTERIOR_FASHION002 then
		Exterior:LuaFnExteriorFashionOperation(g_msgFrameVar[1], g_msgFrameVar[2], g_msgFrameVar[3], g_msgFrameVar[4])
	end

	if g_FrameInfo == FrameInfoList.CONFIRM_EXTERIOR_REPLACE then
		Exterior:LuaFnExteriorPlayerSaveSharePlan(g_msgFrameVar[1], 0)
	end
	
	-- È·ÈÏ½âÉ¢°ï»á
	if(g_FrameInfo == FrameInfoList.DISCARD_GUILD) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DestroyGuild");
			Set_XSCRIPT_ScriptID(000030);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end
	
	MessageBox_Self_OK_Clicked_Ex();
	this:Hide();
end

function MessageBox_Self_PetSyn_OK_Clicked()
	Pet:Syn_Do(g_CityData[1], g_CityData[2]);
	g_CityData = {};
end
--===============================================
-- ·ÅÆú°ÚÌ¯(IDCONCEL)
--===============================================
function MessageBox_Self_Cancel_Clicked(bClick)
	if( 1 == bClick ) then
		--AxTrace( 0, 0, bClick )
		if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
		end
    end

	if ( g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME ) then
		--Í¨Öª½â³ýËø¶¨
		DiscardItemCancelLocked();
	elseif ( g_FrameInfo == FrameInfoList.DISCARD_QUAL8ITEM_FRAME ) then
		DiscardItemCancelLocked();

    elseif ( g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME ) then
		--Í¨Öª½â³ý¼ÓËø
		CancelLockAfterConfirm();

	elseif ( g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_DIS_FIRSTMAN ) then
		this:Hide();
	elseif ( g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM ) then
		Guild:CreateGuildConfirm(0);

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_Cancel_Clicked();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		g_CityData = {};
	-- add by zchw
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		this:Hide();
	elseif g_FrameInfo == FrameInfoList.ACTIVITY_WABAO_23Q3 then
		MessageBox_Self_OnComfirmGetMap_Cancel()
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		if bClick == 1 then
			PushEvent(462, 1); --PETPROCREATE_KEY_STATE
		end
		this:Hide();
	elseif g_FrameInfo == FrameInfoList.CONFIRM_QIXI_QUEQIANG then
		this:Hide();
	elseif g_FrameInfo == FrameInfoList.CONFIRM_RELIVE_SPECIALITEM then
		this:Hide();
	elseif( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		if bClick == 1 then
			StallSale:CloseStall("cancel");
			-- add by zchw
			StallSale:CloseStallMessage();
		end
		-- add by zchw
		StallSale:CloseStallMessage();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		g_CityData = {};
--	elseif( g_FrameInfo == FrameInfoList.SERVER_CONTROL ) then
--		Clear_XSCRIPT();
--			Set_XSCRIPT_Function_Name(Server_Script_Function);
--			Set_XSCRIPT_ScriptID(Server_Script_ID);
--			Set_XSCRIPT_Parameter(0,Server_Return_1);
--			Set_XSCRIPT_Parameter(1,-1);
--			Set_XSCRIPT_ParamCount(2);
--		Send_XSCRIPT();
	elseif(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx ~=nil and tonumber(Recycle_Bag_idx)>0) then
			PlayerShop:CancelSellItem2RecycleShop(Recycle_Bag_idx);
		end
	end

	--È¡ÏûÉ¾³ýÊ ·Ñ±íÇé
	if (g_FrameInfo == FrameInfoList.UNINSTALL_EMO) then
		g_currentIndex = 0
	end

	--È¡ÏûÉ¾³ýÊ ·ÑÐÝÏÐ¶¯×÷
	if (g_FrameInfo == FrameInfoList.UNINSTALL_CHAT_ACTION) then
		g_currentIndex = 0
	end

	if("NET_CLOSE" == g_LastEvent) then
		local ServerName=Variable:GetVariable("Login_ServerName")
		local SceneId = GetSceneID()
		if(SceneId~=nil and ServerName~= nil) then
			local keyValue = Player:SendReportMsg(ServerName,tostring(SceneId))
			g_LastEvent = ""
		end
	end

	if g_FrameInfo == FrameInfoList.SERVER_CONTROL and bClick == 1 then
		--µãÈ¡ÏûµÄrpc
		if Server_Script_Function_Set[2] and Server_Script_Function_Set[2] ~= "" then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name(Server_Script_Function_Set[2])
				Set_XSCRIPT_ScriptID(Server_Script_ID);
				Set_XSCRIPT_Parameter(0,Server_Return_1);
				Set_XSCRIPT_Parameter(1,Server_Return_2);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		end
	end

	if g_FrameInfo == FrameInfoList.CONFIRM_IMMIGRATION   and bClick == 1 then
		--ÒÆÃñÈ¡Ïû
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpouseImmigrationCallBack")
		Set_XSCRIPT_ScriptID(807012)

		Set_XSCRIPT_Parameter(0,ImmigArg1)
		Set_XSCRIPT_Parameter(1,ImmigArg2)
		Set_XSCRIPT_Parameter(2,0)
		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_CANCEL_IMMIGRATION   and bClick == 1 then
		--ÒÆÃñÈ¡Ïû
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SpuoseCancelImmg_confirm")
		Set_XSCRIPT_ScriptID(807012)
		Set_XSCRIPT_Parameter(0,ImmigArg1)
		Set_XSCRIPT_Parameter(1,ImmigArg2)
		Set_XSCRIPT_Parameter(2,0)
		Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end

	if g_FrameInfo == FrameInfoList.WEEDING_PLANE_CONFIRM   and bClick == 1 and g_msgFrameVar[1] == 3 then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnCancelConfirm")
		Set_XSCRIPT_ScriptID(g_msgFrameVar[5])
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()

		PushDebugMessage("#{JHYH_230330_136}")
	end

	if bClick == 1 and g_FrameInfo == FrameInfoList.CONFIRM_DAHUAQIXI_BUYITEM then
		PushEvent("DAHUASHOP_BUYITEM_ONCANCELLED")
	end

	this:Hide();
end

function MessageBox_Self_Help()
	if( g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE ) then
		Helper:GotoHelper( "61" );
	else
		Helper:GotoHelper("*MessageBox_Self");
	end
end


function MessageBox_Self_ShowDart()
	if (Dart_Data[1] >=1 and Dart_Data[1] <= 5) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_2}" ); --???
	elseif (Dart_Data[1] == 6) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_1}" ); --???
	elseif (Dart_Data[1] == 7) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_5}" ); --????
	elseif (Dart_Data[1] == 8) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_4}" ); --????
	elseif (Dart_Data[1] == 9) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_3}" ); --???
	end

	MessageBox_Self_DragTitle:SetText("");
	MessageBox_Self_UpdateRect();

	this:Show();
	MessageBox_Self_OK_Button:Show();
	MessageBox_Self_Cancel_Button:Show();
end


function MessageBox_Self_AdjustDart()
	if (Dart_Data[1] >=1 and Dart_Data[1] <= 5) then
		DataPool:DarkAdjustAttr(Dart_Data[2], Dart_Data[1], 1);	--???
	elseif (Dart_Data[1] == 6) then
		--	DataPool:DarkAdjustSkill(Dart_Data[2] , 1);		--ÍüÎÞÊ¯
		--Ï´¼¼ÄÜ
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DarkSkillAdjustForBagItem");
			Set_XSCRIPT_ScriptID(332207);
			Set_XSCRIPT_Parameter(0,Dart_Data[2]);
			Set_XSCRIPT_Parameter(1,1);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (Dart_Data[1] == 7) then
		DataPool:DarkResetQuality(Dart_Data[2], 1, 1);    --????
	elseif (Dart_Data[1] == 8) then
		DataPool:DarkResetQuality(Dart_Data[2], 2, 1);    --????
	elseif (Dart_Data[1] == 9) then
		DataPool:DarkReset(Dart_Data[2], 1);		--???
	end
end

function MessageBox_GetNeedUseConfirmItemShowTxt( itemTblIdx )
	--»ñÈ¡ÏÔÊ¾ÄÚÈÝ
	for _, item in UseConfirmItemShowTxt do
		if ( itemTblIdx == item.idx ) then
			return item.txt;
		end
	end
	return nil;
end

function MessageBox_Self_WHWG_Active_Confirm()

	MessageBox_Self_DragTitle:SetText("")

	local wgID = Dart_Data[1]

	local strName = DataPool:LuaFnGetWHWGInfo(wgID, "Name")
	local need_item = DataPool:LuaFnGetWHWGInfo(wgID, "ActiveItem")
	local need_item_count = DataPool:LuaFnGetWHWGInfo(wgID, "ActiveItemCount")
	local need_money = DataPool:LuaFnGetWHWGInfo(wgID, "ActiveCost")
	local item_name = DataPool:LuaFnGetItemNameByTableIndex(need_item)

	local strTemp = ScriptGlobal_Format("#{WH_210223_82}", tostring(strName), tostring(need_item_count), tostring(item_name), tostring(need_money))
	MessageBox_Self_Text:SetText(strTemp)

	MessageBox_Self_UpdateRect()

	this:Show()
	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()


end

function MessageBox_Self_RideCard_Confirm()
	
	g_FrameInfo = FrameInfoList.RIDE_CARD_USE_CONFIRM
	
	local iBagIndex = g_msgFrameVar[1]
	
	MessageBox_Self_DragTitle:SetText("#{ZJYK_231019_15}")
	
	local itemName = PlayerPackage:GetBagItemName(iBagIndex)
	local strTemp = ScriptGlobal_Format("#{ZJYK_231019_16}", itemName)
	MessageBox_Self_Text:SetText(strTemp)
	this:Show()
end

function MessageBox_Self_ExteriorRide_Confirm(flag)

	if flag == 0 then
		g_FrameInfo = FrameInfoList.EXTERIOR_RIDE_EQUIP_CONFIRM
	else
		g_FrameInfo = FrameInfoList.EXTERIOR_RIDE_ITEM_CONFIRM
	end

	MessageBox_Self_DragTitle:SetText("")

	local nExteriorID = g_msgFrameVar[3]
	local nLeftTime = g_msgFrameVar[4]
	local nAddLimitTime = g_msgFrameVar[5]

	local strName = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Name")

	local strTemp = ""
	if nLeftTime > 0 then
		--ÓÀ¾Ã×øÆï
		if nAddLimitTime < 0 then
			--µÀ¾ßÊ¹ÓÃ³É¹¦ºó£¬¿É½«AAA±ä¸üÎªÓÀ¾Ã×øÆï£¬ÄúÈ·¶¨ÒªÊ¹ÓÃÂð
			strTemp = ScriptGlobal_Format("#{WGTJ_200617_67}", strName)
		else
			if nLeftTime + nAddLimitTime*60 > 365*24*60*60 then
				strTemp = ScriptGlobal_Format("#{WGTJ_201222_115}", strName)
			else
				local strAddTime = ""
				if nAddLimitTime >= 1440 then
					local nAddDay = math.floor(nAddLimitTime / 1440)
					strAddTime = ScriptGlobal_Format("#{WGTJ_201222_94}", tostring(nAddDay))
				elseif nAddLimitTime >= 60 then
					local nAddHour = math.floor(nAddLimitTime / 60)
					strAddTime = ScriptGlobal_Format("#{WGTJ_201222_95}", tostring(nAddHour))
				else
					strAddTime = "#{WGTJ_201222_96}"
				end
				strTemp = ScriptGlobal_Format("#{WGTJ_201222_36}", strName, strAddTime)
			end
		end
	else
		--ÓÀ¾Ã×øÆï
		if nAddLimitTime < 0 then
			--µÀ¾ßÊ¹ÓÃ³É¹¦ºó£¬¿É½«AAA±ä¸üÎªÓÀ¾Ã×øÆï£¬ÄúÈ·¶¨ÒªÊ¹ÓÃÂð
			strTemp = ScriptGlobal_Format("#{WGTJ_200617_67}", strName)
		else
			local strAddTime = ""
			if nAddLimitTime >= 1440 then
				local nAddDay = math.floor(nAddLimitTime / 1440)
				strAddTime = ScriptGlobal_Format("#{WGTJ_201222_94}", tostring(nAddDay))
			elseif nAddLimitTime >= 60 then
				local nAddHour = math.floor(nAddLimitTime / 60)
				strAddTime = ScriptGlobal_Format("#{WGTJ_201222_95}", tostring(nAddHour))
			else
				strAddTime = "#{WGTJ_201222_96}"
			end
			strTemp = ScriptGlobal_Format("#{WGTJ_201222_38}", strName, strAddTime)
		end
	end

	MessageBox_Self_Text:SetText(strTemp)

	this:Show()
end

function MessageBox_Self_PetSoulAddlife_Confirm()

	g_FrameInfo = FrameInfoList.PETSOUL_ADDLIFE_CONFIRM

	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_Text:SetText("#{SHXT_20211230_105}")

	this:Show()
end

function MessageBox_Self_PetPetSoulSmash_ConfirmLevel()

	g_FrameInfo = FrameInfoList.PETSOUL_SMASH_CONFIRMLEVEL

	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_Text:SetText("#{SHXT_221104_9}")

	this:Show()
end

function MessageBox_Self_PetPetSoulSmash_ConfirmQual()

	g_FrameInfo = FrameInfoList.PETSOUL_SMASH_CONFIRMQUAL

	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_Text:SetText("#{SHXT_20211230_139}")

	this:Show()
end

function MessageBox_Self_PetPetSoulLevelDown_Confirm()

	g_FrameInfo = FrameInfoList.PETSOUL_LEVELDOWN_CONFIRM

	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_Text:SetText("#{SHXT_20211230_286}")

	this:Show()
end

function MessageBox_Self_ShengWangSaoDang_Confirm()
	g_FrameInfo = FrameInfoList.SHENGWANG_SAODANG_CONFIRM

	MessageBox_Self_DragTitle:SetText("")
	local nNum =g_msgFrameVar[1]
	local nJiaoZi =g_msgFrameVar[2]
	local nbouns =g_msgFrameVar[3]
	local strTemp = ScriptGlobal_Format("#{SWXT_230919_5}", nNum, nJiaoZi,nbouns)
	MessageBox_Self_Text:SetText(strTemp)

	this:Show()
end

function MessageBox_Self_QTESignInClose_Confirm()

	g_FrameInfo = FrameInfoList.CONFIRM_QTESIGNIN_CLOSE

	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_Text:SetText("#{BBYJ_220104_65}")
	MessageBox_Self_OK_Button:Show();
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_UnlockExteriorPoss_Confirm()

	g_FrameInfo = FrameInfoList.UNLOCK_EXTERIOR_POSS_CONFIRM
	MessageBox_Self_DragTitle:SetText("")

	local nExteriorID = g_msgFrameVar[1]

	local strName = Exterior:LuaFnGetExteriorRideInfo(nExteriorID, "Name")
	local need_item = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "NeedItem")
	local need_item_count = Exterior:LuaFnGetExteriorPossInfo(nExteriorID, "NeedCount")

	local name, icon = LifeAbility:GetPrescr_Material(need_item)

	local strTemp = ScriptGlobal_Format("#{SHRH_20220427_49}", tostring(need_item_count), name)

	MessageBox_Self_Text:SetText(strTemp)

	this:Show()
end

function MessageBox_Self_OnConfirmGetMap()
	CancelLastOp(FrameInfoList.ACTIVITY_WABAO_23Q3)
	g_FrameInfo = FrameInfoList.ACTIVITY_WABAO_23Q3
	g_BaoTuInfo.targetId = Get_XParam_INT(0)
	g_BaoTuInfo.itemId = Get_XParam_INT(1)
	local objCaredID = DataPool:GetNPCIDByServerID(g_BaoTuInfo.targetId)
	if objCaredID ~= -1 then
		this:CareObject(objCaredID, 1, "MsgBox")
	end
	if g_BaoTuInfo.itemId == 8513 then --???????
		MessageBox_Self_Text:SetText("#{WDZD_230721_11}")
	elseif g_BaoTuInfo.itemId == 8514 then --???????
		MessageBox_Self_Text:SetText("#{WDZD_230721_12}")
	else
		MessageBox_Self_Text:SetText("#{ZNWB_230625_46}")
	end
	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_OnComfirmGetMap_Cancel()
	-- PushDebugMessage("OnComfirmGetMap_Cancel")
	if g_BaoTuInfo.targetId == 0 then
		return
	end
	local objCaredID = DataPool:GetNPCIDByServerID(g_BaoTuInfo.targetId)
	if objCaredID ~= -1 then
		-- PushDebugMessage("objCaredID="..objCaredID)
		this:CareObject(objCaredID, 0, "MsgBox")
	end
	g_BaoTuInfo.targetId = 0
	g_BaoTuInfo.itemId = 0
end

function MessageBox_Self_ExteriorWeapon_Confirm()

	g_FrameInfo = FrameInfoList.EXTERIOR_WEAPON_ITEM_CONFIRM

	MessageBox_Self_DragTitle:SetText("")

	local nExteriorID = g_msgFrameVar[3]
	local nLeftTime = g_msgFrameVar[4]
	local nAddLimitTime = g_msgFrameVar[5]

	local strName = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Name")

	local bOverLoad = 0
	local nRealAddTime = nAddLimitTime
	--»ÃÎäÓÐÐ§ÆÚ½«´ïµ½365Ìì
	if nLeftTime + nAddLimitTime > 31536000 then
		nRealAddTime = 31536000 - nLeftTime
		bOverLoad = 1
	end

	local strTemp = ""
	if nLeftTime > 0 then
		--ÓÀ¾Ã
		if nAddLimitTime < 0 then
			strTemp = ScriptGlobal_Format("#{HSWQ_20220607_16}", strName)
		else
			if bOverLoad == 1 then
				strTemp = ScriptGlobal_Format("#{HSWQ_20220607_62}", strName)
			else
				local strAddTime = ""
				if nAddLimitTime >= 86400 then
					local nAddDay = math.floor(nAddLimitTime / 86400)
					strAddTime = tostring(nAddDay)
				elseif nAddLimitTime >= 3600 then
				--	local nAddHour = math.floor(nAddLimitTime / 3600)
				--	strAddTime = ScriptGlobal_Format("#{WGTJ_201222_95}", tostring(nAddHour))
				else
				--	strAddTime = "#{WGTJ_201222_96}"
				end
				strTemp = ScriptGlobal_Format("#{HSWQ_20220607_10}", strName, strAddTime)
			end
		end
	else
		--ÓÀ¾Ã
		if nAddLimitTime < 0 then
			strTemp = ScriptGlobal_Format("#{HSWQ_20220607_16}", strName)
		else
			local strAddTime = ""
			if nAddLimitTime >= 86400 then
				local nAddDay = math.floor(nAddLimitTime / 86400)
				strAddTime = tostring(nAddDay)
			elseif nAddLimitTime >= 3600 then
			--	local nAddHour = math.floor(nAddLimitTime / 3600)
			--	strAddTime = ScriptGlobal_Format("#{WGTJ_201222_95}", tostring(nAddHour))
			else
			--	strAddTime = "#{WGTJ_201222_96}"
			end
			strTemp = ScriptGlobal_Format("#{HSWQ_20220607_10}", strName, strAddTime)
		end
	end

	MessageBox_Self_Text:SetText(strTemp)

	this:Show()
end

function MessageBox_Self_OnConfirmChaiJieDW()
	CancelLastOp(FrameInfoList.CHAI_JIE_DIAO_WEN)
	g_FrameInfo = FrameInfoList.CHAI_JIE_DIAO_WEN
	local needYB = Get_XParam_INT(1)
	local getJCS = Get_XParam_INT(2)
	local itemName = PlayerPackage:GetBagItemName( Get_XParam_INT(0) )
	if itemName == nil then
		return
	end
	local thisMsg = ScriptGlobal_Format("#{DWCJJ_140606_19}", itemName, needYB, getJCS, getJCS*35)
	MessageBox_Self_Text:SetText(thisMsg)
	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_QixidakaAbandon_Confirm()
	g_FrameInfo = FrameInfoList.QIXIDAKA_MISSIN_ABANDON
	if g_msgFrameVar[1] == 1 then
		MessageBox_Self_Text:SetText("#{QXDK_20220623_67}")
	else
		MessageBox_Self_Text:SetText("#{QXDK_20220623_70}")
	end
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show();
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_ClearVar()
	for i = 1,8 do
		g_msgFrameVar[i] = 0
	end
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function MessageBox_Self_Frame_On_ResetPos()
  MessageBox_Self_Frame:SetProperty("UnifiedPosition", g_MessageBox_Self_Frame_UnifiedPosition);
end

function MessageBox_Self_ShenBing_Transition_Confirm()
	g_FrameInfo = FrameInfoList.SHENBING_TRANSITION_CONFIRM

	MessageBox_Self_Text:SetText("#{SBFW_20230707_146}")	
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_ShenBing_LevelUp_Bind_Confirm()
	g_FrameInfo = FrameInfoList.SHENBING_LEVELUP_BIND_CONFIRM

	MessageBox_Self_Text:SetText("#{SBFW_20230707_299}")
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_ShenBing_Transition_Bind_Confirm()
	g_FrameInfo = FrameInfoList.SHENBING_TRANSITION_BIND_CONFIRM

	MessageBox_Self_Text:SetText("#{SBFW_20230707_301}")
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_ShenBing_SkillActive_Bind_Confirm()
	g_FrameInfo = FrameInfoList.SHENBING_SKILL_ACTIVE_BIND_CONFIRM

	MessageBox_Self_Text:SetText("#{SBFW_20230707_300}")
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_ShenBing_SkillLevelUp_Bind_Confirm()
	g_FrameInfo = FrameInfoList.SHENBING_SKILL_LEVELUP_BIND_CONFIRM

	MessageBox_Self_Text:SetText("#{SBFW_20230707_302}")
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_BuyFashionCloth_Confirm()
	g_FrameInfo = FrameInfoList.BUY_SUPERASS_FASHION_CONFIRM
	
	local item_table_index = g_msgFrameVar[1]
	local item_name = DataPool:Lua_GetItemNameByIndex(item_table_index)

	local strTemp = ScriptGlobal_Format("#{ZQPM_240402_105}", tostring(item_name))

	MessageBox_Self_Text:SetText(strTemp)
	MessageBox_Self_DragTitle:SetText("")

	MessageBox_Self_OK_Button:Show()
	MessageBox_Self_Cancel_Button:Show()
	MessageBox_Self_UpdateRect()
	this:Show()
end

function MessageBox_Self_UseEmo_Confirm()
	g_FrameInfo = FrameInfoList.RMB_EMO_INSTALL_CONFIRM
	
	local emo_package_id = g_msgFrameVar[3] --emoid
	local bHaveEmoSet = g_msgFrameVar[4] --isHave
	local LeftTimeMin = g_msgFrameVar[5] --lefttime
	local addTimeHour = g_msgFrameVar[6] --addHour
	
	local emo_set_name = DataPool:LuaFnGetEmoSetName(emo_package_id)
	
	if bHaveEmoSet == 1 then
		if addTimeHour < 0 then
			local strTemp = ScriptGlobal_Format("#{BQB_220329_02}", tostring(emo_set_name))
			MessageBox_Self_Text:SetText(strTemp)
		else
			if addTimeHour * 60 + LeftTimeMin > 525600 then
				MessageBox_Self_Text:SetText("#{BQB_220329_07}")
			else
				local addTimeDay = math.floor(addTimeHour / 24)
				local strTemp = ScriptGlobal_Format("#{BQB_220329_10}", tostring(emo_set_name), tostring(addTimeDay))
				MessageBox_Self_Text:SetText(strTemp)
			end
		end
	else
		if addTimeHour < 0 then
			local strTemp = ScriptGlobal_Format("#{BQB_220329_12}", tostring(emo_set_name))
			MessageBox_Self_Text:SetText(strTemp)
		else
			local addTimeDay = math.floor(addTimeHour / 24)
			local strTemp = ScriptGlobal_Format("#{BQB_220329_11}", tostring(emo_set_name), tostring(addTimeDay))
			MessageBox_Self_Text:SetText(strTemp)
		end
	end
	MessageBox_Self_DragTitle:SetText("")
	MessageBox_Self_UpdateRect()
	this:Show()
end

--===============================================
-- MessageBox_Self_Check_Clicked
--===============================================
function MessageBox_Self_Check_Clicked(nIndex)
	
end
