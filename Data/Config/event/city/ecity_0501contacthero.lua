--MisDescBegin
-- 脚本号
x600024_g_ScriptId = 600024

--任务号
x600024_g_MissionId = 1110

--任务目标npc
x600024_g_Name = "佟芙蓉"

--任务归类
x600024_g_MissionKind = 50

--任务等级
x600024_g_MissionLevel = 10000

--是否是精英任务
x600024_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600024_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600024_g_MissionName = "扩张任务"
x600024_g_MissionInfo = "    今天我想要 %s 了，去帮我找来吧！"			--任务描述
x600024_g_MissionTarget = "    将结交信给%n。#r#{BHRW_091224_1}"		--任务目标
x600024_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600024_g_SubmitInfo = "    事情进展得如何？"							--完成未提交时的npc对话
x600024_g_MissionComplete = "    不错不错，这下本帮的名气又在江湖上提高了不少。"		--完成任务npc说话的话

x600024_g_StrForePart = 5
x600024_g_NPCOffset = 30												-- Suppose to 30, 表里第几列 NPC 的偏移量
x600024_g_NPCOffsetEx	= 255 										--表里第几列 NPC 的偏移量扩充 modi:lby20071126

x600024_g_MissionRound = 55

-- 通用城市任务脚本
x600024_g_CityMissionScript = 600001
x600024_g_ExpandScript = 600023

--任务奖励


--MisDescEnd
