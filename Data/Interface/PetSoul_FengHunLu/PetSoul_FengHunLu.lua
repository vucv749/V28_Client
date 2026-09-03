-- PetSoul_FengHunLu ·â»êÂ¼ 2022-1-5 lishilong
-- !!!reloadscript =PetSoul_FengHunLu
-- !!!reloadscript =MiniMap
-- !!uiopentest = 791010 µ÷Ö¸¶¨½Å±¾ºÅµÄAskOpenMainUI
-- 458

local g_PetSoul_FengHunLu_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 			= 3.0
local g_nObjCaredIDClient 		= -1
local g_nServerObjID 			= -1
local bCaredItem 				= 0
local bCaredObj 				= 0
local bCaredMoney 				= 0
local bCaredYuanBao				= 0
local g_nComfirmParam1			= 0

local g_nFengHunluDayIndex 		= 0 
local g_nMDMaiDian01			= 0	
local g_nMDMaiDian02 			= 0	
local g_nMDReward01 			= 0	
local g_nMDReward02 			= 0	
local g_nHuoYuePoint			= 0	
local g_nEndYear				= 0	
local g_nEndMonth				= 0	
local g_nEndDay					= 0	

local g_nCurPage				= 1

local g_nUICommandID			= 79101001
local g_contorlPage				= {}
local g_contorlPageTips			= {}
local g_contorlEventIcon		= {}
local g_contorlEventDes			= {}
local g_contorlEventProcess		= {}
local g_contorlEventReward		= {}
local g_contorlEventButton		= {}
local g_contorlEventButtonHotP	= {}
local g_contorlEventGetedPic	= {}
local g_contorlPointReward		= {}
local g_contorlPointRewardGeted	= {}

-- Ã¿¸öÍæ¼Ò·â»êÂ¼µÄ³ÖÐøÊ±¼ä
local g_nTotalDays				= 14
-- ×î´ó»î¶¯ÌìÊý	
local g_nMaxTotalDay			= 8 
-- Ã¿Ìì×î´óEventÊýÁ¿	
local g_nMaxEventPerDay			= 5
-- ×î´óMD´æ´¢Á¿	
local g_nMaxSavePos				= 32
-- ×î´óµãÊý½±ÀøµÈ¼¶
local g_nMaxPointRewardLevel	= 5
-- ×î´óµãÊý
local g_nMaxPoint				= 40

-- ÂñµãÊÂ¼þµÄ´æ´¢Ë÷ÒýÐÅÏ¢
-- nSaveMD ´æ´¢MD nSavePosStart ÂñµãÔÚ±¾MDµÄÆðÊ¼Ë÷Òý 
-- nSaveLen Âñµã ¼ÓÃµÄbitÊý nMaxValue ÂñµãÊý¾Ý×î´óÖµ(ÑÏ¸ñÐ¡ÓÚµÈÓÚ(2^nSaveLen) - 1£¬²¢ÇÒÁô³öÁËÒ»¶¨µÃµ¯ÐÔ¿ ¼ä)
-- ²Î¿¼1 »ØÁ÷Ó¢ÐÛÖ®Â· #define HEROESRETURNS_TASK_INDEX_0		0	// Ìí¼Ó1¸öºÃÓÑ µÈ
-- ²Î¿¼2  ½½­ºþ 892664
local g_tabMaiDianSaveInfo = 
{
	[1] 	= {nSaveMDIndex = 1, nSavePosStart = 0, 	nSaveLen = 12, 	nMaxValue = 2500, },-- 1] ?????? 4095 cpp??
	[2] 	= {nSaveMDIndex = 1, nSavePosStart = 12, 	nSaveLen = 5, 	nMaxValue = 20, },	-- 2] ??? 31	
	[3] 	= {nSaveMDIndex = 1, nSavePosStart = 17, 	nSaveLen = 5, 	nMaxValue = 15, },	-- 3] ???? 31
	[4] 	= {nSaveMDIndex = 1, nSavePosStart = 22, 	nSaveLen = 5, 	nMaxValue = 10, },	-- 4] ???? 31
	[5] 	= {nSaveMDIndex = 1, nSavePosStart = 27, 	nSaveLen = 5, 	nMaxValue = 9, },	-- 5] ?? 31
	[6] 	= {nSaveMDIndex = 2, nSavePosStart = 0, 	nSaveLen = 3, 	nMaxValue = 4, },	-- 6] ?? 7
	[7] 	= {nSaveMDIndex = 2, nSavePosStart = 3, 	nSaveLen = 3, 	nMaxValue = 4, },	-- 7] ??? 7
	[8] 	= {nSaveMDIndex = 2, nSavePosStart = 6, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 8] ?? 7
	[9] 	= {nSaveMDIndex = 2, nSavePosStart = 9, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 9] ?? 7
	[10] 	= {nSaveMDIndex = 2, nSavePosStart = 12, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 10 ???? 7
	[11] 	= {nSaveMDIndex = 2, nSavePosStart = 15, 	nSaveLen = 3, 	nMaxValue = 2, },	-- 11 ???? 7
	[12] 	= {nSaveMDIndex = 2, nSavePosStart = 18, 	nSaveLen = 2, 	nMaxValue = 1, },	-- 12 ???? 3 cpp??
	[13] 	= {nSaveMDIndex = 2, nSavePosStart = 20, 	nSaveLen = 2, 	nMaxValue = 1, },	-- 13 ???? 3
}

