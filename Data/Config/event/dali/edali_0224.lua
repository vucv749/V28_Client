--MisDescBegin
--脚本号
x210224_g_ScriptId = 210224

--接受任务NPC属性
x210224_g_Position_X=160.0895
x210224_g_Position_Z=156.9309
x210224_g_SceneID=2
x210224_g_AccomplishNPC_Name="赵天师"

--任务号
x210224_g_MissionId = 704

--上一个任务的ID
--g_MissionIdPre =

--目标NPC
x210224_g_Name	="赵天师"

--任务归类
x210224_g_MissionKind = 13

--任务等级
x210224_g_MissionLevel = 8

--是否是精英任务
x210224_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x210224_g_IsMissionOkFail = 0		--变量的第0位

--以上是动态**************************************************************

--任务文本描述
x210224_g_MissionName="去看看布告"
x210224_g_MissionInfo="#{event_dali_0034}"
x210224_g_MissionTarget="阅读#G大理皇宫门口#W的#R布告牌#W#{_INFOAIM148,40,2,-1}，然后回#G大理城五华坛#W找#R赵天师#W#{_INFOAIM160,157,2,赵天师}。#b#G（请用左键点击带下划线的坐标，帮助您找到该NPC）#l"
x210224_g_ContinueInfo="  你已经看过#Y布告牌#W了吗？"
x210224_g_MissionComplete="  你已经看过#Y布告牌#W了吧？这样的坏人，一定要严加惩处。"
x210224_g_SignPost = {x = 148, z = 40, tip = "布告牌"}
--任务奖励
x210224_g_MoneyBonus=100
--g_ItemBonus={{id=40002108,num=1}}

x210224_g_Custom	= { {id="已阅读公告牌",num=1} }
x210224_g_IsMissionOkFail = 1		--变量的第0位


--MisDescEnd
