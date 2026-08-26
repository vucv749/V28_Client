--MisDescBegin
x998655_g_ScriptId = 998655
x998655_g_MissionId = 2251

--下一任务
x998655_g_NextScriptId = 998656
x998655_g_NextMissionId = 2252

--kdzz
x998655_g_KDZZID = 1006000598
x998655_g_KDZZSubID = 1

--接任务npc
x998655_g_AcceptNPC_Name=""--接任务的npc或者npc列表

--任务数据
x998655_g_MissionKind = 9
x998655_g_MissionLevel = 50
x998655_g_IfMissionElite = 0
x998655_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x998655_g_MissionName="#{SFYD_231227_28}"--任务名
x998655_g_MissionTarget="#{SFYD_231227_281}"--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998655_g_Custom = {{id="在江湖盟会中择一前往",num=1}}

--npc距离
x998655_g_NpcDist = 5

--任务npc
x998655_g_NpcList = 
{
	[51905] = {	IdentityId=IDENTITY_COOKING_IDX,submitsuc="#{SFYD_231227_93}",submiterror="#{SFYD_231227_101}",submitok="#{SFYD_231227_115}",},		--烹饪NPC
	[51906] = {	IdentityId=IDENTITY_PHARMACY_IDX,submitsuc="#{SFYD_231227_94}",submiterror="#{SFYD_231227_102}",submitok="#{SFYD_231227_116}", },		--制药NPC
	[51907] = {	IdentityId=IDENTITY_ATTACKEQUIP_IDX,submitsuc="#{SFYD_231227_96}",submiterror="#{SFYD_231227_104}",submitok="#{SFYD_231227_118}", },	--攻具NPC
	[51909] = {	IdentityId=IDENTITY_ENGINEER_IDX,submitsuc="#{SFYD_231227_98}",submiterror="#{SFYD_231227_106}",submitok="#{SFYD_231227_120}", },		--工程NPC
}

--MisDescEnd