-- Ã¿ÌìµÄÊÂ¼þÐÅÏ¢ Íê³ÉÒÀÀµµÄÂñµãid ÂñµãÊý¾ÝÖµ »îµÃµÄ×Ü»î¶¯µãÊý ×îºóÒ»¸öÔÝÊ±·ÏÆú
-- ËùÓÐ¸ºÊý¶¼ÊÇÌØÊâ´¦ÀíµÄÊÂ¼þ£¬Ä¿Ç°-1ÊÇÃ¿È »îÔ¾Öµ
local g_tabEventInfo = 
{
	-- µÚ1Ìì
	-- »÷É±100¸ö¹ÖÎï	1
	-- ²Î¼Ó1´ÎÆå¾Ö	1
	-- Íê³É1´ÎÎÒ°®ÐÒÔË¿ì»îÈý	1
	-- Íê³É5´Î°ï»áÈÎÎñ	1
	-- ½ñÈ »îÔ¾Öµ´ïµ½100µã	1
	[1] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 100, 	nGetPoint = 1, nEventIndex = 1, },
		[2] = {nMaiDianID = 6, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 2, },
		[3] = {nMaiDianID = 7, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 3, },
		[4] = {nMaiDianID = 3, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 4, },
		[5] = {nMaiDianID = -1, nMaiDianValue = 100, 	nGetPoint = 1, nEventIndex = 5, },
	},
	-- µÚ2Ìì	
	-- »÷É±200¸ö¹ÖÎï	1
	-- Íê³É5´ÎÀÏÈý»·	1
	-- Íê³É1´ÎÐ£³¡±ÈÎä	1
	-- Íê³É1´ÎÅÜÉÌ	1
	-- Íê³É5´Î°ï»áÈÎÎñ	1
	[2] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 200, 	nGetPoint = 1, nEventIndex = 6, },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 7, },
		[3] = {nMaiDianID = 12, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 8, },
		[4] = {nMaiDianID = 8, 	nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 9, },
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 10, },
	},

	-- µÚ3Ìì	
	-- »÷É±400¸ö¹ÖÎï	1
	-- Íê³É1´Î³ÑÐ×´òÍ¼	1
	-- Íê³É1´Î°Ù±äÁ³Æ×	1
	-- Íê³É2´ÎÎÒ°®ÐÒÔË¿ì»îÈý	1
	-- Íê³É3´ÎÑà×Ó	1
	[3] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 400, 	nGetPoint = 1, nEventIndex = 11, },
		[2] = {nMaiDianID = 11, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 12, },
		[3] = {nMaiDianID = 13, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 13, },
		[4] = {nMaiDianID = 7, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 14, },
		[5] = {nMaiDianID = 5, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 15, },
	},

	-- µÚ4Ìì	
	-- »÷É±700¸ö¹ÖÎï	1
	-- Íê³É10´ÎÀÏÈý»·	1
	-- Íê³É2´ÎÆå¾Ö	1
	-- Íê³É1´Î¿Æ¾Ù	1
	-- Íê³É1´ÎÇ°ÊÀ½ñÉú	1
	[4] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 700, 	nGetPoint = 1, nEventIndex = 16, },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 17, },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 18, },
		[4] = {nMaiDianID = 13, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 19, },
		[5] = {nMaiDianID = 10, nMaiDianValue = 1, 		nGetPoint = 1, nEventIndex = 20, },
	},

	-- µÚ5Ìì	
	-- »÷É±1000¸ö¹ÖÎï	1
	-- Íê³É5¸öÊ¦ÃÅÈÎÎñ	1
	-- Íê³É2´ÎÅÜÉÌ	1
	-- Íê³É3´ÎÎÒ°®ÐÒÔË¿ì»îÈý	1
	-- Íê³É10´Î°ï»áÈÎÎñ	1
	[5] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 1000, 	nGetPoint = 1, nEventIndex = 21, },
		[2] = {nMaiDianID = 4, 	nMaiDianValue = 5, 		nGetPoint = 1, nEventIndex = 22, },
		[3] = {nMaiDianID = 8, 	nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 23, },
		[4] = {nMaiDianID = 7, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 24, },
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 25, },
	},

	-- µÚ6Ìì	
	-- »÷É±1500¸ö¹ÖÎï	1
	-- Íê³É15´ÎÀÏÈý»·	1
	-- Íê³É3´ÎÆå¾Ö	1
	-- Íê³É2´Î³ÑÐ×´òÍ¼	1
	-- Íê³É6´ÎÑà×Ó	1
	[6] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 1500, 	nGetPoint = 1, nEventIndex = 26, },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 15, 	nGetPoint = 1, nEventIndex = 27, },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 28, },
		[4] = {nMaiDianID = 11, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 29, },
		[5] = {nMaiDianID = 5, 	nMaiDianValue = 6, 		nGetPoint = 1, nEventIndex = 30, },
	},

	-- µÚ7Ìì	
	-- »÷É±2000¸ö¹ÖÎï
	-- Íê³É10¸öÊ¦ÃÅÈÎÎñ
	-- Íê³É4´ÎÎÒ°®ÐÒÔË¿ì»îÈý
	-- Íê³É2´Î¿Æ¾Ù
	-- Íê³É2´ÎÇ°ÊÀ½ñÉú
	[7] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 2000, 	nGetPoint = 1, nEventIndex = 31, },
		[2] = {nMaiDianID = 4, 	nMaiDianValue = 10, 	nGetPoint = 1, nEventIndex = 32, },
		[3] = {nMaiDianID = 7, 	nMaiDianValue = 4, 		nGetPoint = 1, nEventIndex = 33, },
		[4] = {nMaiDianID = 13, nMaiDianValue = 3, 		nGetPoint = 1, nEventIndex = 34, },
		[5] = {nMaiDianID = 10, nMaiDianValue = 2, 		nGetPoint = 1, nEventIndex = 35, },
	},

	-- µÚ8Ìì	
	-- »÷É±2500¸ö¹ÖÎï
	-- Íê³É20´ÎÀÏÈý»·
	-- Íê³É4´ÎÆå¾Ö
	-- Íê³É9´ÎÑà×Ó
	-- Íê³É15´Î°ï»áÈÎÎñ
	[8] = 
	{
		[1] = {nMaiDianID = 1, 	nMaiDianValue = 2500, 	nGetPoint = 1, nEventIndex = 36, },
		[2] = {nMaiDianID = 2, 	nMaiDianValue = 20, 	nGetPoint = 1, nEventIndex = 37, },
		[3] = {nMaiDianID = 6, 	nMaiDianValue = 4, 		nGetPoint = 1, nEventIndex = 38, },
		[4] = {nMaiDianID = 5, 	nMaiDianValue = 9, 		nGetPoint = 1, nEventIndex = 39, },
		[5] = {nMaiDianID = 3, 	nMaiDianValue = 15, 	nGetPoint = 1, nEventIndex = 40, },
	},
}

