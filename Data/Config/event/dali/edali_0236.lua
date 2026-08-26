--MisDescBegin
--脚本号
--注意，御赐精纺系列的任务，都没有接任务的流程，也就是不会addMission，所以isHaveMission和delMission肯定出错yuanfengfeng-2009-7-29
x210236_g_ScriptId = 210236

--接受任务NPC属性
x210236_g_Position_X=160.4355
x210236_g_Position_Z=127.9695
x210236_g_SceneID=2
x210236_g_AccomplishNPC_Name="李工部"

--前提任务
--g_MissionIdPre =

--任务号
x210236_g_MissionId = 716

--任务目标npc
x210236_g_Name	="李工部"

--任务归类
x210236_g_MissionKind = 13

--任务等级
x210236_g_MissionLevel = 8

--是否是精英任务
x210236_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210236_g_IsMissionOkFail = 0		--变量的第0位

--任务需要得到的物品
x210236_g_DemandItem={{id=20309004,num=1},{id=20309008,num=1}}		--从背包中计算
--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x210236_g_MissionName="御赐精纺衣"
x210236_g_MissionInfo="#{event_dali_0049}"  --任务描述
x210236_g_MissionTarget="找到一品莲子和一品红枣，然后回#G大理城五华坛#W找四大善人之一的#R李工部#W#{_INFOAIM160,128,2,李工部}。"    --任务目标
x210236_g_ContinueInfo="  一品莲子和一品红枣你已经找到了？"		--未完成任务的npc对话
x210236_g_MissionComplete="  年轻人，做的不错。"					--完成任务npc说话的话

--任务奖励
x210236_g_ItemBonus={{id=10413047,num=1}}
x210236_g_MoneyBonus=0

--MisDescEnd
