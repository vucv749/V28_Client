--MisDescBegin
x998659_g_ScriptId = 998659
x998659_g_MissionId = 2255

--前置任务
x998659_g_PreScriptId = 998656
x998659_g_PreMissionId = 2252
x998659_g_PreMissionName="#{SFYD_231227_31}"

--下一任务
x998659_g_NextScriptId = 998657
x998659_g_NextMissionId = 2253

--kdzz
x998659_g_KDZZID = 1006000598
x998659_g_KDZZSubID = 5

--接任务npc
x998659_g_AcceptNPC_Name=""--接任务的npc或者npc列表

--任务数据
x998659_g_MissionKind = 9
x998659_g_MissionLevel = 50
x998659_g_IfMissionElite = 0
x998659_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x998659_g_MissionName="#{SFYD_231227_34}"--任务名
x998659_g_MissionTarget=""--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998659_g_Custom = {}
x998659_g_List1 = 
{
	{30304089,30304090,30304091,},
	{30307223,30307224,30307225,},
	{30301164,30301165,30301166,30301167,30301160,30301161,30301162,30301163,},
	{30307261,30307262,30307263,},
}

x998659_g_List2 = 21000049

--npc距离
x998659_g_NpcDist = 5

--任务npc
x998659_g_NpcList = 
{
	[51905] = {	IdentityId=IDENTITY_COOKING_IDX,acceptsuc="#{SFYD_231227_299}",accepterror="#{SFYD_231227_85}",acceptok="#{SFYD_231227_307}",
							submitfail="#{SFYD_231227_313}",submitsuc="#{SFYD_231227_319}",submiterror="#{SFYD_231227_101}",submitok="#{SFYD_231227_325}",},		--烹饪NPC
	[51906] = {	IdentityId=IDENTITY_PHARMACY_IDX,acceptsuc="#{SFYD_231227_300}",accepterror="#{SFYD_231227_86}",acceptok="#{SFYD_231227_308}",
							submitfail="#{SFYD_231227_314}",submitsuc="#{SFYD_231227_320}",submiterror="#{SFYD_231227_102}",submitok="#{SFYD_231227_326}", },		--制药NPC
	[51907] = {	IdentityId=IDENTITY_ATTACKEQUIP_IDX,acceptsuc="#{SFYD_231227_302}",accepterror="#{SFYD_231227_88}",acceptok="#{SFYD_231227_310}",
							submitfail="#{SFYD_231227_316}",submitsuc="#{SFYD_231227_322}",submiterror="#{SFYD_231227_104}",submitok="#{SFYD_231227_328}", },	--攻具NPC
	[51909] = {	IdentityId=IDENTITY_ENGINEER_IDX,acceptsuc="#{SFYD_231227_304}",accepterror="#{SFYD_231227_90}",acceptok="#{SFYD_231227_312}",
							submitfail="#{SFYD_231227_318}",submitsuc="#{SFYD_231227_324}",submiterror="#{SFYD_231227_106}",submitok="#{SFYD_231227_330}", },		--工程NPC
}

--MisDescEnd