-- ÊÂ¼þ ¹Ê¾
local g_tabEventShowInfo = 
{
	[1] 	= {strDes = "#{XYSHFC_20211229_01}", strTips = "#{XYSHFC_20211229_41}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[2] 	= {strDes = "#{XYSHFC_20211229_02}", strTips = "#{XYSHFC_20211229_42}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[3] 	= {strDes = "#{XYSHFC_20211229_03}", strTips = "#{XYSHFC_20211229_43}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[4] 	= {strDes = "#{XYSHFC_20211229_04}", strTips = "#{XYSHFC_20211229_44}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
	[5] 	= {strDes = "#{XYSHFC_20211229_05}", strTips = "#{XYSHFC_20211229_45}",	strPic = "set:Huodong_7 image:Huodong_7_2"},
	[6] 	= {strDes = "#{XYSHFC_20211229_06}", strTips = "#{XYSHFC_20211229_46}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[7] 	= {strDes = "#{XYSHFC_20211229_07}", strTips = "#{XYSHFC_20211229_47}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[8] 	= {strDes = "#{XYSHFC_20211229_08}", strTips = "#{XYSHFC_20211229_48}",	strPic = "set:CircularTaskTool13 image:CircularTaskTool13_1"},
	[9] 	= {strDes = "#{XYSHFC_20211229_09}", strTips = "#{XYSHFC_20211229_49}",	strPic = "set:Huodong image:Huodong_2"},
	[10] 	= {strDes = "#{XYSHFC_20211229_10}", strTips = "#{XYSHFC_20211229_50}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
	[11] 	= {strDes = "#{XYSHFC_20211229_11}", strTips = "#{XYSHFC_20211229_51}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[12] 	= {strDes = "#{XYSHFC_20211229_12}", strTips = "#{XYSHFC_20211229_52}",	strPic = "set:Huodong_12 image:Huodong_12_13"},
	[13] 	= {strDes = "#{XYSHFC_20211229_13}", strTips = "#{XYSHFC_20211229_53}",	strPic = "set:Buff5 image:Buff5_9"},
	[14] 	= {strDes = "#{XYSHFC_20211229_14}", strTips = "#{XYSHFC_20211229_54}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[15] 	= {strDes = "#{XYSHFC_20211229_15}", strTips = "#{XYSHFC_20211229_55}",	strPic = "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[16] 	= {strDes = "#{XYSHFC_20211229_16}", strTips = "#{XYSHFC_20211229_56}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[17] 	= {strDes = "#{XYSHFC_20211229_17}", strTips = "#{XYSHFC_20211229_57}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[18] 	= {strDes = "#{XYSHFC_20211229_18}", strTips = "#{XYSHFC_20211229_58}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[19] 	= {strDes = "#{XYSHFC_20211229_19}", strTips = "#{XYSHFC_20211229_59}",	strPic = "set:Buff5 image:Buff5_9"},
	[20] 	= {strDes = "#{XYSHFC_20211229_20}", strTips = "#{XYSHFC_20211229_60}",	strPic = "set:Huodong_3 image:Huodong_3_2"},
	[21] 	= {strDes = "#{XYSHFC_20211229_21}", strTips = "#{XYSHFC_20211229_61}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[22] 	= {strDes = "#{XYSHFC_20211229_22}", strTips = "#{XYSHFC_20211229_62}",	strPic = "set:SalaryMission image:SalaryMission_3"},
	[23] 	= {strDes = "#{XYSHFC_20211229_23}", strTips = "#{XYSHFC_20211229_63}",	strPic = "set:Huodong image:Huodong_2"},
	[24] 	= {strDes = "#{XYSHFC_20211229_24}", strTips = "#{XYSHFC_20211229_64}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[25] 	= {strDes = "#{XYSHFC_20211229_25}", strTips = "#{XYSHFC_20211229_65}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
	[26] 	= {strDes = "#{XYSHFC_20211229_26}", strTips = "#{XYSHFC_20211229_66}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[27] 	= {strDes = "#{XYSHFC_20211229_27}", strTips = "#{XYSHFC_20211229_67}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[28] 	= {strDes = "#{XYSHFC_20211229_28}", strTips = "#{XYSHFC_20211229_68}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[29] 	= {strDes = "#{XYSHFC_20211229_29}", strTips = "#{XYSHFC_20211229_69}",	strPic = "set:Huodong_12 image:Huodong_12_13"},
	[30] 	= {strDes = "#{XYSHFC_20211229_30}", strTips = "#{XYSHFC_20211229_70}",	strPic = "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[31] 	= {strDes = "#{XYSHFC_20211229_31}", strTips = "#{XYSHFC_20211229_71}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[32] 	= {strDes = "#{XYSHFC_20211229_32}", strTips = "#{XYSHFC_20211229_72}",	strPic = "set:SalaryMission image:SalaryMission_3"},
	[33] 	= {strDes = "#{XYSHFC_20211229_33}", strTips = "#{XYSHFC_20211229_73}",	strPic = "set:SalaryMission image:SalaryMission_13"},
	[34] 	= {strDes = "#{XYSHFC_20211229_34}", strTips = "#{XYSHFC_20211229_74}",	strPic = "set:Buff5 image:Buff5_9"},
	[35] 	= {strDes = "#{XYSHFC_20211229_35}", strTips = "#{XYSHFC_20211229_75}",	strPic = "set:Huodong_3 image:Huodong_3_2"},
	[36] 	= {strDes = "#{XYSHFC_20211229_36}", strTips = "#{XYSHFC_20211229_76}",	strPic = "set:Huodong_7 image:Huodong_7_6"},
	[37] 	= {strDes = "#{XYSHFC_20211229_37}", strTips = "#{XYSHFC_20211229_77}",	strPic = "set:Huodong_12 image:Huodong_12_5"},
	[38] 	= {strDes = "#{XYSHFC_20211229_38}", strTips = "#{XYSHFC_20211229_78}",	strPic = "set:SalaryMission image:SalaryMission_11"},
	[39] 	= {strDes = "#{XYSHFC_20211229_39}", strTips = "#{XYSHFC_20211229_79}",	strPic = "set:LongZhengWuZai_Icon1 image:LongZhengWuZai_Icon1_16"},
	[40] 	= {strDes = "#{XYSHFC_20211229_40}", strTips = "#{XYSHFC_20211229_80}",	strPic = "set:CircularTaskTool22 image:CircularTaskTool22_2"},
}

-- µã»÷²ÎÓë°´Å¥µÄÏìÓ¦
-- nOpType 1 ·µ»ØÐÑÄ¿ÌáÊ¾£¬ nOpType 2 Ñ°Â·
local g_tabEventClickInfo = 
{
	[1] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_81}", },	-- ??????1
	[2] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "Trß½ng D¸ch Qu¯c", strShow = "", },	-- ???????(274,95)????
	[3] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "Li­u Nguy®t H°ng", strShow = "", },	-- ???????(130,230)????
	[4] 	= {nOpType= 1, nSceneID = 0, nPosX = 0, 	nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_82}", },	-- ??????9
	[5] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_83}", },	-- ??????10
	[6] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_84}", },	-- ??????2
	[7] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ti«n Hoành Vû", strShow = "", },	-- ???????(62,162)????
	[8] 	= {nOpType= 1, nSceneID = 0, nPosX = 0, 	nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_85}", },	-- ??????11
	[9] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_86}", },	-- ??????12
	[10] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_87}", },	-- ??????9
	[11] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_88}", },	-- ??????3
	[12] 	= {nOpType= 2, nSceneID = 1, nPosX = 127,	nPoxZ = 133,	strNPCName = "Ngô Gi¾i", strShow = "", },	-- ???????(127,133)???
	[13] 	= {nOpType= 2, nSceneID = 1, nPosX = 168,	nPoxZ = 168,	strNPCName = "Vån NgÕn Bác", strShow = "", },	-- ???????(168,168)????
	[14] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "Li­u Nguy®t H°ng", strShow = "", },	-- ???????(130,230)????
	[15] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "Lý Cß½ng", strShow = "", },	-- ???????(70,119)???
	[16] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_89}", },	-- ??????4
	[17] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ti«n Hoành Vû", strShow = "", },	-- ???????(62,162)????
	[18] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "Trß½ng D¸ch Qu¯c", strShow = "", },	-- ???????(274,95)????
	--[19] 	= {nOpType= 2, nSceneID = 2, nPosX = 50,	nPoxZ = 152,	strNPCName = "Ö÷¿¼¹Ù", strShow = "", },	-- ×Ô¶¯Ñ°Â·ÖÁ´óÀí£¨50£¬152£©Ö÷¿¼¹Ù´¦
	[19] 	= {nOpType= 2, nSceneID = 1, nPosX = 168,	nPoxZ = 168,	strNPCName = "Vån NgÕn Bác", strShow = "", },	-- ???????(168,168)????
	[20] 	= {nOpType= 2, nSceneID = 0, nPosX = 194,	nPoxZ = 180,	strNPCName = "", strShow = "", },	-- ???????(194,180)?????
	[21] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_90}", },	-- ??????5
	[22] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_91}", },	-- ??????13
	[23] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_92}", },	-- ??????12
	[24] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "Li­u Nguy®t H°ng", strShow = "", },	-- ???????(130,230)????
	[25] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_93}", },	-- ??????9
	[26] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_94}", },	-- ??????6
	[27] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ti«n Hoành Vû", strShow = "", },	-- ???????(62,162)????
	[28] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "Trß½ng D¸ch Qu¯c", strShow = "", },	-- ???????(274,95)????
	[29] 	= {nOpType= 2, nSceneID = 1, nPosX = 127,	nPoxZ = 133,	strNPCName = "Ngô Gi¾i", strShow = "", },	-- ???????(127,133)???
	[30] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "Lý Cß½ng", strShow = "", },	-- ???????(70,119)???
	[31] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_95}", },	-- ??????7
	[32] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_96}", },	-- ??????13
	[33] 	= {nOpType= 2, nSceneID = 1, nPosX = 130, 	nPoxZ = 230,	strNPCName = "Li­u Nguy®t H°ng", strShow = "", },	-- ???????(130,230)????
	--[34] 	= {nOpType= 2, nSceneID = 2, nPosX = 50,	nPoxZ = 152,	strNPCName = "Ö÷¿¼¹Ù", strShow = "", },	-- ×Ô¶¯Ñ°Â·ÖÁ´óÀí£¨50£¬152£©Ö÷¿¼¹Ù´¦
	[34] 	= {nOpType= 2, nSceneID = 1, nPosX = 168,	nPoxZ = 168,	strNPCName = "Vån NgÕn Bác", strShow = "", },	-- ???????(168,168)????
	[35] 	= {nOpType= 2, nSceneID = 0, nPosX = 194,	nPoxZ = 180,	strNPCName = "", strShow = "", },	-- ???????(194,180)?????
	[36] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_97}", },	-- ??????8
	[37] 	= {nOpType= 2, nSceneID = 1, nPosX = 62,	nPoxZ = 162,	strNPCName = "Ti«n Hoành Vû", strShow = "", },	-- ???????(62,162)????
	[38] 	= {nOpType= 2, nSceneID = 2, nPosX = 274,	nPoxZ = 95,		strNPCName = "Trß½ng D¸ch Qu¯c", strShow = "", },	-- ???????(274,95)????
	[39] 	= {nOpType= 2, nSceneID = 4, nPosX = 70,	nPoxZ = 119,	strNPCName = "Lý Cß½ng", strShow = "", },	-- ???????(70,119)???
	[40] 	= {nOpType= 1, nSceneID = 0, nPosX = 0,		nPoxZ = 0,		strNPCName = "", strShow = "#{XYSHFC_20211229_98}", },	-- ??????9
}

