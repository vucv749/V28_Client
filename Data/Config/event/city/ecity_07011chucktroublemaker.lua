--MisDescBegin

--脚本号
x600037_g_ScriptId = 600037

--任务号
x600037_g_MissionId = 1112

--父任务号
x600037_g_UpMissionId = 1111

--任务等级
x600037_g_MissionLevel = 10000

--任务归类
x600037_g_MissionKind = 50

--是否是精英任务
x600037_g_IfMissionElite = 0

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--角色Mission变量说明
x600037_g_IsMissionOkFail			=0	--0 任务完成标记[值不能变]
x600037_g_MissionParam_SubId		=1	--1 子任务脚本号存放位置[值不能变]
x600037_g_MissionParam_KillNumber	=2	--2 需要消灭的怪物数量
x600037_g_Param_sceneid				=3	--3号：当前副本任务的场景号
x600037_g_Param_killcount			=4	--4号：杀死任务怪的数量
--6号：未用
--7号：未用

--**********************************以上是动态****************************

--任务文本描述
x600037_g_MissionName = "与人出头"
x600037_g_MissionInfo = ""													--任务描述
x600037_g_MissionTarget = "    赶走滋事者。#r#{BHRW_091224_1}"				--任务目标

x600037_g_Parameter_Kill_CountRandom = { { id = 300470, numNeeded = 2, numKilled = 4 } }

-- 通用城市任务脚本
x600037_g_CityMissionScript = 600001
x600037_g_ConstructionScript = 600035
x600037_g_TransScript = 400900

--任务奖励


--MisDescEnd
