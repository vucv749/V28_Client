--MisDescBegin
-- 脚本号
x600005_g_ScriptId = 600005

--任务号
x600005_g_MissionId = 1105

--任务目标npc
x600005_g_Name = "马应雄"

--任务归类
x600005_g_MissionKind = 50

--任务等级
x600005_g_MissionLevel = 10000

--是否是精英任务
x600005_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600005_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600005_g_MissionName = "工程任务"
x600005_g_MissionInfo = "    今天我想要 %s 了，去帮我找来吧！"			--任务描述
x600005_g_MissionTarget = "    将%i送给%n。#r#{BHRW_091224_1}"			--任务目标
x600005_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600005_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600005_g_MissionComplete = "    干得不错，甚好甚好。"					--完成任务npc说话的话

x600005_g_StrForePart = 5
x600005_g_ItemOffset = 18												-- Suppose to 18, 表里第几个物品列的偏移量
x600005_g_NPCOffset = 7													-- Suppose to 7, 表里第几列 NPC 的偏移量
x600005_g_NPCOffsetEx = 245													-- Suppose to 7, 表里第几列 NPC 的偏移量

x600005_g_MissionRound = 38

-- 通用城市任务脚本
x600005_g_CityMissionScript = 600001
x600005_g_EngineeringScript = 600002

--任务奖励


--MisDescEnd
