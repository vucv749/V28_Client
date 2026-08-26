--MisDescBegin
--脚本号
x600045_g_ScriptId	= 600045

--接受任务NPC属性
x600045_g_Position_X=133
x600045_g_Position_Z=50

x600045_g_AccomplishNPC_Name="武大威"

--任务号
x600045_g_MissionId			= 1121

--任务目标npc
x600045_g_Name 					= "武大威"
--任务归类
x600045_g_MissionKind			= 50 --玩家城市
--任务等级
x600045_g_MissionLevel		= 10000
--是否是精英任务
x600045_g_IfMissionElite	= 0
--任务是否已经完成
x600045_g_IsMissionOkFail	= 0		--任务参数的第0位

--任务文本描述
x600045_g_MissionName			= "打探消息"
--任务描述
x600045_g_MissionInfo			= "帮派任务，利用情报簿打探其他帮派城市信息！"
--任务目标
x600045_g_MissionTarget		= "    需要和本帮成员组队收集3个不同帮派城市情报，然后到#G武大威#B[133,50]#W处领取奖励！"
--未完成任务的npc对话
x600045_g_ContinueInfo		= "看来你还没有完成啊！"
--完成任务npc说的话
x600045_g_MissionComplete	= "做的很好，感谢你为本帮派做出的贡献！"

--任务是否完成
--x600045_g_Mission_IsComplete = 0		--任务参数的第0位
--打探第几个城市
x600045_g_city 				 	= 1		 --任务参数的第1位

-- 任务完成情况,内容动态刷新,占用任务参数的第1位

x600045_g_Custom	= { {id="已打探城市",num=3} }

--MisDescEnd
