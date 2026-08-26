--MisDescBegin
-- 脚本号
x600044_g_ScriptId = 600044

--任务号
x600044_g_MissionId = 1109

--任务目标npc
x600044_g_Name = "武大威"

--任务归类
x600044_g_MissionKind = 50

--任务等级
x600044_g_MissionLevel = 10000

--是否是精英任务
x600044_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600044_g_IsMissionOkFail			= 0									--0 任务完成标记[值不能变]
x600044_g_MissionParam_SubId		= 1									--1 子任务脚本号存放位置[值不能变]

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600044_g_MissionName = "国防任务"
x600044_g_MissionInfo = "    国防任务"									--任务描述
x600044_g_MissionTarget = "    你的任务是杀死%n。#r#{BHRW_091224_1}"	--任务目标
x600044_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600044_g_SubmitInfo = "    事情进展得如何？"							--完成未提交时的npc对话
x600044_g_MissionComplete = "    干得不错，甚好甚好。"					--完成任务npc说话的话

x600044_g_StrForePart = 4

x600044_g_MissionRound = 79

x600044_g_Parameter_Kill_AllRandom = { { id = 4, numNeeded = 5, numKilled = 6 } }

-- 通用城市任务脚本
x600044_g_CityMissionScript = 600001
x600044_g_MilitaryScript = 600030

--任务奖励


--MisDescEnd
