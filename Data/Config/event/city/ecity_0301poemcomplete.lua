--MisDescBegin
-- 脚本号
x600013_g_ScriptId = 600013

--任务号
x600013_g_MissionId = 1107

--任务目标npc
x600013_g_Name = "苟写"

--任务归类
x600013_g_MissionKind = 50

--任务等级
x600013_g_MissionLevel = 10000

--是否是精英任务
x600013_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600013_g_IsMissionOkFail = 0							-- 任务完成标记
x600013_g_MissionParam_SubId = 1						-- 子任务脚本号存放位置
x600013_g_MissionParam_PoemIssued = 2					-- 是否已经发布诗句
x600013_g_MissionParam_IsFailed = 3						-- 正确答案索引存放位置
x600013_g_MissionParam_PoemIndex = 4					-- 诗句索引存放位置
x600013_g_MissionParam_AnswerIndex = 5					-- 正确答案索引存放位置

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x600013_g_MissionName = "科技任务"
x600013_g_MissionInfo = "    今天我想要 %s 了，去帮我找来吧！"			--任务描述
x600013_g_MissionTarget = "    答对古诗对句一题。#r#{BHRW_091224_1}"	--任务目标
x600013_g_ContinueInfo = "    你的任务还没有完成么？"					--未完成任务的npc对话
x600013_g_SubmitInfo = "    事情进展得如何？"							--完成未提交时的npc对话
x600013_g_MissionComplete = "    干得不错，甚好甚好。"					--完成任务npc说话的话

x600013_g_StrForePart = 5
x600013_g_Offset = 140000												-- Suppose to 150000, 表里第几个物品列的偏移量

x600013_g_MissionRound = 42

-- 通用城市任务脚本
x600013_g_CityMissionScript = 600001
x600013_g_SciTechScript = 600012

--任务奖励


--MisDescEnd
