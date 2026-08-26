local g_InitiativeClose = 0;
local g_currentList = 0;
local g_currentIndex = 0;
-- 摆摊地租提示窗口，在这里有发送给服务器的确定开始摆摊的消息
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
	TEAM_ASKJOIN				= 4,	--有人邀请你加入队伍
    TEAM_MEMBERINVERT			= 5,	--队员邀请某人加入队伍请求你同意
    TEAM_SOMEASK				= 6,	--某人申请加入队伍
    TEAM_FOLLOW		 			= 7,	--进入组队跟随模式
    FRAME_AFFIRM_SHOW 			= 8,	--进入放弃任务确认模式
    GUILD_CREATE_CONFIRM		= 9, 	--帮会创建确认模式
    SYSTEM_TIP_INFO 			= 10,	--系统提示对话框模式
    GUILD_QUIT_CONFIRM 			= 11,	--帮会退出确认模式
    GUILD_DESTORY_CONFIRM		= 12,	--帮会删除确认模式
    CALL_OF						= 13,	--拉人
    NET_CLOSE_MESSAGE			= 14,	--断开网络
    PET_FREE_CONFIRM			= 15,	--珍兽放生确认
    CITY_CONFIRM				= 16,	--城市相关确认
    SAVE_STALL_INFO				= 17,	--保存摆摊信息
    PET_SYNC_CONFIRM			= 18,	--珍兽繁殖确认
    QUIT_GAME					= 19,	--退出游戏的确认
    EQUIP_ITEM					= 20,	--装备物品
    YUANBAO_BUY_ITEM		= 21, --元宝商店购买物品确认
    CONFIRM_REMOVE_STALL	= 22,--确认撤滩 add by zchw
    PET_PROCREATE_PROMPT			= 23, -- 珍兽繁殖提示 zchw

	--这个24一定不能改，改了出错的！！！！！Chris
	SERVER_CONTROL				= 24,	--Server控制弹出的提示框
	DELETE_FRIEND_MESSAGE		= 25,	--确定删除好友的提示框

		GUILD_DIS_FIRSTMAN    =87,  --确认删除第一继承人
    GEM_COMBINED_CONFIRM		= 88,	-- 确认宝石合成
   	ENCHASE_CONFIRM					= 99,	-- 确认镶嵌
   	ENCHASE_FOUR_CONFIRM		= 100,	-- add:lby20080527确认4镶嵌

   	--CARVE_CONFIRM				= 102,	-- 确认雕琢



    PS_RENAME_MESSAGE			= 116,	--更改玩家商店店名
    PS_READ_MESSAGE				= 117,	--更改玩家商店介绍（广告）
    PS_ADD_BASE_MONEY			= 118,	--充入本金
    PS_ADD_GAIN_MONEY			= 119,	--充入盈利金
    PS_DEC_GAIN_MONEY			= 120,	--取出盈利金
    PS_ADD_STALL				= 121,	--增加柜台
    PS_DEL_STALL				= 122,	--减少柜台
    PS_INFO_PANCHU				= 123,	--商店盘出
    PS_INFO_PANRU				= 124,	--商店盘入
    PS_INFO_MODIFY_TYPE			= 125,	--更改商店类型
    PS_INFO_PANCHU_YB				= 126,	--商店盘出类型为元宝盘出
    FREEFORALL					= 201,	--FREEFORALL: 个人混战
    FREEFORTEAM					= 202,	--FREEFORTEAM： 组队混战
    FREEFORGUILD				= 203,	-- FREEFORGUILD：帮派混战
    MAKESUREPVPCHALLENGE		= 204,
    EXCHANGE_MONEY_OVERFLOW			= 205, --交易后增加玩家是否到达钱上限的判定

    GUILD_DEMIS_CONFIRM		= 206, 			--禅让确认

    COMMISION_BUY = 208, 							--寄售商店购买确认

    Player_Give_Rose		= 209,
    RECYCLE_DEL_ITEM		=210, 				--取消收购确认

    OPEN_IS_SELL_TO_RECSHOP	= 211, 		--出售物品确认

    CONFIRM_STENGTH = 212,

    CHAR_RANAME_CONFIRM = 213,

    CITY_RANAME_CONFIRM = 214,

    CONFIRM_RE_IDENTIFY = 215,

    KICK_MEMBER_MSGBOX = 216,

		SAFEBOX_LOCK_CONFIRM = 217,						--保险箱锁定确认框
		SAFEBOX_UNLOCK_CONFIRM = 218,					--保险箱解锁确认框

		LOCK_ITEM_CONFIRM_FRAME = 219,        --	加锁确认
    GUILD_LEAGUE_QUIT_CONFIRM = 220,			--	退出帮会同盟确认
    GUILD_LEAGUE_CREATE_CONFIRM = 221,		--	创建帮会同盟确认
		PET_SKILL_STUDY_CONFIRM = 222,				--	宠物学习技能确认
		EXCHANGE_BANGGONG = 223,							--	兑换帮贡牌确认
		PUT_GUILDMONEY = 224,									--	帮会资金捐助
		TLZ_CONFIRM_SETPOS = 225,							--	确认土灵珠重新定位

		DISMISS_TEAM = 226,										--	解散队伍						WTT		20090212
		DART_ADJUST = 227,	-- 暗器属性调整   Vega 20090422
		TRUST_FRIEND = 228,
		NEED_USE_CONFIRM_ITEM = 229,
		GONGLIDAN_USE_CONFIRM = 230, -- 功力丹使用确认 fsy 20091027
		KFS_RESET_GROWRATE = 231,
		UNINSTALL_EMO = 232 ,	--卸载收费表情包
		TEAMBOARD_OPEN_DEL_CHECK = 233,
		UNINSTALL_CHAT_ACTION = 234 ,					--	卸载收费休闲动作包
		--add by FengLiang
		SERVER_CONTROL_EXT		= 255,  --Server控制弹出的提示框的扩展版
		CHANGE_NAME_CONFIRM = 258,
		FREEFORRAID = 259,
		CHANGE_NAME_RETOK = 261,						-- 角色改名成功
		SONGLIAOWAR_XXS_CANCELBUF_CONFIRM 	= 262, 	--宋辽休息室取消buf确认
		SONGLIAOWAR_REST_EXIT_CONFIRM 		= 263, 	--宋辽休息室退出确认
		AUTOMOVE_CONFIRM_NOPKVALUE	   = 300,		--自动寻路确认-不加杀气场景
		AUTOMOVE_CONFIRM_UPPKVALUE     = 301,       --自动寻路确认-加杀气场景
		MESSAGE_AND_QUIT     = 302,       --提示并退出游戏
		MESSAGE_MONTH_CARD     = 303,       --月卡
		HEROS_RETURNS_CONFIRM	 = 304,			-- 回流英雄重返

		HEXINCHUN_YBCONFIRM	 = 305,			--移植-新春签到活动-天禧春华战江湖
		ROSERANK_EXCHANGE_CONFIRM = 306, 					--	2015情人节排行榜兑换二次确认
		RONGYU_BUY_ITEM		= 307, --荣誉值 购买确认
		WHWG_ACTIVE_CONFIRM = 308,			--武魂外观激活确认
		QIXIRANK_EXCHANGE_CONFIRM = 342, --2015七夕情人节兑换确认
		CONFIRM_IMMIGRATION  = 352,				 -- 移民
		CONFIRM_CANCEL_IMMIGRATION  = 353,				 -- 取消移民

		CONFIRM_QIXI_QUEQIANG		= 354, -- 七夕鹊桥 重置确认
		CONFIRM_KAIYANXI_DUIHUAN		= 355, --周年稳活月开宴席-2021年-by yuanpeilong

		EXTERIOR_RIDE_EQUIP_CONFIRM = 356,
		EXTERIOR_RIDE_ITEM_CONFIRM = 357,

		QINGRENJIERANK_EXCHANGE_CONFIRM = 356, --情人节兑换确认
		CONFIRM_FESTIVAL_SHOP			= 357,	--春节代币商店
		CONFIRM_EXTERIOR_FASHION001		= 358,	--时装图鉴确认
		CONFIRM_EXTERIOR_FASHION002		= 359,	--时装图鉴确认

		PETSOUL_ADDLIFE_CONFIRM = 360,
		PETSOUL_SMASH_CONFIRMLEVEL = 361,
		PETSOUL_SMASH_CONFIRMQUAL = 362,
		CONFIRM_QTESIGNIN_CLOSE = 363,	-- 22Q1应景打卡
		CONFIRM_2022_PETYURE = 364, --//2022兽魂版本预热-ypl

		FANLI_SHOP_CONFIRM		= 372,

		BUY_PLAYERSHOP_SECOND_CONFIRM = 373, --购买玩家商店二次确认

		UNLOCK_EXTERIOR_POSS_CONFIRM = 375,

		PETSOUL_LEVELDOWN_CONFIRM = 376,

		DISCARD_QUAL8ITEM_FRAME = 377,

		EXTERIOR_WEAPON_ITEM_CONFIRM = 378,

		QIXIDAKA_MISSIN_ABANDON = 379,

		JIYUAN_SHOP_CONFIRM		= 380,

		CONFIRM_ENTERDIGONG		= 381,

		CONFIRM_GUARDCONFIRM		= 382,-- [2022Q3]拉镖周常活动设计--运镖确认
		CONFIRM_SHAXINGGIVEUP		= 383,-- 新杀星放弃二次确认
		CONFIRM_SECKILLCARDOPEN		= 384,-- 扫荡特权开卡二次确认1月卡2日卡

		MISSION_XIULIAN_CONFIRM = 385,

		CONFIRM_EXTERIOR_REPLACE = 387,	--展示方案替换保存
		ZHANLING_CONFIRM = 388,

		SHENGWANGJOIN_CONFIRM = 389,
		CONFIRM_COLLECT_CRYSTAIL = 390,

		SHENGWANG_YB_SHOP_CONFIRM		= 391,

		YJFS_LEAVE_CONFIRM = 393,
		MAAN_EX_CONFIRM		= 394, --金色马鞍兑换二次确认
		WEEDING_PLANE_CONFIRM	= 395, --选择婚礼
		CHAI_JIE_DIAO_WEN = 396, --拆解雕纹

		MK_EXPRESSING_EMOTIONS=397,

		COUPLE_FASHION_ADD_CONFIRM = 398,
		COUPLE_FASHION_MOVE_CONFIRM = 399,

		COUPLE_VAULT_ADD_CONFIRM = 401,
		CLOSE_COUPLEZONE_VAULT = 402,
		DOUBLEGAME_DESC = 403,
		CONFIRM_WENHUOSXZL = 404,-- 2023Q2版本稳活-束脩之礼 二次确认
		DLZX_FLAG_CHANGEPKMODE = 405,
		WHQ_CONFIRM_BWZQ_SELECTLOVE = 406, --比武招亲心仪对象确认
		JINGJINMISSION2_LEAVE	 = 407,			--武道三任务2副本
		JINGJINMISSION3_LEAVE	 = 408,			--武道三任务3副本
		ACTIVITY_WABAO_23Q3 = 409,				--2023Q3活动-挖宝藏-二次确认

		QIANGHUALU_EX_CONFIRM = 412, --天罡强化露兑换二次确认
		JINGGANGCUO_EX_CONFIRM = 413, --金刚锉兑换二次确认
		
		SHENGWANG_SAODANG_CONFIRM = 414,
		
		SHENBING_TRANSITION_CONFIRM = 415,
		SHENBING_LEVELUP_BIND_CONFIRM = 416,
		SHENBING_TRANSITION_BIND_CONFIRM = 417,
		SHENBING_SKILL_ACTIVE_BIND_CONFIRM = 418,
		SHENBING_SKILL_LEVELUP_BIND_CONFIRM = 419,
		
		RIDE_CARD_USE_CONFIRM = 420,
		BUY_YUEKA_CONFIRM = 421,
		BUY_YUEKA_PROGRESS_CONFIRM = 422,
		MESSAGE_MONTH_CARD2     = 423,       --月卡
		BUY_SUPERASS_FASHION_CONFIRM = 424,		--买超牛B时装确认
		
		RMB_EMO_INSTALL_CONFIRM = 425,
		CONFIRM_RELIVE_SPECIALITEM = 426, --30007044还魂灵露复活

		CONFIRM_DAHUAQIXI_BUYITEM = 427, -- 大话七夕商店：购买物品二次确认
		CONFIRM_DAHUAQIXI_LIXIA = 428, -- 大话七夕商店：婚服礼匣
		CONFIRM_DAHUAQIXI_BUYDAIBI = 429, -- 大话七夕商店：购买代币二次确认
		DISCARD_GUILD					= 430,	--解散帮会

};

