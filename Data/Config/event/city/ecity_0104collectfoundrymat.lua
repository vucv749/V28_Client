--MisDescBegin
-- 脚本号
x600006_g_ScriptId = 600006

--任务号
x600006_g_MissionId = 1105

--任务目标npc
x600006_g_Name = "马应雄"

--任务归类
x600006_g_MissionKind = 50

--任务等级
x600006_g_MissionLevel = 10000

--是否是精英任务
x600006_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600006_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600006_g_MissionName = "工程任务"
x600006_g_MissionInfo = ""													--任务描述
x600006_g_MissionTarget = "    从%n打落%s个%i。#r#{BHRW_091224_1}"			--任务目标
x600006_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600006_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600006_g_MissionComplete = "    干得不错，甚好甚好。"						--完成任务npc说话的话

x600006_g_Parameter_Item_AllRandom = { { id = 7, num = 6 } }

x600006_g_StrForePart = 5

x600006_g_MissionRound = 38

-- 通用城市任务脚本
x600006_g_CityMissionScript = 600001
x600006_g_EngineeringScript = 600002

x600006_g_StrList = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }

--任务奖励


--MisDescEnd