-- ÀÛ¼ÆµãÊý½±ÀøÐÅÏ¢
local g_tabPointRewardInfo = 
{
	[1] = {nNeedPoint = 5, 	nRewardItemID = 38002535, nRewardItemNum = 2, nNeedBagSpace = 2, nNeedMatSpace = 0, },
	[2] = {nNeedPoint = 10, nRewardItemID = 38002535, nRewardItemNum = 2, nNeedBagSpace = 2, nNeedMatSpace = 0, },
	[3] = {nNeedPoint = 15, nRewardItemID = 38002535, nRewardItemNum = 3, nNeedBagSpace = 3, nNeedMatSpace = 0, },
	[4] = {nNeedPoint = 25, nRewardItemID = 38002535, nRewardItemNum = 3, nNeedBagSpace = 3, nNeedMatSpace = 0, },
	[5] = {nNeedPoint = 35, nRewardItemID = 38002536, nRewardItemNum = 4, nNeedBagSpace = 4, nNeedMatSpace = 0, },
}

--=========================================================
-- PreLoad
--=========================================================
function PetSoul_FengHunLu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	if 1 == bCaredItem then
		this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	end
	if 1 == bCaredMoney then
		this:RegisterEvent("UNIT_MONEY")
		this:RegisterEvent("MONEYJZ_CHANGE")
	end
	if 1 == bCaredYuanBao then
		this:RegisterEvent("UPDATE_YUANBAO")
	end
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	-- Í¬²½Ë¢ÐÂÍæ¼Ò»îÔ¾ÐÅÏ¢
	this:RegisterEvent("ZHOUHUOYUE_UPDATE")
end

