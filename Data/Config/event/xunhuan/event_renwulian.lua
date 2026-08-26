--MisDescBegin
--脚本号
x229022_g_scriptId = 229022

--前提任务
--g_MissionIdPre =

--任务目标npc[94,177]
x229022_g_Name	= "王夫人"

--任务号
x229022_g_MissionId = 1202

--任务归类
x229022_g_MissionKind = 1

--任务等级
x229022_g_MissionLevel = 10000

--是否是精英任务
x229022_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x229022_g_IsMissionOkFail = 0		--变量的第0位

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x229022_g_MissionName="连环任务"
x229022_g_MissionInfo=""  --任务描述
x229022_g_MissionTarget = "%f"
x229022_g_ContinueInfo="干得不错"		--未完成任务的npc对话
x229022_g_MissionComplete="嗯, 我知道了, 你干得不错"					--完成任务npc说话的话

--用来保存字符串格式化的数据
x229022_g_FormatList = {
								"找到%n",
								"将%i送给%n",
								"将#Y%p#W送给%n#r  #G小提示：如果需要变异珍兽，也可以找同类二代珍兽代替。",
								"教训%n",
								}

--只是为客户端显示MissionTarget而做, 所有的动态的字符串都需注册到该List表中
x229022_g_StrList = {
						 "他",
						 "她",
						 }

--格式字符串中对应于g_StringList中字符串的索引, 表示从4开始,后多少位视SetMissionByIndexEx(...)的多少而定
x229022_g_StrForePart=4

--动态item编号在missionparam存储的起始位置
x229022_g_ItemForePart=6

x229022_g_MissionRound	= 35		--记录循环任务变量

x229022_g_MissionLimitTime = 1800000

x229022_g_StopWatch_Pause_Flag = 57

x229022_g_NpcIdIndicator={{key=1,npcIdIndex=5},{key=2,npcIdIndex=6},{key=3,npcIdIndex=5},{key=5,npcIdIndex=6}}



--MisDescEnd