local PVPFLAG = { FREEFORALL = 201, FREEFORTEAM = 202, FREEFORGUILD = 203, MAKESUREPVPCHALLENGE = 204, ACCEPTDUEL = 205, DuelGUID = 0, DuelName = "", FREEFORRAID = 259 }
--FREEFORALL: 个人混战 FREEFORTEAM： 组队混战 FREEFORGUILD：帮派混战

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

local g_CityData = {};						--由于upvalue的限制，城市和珍兽合成共用这个数据区

local strMessageString = "";		--对话框字符
local strMessageData   = 0;			--对话框类型，用于提示什么得对话框
local strMessageArgs = 0;				--按钮参数
local strMessageType = "Normal";--按钮风格
local strMessageArgs_2 = 0			--按钮参数2

local GemCombinedData = {}

local EnchaseData = {}

local SplitData = {}

local CarveData = {}

local CommisionBuyData = {}  --寄售商店购买确认框的数据

local MAX_OBJ_DISTANCE = 3.0;

local Client_ItemIndex = -1

local Dart_Data = {}			--暗器数据
local KFS_Data = {}         --武魂数据
local g_MessageBoxSelf_Data={0,0,0,0}
local g_BaoTuInfo = {targetId = -1, itemId = -1}
local g_HeXinChun_Data = 0--移植-新春签到活动-天禧春华战江湖
local g_KaiYanXiDuiHuan_Data = 0 --周年稳活月开宴席-2021年-by yuanpeilong
local g_2022PetYuRe_Data = 0 --//2022兽魂版本预热-ypl
local NeedUseConfirmItemData = {}	--需要使用确认的物品数据
local UseConfirmItemShowTxt = {
	{idx = 30900074, txt = "#{QNG_XML_9}"}, --潜能果
	{idx = 38000009, txt = "#{LYGL_090810_01}"}, --老友的祝福
	{idx = 30900078, txt = "#{QNG_XML_9}"}, -- 潜能真丹
}

local g_TeamBoardWindow = -1; --确认删除的窗口，组队平台
local POS_GUILD_CHIEF = 9

