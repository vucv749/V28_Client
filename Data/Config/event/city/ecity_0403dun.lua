--MisDescBegin
-- 脚本号
x600020_g_ScriptId = 600020

--任务号
x600020_g_MissionId = 1108

--任务目标npc
x600020_g_Name = "穆易"

--任务归类
x600020_g_MissionKind = 50

--任务等级
x600020_g_MissionLevel = 10000

--是否是精英任务
x600020_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600020_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600020_g_MissionName = "市集任务"
x600020_g_MissionInfo = "    今天我想要 %s 了，去帮我找来吧！"			--任务描述
x600020_g_MissionTarget = "    通知%n尽快%s。#r#{BHRW_091224_1}"							--任务目标
x600020_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600020_g_SubmitInfo = "    事情进展得如何？"							--完成未提交时的npc对话
x600020_g_MissionComplete = "    干得不错，甚好甚好。"					--完成任务npc说话的话

x600020_g_StrForePart = 5
x600020_g_Offset = 21													-- Suppose to 21, 表里第几列 NPC 的偏移量
x600020_g_OffsetEx	= 251 										--表里第几列 NPC 的偏移量扩充 modi:lby20071126
x600020_g_MissionRound = 44

-- 通用城市任务脚本
x600020_g_CityMissionScript = 600001
x600020_g_MarketScript = 600017

x600020_g_StrList = { "偿还欠款", "来取货" }

--任务奖励


--MisDescEnd
