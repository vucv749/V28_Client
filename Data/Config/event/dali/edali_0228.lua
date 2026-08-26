--MisDescBegin
--脚本号
x210228_g_ScriptId = 210228

--接受任务NPC属性
x210228_g_Position_X=215
x210228_g_Position_Z=284
x210228_g_SceneID=2
x210228_g_AccomplishNPC_Name="段延庆"

--任务号
x210228_g_MissionId = 708

--上一个任务的ID
x210228_g_MissionIdPre = 707

--目标NPC
x210228_g_Name	="段延庆"

--任务归类
x210228_g_MissionKind = 13

--任务等级
x210228_g_MissionLevel = 8

--是否是精英任务
x210228_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210228_g_IsMissionOkFail = 0		--变量的第0位

--以上是动态**************************************************************

--任务文本描述
x210228_g_MissionName="送矿锄"
x210228_g_MissionInfo="  [有吃的，有穿的，那个#R小乞丐#W还是不能生活啊。去找一把#Y矿锄#W送给他吧，让他以后能够自食其力。]#r  #e00f000小提示：#e000000你可以找边上的 #gfff0f0养雕人 #g000000直接飞到杂货铺附近。#r"
x210228_g_MissionTarget="#{event_dali_0040}"
x210228_g_ContinueInfo="  [你已经把#Y矿锄#W送到#R小乞丐#W手中了吗？]"
x210228_g_MissionComplete="#{event_dali_0041}"
x210228_g_SignPost = {x = 199, z = 256, tip = "小乞丐"}
x210228_g_Custom	= { {id="给小乞丐送矿锄！",num=1} }
--任务奖励
x210228_g_MoneyBonus=240
--g_ItemBonus={{id=40002108,num=1}}


--MisDescEnd