--add by FengLiang 需要返回给服务器端的整形参数列表
--顺序是 targetId, param1, param2.....
local Server_Return_Params = {}
local g_LastEvent = ""--运维事故秒上报
local g_ImmigrationData ={}
g_ImmigrationData[0] = 0 --obj
g_ImmigrationData[1] = 0 --spouseobj
g_ImmigrationData[2] = 0 --目标服务器

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
	---- 有人邀请你加入队伍
	--this:RegisterEvent("SHOW_TEAM_YES_NO");
	---- 队员邀请某人加入队伍请你同意.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	---- 某人申请加入队伍.
	--this:RegisterEvent("TEAM_APPLY");
	---- 队长邀请进入组队跟随模式
	--this:RegisterEvent("TEAM_FOLLOW_INVITE");

	-- 创建帮会确认
	this:RegisterEvent("GUILD_CREATE_CONFIRM");
	-- 删除帮会确认
	this:RegisterEvent("GUILD_DESTORY_CONFIRM");
	-- 退出帮会确认
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
	this:RegisterEvent( "ENCHASE_FOUR_CONFIRM" );-- add:lby20080527确认4镶嵌

	--this:RegisterEvent( "CARVE_CONFIRM" );
	this:RegisterEvent( "EXCHANGE_MONEY_OVERFLOW" );
	this:RegisterEvent( "GUILD_DEMIS_CONFIRM" );
	this:RegisterEvent("YUANBAO_BUY_ITEM_CONFIRM");

	this:RegisterEvent("JIYUAN_BUY_ITEM_CONFIRM");

	this:RegisterEvent("FANLI_BUY_ITEM_CONFIRM");

	this:RegisterEvent("CONFIRM_COMMISION_BUY"); --寄售商店购买确认

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

	--当logon打开的时候，关闭所有MessageBox
	this:RegisterEvent( "GAMELOGIN_OPEN_COUNT_INPUT" );

	this:RegisterEvent( "CONFIRM_RE_IDENTIFY" );

	this:RegisterEvent( "CLOSE_RE_IDENTIFY_MSGBOX" );

	this:RegisterEvent( "KICK_MEMBER_MSGBOX" );

	this:RegisterEvent( "CLOSE_KICK_MEMBER_MSGBOX" );

	--保险箱锁定确认框
	this:RegisterEvent( "SAFEBOX_LOCK_CONFIRM" );

	--保险箱解锁确认框
	this:RegisterEvent( "SAFEBOX_UNLOCK_CONFIRM" );

	this:RegisterEvent( "CLOSE_SAFEBOX_CONFIRM" );

	--加锁确认
	this:RegisterEvent( "LOCK_ITEM_CONFIRM" );
	this:RegisterEvent( "OPEN_PETSKILLSTUDY_MSGBOX" );
	this:RegisterEvent( "CLOSE_PETSKILLSTUDY_MSGBOX" );
	--土灵珠定位确认
	this:RegisterEvent( "CONFIRM_SETPOS_TLZ" );

	-- 弹出解散队伍的二次确认窗口			add by WTT	20090212
	this:RegisterEvent( "OPNE_DISMISS_TEAM_MSGBOX" );

	this:RegisterEvent("PACKAGE_ITEM_CHANGED");

	-- 信任伙伴删除确认
	this:RegisterEvent("TRUST_FRIEND_OPEN_DEL_CHECK");

	this:RegisterEvent("SET_GUILD_FIRSTMAN_NAME");

	-- 弹出物品使用确认窗口
	this:RegisterEvent("NEED_USE_CONFIRM_ITEM");
	--卸载收费表情确认
	this:RegisterEvent("UNINSTALL_EMO_CONFIRM");
	--卸载收费休闲动作确认
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_CONFIRM");

	this:RegisterEvent("TEAMBOARD_OPEN_DEL_CHECK");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	-- 交易成功
	this:RegisterEvent("SUCCEED_EXCHANGE_CLOSE")
	this:RegisterEvent("AUTOMOVE_CONFIRM_NOPKVALUE")
	this:RegisterEvent("AUTOMOVE_CONFIRM_UPPKVALUE")
	-- 角色改名
	this:RegisterEvent("CHANGE_NAME_CONFIRM",true);
	--与衣柜界面互斥
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
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		MessageBox_Self_Frame_On_ResetPos()
		return 0
	-- 游戏分辨率发生了变化
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
	--七夕鹊桥
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
			--如果是关于购物弹出的窗口，才关闭
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg2);	--在货架的位置
			g_CityData[2] = tonumber(arg3);	--在商店的售价
			g_CityData[3] = arg1;	--货物名称

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
			--如果是关于购物弹出的窗口，才关闭
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
			local szInfo = "购买"..item_name.."需要花费"..tostring(g_CityData[2]).."个元宝，你确认吗？";
			MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
			MessageBox_Self_Text:SetText(szInfo);
			this:Show();
		end

	elseif event == "SHENGWANG_YB_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM and this:IsVisible())then
			--如果是关于购物弹出的窗口，才关闭
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
			local szInfo = "购买"..item_name.."需要花费"..tostring(g_msgFrameVar[2]).."个元宝，你确认吗？";
			MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
			MessageBox_Self_Text:SetText(szInfo);
			this:Show();
		end

	elseif event == "FANLI_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.FANLI_SHOP_CONFIRM and this:IsVisible())then
			--如果是关于购物弹出的窗口，才关闭
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
			local szInfo = "购买"..item_name.."需花费"..tostring(g_CityData[2]).."元宝，您确认吗？";
			MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
			MessageBox_Self_Text:SetText(szInfo);
			this:Show();
		end
	elseif event == "RONGYU_BUY_ITEM_CONFIRM" then

		g_CityData = {};
		g_CityData[1] = tonumber(arg1);	--在货架的位置
		g_CityData[2] = tonumber(arg2);	--在商店的售价
		g_CityData[3] = arg0;	--货物名称


		CancelLastOp(FrameInfoList.RONGYU_BUY_ITEM);
		g_FrameInfo = FrameInfoList.RONGYU_BUY_ITEM;

	elseif( event == "PET_SYNC_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		CancelLastOp(FrameInfoList.PET_SYNC_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SYNC_CONFIRM;
	--寄售商店购买确认消息
	elseif event == "CONFIRM_COMMISION_BUY" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.COMMISION_BUY and this:IsVisible())then
			--如果是寄售商店确认框，才关闭
				CommisionBuyData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			CommisionBuyData = {};
			CommisionBuyData[1] = arg1;	--物品名称
			CommisionBuyData[2] = arg2;	--价格
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
		local msg = "您确定要离开新天龙八部游戏世界吗？";
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
		local msg = "您确定要取消此次收购吗？";
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
		local msg = "#W您要出售的材料为#G"..name.."#W，数量为"..Recycle_Shop_Num.."#W,所获金钱为#Y#{_MONEY"..Recycle_Shop_AllPrice.."}";
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
		-- local msg = "强化时将优先扣除物品栏已绑定的强化精华，强化后的装备也将与您绑定，确定要继续强化吗？#r提示：如果不想将强化后的装备绑定，请将背包中已绑定的强化精华放入仓库再来强化。";
		MessageBox_Self_Text:SetText("#{CLXZ_220623_7}");
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "EXCHANGE_BANGGONG" ) then
		BangGong_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --这里不需要在使用GetNPCIDByServerID了
		if ObjCaredID ~= -1 then
			--开始关心NPC
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
		ObjCaredID = tonumber(arg1); --这里不需要在使用GetNPCIDByServerID了
		if ObjCaredID ~= -1 then
		--开始关心NPC
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
		local msg = "重新鉴定装备资质时将优先扣除物品栏中已绑定的金刚砂或金刚锉，重新鉴定资质后的装备也将与您绑定，确定要继续鉴定吗？#r#G提示：如果不想鉴定后的装备绑定，请将背包中已绑定的金刚砂和金刚锉放入仓库再来鉴定。#W";
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
		local msg = "#cfff263你确定要将玩家#G"..Member_Name.."#cfff263开除出帮会吗？";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	---确定开始自动寻路么？
	if ( event == "AUTOMOVE_CONFIRM_NOPKVALUE" ) then
	    MessageBox_Self_Text:SetText( tostring(arg0) )
        MessageBox_Self_DragTitle:SetText("#gFF0FA0自动寻路");
		MessageBox_Self_UpdateRect();
		g_FrameInfo = FrameInfoList.AUTOMOVE_CONFIRM_NOPKVALUE
		this:Show();
	end

	---确定开始自动寻路么？
	if( event == "AUTOMOVE_CONFIRM_UPPKVALUE") then
	    MessageBox_Self_Text:SetText( tostring(arg0) )
        MessageBox_Self_DragTitle:SetText("#gFF0FA0自动寻路");
		MessageBox_Self_UpdateRect();
		g_FrameInfo = FrameInfoList.AUTOMOVE_CONFIRM_UPPKVALUE
	end

	--2015情人节排行榜兑换二次确认
	if ( event == "ROSERANK_EXCHANGE_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("");			-- 设置标题
		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );
		MessageBox_Self_Text:SetText(g_msgFrameVar[3]);
		g_FrameInfo = FrameInfoList.ROSERANK_EXCHANGE_CONFIRM;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
	end

	--2015七夕情人节排行榜兑换二次确认
	if ( event == "QIXIRANK_EXCHANGE_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("");			-- 设置标题
		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );
		MessageBox_Self_Text:SetText(g_msgFrameVar[3]);
		g_FrameInfo = FrameInfoList.QIXIRANK_EXCHANGE_CONFIRM;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
	end

	--情人节排行榜兑换二次确认
	if ( event == "QINGRENJIERANK_EXCHANGE_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("");			-- 设置标题
		g_msgFrameVar[1] = tonumber( arg0 );
		g_msgFrameVar[2] = tonumber( arg1 );
		g_msgFrameVar[3] = tostring( arg2 );
		MessageBox_Self_Text:SetText(g_msgFrameVar[3]);
		g_FrameInfo = FrameInfoList.QINGRENJIERANK_EXCHANGE_CONFIRM;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
	end

	-- 共享时装
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
			-- 寻找游戏
			msg = "#{SRWF_230329_33}"
		elseif (gameType == 2) then
			-- 算术游戏
			msg = "#{SRWF_230329_32}"
		elseif (gameType == 3) then
			-- 躲避游戏
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

	-- 默认隐藏按钮
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
		MessageBox_Self_Text:SetText( "#Y您的钱已经到达上限，请尽快处理，在此期间不要做#R下线或者转移场景的操作，#Y否则会使得超出上限的金钱消失。" );

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
			MessageBox_Self_Text:SetText( "你确定要将帮主的职位禅让给"..TargetName.."吗？禅后你的职位将为副帮主。" );
		end
		MessageBox_Self_UpdateRect();
		CancelLastOp(FrameInfoList.GUILD_DEMIS_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DEMIS_CONFIRM
		this:Show();
	end

	if event == "ENCHASE_CONFIRM" then
		MessageBox_Self_Text:SetText( "没有特殊材料会导致镶嵌失败之后宝石消失。您确定要继续镶嵌吗？" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_CONFIRM
		this:Show();
	end

	if ( event == "SET_GUILD_FIRSTMAN_NAME" ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0#{BHCR_xml_XX(01)}");													-- 设置标题
		local szMsg = Guild:GetMyGuildInfo("FirstManName");
		if szMsg ~= "" then
			MessageBox_Self_Text:SetText( "#{BHCR_090713_08}"..szMsg);	-- 设置内容
		else
			MessageBox_Self_Text:SetText( "#{BHCR_090713_07}");
		end
		--MessageBox_Self_Text:SetText(szMsg);
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		CancelLastOp(FrameInfoList.SET_GUILD_FIRSTMAN_NAME);
		g_FrameInfo = FrameInfoList.SET_GUILD_FIRSTMAN_NAME;
		this:Show();
		--g_currentIndex = tonumber( arg0 );
		return;
	end

	if event == "ENCHASE_FOUR_CONFIRM" then  -- add:lby20080527确认4镶嵌
		MessageBox_Self_Text:SetText( "没有特殊材料会导致镶嵌失败之后宝石消失。您确定要继续镶嵌吗？" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_FOUR_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_FOUR_CONFIRM
		this:Show();
	end

	-- 打开珍兽技能学习的二次确认界面
	if event == "OPEN_PETSKILLSTUDY_MSGBOX" then
		MessageBox_Self_Text:SetText( "你的珍兽即将获得两个手动技能，这个操作需要花费#{_EXCHG990000}，你确定吗？" );
		CancelLastOp(FrameInfoList.PET_SKILL_STUDY_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SKILL_STUDY_CONFIRM
		this:Show();
	end

	-- 关闭珍兽技能学习的二次确认界面
	if(event == "CLOSE_PETSKILLSTUDY_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

--	if event == "CARVE_CONFIRM" then
--		MessageBox_Self_Text:SetText( "注意！#您要雕琢的宝石或雕琢符为已绑定物品，雕琢后的宝石也将与您绑定，确认要继续雕琢的话请再次点击雕琢按钮。" );
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
		--记录当前位置
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
			MessageBox_Self_Text:SetText( "您确认向"..TargetName.."提出宣战么？杀死对方之后会增加您的杀气值，杀气高了人物死亡时会导致额外损失" );
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
		    ModeText = "此模式下将会攻击除自己之外的所有玩家，请确认开启"
		end
		if( 2 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORTEAM);
		    --AxTrace(0,0,FrameInfoList.FREEFORTEAM);
		    g_FrameInfo = FrameInfoList.FREEFORTEAM;
		    ModeText = "此模式下将会攻击除队友之外的所有玩家，请确认开启"
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
	    local MsgText = Name.."向您提出决斗，您是否同意？注意：在决斗中死亡将会有惩罚。"
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


	-- 帮会成立需玩家确认
	elseif ( event == "GUILD_CREATE_CONFIRM" ) then
		argCREATE_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_CREATE_CONFIRM;
		MessageBox_Self_Text:SetText("是要创建" .. argCREATE_CONFIRM0 .. "吗?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- 帮会删除需玩家确认
	elseif ( event == "GUILD_DESTORY_CONFIRM" ) then
		argDESTORY_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_DESTORY_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DESTORY_CONFIRM;
		MessageBox_Self_Text:SetText("是要删除" .. argDESTORY_CONFIRM0 .. "吗?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- 帮会退出需玩家确认
	elseif ( event == "GUILD_QUIT_CONFIRM" ) then
		argQUIT_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_QUIT_CONFIRM;
		MessageBox_Self_Text:SetText("是要退出" .. argQUIT_CONFIRM0 .. "吗?");
		MessageBox_Self_UpdateRect();
		this:Show();

	--帮会同盟退出确认
	elseif event == "GUILD_LEAGUE_QUIT_CONFIRM" then
		argQUIT_LEAGUE_CONFIRM0 = arg0;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM
		MessageBox_Self_Text:SetText( "你确定要退出"..argQUIT_LEAGUE_CONFIRM0.."同盟吗？" );
		MessageBox_Self_UpdateRect();
		this:Show();

	--帮会同盟创建确认
	elseif event == "GUILD_LEAGUE_CREATE_CONFIRM" then
		argCREATE_LEAGUE_CONFIRM0 = arg0;
		argCREATE_LEAGUE_CONFIRM1 = arg1;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM
		MessageBox_Self_Text:SetText( "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}" );
		MessageBox_Self_UpdateRect();
		this:Show();


	-- 服务器断了
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

		elseif( arg0 == "immitbase" )		then -- 本金
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_BASE_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_BASE_MONEY;

		elseif( arg0 == "immit" )				then -- 盈利金存入
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_GAIN_MONEY;

		elseif( arg0 == "draw" )				then -- 盈利金取出
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


		elseif( arg0 == "sale" )     	then 	-- 盘出
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU;
		elseif( arg0 == "saleYB" )     	then 	-- 元宝盘出
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU_YB);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU_YB;


		elseif( arg0 == "back" )     	then	-- 取消盘出
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANRU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANRU;

		elseif( arg0 == "ps_type" )		then	-- 更改玩家商店的子类提示信息
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
						--开始关心NPC
						this:CareObject(ObjCaredID, 1, "MsgBox");
					end
				end

				--跨场景寻路已经处理过弹窗了
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
		-- 帮会解散确认
		elseif(tonumber(arg0) == 20250829) then
			g_newName = Get_XParam_STR(0)
			CancelLastOp(FrameInfoList.DISCARD_GUILD);
			g_FrameInfo = FrameInfoList.DISCARD_GUILD
			MessageBox_Self_Text:SetText( "你确定要解散"..tostring(g_newName).."帮会吗？" );		
			MessageBox_Self_UpdateRect();	
			this:Show();
			return
		elseif tonumber(arg0) == 8092720 then --确定拆解雕纹？
			MessageBox_Self_OnConfirmChaiJieDW()
			return
		elseif (tonumber(arg0) == 300039 ) then   --物品UI_COMMAND
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
				PushDebugMessage("#{BHCR_090713_06}") --非帮主不能撤销第一继承人
				this:Hide();
				return
			else
				argGUILD_DIS_FIRSTMAN0 = arg0
				CancelLastOp(FrameInfoList.GUILD_DIS_FIRSTMAN);
				g_FrameInfo = FrameInfoList.GUILD_DIS_FIRSTMAN;
				MessageBox_Self_Text:SetText("你确定要撤销第一继承人吗?");
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
        elseif (tonumber(arg0) == 809270 ) then--武魂洗成长率
			g_FrameInfo = FrameInfoList.KFS_RESET_GROWRATE
			KFS_Data = {}
			KFS_Data[1] = Get_XParam_INT(0)
			KFS_Data[2] = Get_XParam_INT(1)
			if KFS_Data[1] == 1 then
				MessageBox_Self_Text:SetText( "#{WHXCZL_091026_09}" );--回天精石
			elseif KFS_Data[1] == 2 then
				MessageBox_Self_Text:SetText( "#{WHXCZL_091026_10}" );--回天神石
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
			if (1 == nKckType) then		-- 防沉迷1.5小时到
				MessageBox_Self_Text:SetText("#{CMXT_191210_05}")
			elseif (2 == nKckType) then		-- 防沉迷晚10点到
				MessageBox_Self_Text:SetText("#{CMXT_191210_11}")
			elseif (3 == nKckType) then	--GM工具踢下线提示
				MessageBox_Self_Text:SetText("#{YCTS_20200721_01}")
			elseif (4 == nKckType) then	--CTU工具踢下线提示
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
				--开始关心NPC
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
			--如果有第二个整形参数，表明有需要关心的NPC
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
		elseif (tonumber(arg0) == 807012 ) then--移民
			g_FrameInfo = FrameInfoList.CONFIRM_IMMIGRATION;
			ImmigArg0 = Get_XParam_INT(0)
			ImmigArg1 = Get_XParam_INT(1)
			ImmigArg2 = Get_XParam_INT(2)
			local targetName = Get_XParam_STR(0);
			local targetServerName = Get_XParam_STR(1)	;
			local msg =ScriptGlobal_Format( "#{FWQYM_160531_240}", targetName,targetServerName)
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_DragTitle:SetText("夫妻移民");
			MessageBox_Self_UpdateRect();
		elseif (tonumber(arg0) == 20160601 ) then--取消移民

			g_FrameInfo = FrameInfoList.CONFIRM_CANCEL_IMMIGRATION;
			ImmigArg0  = Get_XParam_INT(0)
			ImmigArg1  = Get_XParam_INT(1)
			ImmigArg2  = Get_XParam_INT(2)
			local targetName = Get_XParam_STR(0)
			local targetServerName = Get_XParam_STR(1)
			local msg =ScriptGlobal_Format( "#{FWQYM_160601_252}", targetName,targetServerName)
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_DragTitle:SetText("夫妻移民");
			MessageBox_Self_UpdateRect();

		elseif (tonumber(arg0) == 892663) then-- 移植-新春签到活动-天禧春华战江湖
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

		--周年稳活月开宴席-2021年-by yuanpeilong
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

		--//2022兽魂版本预热-ypl
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
			MessageBox_Self_DragTitle:SetText("#{CJDB_211122_18}");			-- 设置标题
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
			g_msgFrameVar[1] = Get_XParam_INT(0) --是否是今日任务
			MessageBox_Self_QixidakaAbandon_Confirm()
		elseif tonumber(arg0) == 89331301 then-- 新杀星放弃二次确认
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.CONFIRM_SHAXINGGIVEUP
			MessageBox_Self_Text:SetText("#{XSX_220705_109}");	-- 设置内容
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 89119501 then-- 扫荡特权开卡二次确认1月卡2日卡
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.CONFIRM_SECKILLCARDOPEN
			MessageBox_Self_DragTitle:SetText("#{TQJF_221108_31}")
			if g_msgFrameVar[1] == 1 then
				MessageBox_Self_Text:SetText("#{TQJF_221108_32}");	-- 设置内容
			else
				MessageBox_Self_Text:SetText("#{TQJF_221108_34}");	-- 设置内容
			end
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 88816001 then-- [2022Q3]拉镖周常活动设计--运镖确认
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_msgFrameVar[2]  = Get_XParam_INT(1)
			g_msgFrameVar[3]  = Get_XParam_INT(2)
			g_FrameInfo = FrameInfoList.CONFIRM_GUARDCONFIRM
			MessageBox_Self_Text:SetText(Get_XParam_STR(0));	-- 设置内容
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 99827002 then-- 2023Q2版本稳活-束脩之礼 二次确认
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.CONFIRM_WENHUOSXZL
			if g_msgFrameVar[1] == 1 then
				MessageBox_Self_Text:SetText("#{SXZL_032901_177}");	-- 设置内容
				MessageBox_Self_DragTitle:SetText("#{SXZL_032901_176}")
			elseif g_msgFrameVar[1] == 2 then
				MessageBox_Self_Text:SetText("#{SXZL_032901_164}");	-- 设置内容
				MessageBox_Self_DragTitle:SetText("#{SXZL_032901_163}")
			end
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 2505531 then-- 2023Q3活动-挖宝藏-二次确认
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
				MessageBox_Self_Text:SetText( "#{MJXZ_210510_199}" );	-- 设置内容
			elseif g_msgFrameVar[1] == 2 then
				MessageBox_Self_Text:SetText( "#{MJXZ_210510_167}" );	-- 设置内容
			else
				return
			end
			MessageBox_Self_DragTitle:SetText("")

			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 89021502 then-- 战令快捷购买战令
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_FrameInfo = FrameInfoList.ZHANLING_CONFIRM
			MessageBox_Self_Text:SetText("#{SWXT_221213_54}");	-- 设置内容
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 99852601 then-- 战令快捷购买月卡
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_FrameInfo = FrameInfoList.BUY_YUEKA_CONFIRM
			MessageBox_Self_Text:SetText(Get_XParam_STR(0));	-- 设置内容
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif tonumber(arg0) == 99852602 then-- 战令快捷购买月卡进度
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)
			g_FrameInfo = FrameInfoList.BUY_YUEKA_PROGRESS_CONFIRM
			MessageBox_Self_Text:SetText(Get_XParam_STR(0));	-- 设置内容
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
				MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{CJWK_221220_27}",5) );	-- 设置内容
			elseif g_msgFrameVar[2] >= 5 then
				MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{CJWK_221220_28}",5) );	-- 设置内容
			else
				MessageBox_Self_Text:SetText( ScriptGlobal_Format("#{CJWK_221220_28}",g_msgFrameVar[1],5-g_msgFrameVar[1]) );	-- 设置内容
			end
			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()

		elseif tonumber(arg0) == 80602104 then-- 婚礼选择二次确认
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

			MessageBox_Self_Text:SetText( text ); -- 设置内容

			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif (tonumber(arg0) == 99834801) then
			-- 帝陵再现 夺旗 改变PK模式
			CancelLastOp(-1)
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1]  = Get_XParam_INT(0)

			g_FrameInfo = FrameInfoList.DLZX_FLAG_CHANGEPKMODE

			MessageBox_Self_Text:SetText("#{DLZX_230518_31}") -- 设置内容

			MessageBox_Self_DragTitle:SetText("")
			MessageBox_Self_OK_Button:Show();
			MessageBox_Self_Cancel_Button:Show()
			MessageBox_Self_UpdateRect()
			this:Show()
		elseif (tonumber(arg0) == 99836101) then-- 武道三任务2副本离开确认
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
		elseif (tonumber(arg0) == 99836401) then-- 武道三任务3副本离开确认
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
				--开始关心NPC
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
		elseif (tonumber(arg0) == 99929902) then -- 婚服紫霞礼匣
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
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
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
		MessageBox_Self_Text:SetText("#cFFF263是否送#c00ff00999朵玫瑰#cFFF263给#c00ff00"..g_RoseArg0.."#cFFF263?");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	elseif( event == "NEED_USE_CONFIRM_ITEM" ) then
		NeedUseConfirmItemData[1] = arg0; --目标objID
		NeedUseConfirmItemData[2] = arg1; --目标x坐标
		NeedUseConfirmItemData[3] = arg2; --目标y坐标
		NeedUseConfirmItemData[4] = arg3; --物品包内索引
		NeedUseConfirmItemData[5] = arg4; --物品表内索引
		if(NeedUseConfirmItemData[1] == nil)then
			return;
		end

		local itemTableIdx = tonumber(NeedUseConfirmItemData[5]);
		--获取显示内容
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



	-- add:lby20080527确认4镶嵌ENCHASE_FOUR_CONFIRM
	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "CHAR_RANAME_CONFIRM" ) then
		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0角色改名");
		MessageBox_Self_Text:SetText("注意，您只有一次改名的机会。#r您确认要修改名字为#G"..g_arg_chrc.."#cFFF263么？");
		CancelLastOp(FrameInfoList.CHAR_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CHAR_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "CITY_RANAME_CONFIRM" ) then
		g_arg_circ = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会改名");
		MessageBox_Self_Text:SetText("注意，您只有一次改名的机会。#r您确认要修改帮会名为#G"..g_arg_circ.."#cFFF263么？");
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
		MessageBox_Self_DragTitle:SetText("#gFF0FA0保险箱锁定");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_10}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "SAFEBOX_UNLOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_UNLOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_UNLOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0保险箱解锁");
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
				MessageBox_Self_Text:SetText("#{SFDJ_240117_169}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）".."#{TLZ_081114_2}")
			else
				MessageBox_Self_Text:SetText("#{TLZ_081114_1}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）".."#{TLZ_081114_2}")
			end
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			MessageBox_Self_OK_Clicked()
			this:Hide()
			return
		end

	end

	-- 弹出解散队伍的二次确认窗口			add by WTT	20090212
	if (event == "OPNE_DISMISS_TEAM_MSGBOX")	then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0解散队伍");			-- 设置标题
		MessageBox_Self_Text:SetText( "#{TeamDismiss_090912_1}" );	-- 设置内容
		CancelLastOp(FrameInfoList.DISMISS_TEAM);
		g_FrameInfo = FrameInfoList.DISMISS_TEAM;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
		return;
	end

	if ( event == "TRUST_FRIEND_OPEN_DEL_CHECK" ) then
		MessageBox_Self_DragTitle:SetText("#{XRHB_09515_14}");													-- 设置标题
		MessageBox_Self_Text:SetText( "#{XRHB_09515_15}"..arg1.."#{XRHB_09515_16}");	-- 设置内容
		CancelLastOp(FrameInfoList.TRUST_FRIEND);
		g_FrameInfo = FrameInfoList.TRUST_FRIEND;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
		g_currentIndex = tonumber( arg0 );
		return;
	end

	-- 卸载收费表情确认
	if event == "UNINSTALL_EMO_CONFIRM" then
		MessageBox_Self_DragTitle:SetText("#{BQB_XML_10}")												-- 设置标题
		g_currentIndex = tonumber(arg0)
		local emo_package_id, emo_valid_date, emo_count = DataPool:LuaFnEnumEmoInfo(g_currentIndex)
		local emo_set_name = DataPool:LuaFnGetEmoSetName(emo_package_id)
		MessageBox_Self_Text:SetText("#{BQB_091026_8}"..tostring(emo_set_name).."#{BQB_091026_9}") -- 您确认要卸载&U表情包吗？
		g_FrameInfo = FrameInfoList.UNINSTALL_EMO
		MessageBox_Self_UpdateRect()															-- 恢复窗口大小到初始大小
		this:Show()
		return
	end

	-- 卸载收费休闲动作确认
	if ( event == "UNINSTALL_CHAT_ACTION_CONFIRM" ) then
		MessageBox_Self_DragTitle:SetText("#{BQB_XML_10}");					-- 设置标题：卸载确认
		g_currentIndex = tonumber( arg0 );
		local actionID , actionValidDate , actionCount, actionMinIndex, actionType = DataPool:Get_RMB_ChatActionInfo(g_currentIndex )
		local actionName = DataPool : Get_RMB_ChatActionName(actionID)
		MessageBox_Self_Text : SetText( "#{SRDZ_20221107_07}"..tostring(actionName).."#{SRDZ_20221107_08}" );		-- 您确认要卸载XXX动作包吗？#G（卸载后将不能继续使用此表情包）
		g_FrameInfo = FrameInfoList.UNINSTALL_CHAT_ACTION;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
		return;
	end

	if ( event == "TEAMBOARD_OPEN_DEL_CHECK" ) then
		g_TeamBoardWindow = tonumber(arg0);
		MessageBox_Self_DragTitle:SetText("#{ZDPT_XML_24}");													-- 设置标题
		MessageBox_Self_Text:SetText( "#{ZDPT_XML_25}");	-- 设置内容
		g_FrameInfo = FrameInfoList.TEAMBOARD_OPEN_DEL_CHECK;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
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
			--开始关心NPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end

		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#{GMT_20100811_3}"); -- #gFF0FA0角色改名
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
		MessageBox_Self_DragTitle:SetText("#{CJDB_211122_18}");			-- 设置标题
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
			-- 全部保存
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

		MessageBox_Self_DragTitle:SetText(strTitle);			-- 设置标题

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
	
	-- 关闭大话七夕购买的二次确认界面
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

	if strMessageData == "YiGuiDressBind" then     --衣柜需要NPC关心
		ObjCaredID = tonumber(strMessageArgs_2)
		if ObjCaredID ~= -1 then
			--开始关心NPC
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
	MessageBox_Self_DragTitle:SetText("#gFF0FA0#gFF0FA0确 认")
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
	--取消当前建设建筑物的确认信息
	if(g_CityData[1] == 0) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0取消当前建设");
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		local szExist = City:GetBuildingInfo(bId, "exist");
		if(tonumber(szExist) > 0) then szExist = "升级"; else szExist = "修建"; end
		local szCurPro = tostring(City:GetCityManageInfo("CurProgress"));
		local szAttr = (City:GetBuildingInfo(bId, "condattrname"));

		local msg = "本帮目前正在"..szExist..szName.."中，已经完成了进度"..szCurPro.."。终止后，";
		msg = msg..szExist.."将失败，所有进度将为0，不退还任何帮资金和"..szAttr.."，你确定要终止当前的";
		msg = msg..szExist.."吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--申请领地确认信息
	elseif(g_CityData[1] == 1) then
		local szPortName = City:GetPortInfo(g_CityData[2], "Name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0申请领地");
		--你确定要申请所在于AA的“BB”领地吗？这项行为需要消耗1000个金币。
		local msg = "#cFFF263你确定要申请所在于#cFE7E82"..tostring(szPortName).."#cFFF263的#H"..g_CityData[3].."#cFFF263";
		msg = msg.."领地吗？这项行为需要消耗1000#-14或者一块建城令牌。";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--修建或升级建筑物
	elseif(g_CityData[1] == 2 or g_CityData[1] == 3) then
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		if(bLevel == -1 or bId == -1) then
			local szExist = "";
			if(g_CityData[1] == 2) then
				MessageBox_Self_DragTitle:SetText("#gFF0FA0建设新建筑");
				szExist = "修建";
			else
				MessageBox_Self_DragTitle:SetText("#gFF0FA0升级建筑");
				szExist = "升级";
			end

			local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
			--建设条件
			local cd = {City:GetBuildingInfo(g_CityData[2], "condition")};
			--0.金钱
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.消耗值
			local szAttr = (City:GetBuildingInfo(g_CityData[2], "condattrname"));
			local szAttrVal = tostring(cd[4]);
			--2.任务数
			local mn = tostring(cd[2]);

			local msg = szExist..szName.."需要帮资金"..money.."，消耗"..szAttr..szAttrVal;
			msg = msg.."点，同时发布任务"..mn.."个，你确定吗?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(0);	--取消当前建筑的确认信息
		end
	--降级或拆毁建筑物
	elseif(g_CityData[1] == 4 or g_CityData[1] == 5) then
		local szExist = "";
		if(g_CityData[1] == 4) then
			MessageBox_Self_DragTitle:SetText("#gFF0FA0降级建筑");
			szExist = "降级";
		else
			MessageBox_Self_DragTitle:SetText("#gFF0FA0拆毁建筑");
			szExist = "拆毁";
		end

		local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
		local szPreAttr = "";
		_,szPreAttr = City:GetBuildingInfo(g_CityData[2], "condattrname");
		local msg = szExist..szName.."将会使建筑功能与作用减少，且不退还任何帮资金与";
		msg = msg..szPreAttr.."，你确定要这样做吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--修改城市反展趋势六率值
	elseif(g_CityData[1] == 6) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改发展方向");
		local msg = "修改发展方向将会消耗帮会资金50#-02，你确定要这样做吗?"
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--取消研究的确认信息
	elseif(g_CityData[1] == 7) then
		local rName, _, rIdx = City:GetResearchInfo("CurResearch");
		local szCurPro = tostring(City:GetResearchInfo("ResearchProcess"));

		MessageBox_Self_DragTitle:SetText("#gFF0FA0终止研究");
		local msg = "本帮目前正在研究"..rName.."中，已经完成了进度"..szCurPro.."。终止后，";
		msg = msg.."研究将失败，所有进度将为0，不退还任何帮资金和属性值，你确定要终止当前的研究吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--开始研究的确认信息
	elseif(g_CityData[1] == 8) then
		local rName = City:GetResearchInfo("CurResearch");
		if("" == rName) then
			local bIdx = tonumber(g_CityData[2]);
			local rIdx = tonumber(g_CityData[3]);
			MessageBox_Self_DragTitle:SetText("#gFF0FA0研究配方");
			local szResearchName = City:GetResearchInfo("ResearchName", bIdx, rIdx);
			--建设条件
			local cd = {City:GetResearchInfo("ResearchCondition", bIdx, rIdx)};
			--0.金钱
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.所需值
			local szAttr = City:GetResearchInfo("RCAttrName", bIdx, rIdx);
			local szAttrVal = tostring(cd[4]);
			--2.任务数
			local mn = tostring(cd[2]);
			local msg = "研究"..szResearchName.."需要帮资金"..money.."，消耗";
			msg = msg..szAttr..szAttrVal.."，同时发布任务"..mn.."个，你确定吗?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(7);	--取消当前研究的确认信息
		end
	--创建商业路线的确认信息
	elseif(g_CityData[1] == 9) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0创建商业路线");
		local msg = "此操作将与编号为"..tostring(g_CityData[2]).."的帮会建立商线，只有双方互建商线，商线才会生效，你确定要建立吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--取消商业路线的确认信息
	elseif(g_CityData[1] == 10) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0取消商业路线");
		local dt = {City:GetCityRoadInfo("RoadDetail", g_CityData[2])};
		local msg = "";
		if(dt[4]) then
			msg = "此操作将使本帮与对方帮会的商业行为单方面终止，你确定要继续进行操作吗?";
		else
			msg = "此操作将使本帮与对方帮会不会再有互建商线的可能，你确定要继续进行操作吗?";
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

		MessageBox_Self_DragTitle:SetText("#gFF0FA0保存摊位设置");
		local szInfo;
		szInfo = "#{INTERFACE_XML_681}";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- add by zchw
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0收摊");
		local szInfo;
		szInfo = "你真的要收摊吗？";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- zchw for pet procreate
	elseif (g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0注意");
		MessageBox_Self_Text:SetText("#{PET_FANZHI_20080313_01}");
		this:Show();
	--七夕鹊桥
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_QIXI_QUEQIANG) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0注意");
		MessageBox_Self_Text:SetText("#{QXWH_20210616_69}");
		this:Show();
	--还魂灵露复活
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_RELIVE_SPECIALITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0复活");
		MessageBox_Self_Text:SetText("#{SFDJ_240117_163}");
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
		local szInfo;
		if ( g_CurUint == g_CurUintType.YuanBao ) then
			szInfo = "购买"..g_CityData[3].."需要花费"..tostring(g_CityData[2]).."个元宝，你确认吗？";
		elseif ( g_CurUint == g_CurUintType.Bind ) then
			szInfo = "#{BDYB_090720_01}"..g_CityData[3].."#{BDYB_090720_02}"..tostring(g_CityData[2]).."#{BDYB_090720_03}";
		end
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();

	elseif(g_FrameInfo == FrameInfoList.RONGYU_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
		local szInfo;
			szInfo = "购买"..g_CityData[3].."需要花费"..tostring(g_CityData[2]).."荣誉值，你确认吗？";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
		local szInfo;
		szInfo = "购买"..CommisionBuyData[1].."需要花费"..CommisionBuyData[2].."，你确认吗？";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.DISCARD_GUILD) then
		--通知解除锁定
		MessageBox_Self_DragTitle:SetText("#gFF0FA0解散帮会");
		local szStr = "你真的要解散[".. tostring(g_newName) .."]帮会?"
		MessageBox_Self_Text:SetText(szStr);
	end

end

--===============================================
-- UpdateTitle
--===============================================
function UpdateTitle()
    --因为在MessageBox_Self_UpdateFrame函数中,"upvalue"严重超员,增加了这个函数用来更改msgbox的标题
    if ( PVPFLAG.FREEFORALL == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");
    elseif ( PVPFLAG.FREEFORTEAM == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");
    elseif ( PVPFLAG.FREEFORGUILD == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");
    elseif ( PVPFLAG.MAKESUREPVPCHALLENGE == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0宣战确认");
	elseif g_FrameInfo == FrameInfoList.SONGLIAOWAR_REST_EXIT_CONFIRM then
		MessageBox_Self_DragTitle:SetText("#{XSLDZ_180521_338}")
	elseif ( PVPFLAG.FREEFORRAID == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");

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
		--提示本的费用
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
		if (nCoinType == 1) then --元宝摆摊
			local szInfo = "#{YBBT_081031_1}".. szMoneyPosTax .."#{YBBT_081031_2}1#{YBBT_081031_3}";
			MessageBox_Self_Text:SetText(szInfo);
		else
			local szInfo = "#{YBBT_081031_4}".. szMoneyPosTax .."#{YBBT_081031_5}".. tostring(nTradeTax) .."#{YBBT_081031_6}";
			MessageBox_Self_Text:SetText(szInfo);
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--通知解除锁定
		MessageBox_Self_DragTitle:SetText("#gFF0FA0销毁物品");
		local szStr = "你真的要销毁".. argDISCARD_ITEM_FRAME0 .."?"
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.DISCARD_QUAL8ITEM_FRAME) then
		--通知解除锁定
		MessageBox_Self_DragTitle:SetText("#gFF0FA0销毁物品");
		MessageBox_Self_Text:SetText(ScriptGlobal_Format("#{YZZBMD_220627_04}",g_msgFrameVar[1]))
		MessageBox_Self_CheckClient:Show()
		MessageBox_Self_CheckBtn:Show()
		MessageBox_Self_CheckText:Show()
		MessageBox_Self_CheckText:SetText("#{YZZBMD_240419_1}")
		MessageBox_Self_CheckBtn:SetCheck( 0 );	

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0销毁物品");
		local szStr = argCANNT_DISCARD_ITEM0.."是任务物品，不能销毁";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0加锁");
		local szStr = "".."#cff0000注意！#r#Y为了保护您的财产安全，一旦物品或珍兽成功被加锁，再次解锁则需要等待#G3天#Y，您确定要继续加锁么？";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0放弃任务");
		if Quest_Number==888767 then
			MessageBox_Self_Text:SetText("#{GEHJ_211015_22}");
		elseif Quest_Number==888779 then
			MessageBox_Self_Text:SetText("#{CCYXN_20211202_27}");
		elseif Quest_Number==998269 then-- 2023Q2版本稳活-束脩之礼
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
		elseif Quest_Number==890143 then--2023Q1不老长春谷预热任务1
			MessageBox_Self_Text:SetText("#{CCYR_221220_108}");
		elseif Quest_Number==890144 then--2023Q1不老长春谷预热任务2
			MessageBox_Self_Text:SetText("#{CCYR_221220_111}");
		elseif Quest_Number==890145 then--2023Q1不老长春谷预热任务3
			MessageBox_Self_Text:SetText("#{CCYR_221220_112}");
		elseif Quest_Number==890146 then--2023Q1不老长春谷预热任务4
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
			local szStr = "#cFFF263你真的要放弃#R任务:"..argFRAME_AFFIRM_SHOW0.."#cFFF263吗？";
			MessageBox_Self_Text:SetText(szStr);
		end
	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- 帮会成立需玩家确认
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会成立");
		local szStr = "你确认创建" .. argCREATE_CONFIRM0 .. "帮会吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会解散");
		local szStr = "你确认删除" .. argDESTORY_CONFIRM0 .. "帮会吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DIS_FIRSTMAN) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0#{BHCR_xml_XX(04)}");
		local szStr = "你确定要撤销第一继承人吗?";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会退出");
		local szStr = "你确认退出" .. argQUIT_CONFIRM0 .. "帮会吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0同盟退出");
		local szStr = "你确认退出" .. argQUIT_LEAGUE_CONFIRM0 .. "同盟吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0同盟创建");
		local szStr = "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		MessageBox_Self_Text:SetText(argNET_CLOSE0);
	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0珍兽放生");
		local petname = Pet:GetPetList_Appoint(Pet_Number) ;
		local strname, pettype = Pet:GetName(Pet_Number);
		local szStr = "是否确认放生["..petname.."]("..pettype..")?" ;
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改店名");
		--玩家商店更名需要的金钱数字
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

		local szInfo = "修改店名需要支付牌匾金字费2".."#-02".. "×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor().."需要支付"..szMoney.."，你确定要修改吗？"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--玩家商店更更改商店说明需要的金钱数字
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改店铺描述");
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

		local szInfo = "修改店描述需要支付笔墨费".."50#-03".. "×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor().."需要支付"..szMoney.."，你确定要修改吗？"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0充入本金");
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

		local szInfo = "你将充入" .. szMoney .. "，系统还将收取你3%的投资税，你将需要额外支付" .. szMoney1 .. "，你确定要充入吗？";

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0充入盈利金");
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

		local szInfo = "你将充入" .. szMoney .. "，系统还将收取你3%的投资税，你将需要额外支付" .. szMoney1 .. "，你确定要充入吗？";

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

		--设置服务器传过来的字符串参数
		Server_Script_Function_Set[1] = Get_XParam_STR(0)
		Server_Script_Function_Set[2] = nil
		MessageBox_Self_Text:SetText(Get_XParam_STR(1))

		--设置服务器传过来的整形参数，这些参数会被传回服务器
		Server_Script_ID = Get_XParam_INT(0)
		local count = Get_XParam_INT_Count()
		Server_Return_Params[0]=count
		for i=1, count do
			Server_Return_Params[i] = Get_XParam_INT(i)
		end

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0扩张柜台");
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

		local szInfo = "扩张柜台需要支付30#-02×商业指数×2×103%，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要扩张吗？"

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0缩减柜台");
		MessageBox_Self_Text:SetText("#{SJGT_090825_01}");

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0盘出店铺");
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

		local szInfo = "盘出店铺需要支付15#-02×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要盘出店铺吗？"
		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU_YB)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0盘出店铺");
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

		local szInfo = "盘出店铺需要支付15#-02×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要盘出店铺吗？"
		MessageBox_Self_Text:SetText(szInfo);
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)  then   --盘入

		MessageBox_Self_DragTitle:SetText("#gFF0FA0盘入店铺");
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

		local szInfo = "取消盘出柜台需要支付5#-02×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要盘入店铺吗？"

		MessageBox_Self_Text:SetText(szInfo);

	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改店铺类型");
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

		local szInfo = "修改店类型需要支付搬运费：5#-02 ×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要修改吗？"

		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0删除确认");
		local szInfo;
		local relationtype = DataPool:GetFriend(g_currentList,g_currentIndex, "RELATION_TYPE" )
		if relationtype == 7 then
			szInfo = "#cFFF263你确定要删除".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."吗？删除后将不能与对方进行任何师徒相关的活动。";
		else
			szInfo = "#cFFF263你确定要删除".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."吗？";
		end
		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_UpdateFrame();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0珍兽合成");
		local msg = "你确定将这两只珍兽合成为一只吗?";
		MessageBox_Self_Text:SetText(msg);
	elseif( g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮贡牌兑换");
	elseif( g_FrameInfo == FrameInfoList.PUT_GUILDMONEY ) then
		MessageBox_Self_DragTitle:SetText("#{BPZJ_0801014_020}");
	elseif( g_FrameInfo == FrameInfoList.CHANGE_NAME_RETOK ) then
		MessageBox_Self_DragTitle:SetText("#{GMT_20100811_3}");
		local changenameMsg = string.format("#{GMT_20100811_29}%s#{GMT_20100811_30}",g_newName)
		MessageBox_Self_Text:SetText(changenameMsg);
	elseif( g_FrameInfo == FrameInfoList.HEXINCHUN_YBCONFIRM ) then-- 移植-新春签到活动-天禧春华战江湖
		MessageBox_Self_DragTitle:SetText("#{CJYJ_201222_03}");
	elseif( g_FrameInfo == FrameInfoList.CONFIRM_KAIYANXI_DUIHUAN ) then	--周年稳活月开宴席-2021年-by yuanpeilong
		MessageBox_Self_DragTitle:SetText("#{KYX_20210715_04}");
	elseif( g_FrameInfo == FrameInfoList.CONFIRM_2022_PETYURE ) then	--//2022兽魂版本预热-ypl
		MessageBox_Self_DragTitle:SetText("");
	elseif( g_FrameInfo == FrameInfoList.JIYUAN_SHOP_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
	elseif( g_FrameInfo == FrameInfoList.FANLI_SHOP_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
	elseif( g_FrameInfo == FrameInfoList.SHENGWANG_YB_SHOP_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
	end

	MessageBox_Self_UpdateFrameEx();
	MessageBox_Self_UpdateRect();
	this:Show();
end

--===============================================
-- 点击确定（IDOK）
--===============================================
function MessageBox_Self_OK_Clicked_Ex()
    AxTrace( 0, 0, "MessageBox_OnOKClick" )
	if( g_FrameInfo == FrameInfoList.FREEFORALL ) then --同意开启个人混战
        AxTrace( 0, 0, "FrameInfoList.FREEFORALL" )
        Player:ChangePVPMode( 1 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORTEAM ) then --同意开启队伍混战
        AxTrace( 0, 0, "FrameInfoList.FREEFORTEAM" )
        Player:ChangePVPMode( 3 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORGUILD ) then  --同意开启帮派混战
        AxTrace( 0, 0, "FrameInfoList.FREEFORGUILD" )
        Player:ChangePVPMode( 4 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORRAID ) then  --同意开启团队混战
        Player:ChangePVPMode( 5 );
    end
    if( g_FrameInfo == FrameInfoList.MAKESUREPVPCHALLENGE ) then  --确认宣战
        AxTrace( 0, 0, "FrameInfoList.MAKESUREPVPCHALLENGE" )
        Player:PVP_Challenge( 2 );     --2为宣战确认对话框确认
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
	--七夕鹊桥 确认
	elseif g_FrameInfo == FrameInfoList.CONFIRM_QIXI_QUEQIANG then
		PushEvent("RESET_QIXI_QUEQIANG");--重置
	--还魂灵露复活
	elseif g_FrameInfo == FrameInfoList.CONFIRM_RELIVE_SPECIALITEM then
		Player:SendReliveMessage_Relive();--复活
	elseif  g_FrameInfo == FrameInfoList.QUIT_GAME  then
		EnterQuitWait(0);
		--QuitApplication("quit");
	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)    then
		PlayerShop:ChangeShopNum("del_ok");
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)    then
		PlayerShop:Transfer("apply", "sale", g_nData, 0);--0为金币盘出
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU_YB)    then
		PlayerShop:Transfer("apply", "sale", g_nData, 1);--1为元宝盘出
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
		tonumber(NeedUseConfirmItemData[1]), --目标objID
		tonumber(NeedUseConfirmItemData[2]), --目标x坐标
		tonumber(NeedUseConfirmItemData[3]), --目标y坐标
		tonumber(NeedUseConfirmItemData[4]), --物品包内索引
		tonumber(NeedUseConfirmItemData[5])  --物品表内索引
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

	--删除收费表情
	if g_FrameInfo == FrameInfoList.UNINSTALL_EMO then
		DataPool:LuaFnUnInstallEmo(g_currentIndex, 1)
		g_currentIndex = 0
		return
	end

	--删除收费休闲动作包
	if (g_FrameInfo == FrameInfoList.UNINSTALL_CHAT_ACTION) then
		DataPool : UnInstall_RMB_ChatAction(g_currentIndex , 1)
		g_currentIndex = 0
		return
	end

	--确认开始自动寻路
	if(g_FrameInfo == FrameInfoList.AUTOMOVE_CONFIRM_NOPKVALUE) then
		StartAutoMove()
		this:Hide()
	end


	--确认开始自动寻路
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

	--2015七夕情人节排行榜兑换二次确认
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

	--情人节排行榜兑换二次确认
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

	--月卡
	if(g_FrameInfo == FrameInfoList.MESSAGE_MONTH_CARD) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnUseMonthCard");
			Set_XSCRIPT_ScriptID(892666);
			Set_XSCRIPT_Parameter(0, 1);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	
	--月卡
	if(g_FrameInfo == FrameInfoList.MESSAGE_MONTH_CARD2) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnUseMonthCard2");
			Set_XSCRIPT_ScriptID(892666);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
	end

	--回流英雄重返
	if(g_FrameInfo == FrameInfoList.HEROS_RETURNS_CONFIRM) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name( "OnBuyShopItem" )
			Set_XSCRIPT_ScriptID(808110)
			Set_XSCRIPT_Parameter(0,g_MessageBoxSelf_Data[1])
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT();
	end

	-- 移植-新春签到活动-天禧春华战江湖
	if(g_FrameInfo == FrameInfoList.HEXINCHUN_YBCONFIRM) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetReward")
			Set_XSCRIPT_ScriptID(892663)
			Set_XSCRIPT_Parameter(0,g_HeXinChun_Data)
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

	--周年稳活月开宴席-2021年-by yuanpeilong
	if(g_FrameInfo == FrameInfoList.CONFIRM_KAIYANXI_DUIHUAN) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DuiHuan_True")
			Set_XSCRIPT_ScriptID(891176)
			Set_XSCRIPT_Parameter(0,g_KaiYanXiDuiHuan_Data)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end

	--//2022兽魂版本预热-ypl
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
	-- [2022Q3]拉镖周常活动设计--运镖确认
	if g_FrameInfo == FrameInfoList.CONFIRM_GUARDCONFIRM then
		if g_msgFrameVar[1] == 1 then--开始
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("AskAccept")
				Set_XSCRIPT_ScriptID(888160)
				Set_XSCRIPT_Parameter(0,g_msgFrameVar[2])
				Set_XSCRIPT_Parameter(1,g_msgFrameVar[3])
				Set_XSCRIPT_Parameter(2,1)
				Set_XSCRIPT_ParamCount(3)
			Send_XSCRIPT()
		elseif g_msgFrameVar[1] == 2 then--结束
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
	-- 2023Q2版本稳活-束脩之礼 二次确认
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
	-- 黄金马鞍兑换二次确认
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
		-- 新杀星放弃二次确认
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GiveUpTheBoss" )
			Set_XSCRIPT_ScriptID( 893311)
			Set_XSCRIPT_Parameter( 0 ,g_msgFrameVar[1])
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	end
	if g_FrameInfo == FrameInfoList.CONFIRM_SECKILLCARDOPEN then
		-- 扫荡特权开卡二次确认1月卡2日卡
		if g_msgFrameVar[1] == 1 then
			--月卡
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "ConfirmOpenTeQuan" )
				Set_XSCRIPT_ScriptID( 891194)
				Set_XSCRIPT_ParamCount( 0 )
			Send_XSCRIPT()
		else
			--日卡
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

	-- 武道三任务2离开副本
	if(g_FrameInfo == FrameInfoList.JINGJINMISSION2_LEAVE) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ConfimLeave")
			Set_XSCRIPT_ScriptID(998361)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
		-- 武道三任务3离开副本
	if(g_FrameInfo == FrameInfoList.JINGJINMISSION3_LEAVE) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ConfimLeave")
			Set_XSCRIPT_ScriptID(998364)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end


	--强化露兑换二次确认
	if g_FrameInfo == FrameInfoList.QIANGHUALU_EX_CONFIRM then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnConfirmJingHua")
			Set_XSCRIPT_ScriptID(998265)
			Set_XSCRIPT_Parameter(0,g_msgFrameVar[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		this:Hide()
	end


	--金刚锉兑换二次确认
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
	if( strMessageData == "EquipBind" ) then -- 绑定
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end

	if( strMessageData == "DressProtected" ) then -- 绑定
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end

	if(strMessageData == "YiGuiDressBind" ) then
	    YiGui:EquipDressWithoutAskBind(tonumber( strMessageArgs ))
	end

	this:Hide();
end
--===============================================
-- 点击确定（IDOK）
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

-- add:lby20080527确认4镶嵌ENCHASE_FOUR_CONFIRM
	if g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM then
		LifeAbility : Do_Enchase_Four( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

	-- 宠物学习技能确认：两个手动技能学习
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
		--通知服务器决定开始在这里摆摊
		StallSale:AgreeBeginStall();

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--通知销毁物品
		local equipQual = DiscardEquipQual() --装备品质 非装备返回0
		local equipStar = equipQual

		local nNeedQueRen = DataPool:GetDestroyErciQueRen()
		if equipStar >= 7 and nNeedQueRen ~= 0 then
			MessageBox_Self_ClearVar()
			g_msgFrameVar[1] = equipStar
			g_FrameInfo=FrameInfoList.DISCARD_QUAL8ITEM_FRAME
			MessageBox_Self_UpdateFrame()
			return
		else
			--通知销毁物品
			DiscardItem();
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_QUAL8ITEM_FRAME) then
		local nNeedQueRen = MessageBox_Self_CheckBtn:GetCheck()
		-- 设置标记，之后不再弹二次确认窗
		if nNeedQueRen > 0 then
			DataPool:SetDestroyErciQueRen()
		end

		DiscardItem();
	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		--任务物品不能销毁
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		--通知加锁物品
		LockAfterConfirm();

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		--放弃任务
		if(Quest_Number > -1) then
			QuestFrameMissionAbnegate(Quest_Number);
		end
		g_InitiativeClose = 1;
		this:Hide();


	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- 帮会成立需玩家确认
		Guild:CreateGuildConfirm(1);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
		-- 帮会成立需玩家确认
		Guild:CreateGuildConfirm(2);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DIS_FIRSTMAN) then
		-- 撤销第一继承人确认
		Guild:UnSetFirstMan();
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		-- 帮会成立需玩家确认
		Guild:CreateGuildConfirm(3);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		Pet : Go_Free(Pet_Number);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		--玩家商店更名需要的金钱数字
		PlayerShop:Modify("name_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--玩家商店更更改商店说明需要的金钱数字
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

	-- 确认解散队伍			add by WTT	20090212
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
	
	-- 确认解散帮会
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
-- 放弃摆摊(IDCONCEL)
--===============================================
function MessageBox_Self_Cancel_Clicked(bClick)
	if( 1 == bClick ) then
		--AxTrace( 0, 0, bClick )
		if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
		end
    end

	if ( g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME ) then
		--通知解除锁定
		DiscardItemCancelLocked();
	elseif ( g_FrameInfo == FrameInfoList.DISCARD_QUAL8ITEM_FRAME ) then
		DiscardItemCancelLocked();

    elseif ( g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME ) then
		--通知解除加锁
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

	--取消删除收费表情
	if (g_FrameInfo == FrameInfoList.UNINSTALL_EMO) then
		g_currentIndex = 0
	end

	--取消删除收费休闲动作
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
		--点取消的rpc
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
		--移民取消
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
		--移民取消
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
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_2}" ); --神亦石
	elseif (Dart_Data[1] == 6) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_1}" ); --忘无石
	elseif (Dart_Data[1] == 7) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_5}" ); --百淬神玉
	elseif (Dart_Data[1] == 8) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_4}" ); --千淬神玉
	elseif (Dart_Data[1] == 9) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_3}" ); --浴火石
	end

	MessageBox_Self_DragTitle:SetText("");
	MessageBox_Self_UpdateRect();

	this:Show();
	MessageBox_Self_OK_Button:Show();
	MessageBox_Self_Cancel_Button:Show();
