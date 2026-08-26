--MisDescBegin
--脚本号
x210226_g_ScriptId = 210226

--接受任务NPC属性
x210226_g_Position_X=215
x210226_g_Position_Z=284
x210226_g_SceneID=2
x210226_g_AccomplishNPC_Name="段延庆"

--任务号
x210226_g_MissionId = 706

--上一个任务的ID
x210226_g_MissionIdPre = 705

--目标NPC
x210226_g_Name	="段延庆"

--任务归类
x210226_g_MissionKind = 13

--任务等级
x210226_g_MissionLevel = 8

--是否是精英任务
x210226_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210226_g_IsMissionOkFail = 0		--变量的第0位

--以上是动态**************************************************************

--任务文本描述
x210226_g_MissionName="送馒头"
x210226_g_MissionInfo="  [原来你是为了那告示来的。我不跟你废话。那边有个#R小乞丐#W快要饿死了，你去找个#Y馒头#W送给他。]"
x210226_g_MissionTarget="#{event_dali_0037}"
x210226_g_ContinueInfo="  [你已经把#Y馒头#W送到#R小乞丐#W手中了吗？]"
x210226_g_MissionComplete="  [嗯，看来你这个年轻人还是个可造之材。]"
x210226_g_SignPost = {x = 199, z = 256, tip = "小乞丐"}
x210226_g_Custom	= { {id="给小乞丐送馒头！",num=1} }
--任务奖励
x210226_g_MoneyBonus=100
--g_ItemBonus={{id=40002108,num=1}}


--MisDescEnd
