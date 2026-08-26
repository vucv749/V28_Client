--MisDescBegin

--脚本号
x600014_g_ScriptId = 600014

--任务号
x600014_g_MissionId = 1107

--目标NPC
x600014_g_Name = "苟写"

--任务等级
x600014_g_MissionLevel = 10000

--任务归类
x600014_g_MissionKind = 50

--是否是精英任务
x600014_g_IfMissionElite = 0

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--角色Mission变量说明
x600014_g_IsMissionOkFail			=0	--0 任务完成标记
x600014_g_MissionParam_SubId		=1	--1 子任务脚本号存放位置
x600014_g_MissionParam_KillNumber	=2	--2 需要消灭的怪物数量
x600014_g_Param_sceneid				=3	--3号：当前副本任务的场景号
x600014_g_Param_teamid				=4	--4号：接副本任务时候的队伍号
x600014_g_Param_killcount			=5	--5号：杀死任务怪的数量
x600014_g_Param_time				=6	--6号：完成副本所用时间(单位：秒)
--6号：未用
--7号：未用

--循环任务的数据索引，里面存着已做的环数
x600014_g_MissionRound = 42
--**********************************以上是动态****************************

--任务文本描述
x600014_g_MissionName = "科技任务"
x600014_g_MissionInfo = ""													--任务描述
x600014_g_MissionTarget = "    消灭书房中所有蠹怪。#r#{BHRW_091224_1}"		--任务目标
x600014_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600014_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600014_g_MissionComplete = "    干得不错，甚好甚好。"						--完成任务npc说话的话

x600014_g_Parameter_Kill_CountRandom = { { id = 300475, numNeeded = 2, numKilled = 5 } }

-- 通用城市任务脚本
x600014_g_CityMissionScript = 600001
x600014_g_SciTechScript = 600012

--任务奖励


--MisDescEnd
