--MisDescBegin
--脚本号
x232002_g_ScriptId	= 232002
--副本名称
x232002_g_CopySceneName	= "水牢"
--任务号
x232002_g_MissionId			= 1213
--上一个任务的ID
x232002_g_MissionIdPre	= 1212
--目标NPC
x232002_g_Name					= "呼延庆"
--是否是精英任务
x232002_g_IfMissionElite= 1
--任务等级
x232002_g_MissionLevel	= 10000
--任务归类
x232002_g_MissionKind		= 1
--任务文本描述
x232002_g_MissionName			= "水牢"
--任务描述
x232002_g_MissionInfo			= "#{event_xunhuan_0006}"
--任务目标
x232002_g_MissionTarget		= "  太湖水寨的呼延庆#{_INFOAIM67,77,4,呼延庆}让你杀死10个犯人头目和50个小怪物。"
--未完成任务的npc对话
x232002_g_ContinueInfo		= "  你是否已经杀死10个凶悍的犯人头目，以及诸多小怪物？"
--完成任务npc说话的话
x232002_g_MissionComplete	= "  水牢终于守住了，我们以后千万不能掉以轻心。"
--任务奖励
--x232002_g_MoneyBonus			= 1000
--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--循环任务的数据索引，里面存着已做的环数 MD_SHUILAO_HUAN
--任务是否已经完成
--MissionRound =
--**********************************以上是动态****************************
--角色Mission变量说明
x232002_g_IsMissionOkFail	= 0	--0号：当前任务是否完成(0未完成；1完成)
x232002_g_MissionRound		= 5	--Define MD_BAIMASI_HUAN from ScriptGlobal.lua
x232002_g_DemandKill			= { {id=367,num=60} }
x232002_g_Param_killcount	= 1	--1号：杀死任务怪的数量
x232002_g_Param_sceneid		= 2	--2号：当前副本任务的场景号
x232002_g_Param_teamid		= 3	--3号：接副本任务时候的队伍号
x232002_g_Param_time			= 4	--4号：完成副本所用时间(单位：秒)
--6号：具体副本事件脚本占用
--7号：具体副本事件脚本占用

--MisDescEnd
