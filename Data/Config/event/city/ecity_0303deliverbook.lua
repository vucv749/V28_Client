--MisDescBegin
-- 脚本号
x600015_g_ScriptId = 600015

--任务号
x600015_g_MissionId = 1107

--任务目标npc
x600015_g_Name = "苟写"

--任务归类
x600015_g_MissionKind = 50

--任务等级
x600015_g_MissionLevel = 10000

--是否是精英任务
x600015_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600015_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600015_g_MissionName = "科技任务"
x600015_g_MissionInfo = "    今天我想要 %s 了，去帮我找来吧！"			--任务描述
x600015_g_MissionTarget = "    将%i送给%n。#r#{BHRW_091224_1}"			--任务目标
x600015_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600015_g_SubmitInfo = "    事情进展得如何？"							--完成未提交时的npc对话
x600015_g_MissionComplete = "    干得不错，甚好甚好。"					--完成任务npc说话的话

x600015_g_StrForePart = 5
x600015_g_ItemOffset = 20												-- Suppose to 20, 表里第几个物品列的偏移量
x600015_g_NPCOffset = 16												-- Suppose to 16, 表里第几列 NPC 的偏移量
x600015_g_NPCOffsetEx	= 249 										--表里第几列 NPC 的偏移量扩充 modi:lby20071126
x600015_g_MissionRound = 42

-- 通用城市任务脚本
x600015_g_CityMissionScript = 600001
x600015_g_SciTechScript = 600012

--任务奖励


--MisDescEnd