--=========================================================
-- OnLoad
--=========================================================
function PetSoul_FengHunLu_OnLoad()
	g_PetSoul_FengHunLu_Frame_UnifiedPosition = PetSoul_FengHunLu_FrameFull:GetProperty("UnifiedPosition")

	-- PetSoul_FengHunLu_OK_Button : SetEvent("Clicked", "PetSoul_FengHunLu_ConfirmClick()")

	g_contorlPage[1]				= PetSoul_FengHunLu_Day1
	g_contorlPage[2]				= PetSoul_FengHunLu_Day2
	g_contorlPage[3]				= PetSoul_FengHunLu_Day3
	g_contorlPage[4]				= PetSoul_FengHunLu_Day4
	g_contorlPage[5]				= PetSoul_FengHunLu_Day5
	g_contorlPage[6]				= PetSoul_FengHunLu_Day6
	g_contorlPage[7]				= PetSoul_FengHunLu_Day7
	g_contorlPage[8]				= PetSoul_FengHunLu_Day8

	g_contorlPageTips[1]			= PetSoul_FengHunLu_Day1_tips
	g_contorlPageTips[2]			= PetSoul_FengHunLu_Day2_tips
	g_contorlPageTips[3]			= PetSoul_FengHunLu_Day3_tips
	g_contorlPageTips[4]			= PetSoul_FengHunLu_Day4_tips
	g_contorlPageTips[5]			= PetSoul_FengHunLu_Day5_tips
	g_contorlPageTips[6]			= PetSoul_FengHunLu_Day6_tips
	g_contorlPageTips[7]			= PetSoul_FengHunLu_Day7_tips
	g_contorlPageTips[8]			= PetSoul_FengHunLu_Day8_tips

	g_contorlEventIcon[1]			= PetSoul_FengHunLu_Lace1_Icon
	g_contorlEventIcon[2]			= PetSoul_FengHunLu_Lace2_Icon
	g_contorlEventIcon[3]			= PetSoul_FengHunLu_Lace3_Icon
	g_contorlEventIcon[4]			= PetSoul_FengHunLu_Lace4_Icon
	g_contorlEventIcon[5]			= PetSoul_FengHunLu_Lace5_Icon

	g_contorlEventDes[1]			= PetSoul_FengHunLu_Lace1_Text1
	g_contorlEventDes[2]			= PetSoul_FengHunLu_Lace2_Text1
	g_contorlEventDes[3]			= PetSoul_FengHunLu_Lace3_Text1
	g_contorlEventDes[4]			= PetSoul_FengHunLu_Lace4_Text1
	g_contorlEventDes[5]			= PetSoul_FengHunLu_Lace5_Text1

	g_contorlEventProcess[1]		= PetSoul_FengHunLu_Lace1_Text2
	g_contorlEventProcess[2]		= PetSoul_FengHunLu_Lace2_Text2
	g_contorlEventProcess[3]		= PetSoul_FengHunLu_Lace3_Text2
	g_contorlEventProcess[4]		= PetSoul_FengHunLu_Lace4_Text2
	g_contorlEventProcess[5]		= PetSoul_FengHunLu_Lace5_Text2

	g_contorlEventReward[1]			= PetSoul_FengHunLu_Lace1_Text3
	g_contorlEventReward[2]			= PetSoul_FengHunLu_Lace2_Text3
	g_contorlEventReward[3]			= PetSoul_FengHunLu_Lace3_Text3
	g_contorlEventReward[4]			= PetSoul_FengHunLu_Lace4_Text3
	g_contorlEventReward[5]			= PetSoul_FengHunLu_Lace5_Text3

	g_contorlEventButton[1]			= PetSoul_FengHunLu_Lace1_Go
	g_contorlEventButton[2]			= PetSoul_FengHunLu_Lace2_Go
	g_contorlEventButton[3]			= PetSoul_FengHunLu_Lace3_Go
	g_contorlEventButton[4]			= PetSoul_FengHunLu_Lace4_Go
	g_contorlEventButton[5]			= PetSoul_FengHunLu_Lace5_Go

	g_contorlEventButtonHotP[1]		= PetSoul_FengHunLu_Lace1_Go_tips
	g_contorlEventButtonHotP[2]		= PetSoul_FengHunLu_Lace2_Go_tips
	g_contorlEventButtonHotP[3]		= PetSoul_FengHunLu_Lace3_Go_tips
	g_contorlEventButtonHotP[4]		= PetSoul_FengHunLu_Lace4_Go_tips
	g_contorlEventButtonHotP[5]		= PetSoul_FengHunLu_Lace5_Go_tips

	g_contorlEventGetedPic[1]		= PetSoul_FengHunLu_Lace1_Get
	g_contorlEventGetedPic[2]		= PetSoul_FengHunLu_Lace2_Get
	g_contorlEventGetedPic[3]		= PetSoul_FengHunLu_Lace3_Get
	g_contorlEventGetedPic[4]		= PetSoul_FengHunLu_Lace4_Get
	g_contorlEventGetedPic[5]		= PetSoul_FengHunLu_Lace5_Get

	g_contorlPointReward[1]			= PetSoul_FengHunLu_Award1
	g_contorlPointReward[2]			= PetSoul_FengHunLu_Award2
	g_contorlPointReward[3]			= PetSoul_FengHunLu_Award3
	g_contorlPointReward[4]			= PetSoul_FengHunLu_Award4
	g_contorlPointReward[5]			= PetSoul_FengHunLu_Award5

	g_contorlPointRewardGeted[1]	= PetSoul_FengHunLu_Award1_Get
	g_contorlPointRewardGeted[2]	= PetSoul_FengHunLu_Award2_Get
	g_contorlPointRewardGeted[3]	= PetSoul_FengHunLu_Award3_Get
	g_contorlPointRewardGeted[4]	= PetSoul_FengHunLu_Award4_Get
	g_contorlPointRewardGeted[5]	= PetSoul_FengHunLu_Award5_Get

end

