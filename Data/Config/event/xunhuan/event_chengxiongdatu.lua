--MisDescBegin
--脚本号
x229020_g_ScriptId = 229020

--前提任务
--g_MissionIdPre =

--任务号
x229020_g_MissionId = 1200

--任务目标npc
x229020_g_Name	= "吴玠"

--任务归类
x229020_g_MissionKind = 1

--任务等级
x229020_g_MissionLevel = 10000

--是否是精英任务
x229020_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x229020_g_IsMissionOkFail = 0		--变量的第0位

--任务需要杀死的怪
x229020_g_DemandKill ={{id=3500,num=1}}		--变量第1位

x229020_g_DemandTrueKill ={{name="恶棍",num=1}}

--任务需要得到的物品
--g_DemandItem={{id=20309001,num=1},{id=20309005,num=1}}		--从背包中计算
--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x229020_g_MissionName="#{CXDT_090304_01}"
x229020_g_MissionInfo="#{CXDT_090304_02}"  --任务描述
x229020_g_MissionTarget = "#{CXDT_090304_03}"
x229020_g_ContinueInfo="#{CXDT_090304_04}"		--未完成任务的npc对话
x229020_g_MissionComplete="#{CXDT_090304_05}"					--完成任务npc说话的话

--任务奖励
x229020_g_MissionItem={{id=40004000,num=1}}

x229020_g_MissionRound = 49
--g_MoneyBonus = 1000


--MisDescEnd
