--MisDescBegin
x998269_g_ScriptId = 998269
x998269_g_MissionId = 2195

--时间
x998269_g_BeginTime = 20230616
x998269_g_EndTime = 20230628
x998269_g_PrizeTime = 20230706

--kdzz
x998269_g_KDZZID = 1001000230
x998269_g_KDZZSubID = 1

--接任务npc
x998269_g_AcceptNPC_Name="易相知"--接任务的npc或者npc列表

--交任务npc
x998269_g_Position_X=160--完成任务NPC属性
x998269_g_Position_Z=112
x998269_g_SceneID=0
x998269_g_AccomplishNPC_Name="易相知"

--任务数据
x998269_g_MissionKind = 3
x998269_g_MissionLevel = 30
x998269_g_IfMissionElite = 0
x998269_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x998269_g_MissionName="#{SXZL_032901_63}"--任务名
x998269_g_MissionInfo="#{SXZL_032901_33}"--任务文本描述（任务领取对白）
x998269_g_MissionTarget="#{SXZL_032901_64}"--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998269_g_Custom = {{id="礼物送出",num=1}}

--npc距离
x998269_g_NpcDist = 5

--需要道具
x998269_g_NeedItem = 38002822
x998269_g_NeedNum = 6
--副本掉落数量
x998269_g_DaiBiItemGiveOnce = 1

--礼物npc
x998269_g_NpcList = 
{
	[1] = { sceneid = 0, npcid = 51032, npcname = "乔峰", itemid = 40005112, 
		text1 = "#{SXZL_032901_07}", text2 = "#{SXZL_032901_08}", text3 = "#{SXZL_032901_09}", text4 = "#{SXZL_032901_10}", 
		text0 = "#{SXZL_032901_104}", text5 = "#{SXZL_032901_111}", text6 = "#{SXZL_032901_112}", },
	[2] = { sceneid = 2, npcid = 51033, npcname = "段誉", itemid = 40005113, 
		text1 = "#{SXZL_032901_13}", text2 = "#{SXZL_032901_14}", text3 = "#{SXZL_032901_102}", text4 = "#{SXZL_032901_15}", 
		text0 = "#{SXZL_032901_105}", text5 = "#{SXZL_032901_113}", text6 = "#{SXZL_032901_114}", },
	[3] = { sceneid = 1, npcid = 51034, npcname = "虚竹", itemid = 40005114, 
		text1 = "#{SXZL_032901_16}", text2 = "#{SXZL_032901_17}", text3 = "#{SXZL_032901_18}", text4 = "#{SXZL_032901_19}", 
		text0 = "#{SXZL_032901_106}", text5 = "#{SXZL_032901_115}", text6 = "#{SXZL_032901_116}", },
	[4] = { sceneid = 0, npcid = 51035, npcname = "阿朱", itemid = 40005117, 
		text1 = "#{SXZL_032901_20}", text2 = "#{SXZL_032901_21}", text3 = "#{SXZL_032901_22}", text4 = "#{SXZL_032901_23}", 
		text0 = "#{SXZL_032901_107}", text5 = "#{SXZL_032901_119}", text6 = "#{SXZL_032901_120}", },
	[5] = { sceneid = 1, npcid = 51036, npcname = "木婉清", itemid = 40005116, 
		text1 = "#{SXZL_032901_24}", text2 = "#{SXZL_032901_25}", text3 = "#{SXZL_032901_26}", text4 = "#{SXZL_032901_27}", 
		text0 = "#{SXZL_032901_109}", text5 = "#{SXZL_032901_121}", text6 = "#{SXZL_032901_122}", },
	[6] = { sceneid = 2, npcid = 51037, npcname = "王语嫣", itemid = 40005115, 
		text1 = "#{SXZL_032901_28}", text2 = "#{SXZL_032901_29}", text3 = "#{SXZL_032901_30}", text4 = "#{SXZL_032901_32}", 
		text0 = "#{SXZL_032901_108}", text5 = "#{SXZL_032901_117}", text6 = "#{SXZL_032901_118}", },
}

--任务道具
x998269_g_TaskList = {1,6,2,4,3,5,2,4,3,1,6,5,4,}

--奖励道具
x998269_g_PrizeCommon = 38002814
x998269_g_PrizeSpecial = 38002815


--MisDescEnd
