--MisDescBegin

--脚本号
x231001_g_ScriptId = 231001

--副本名称
x231001_g_CopySceneName="珍珑棋局"

--任务号
x231001_g_MissionId = 4013

--上一个任务的ID
x231001_g_MissionIdPre = 4011

--目标NPC
x231001_g_Name = "王积薪"

--是否是精英任务
x231001_g_IfMissionElite = 1

--任务等级
x231001_g_MissionLevel = 10000

--任务归类
x231001_g_MissionKind = 1

--任务文本描述
x231001_g_MissionName="珍珑棋局"
x231001_g_MissionInfo="杀死棋盘上所有的108枚棋子，将王积薪从珍珑棋局的控制中解救出来。"  --任务描述
x231001_g_MissionTarget="杀死108枚棋子。"	--任务目标
x231001_g_ContinueInfo="你已经杀死108枚棋子了吗？"	--未完成任务的npc对话
x231001_g_MissionComplete="谢谢啊，我终于从无胜负的棋局中解脱出来了。"	--完成任务npc说话的话

--任务奖励
x231001_g_MoneyBonus=5000

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--循环任务的数据索引，里面存着已做的环数 MD_LINGLONG_HUAN
--任务是否已经完成
--MissionRound =
--**********************************以上是动态****************************
--角色Mission变量说明
x231001_g_IsMissionOkFail	= 0	--0号：当前任务是否完成(0未完成；1完成)
x231001_g_MissionRound		= 5	--Define MD_BAIMASI_HUAN from ScriptGlobal.lua
--x231001_g_DemandKill		= { {id=700,num=108} }
x231001_g_Custom					= { {id="已杀死：#r棋子",num=108} }
x231001_g_Param_killcount	=	1	--1号：杀死任务怪的数量
x231001_g_Param_sceneid		= 2	--2号：当前副本任务的场景号
x231001_g_Param_teamid		= 3	--3号：接副本任务时候的队伍号
x231001_g_Param_time			= 4	--4号：完成副本所用时间(单位：秒)
--6号：具体副本事件脚本占用
--7号：具体副本事件脚本占用

--MisDescEnd
