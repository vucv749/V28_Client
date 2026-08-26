--MisDescBegin
--脚本号
x808082_g_ScriptId	= 808082

--接受任务NPC属性
x808082_g_Position_X=54.9700
x808082_g_Position_Z=192.5128
x808082_g_SceneID=2
x808082_g_AccomplishNPC_Name="王若禹"

--任务号
x808082_g_MissionId			= 1000
--下一个任务的ID
x808082_g_MissionIdNext	= 1000
--任务目标npc
x808082_g_Name 					= "王若禹"
--任务归类
x808082_g_MissionKind			= 13
--任务等级
x808082_g_MissionLevel		= 20
--是否是精英任务
x808082_g_IfMissionElite	= 0
--任务是否已经完成
x808082_g_IsMissionOkFail	= 0		--任务参数的第0位

--任务文本描述
x808082_g_MissionName			= "龟兔赛跑任务"
--任务描述
x808082_g_MissionInfo			= "#{GodFire_Info_001}"
--任务目标
x808082_g_MissionTarget		= "#{GodFire_Info_006}"
--未完成任务的npc对话
x808082_g_ContinueInfo		= "#{GodFire_Info_007}"
--完成任务npc说的话
x808082_g_MissionComplete	= "#{GodFire_Info_008}"
--每次龟兔赛跑活动需要打卡的城市总数
x808082_g_MaxRound	= 3
--控制脚本
x808082_g_ControlScript		= 001066

-- 任务完成情况,内容动态刷新,分别占用任务参数的第1,2,3,4位
x808082_g_Custom	= { {id="已与洛阳的赵明诚对话",num=1}, {id="已与苏州的陆士铮对话",num=1}, {id="已与大理的王若禹对话",num=1}, {id="已点燃全部孔明灯",num=24} }

--MisDescEnd
