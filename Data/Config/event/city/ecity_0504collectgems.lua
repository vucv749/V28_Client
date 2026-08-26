--MisDescBegin
-- 脚本号
x600027_g_ScriptId = 600027

--任务号
x600027_g_MissionId = 1110

--任务目标npc
x600027_g_Name = "佟芙蓉"

--任务归类
x600027_g_MissionKind = 50

--任务等级
x600027_g_MissionLevel = 10000

--是否是精英任务
x600027_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600027_g_IsMissionOkFail			=0	--0 任务完成标记[值不能变]
x600027_g_MissionParam_SubId		=1	--1 子任务脚本号存放位置[值不能变]
x600027_g_GemCount					=2	--2 需要的宝石数量
x600027_g_GemSerialNum				=3	--3 需要的宝石

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600027_g_MissionName = "扩张任务"
x600027_g_MissionInfo = ""			--任务描述
x600027_g_MissionTarget = "    找%s个%i交还到本帮的佟芙蓉 ( 148, 96 )处。#r#{BHRW_091224_1}"	--任务目标
x600027_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600027_g_SubmitInfo = "    事情进展得如何？"							--完成未提交时的npc对话
x600027_g_MissionComplete = "    甚好甚好。"							--完成任务npc说话的话

x600027_g_Parameter_Item_AllRandom = { { id = 3, num = 2 } }

x600027_g_StrForePart = 2
x600027_g_Offset = 35													-- Suppose to ？, 表里第几个物品列的偏移量

x600027_g_MissionRound = 55

-- 通用城市任务脚本
x600027_g_CityMissionScript = 600001
x600027_g_ExpandScript = 600023

x600027_g_StrList = { " 0 ", " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", " 10 " }

--任务奖励



--MisDescEnd