--=========================================================
-- OnEvent
--=========================================================
function PetSoul_FengHunLu_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 ¹Ø± , 1 ´ò¿ª, 2 Ë¢ÐÂ, 3 ¶þ´ÎÈ·ÈÏ¿ò
		local nOpType 	= Get_XParam_INT(0)

		-- ¹Ø± ½çÃæ
		if 0 == nOpType then	
			if this:IsVisible() then
				PetSoul_FengHunLu_OnClose()
			end
		end

		-- ´ò¿ª½çÃæ
		if 1 == nOpType then
			-- ¹Ø×¢npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						PetSoul_FengHunLu_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_PetSoul_FengHunLu()
			end

			-- ÏÔÊ¾½çÃæ
			-- ÎªÁË½â¾ö½çÃæ±» Úµ²µÄÎÊÌâ£¬ÏÈ°Ñ½çÃæ¹ØÁË
			-- if this:IsVisible() then
			-- 	PetSoul_FengHunLu_OnClose()
			-- end
			PetSoul_FengHunLu_Reset()
			PetSoul_FengHunLu_Frame_On_ResetPos()
			this:Show()
			PetSoul_FengHunLu_ParamInit()

			-- ³õÊ¼»¯Ñ¡ÖÐ·ÖÒ³
			if g_nFengHunluDayIndex > g_nMaxTotalDay then
				g_nCurPage = g_nMaxTotalDay
			else
				g_nCurPage = g_nFengHunluDayIndex
			end

			PetSoul_FengHunLu_PageClick(g_nCurPage)

			PetSoul_FengHunLu_MoneyUpdate()
			PetSoul_FengHunLu_YuanBaoUpdate()
			PetSoul_FengHunLu_Update(1)
		end
			
		-- Ë¢ÐÂ½çÃæ
		if 2 == nOpType then
			-- ¹Ø×¢npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						PetSoul_FengHunLu_OnClose()
					end
				end
			end
			if this:IsVisible() then
				PetSoul_FengHunLu_ParamInit()
				PetSoul_FengHunLu_Update(0)
			end
		end

		-- ¶þ´ÎÈ·ÈÏ¿ò
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("PetSoul_FengHunLu_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end
	
	-- Í¬²½Ë¢ÐÂÍæ¼Ò»îÔ¾ÐÅÏ¢
	elseif (event == "ZHOUHUOYUE_UPDATE") then
		-- Ë¢ÐÂ½çÃæ
		-- if this:IsVisible() then
		-- 	g_nHuoYuePoint = tonumber( arg4 )
		-- 	PetSoul_FengHunLu_Update(0)
		-- end

	-- ============================================
	-- Í¨ÓÃÂß¼­
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- ¹Ø± ½çÃæ
			PetSoul_FengHunLu_OnClose()
		end	

	-- ÎïÆ·¸Ä±ä
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- Ë¢ÐÂ½çÃæ
		if this:IsVisible() then
			PetSoul_FengHunLu_Update(0)
		end

	-- ½ðÇ®¸Ä±ä
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		PetSoul_FengHunLu_MoneyUpdate()

	-- Ôª±¦¸Ä±ä
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		PetSoul_FengHunLu_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		PetSoul_FengHunLu_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		PetSoul_FengHunLu_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_FengHunLu_Frame_On_ResetPos()
		
	end
end

--=========================================================
-- ½çÃæ²ÎÊý³õÊ¼»¯
--=========================================================
function PetSoul_FengHunLu_ParamInit()
	g_nFengHunluDayIndex 	= Get_XParam_INT(1)
	g_nMDMaiDian01			= Get_XParam_INT(2)
	g_nMDMaiDian02 			= Get_XParam_INT(3)
	g_nMDReward01 			= Get_XParam_INT(4)
	g_nMDReward02 			= Get_XParam_INT(5)
	g_nHuoYuePoint 			= Get_XParam_INT(6)
	g_nEndYear 				= Get_XParam_INT(7)
	g_nEndMonth 			= Get_XParam_INT(8)
	g_nEndDay 				= Get_XParam_INT(9)

	-- PushDebugMessage("g_nFengHunluDayIndex:"..g_nFengHunluDayIndex)
	-- PushDebugMessage("g_nMDMaiDian01:"..g_nMDMaiDian01..",g_nMDMaiDian02:"..g_nMDMaiDian02)
	-- PushDebugMessage("g_nMDReward01:"..g_nMDReward01..",g_nMDReward02:"..g_nMDReward02)

	if g_nFengHunluDayIndex <= 0 then
		PetSoul_FengHunLu_OnClose()
	end

end

--=========================================================
-- ½çÃæ¸üÐÂ
--=========================================================
-- !!!reloadscript =PetSoul_FengHunLu
function PetSoul_FengHunLu_Update(bOpen)
	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end

	if nil == g_nCurPage or g_nCurPage <= 0 or g_nCurPage > nOpenDays then
		return
	end

	-- Ò³Ç©Ñ¡ÖÐÂß¼­
	for i = 1, g_nMaxTotalDay do
		g_contorlPage[i] : SetCheck(0)
	end
	g_contorlPage[g_nCurPage] : SetCheck(1)

	-- µãÊý½±Àø ¹Ê¾
	for i = 1, table.getn(g_tabPointRewardInfo) do
		tPointRewardInfo = g_tabPointRewardInfo[i]
		-- local theAction = DataPool:CreateBindActionItemForShow(tPointRewardInfo.nRewardItemID, 1)
		local theAction = DataPool:CreateActionItemForShow(tPointRewardInfo.nRewardItemID, tPointRewardInfo.nRewardItemNum)
		g_contorlPointReward[i] : SetActionItem(theAction:GetID())

		local bGeted = PetSoul_FengHunLu_GetPointRewardFlag(i)
		if 1 == bGeted then
			g_contorlPointRewardGeted[i] : Show()
		else
			g_contorlPointRewardGeted[i] : Hide()
		end
	end

	-- ½ø¶ÈÌõ ¹Ê¾
	local nTotalPoint = PetSoul_FengHunLu_GetTotalPoint()
	local strTipsForProgress = ScriptGlobal_Format("#{XYSHFC_20211229_153}", tostring(nTotalPoint))
	PetSoul_FengHunLu_EXPTip : SetToolTip(strTipsForProgress)
	PetSoul_FengHunLu_EXP : SetProgress(tonumber(nTotalPoint), g_nMaxPoint)	

	-- ½ØÖ¹Ê±¼äÏÔÊ¾
	PetSoul_FengHunLu_Condition_Text : SetText( ScriptGlobal_Format("#{XYSHFC_20211229_154}", g_nEndYear, g_nEndMonth, g_nEndDay ))

	-- ÁìÈ¡½±ÀøµÄºìµã
	local bShowHotPointForPointReward = 0
	for i = 1, g_nMaxPointRewardLevel do
		local subInfo = g_tabPointRewardInfo[i]
		if nil ~= subInfo and nTotalPoint >= subInfo.nNeedPoint and 1 ~= PetSoul_FengHunLu_GetPointRewardFlag(i) then
			-- PushDebugMessage("i"..i..",nTotalPoint:"..nTotalPoint..",subInfo.nNeedPoint:"..subInfo.nNeedPoint..",Flag:"..PetSoul_FengHunLu_GetPointRewardFlag(i))
			bShowHotPointForPointReward = 1
		end
	end

	if 1 == bShowHotPointForPointReward then
		PetSoul_FengHunLu_GetAward_tips : Show()
	else
		PetSoul_FengHunLu_GetAward_tips : Hide()
	end
		
	-- ÏÈÒþ²ØËùÓÐ·ÖÒ³µÄºìµã
	for i = 1, g_nMaxTotalDay do
		g_contorlPageTips[i] : Hide()
	end

	-- ¼ÆËãËùÓÐ·ÖÒ³µÄºìµãÐÅÏ¢
	for i = 1, nOpenDays do
		local bShowHotPoint = 0
		for j = 1, g_nMaxEventPerDay do
			local nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex = PetSoul_FengHunLu_GetEventDetailInfo(i, j)
			if 1 == bFinish and 0 == bEventRewardFlag then
				bShowHotPoint = 1
			end
		end

		if 1 == bShowHotPoint then
			g_contorlPageTips[i] : Show()
		end
	end

	-- ÏÔÊ¾·ÖÒ³ÊÂ¼þÐÅÏ¢
	for i = 1, g_nMaxEventPerDay do
		local nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex = PetSoul_FengHunLu_GetEventDetailInfo(g_nCurPage, i)

		-- PushDebugMessage("nMaiDianID"..nMaiDianID.."nCurMaiDianValue"..nCurMaiDianValue)

		local tEventShowInfo 	= g_tabEventShowInfo[nEventIndex]
		local tEventClickInfo 	= g_tabEventClickInfo[nEventIndex]

		if nil == tEventShowInfo or nil == tEventClickInfo then
			return
		end

		g_contorlEventIcon[i] 		: SetProperty("Image", tEventShowInfo.strPic)
		g_contorlEventDes[i] 		: SetText( tEventShowInfo.strDes )
		if nCurMaiDianValue == nNeedMaiDianValue then
			g_contorlEventProcess[i] 	: SetText( "#{XYSHFC_20211229_163}" )
		else
			g_contorlEventProcess[i] 	: SetText( ScriptGlobal_Format("#{XYSHFC_20211229_128}", nCurMaiDianValue, nNeedMaiDianValue ))
		end
		g_contorlEventReward[i] 	: SetText( ScriptGlobal_Format("#{XYSHFC_20211229_129}", nGetRewardPoint ))
		g_contorlEventButton[i] 	: SetToolTip(tEventShowInfo.strTips)

		g_contorlEventButton[i] : Show()
		g_contorlEventGetedPic[i] : Hide()
		g_contorlEventButtonHotP[i] : Hide()
		
		if 0 == bFinish then
			-- Ç°Íù
			g_contorlEventButton[i] : SetText( "Ðªn " )
		elseif 0 == bEventRewardFlag then
			-- ÁìÈ¡
			g_contorlEventButton[i] : SetText( "#{XYSHFC_20211229_106}" )
			g_contorlEventButtonHotP[i] : Show()
		else
			-- ÒÑÁìÈ¡
			g_contorlEventButton[i] : Hide()
			g_contorlEventGetedPic[i] : Show()
		end

	end
	
end

--=========================================================
-- »ñÈ¡ÂñµãµÄÖµ
--=========================================================
function PetSoul_FengHunLu_GetMaiDianValue(nMaiDianID)
	if nil == nMaiDianID or nMaiDianID <= 0 then 
		return 0
	end

	local tableMaiDianInfo = g_tabMaiDianSaveInfo[nMaiDianID]
	if nil == tableMaiDianInfo then
		return 0
	end

	local nSaveMD = 0
	if 1 == tableMaiDianInfo.nSaveMDIndex then
		nSaveMD = g_nMDMaiDian01
	end
	if 2 == tableMaiDianInfo.nSaveMDIndex then
		nSaveMD = g_nMDMaiDian02
	end
	local nSavePos 	= tableMaiDianInfo.nSavePosStart
	local nSaveLen 	= tableMaiDianInfo.nSaveLen

	-- PushDebugMessage("nMaiDianID:"..nMaiDianID..",nSaveMD:"..nSaveMD..",nSavePos:"..nSavePos..",nSaveLen:"..nSaveLen)

	local nRet, nRetValue = GetBitValueInUINT(nSaveMD, nSavePos, nSaveLen)
	if nil == nRet or 1 ~= nRet then
		return 0
	end

	return nRetValue
end

--=========================================================
-- »ñÈ¡ÊÂ¼þ½±ÀøÊÇ·ñÒÑÁìÈ¡±ê¼Ç nDay µÚxÌì[1,8]£» nIndexOfDay[1,5] ±¾ÌìµÄµÚx¸öÊÂ¼þ
-- MD01 MD02 Ò»ÆðÊ¹ÓÃ Ã¿Ìì×î´ó5¸öµã ×î¶à8Ìì ¹²¼Æ40¸öµã ´ÓµÍ1Î»¿ªÊ¼Ê¹ÓÃ
-- ²ÎÊý·Ç·¨·µ»Ø-1 
--=========================================================
function PetSoul_FengHunLu_GetEventRewardFlag(nDay, nIndexOfDay)
	if nil == nDay or nDay < 1 or nDay > g_nMaxTotalDay then
		return -1
	end

	if nil == nIndexOfDay or nIndexOfDay < 1 or nIndexOfDay > g_nMaxEventPerDay then
		return -1
	end

	local nSaveMD = g_nMDReward01
	local nSavePos = g_nMaxEventPerDay * (nDay - 1) + nIndexOfDay - 1
	if nSavePos >= g_nMaxSavePos then
		nSaveMD = g_nMDReward02
		nSavePos = nSavePos - g_nMaxSavePos
	end

	-- °´Î»È¡±ê¼Ç[0,31]
	local nRet, nRetValue = GetBitValueInUINT(nSaveMD, nSavePos, 1)
	if nil == nRet or 1 ~= nRet then
		return 0
	end
	return nRetValue
end

--**********************************
-- »ñµÃÃ¿ÌìµÄ»î¶¯ÊÂ¼þµÄËùÓÐÐÅÏ¢
--**********************************
function PetSoul_FengHunLu_GetEventDetailInfo(nDayIndex, nIndexOfDay)

	if nil == nDayIndex or nDayIndex <= 0 then 
		return 0, 0, 0, 0, 0, 0
	end

	if nil == nIndexOfDay or nIndexOfDay <= 0 then 
		return 0, 0, 0, 0, 0, 0
	end

	local tableDayInfo = g_tabEventInfo[nDayIndex]
	if nil == tableDayInfo then
		return 0, 0, 0, 0, 0, 0
	end

	local tableEventInfo = tableDayInfo[nIndexOfDay]
	if nil == tableEventInfo then
		return 0, 0, 0, 0, 0, 0
	end

	local nMaiDianID 			= tableEventInfo.nMaiDianID
	local nNeedMaiDianValue 	= tableEventInfo.nMaiDianValue
	local nGetRewardPoint 		= tableEventInfo.nGetPoint
	local nEventIndex 			= tableEventInfo.nEventIndex
	local bEventRewardFlag		= PetSoul_FengHunLu_GetEventRewardFlag(nDayIndex, nIndexOfDay)
	local bFinish				= 0
	local nCurMaiDianValue		= 0

	if nMaiDianID > 0 then
		--  ý³£Âñµã
		local tableMaiDianInfo = g_tabMaiDianSaveInfo[nMaiDianID]
		if nil == tableMaiDianInfo then
			return 0, 0, 0, 0, 0, 0
		end

		nCurMaiDianValue = PetSoul_FengHunLu_GetMaiDianValue(nMaiDianID)

		-- ÒÑ¾­ÁìÈ¡ÁË ÌØÐ´³ÉÍê³É
		if 1 == bEventRewardFlag then
			nCurMaiDianValue = nNeedMaiDianValue
		end

	elseif -1 == nMaiDianID then
		-- ÌØÐ´ Ã¿È »îÔ¾µãÊý
		nCurMaiDianValue = g_nHuoYuePoint
		-- ÒÑ¾­ÁìÈ¡ÁË ÌØÐ´³ÉÍê³É
		if 1 == bEventRewardFlag then
			nCurMaiDianValue = nNeedMaiDianValue
		end
	else
		return 0, 0, 0, 0, 0, 0
	end

	if nCurMaiDianValue >= nNeedMaiDianValue then
		bFinish = 1
		nCurMaiDianValue = nNeedMaiDianValue
	end

	return nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex
end

--**********************************
-- ¼ÆËãÒÑÁìÈ¡µãÊý
--**********************************
function PetSoul_FengHunLu_GetTotalPoint()

	local nTotalPoint = 0
	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end
	for i = 1, nOpenDays do 
		for j = 1, g_nMaxEventPerDay do
			nTotalPoint = nTotalPoint + PetSoul_FengHunLu_GetEventRewardFlag(i, j)
		end
	end

	return nTotalPoint
end

--**********************************
-- »ñÈ¡ÀÛ»ý»ý·Ö½±ÀøÊÇ·ñÒÑÁìÈ¡±ê¼Ç nPointRewardLevel[1,10] µÚx¸ö»ý·Ö½±ÀøµÈ¼¶
-- MD02 ×î¸ßÎ»¿ªÊ¼Ê¹ÓÃ
-- ²ÎÊý·Ç·¨·µ»Ø-1 
--**********************************
function PetSoul_FengHunLu_GetPointRewardFlag(nPointRewardLevel)

	if nil == nPointRewardLevel or nPointRewardLevel < 1 or nPointRewardLevel > g_nMaxPointRewardLevel then
		return -1
	end

	local nSaveMD = g_nMDReward02
	local nSavePos = g_nMaxSavePos - nPointRewardLevel

	-- °´Î»È¡±ê¼Ç[0,31]
	local nRet, nRetValue = GetBitValueInUINT(nSaveMD, nSavePos, 1)
	if nil == nRet or 1 ~= nRet then
		return 0
	end
	return nRetValue
end

--=========================================================
-- ¶þ´ÎÈ·ÈÏ¿ò»Øµ÷ ["Type"] "Ok"µÄ·µ»ØÖµÓÐ"Ok"£» ["Type"] "YesNo"µÄ·µ»ØÖµÓÐ "Yes" "No"
--=========================================================
function PetSoul_FengHunLu_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- ·­Ò³
--=========================================================
function PetSoul_FengHunLu_PageClick(nPage)
	if nil == nPage or nPage <= 0 or nPage > g_nMaxTotalDay then
		return
	end

	if g_nCurPage == nPage then
		return
	end

	-- ·ÖÒ³Î´¿ªÆô
	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end
	if nPage > nOpenDays then
		PushDebugMessage(ScriptGlobal_Format("#{XYSHFC_20211229_127}", nPage))
		--  âÀïÒ²ÒªË¢ÐÂ ²»È»½çÃæ°´Å¥»á×Ô¶¯±»check
		PetSoul_FengHunLu_Update(bOpen)
		return
	end

	g_nCurPage = nPage
	
	PetSoul_FengHunLu_Update(0)
end

--=========================================================
-- »îµÃµãÊý×Ü½±Àø
--=========================================================
function PetSoul_FengHunLu_GetAwardClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "GetRewardOfPoint" )
		Set_XSCRIPT_ScriptID(791010)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========================================================