end


function MessageBox_Self_AdjustDart()
	if (Dart_Data[1] >=1 and Dart_Data[1] <= 5) then
		DataPool:DarkAdjustAttr(Dart_Data[2], Dart_Data[1], 1);	--神亦石
	elseif (Dart_Data[1] == 6) then
		--	DataPool:DarkAdjustSkill(Dart_Data[2] , 1);		--忘无石
		--洗技能
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("DarkSkillAdjustForBagItem");
			Set_XSCRIPT_ScriptID(332207);
			Set_XSCRIPT_Parameter(0,Dart_Data[2]);
			Set_XSCRIPT_Parameter(1,1);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (Dart_Data[1] == 7) then
		DataPool:DarkResetQuality(Dart_Data[2], 1, 1);    --百淬神玉
	elseif (Dart_Data[1] == 8) then
		DataPool:DarkResetQuality(Dart_Data[2], 2, 1);    --千淬神玉
	elseif (Dart_Data[1] == 9) then
		DataPool:DarkReset(Dart_Data[2], 1);		--浴火石
	end
end

function MessageBox_GetNeedUseConfirmItemShowTxt( itemTblIdx )
	--获取显示内容
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
		--永久坐骑
		if nAddLimitTime < 0 then
			--道具使用成功后，可将AAA变更为永久坐骑，您确定要使用吗
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
		--永久坐骑
		if nAddLimitTime < 0 then
			--道具使用成功后，可将AAA变更为永久坐骑，您确定要使用吗
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
	if g_BaoTuInfo.itemId == 8513 then --寻常历练?持续
		MessageBox_Self_Text:SetText("#{WDZD_230721_11}")
	elseif g_BaoTuInfo.itemId == 8514 then --双倍历练?持续
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
	--幻武有效期将达到365天
	if nLeftTime + nAddLimitTime > 31536000 then
		nRealAddTime = 31536000 - nLeftTime
		bOverLoad = 1
	end

	local strTemp = ""
	if nLeftTime > 0 then
		--永久
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
		--永久
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
-- 恢复界面的默认相对位置
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