--MisDescBegin
--脚本号
--注意，御赐精纺系列的任务，都没有接任务的流程，也就是不会addMission，所以isHaveMission和delMission肯定出错yuanfengfeng-2009-7-29
x210233_g_ScriptId = 210233

--接受任务NPC属性
x210233_g_Position_X=160.4355
x210233_g_Position_Z=127.9695
x210233_g_SceneID=2
x210233_g_AccomplishNPC_Name="李工部"

--前提任务
--g_MissionIdPre =

--任务号
x210233_g_MissionId = 713

--任务目标npc
x210233_g_Name	="李工部"

--任务归类
x210233_g_MissionKind = 13

--任务等级
x210233_g_MissionLevel = 2

--是否是精英任务
x210233_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210233_g_IsMissionOkFail = 0		--变量的第0位

--任务需要得到的物品
x210233_g_DemandItem={{id=20309001,num=1},{id=20309005,num=1}}		--从背包中计算
--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x210233_g_MissionName="御赐精纺帽"
x210233_g_MissionInfo="#{event_dali_0046}"  --任务描述
x210233_g_MissionTarget="找到一品糯米和一品红豆，然后回#G大理城五华坛#W找四大善人之一的#R李工部#W#{_INFOAIM160,128,2,李工部}。"		--任务目标
x210233_g_ContinueInfo="  一品糯米和一品红豆你已经找到了？"		--未完成任务的npc对话
x210233_g_MissionComplete="  年轻人，做的不错。"					--完成任务npc说话的话

--任务奖励
x210233_g_ItemBonus={{id=10410047,num=1}}
x210233_g_MoneyBonus=0

--MisDescEnd