-- °ïÖú°´Å¥
--=========================================================
function PetSoul_FengHunLu_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "ShowHelp" )
		Set_XSCRIPT_ScriptID(791010)			
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========================================================
-- Ã¿È ÊÂ¼þµã»÷
--=========================================================
function PetSoul_FengHunLu_Item_Clicked(nIndexOfDay)

	-- PushDebugMessage("PetSoul_FengHunLu_Item_Clicked")

	if nil == nIndexOfDay or nIndexOfDay <=0 or nIndexOfDay > g_nMaxEventPerDay then
		return
	end

	local nOpenDays = g_nFengHunluDayIndex
	if nOpenDays > g_nMaxTotalDay then
		nOpenDays = g_nMaxTotalDay
	end

	if nil == g_nCurPage or g_nCurPage <= 0 or g_nCurPage > nOpenDays then
		return
	end

	local nMaiDianID, nCurMaiDianValue, nNeedMaiDianValue, nGetRewardPoint, bEventRewardFlag, bFinish, nEventIndex = PetSoul_FengHunLu_GetEventDetailInfo(g_nCurPage, nIndexOfDay)

	if 1 == bEventRewardFlag then
		return
	end

	-- PushDebugMessage("PetSoul_FengHunLu_Item_Clicked"..",bFinish:"..bFinish..",bEventRewardFlag:"..bEventRewardFlag)

	if 1 == bFinish then
		-- Áì½±
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GetRewardOfEvent" )
			Set_XSCRIPT_ScriptID(791010)
			Set_XSCRIPT_Parameter(0, g_nCurPage)					
			Set_XSCRIPT_Parameter(1, nIndexOfDay)				
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	else
		local tEventClickInfo 	= g_tabEventClickInfo[nEventIndex]

		if nil == tEventClickInfo then
			return
		end

		if g_nFengHunluDayIndex < 0 then
			PushDebugMessage("#{XYSHFC_20211229_131}")
		end

		-- ·µ»ØÐÑÄ¿ÌáÊ¾
		if 1 == tEventClickInfo.nOpType then
			PushDebugMessage(tEventClickInfo.strShow)
		end

		-- Ñ°Â·
		if 2 == tEventClickInfo.nOpType then
			AutoRuntoTargetExWithName(tEventClickInfo.nPosX, tEventClickInfo.nPoxZ, tEventClickInfo.nSceneID, tEventClickInfo.strNPCName)
		end
	end

