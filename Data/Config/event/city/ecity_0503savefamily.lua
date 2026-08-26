--MisDescBegin

--k¸ch bän g¯c Hào
x600026_g_ScriptId = 600026

--nhi®m vø Hào
x600026_g_MissionId = 1110

--møc tiêu NPC
x600026_g_Name = "Ðông Phù Dung"

--nhi®m vø c¤p b§c
x600026_g_MissionLevel = 10000

--nhi®m vø phân loÕi
x600026_g_MissionKind = 50

--hay không Th¸ tinh anh nhi®m vø
x600026_g_IfMissionElite = 0

--********phía dß¾i Ki HÕng Th¸ ðµng thái bi¬u hi®n Ðích nµi dung, dùng cho TÕi nhi®m vø Li®t Bi¬u Trung ðµng thái bi¬u hi®n nhi®m vø tình hu¯ng******
--vai di­n Missionlßþng biªn ð±i thuyªt minh

x600026_g_IsMissionOkFail			=0	--0 ??????
x600026_g_MissionParam_SubId		=1	--1 ??????????
x600026_g_Param_sceneid				=2	--2 ??????????
x600026_g_MissionParam_Phase		=3	--3 ??? ??????????UI?????
x600026_g_MissionParam_MasterId		=4	--4 ?????NPCId?
x600026_g_MissionParam_MenpaiIndex	=5	--5 ??????,??????????????????[???]????????????[????]

--tu¥n hoàn nhi®m vø Ðích s¯ li®u hß¾ng dçn tra cÑu, bên trong T°n Trß¾c Dî T¯ Ðích Hoàn S±
x600026_g_MissionRound = 55
--**********************************ðã ngoài Th¸ ðµng thái****************************

--nhi®m vø vån bän miêu tä
x600026_g_MissionName = "Nhi®m vø khuªch trß½ng"
x600026_g_MissionInfo = ""														--????
x600026_g_MissionTarget = "%f"													--????
x600026_g_ContinueInfo = "    Nhi®m vø cüa các hÕ vçn chßa hoàn thành à?"							--??????npc??
x600026_g_SubmitInfo = "    Sñ tình tiªn tri¬n nhß thª nào r°i?"									--???????npc??
x600026_g_MissionComplete = "R¤t t¯t, l¥n này hành ðµng giang h° biªt rõ, ð«u b¸ XÑng Ngã Bang ðÕi ðÑc ðÕi nghîa."	--????npc????

x600026_g_StrForePart = 3

--dùng ð¬ bäo t°n tñ phù Xuyªn cách thÑc Hoá Ðích s¯ li®u
x600026_g_FormatList = {
	"",
	"Träo%1ncÑu vi®n Cai môn phái ðÕi kiªp nÕn ðÕi nÕn. #r#{BHRW_091224_1}",
	"Hµ t¯ng%2sð® tØ ði ra c¤m ð¸a. #r#{BHRW_091224_1}",
}

x600026_g_StrList = {
	[0] = "Thiªu Lâm",
	[1] = "Minh Giáo",
	[2] = "Cái Bang",
	[3] = "Võ Ðang",
	[4] = "?ëáÒ",
	[5] = "Thiên Long Tñ",
	[6] = "Tinh Túc",
	[7] = "Thiên S½n",
	[8] = "Tiêu dao",
}

x600026_g_MenpaiInfo = {
	[0] = { Name = "Thiªu Lâm",		NpcId = 1700008,	CopySceneName = "Tháp Lâm",		Type = FUBEN_TALIN1,		    Map = "tongrenxiang_2.nav",		Exit = "tongrenxiang_2_area.ini",	Monster = "tongrenxiang_2_monster_%d.ini", 	EntrancePos = { x = 28, z = 52 },	BackPos = { x = 38, z = 97 }, },
	[1] = { Name = "Minh Giáo",		NpcId = 1700009,	CopySceneName = "Quang Minh ðµng",	Type = FUBEN_GUANGMINGDONG1,	Map = "guangmingdong_2.nav",	Exit = "guangmingdong_2_area.ini",	Monster = "guangmingdong_2_monster_%d.ini", EntrancePos = { x = 19, z = 42 },	BackPos = { x = 98, z = 57 }, },
	[2] = { Name = "Cái Bang",		NpcId = 1700010,	CopySceneName = "H¥m rßþu",		Type = FUBEN_JIUJIAO1,			Map = "jiujiao_2.nav",			Exit = "jiujiao_2_area.ini",		Monster = "jiujiao_2_monster_%d.ini", 		EntrancePos = { x = 45, z = 47 },	BackPos = { x = 91, z = 99 }, },
	[3] = { Name = "Võ Ðang",		NpcId = 1700011,	CopySceneName = "Linh Tính Phong",	Type = FUBEN_LINGXINGFENG1,		Map = "lingxingfeng_2.nav",		Exit = "lingxingfeng_2_area.ini",	Monster = "lingxingfeng_2_monster_%d.ini", 	EntrancePos = { x = 42, z = 46 },	BackPos = { x = 77, z = 86 }, },
	[4] = { Name = "?ëáÒ",		NpcId = 1700012,	CopySceneName = "Ðào Hoa Tr§n",	Type = FUBEN_TAOHUAZHEN1,		Map = "taohuazhen_2.nav",		Exit = "taohuazhen_2_area.ini",		Monster = "taohuazhen_2_monster_%d.ini", 	EntrancePos = { x = 26, z = 46 },	BackPos = { x = 96, z = 73 }, },
	[5] = { Name = "Thiên Long Tñ",	NpcId = 1700013,	CopySceneName = "Chân tháp",		Type = FUBEN_TADI1,				Map = "tadi_2.nav",				Exit = "tadi_2_area.ini",			Monster = "tadi_2_monster_%d.ini", 			EntrancePos = { x = 45, z = 48 },	BackPos = { x = 96, z = 67 }, },
	[6] = { Name = "Tinh Túc",		NpcId = 1700014,	CopySceneName = "Ngû Th¥n Ðµng",	Type = FUBEN_WUSHENDONG1,		Map = "wushendong_2.nav",		Exit = "wushendong_2_area.ini",		Monster = "wushendong_2_monster_%d.ini", 	EntrancePos = { x = 14, z = 40 },	BackPos = { x = 142, z = 56 }, },
	[7] = { Name = "Thiên S½n",		NpcId = 1700015,	CopySceneName = "Chiªt Mai Phong",	Type = FUBEN_ZHEMEIFENG1,		Map = "zhemeifeng_2.nav",		Exit = "zhemeifeng_2_area.ini",		Monster = "zhemeifeng_2_monster_%d.ini", 	EntrancePos = { x = 29, z = 49 },	BackPos = { x = 90, z = 45 }, },
	[8] = { Name = "Tiêu dao",		NpcId = 1700016,	CopySceneName = "C¯c ð¸a",		Type = FUBEN_GUDI1,				Map = "gudi_2.nav",				Exit = "gudi_2_area.ini",			Monster = "gudi_2_monster_%d.ini", 			EntrancePos = { x = 42, z = 47 },	BackPos = { x = 124, z = 145 }, },
}

-- thông døng thành th¸ nhi®m vø k¸ch bän g¯c
x600026_g_CityMissionScript = 600001
x600026_g_ExpandScript = 600023

--nhi®m vø thß·ng cho


--MisDescEnd
