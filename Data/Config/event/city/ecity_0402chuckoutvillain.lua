--MisDescBegin

--脚本号
x600019_g_ScriptId = 600019

--任务号
x600019_g_MissionId = 1108

--目标NPC
x600019_g_Name = "穆易"

--任务等级
x600019_g_MissionLevel = 10000

--任务归类
x600019_g_MissionKind = 50

--是否是精英任务
x600019_g_IfMissionElite = 0

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--角色Mission变量说明
x600019_g_IsMissionOkFail			=0	--0 任务完成标记
x600019_g_MissionParam_SubId		=1	--1 子任务脚本号存放位置
x600019_g_MissionParam_KillNumber	=2	--2 需要消灭的怪物数量
x600019_g_Param_sceneid				=3	--3号：当前副本任务的场景号
x600019_g_Param_teamid				=4	--4号：接副本任务时候的队伍号
x600019_g_Param_killcount			=5	--5号：杀死任务怪的数量
x600019_g_Param_time				=6	--6号：完成副本所用时间(单位：秒)
--6号：未用
--7号：未用

--循环任务的数据索引，里面存着已做的环数
x600019_g_MissionRound = 44
--**********************************以上是动态****************************

--任务文本描述
x600019_g_MissionName = "市集任务"
x600019_g_MissionInfo = ""													--任务描述
x600019_g_MissionTarget = "    点击穆易，让他带你去市场，教训教训流氓恶霸。#r#{BHRW_091224_1}"		--任务目标
x600019_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600019_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600019_g_MissionComplete = "    干得不错，甚好甚好。"						--完成任务npc说话的话

x600019_g_Parameter_Kill_CountRandom = { { id = 300474, numNeeded = 2, numKilled = 5 } }

-- 通用城市任务脚本
x600019_g_CityMissionScript = 600001
x600019_g_MarketScript = 600017

--任务奖励


--MisDescEnd