end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function PetSoul_FengHunLu_Reset()
	g_nCurPage 				= 1
	g_nFengHunluDayIndex 	= 0
	g_nMDMaiDian01			= 0
	g_nMDMaiDian02 			= 0
	g_nMDReward01 			= 0
	g_nMDReward02 			= 0
	g_nHuoYuePoint 			= 0
	g_nEndYear 				= 0
	g_nEndMonth 			= 0
	g_nEndDay 				= 0
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function PetSoul_FengHunLu_OnClose()	
	this:Hide()
	StopCareObject_PetSoul_FengHunLu()
	-- ÖØÖÃ
	PetSoul_FengHunLu_Reset()
end

--=========================================================
-- ½çÃæÒþ²Ø
-- <Event Name="Hidden" Function="PetSoul_FengHunLu_OnHiden();" />
--=========================================================
function PetSoul_FengHunLu_OnHiden()
	StopCareObject_PetSoul_FengHunLu()
	-- ÖØÖÃ
	PetSoul_FengHunLu_Reset()
end

--=========================================================
-- ¹ØÐÄ²Ù×÷
--=========================================================
function BeginCareObject_PetSoul_FengHunLu()
	-- ¹ØÐÄ
	this:CareObject(g_nObjCaredIDClient, 1, "PetSoul_FengHunLu")
end

function StopCareObject_PetSoul_FengHunLu()
	-- È¡Ïû¹ØÐÄ
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "PetSoul_FengHunLu")
	end
	g_nServerObjID = -1
end

--=========================================================
-- ½ðÇ®Ë¢ÐÂ£º½çÃæ¸üÐÂµ÷ÓÃÒ»´Î ½ðÇ®ÊÂ¼þµ÷ÓÃÒ»´Î
--=========================================================
function PetSoul_FengHunLu_MoneyUpdate()
	-- PetSoul_FengHunLu_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- PetSoul_FengHunLu_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- Ôª±¦Ë¢ÐÂ£º½çÃæ¸üÐÂµ÷ÓÃÒ»´Î Ôª±¦ÊÂ¼þµ÷ÓÃÒ»´Î
--=========================================================
function PetSoul_FengHunLu_YuanBaoUpdate()
	-- PetSoul_FengHunLu_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- ½çÃæÎ»ÖÃ
--=========================================================
function PetSoul_FengHunLu_Frame_On_ResetPos()
	PetSoul_FengHunLu_FrameFull:SetProperty("UnifiedPosition", g_PetSoul_FengHunLu_Frame_UnifiedPosition)
end
