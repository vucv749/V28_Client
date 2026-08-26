--MisDescBegin
--脚本号
x500500_g_ScriptId = 500500

--上一个任务的ID
--g_MissionIdPre =

--任务号
x500500_g_MissionId = 700

--任务目标npc
x500500_g_Name	="何执中" 

--任务道具编号
x500500_g_ItemId = 40002106

--任务道具需求数量
x500500_g_ItemNeedNum = 1

--任务归类
x500500_g_MissionKind = 1

--任务等级
x500500_g_MissionLevel = 20

--是否是精英任务
x500500_g_IfMissionElite = 0

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
x500500_g_IsMissionOkFail = 0					--变量的第0位
x500500_g_DemandItem={{id=40002106,num=1}}		--变量第1位,任务需要得到的物品
x500500_g_MissionRound = 3						--循环任务的数据索引，里面存着已做的环数 MD_WABAO_HUAN
--**********************************以上是动态****************************


--任务文本描述
x500500_g_MissionName="寻宝"
x500500_g_MissionInfo="#{M_700_TEXT1}"  --任务描述
x500500_g_MissionTarget="找到宝藏交给何执中"		--任务目标
x500500_g_ContinueInfo="你找到宝藏了么？点击任务道具中的探测器就可以找到宝藏的位置了"		--未完成任务的npc对话
x500500_g_MissionComplete="干的不错"					--完成任务npc说话的话

x500500_g_MoneyBonus=100
x500500_g_ItemBonus={{id=30002001,num=1}}


--MisDescEnd
