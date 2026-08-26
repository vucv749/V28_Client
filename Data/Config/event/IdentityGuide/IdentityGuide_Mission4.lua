--MisDescBegin
x998658_g_ScriptId = 998658
x998658_g_MissionId = 2254

--前置任务
x998658_g_PreScriptId = 998657
x998658_g_PreMissionId = 2253
x998658_g_PreMissionName="#{SFYD_231227_30}"

--kdzz
x998658_g_KDZZID = 1006000598
x998658_g_KDZZSubID = 4

--接任务npc
x998658_g_AcceptNPC_Name=""--接任务的npc或者npc列表

--任务数据
x998658_g_MissionKind = 9
x998658_g_MissionLevel = 50
x998658_g_IfMissionElite = 0
x998658_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x998658_g_MissionName="#{SFYD_231227_31}"--任务名
x998658_g_MissionTarget="#{SFYD_231227_60}"--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998658_g_Custom = {{id="已掌握神工",num=1}}

--npc距离
x998658_g_NpcDist = 5

--任务npc
x998658_g_NpcList = 
{
	[51905] = {	IdentityId=IDENTITY_COOKING_IDX,acceptsuc="#{SFYD_231227_202}",accepterror="#{SFYD_231227_85}",acceptok="#{SFYD_231227_211}",
							submitfail="#{SFYD_231227_217}",submitsuc="#{SFYD_231227_223}",submiterror="#{SFYD_231227_101}",submitok="#{SFYD_231227_229}",},		--烹饪NPC
	[51906] = {	IdentityId=IDENTITY_PHARMACY_IDX,acceptsuc="#{SFYD_231227_203}",accepterror="#{SFYD_231227_86}",acceptok="#{SFYD_231227_212}",
							submitfail="#{SFYD_231227_218}",submitsuc="#{SFYD_231227_224}",submiterror="#{SFYD_231227_102}",submitok="#{SFYD_231227_230}", },		--制药NPC
	[51907] = {	IdentityId=IDENTITY_ATTACKEQUIP_IDX,acceptsuc="#{SFYD_231227_205}",accepterror="#{SFYD_231227_88}",acceptok="#{SFYD_231227_214}",
							submitfail="#{SFYD_231227_220}",submitsuc="#{SFYD_231227_226}",submiterror="#{SFYD_231227_104}",submitok="#{SFYD_231227_232}", },	--攻具NPC
	[51909] = {	IdentityId=IDENTITY_ENGINEER_IDX,acceptsuc="#{SFYD_231227_207}",accepterror="#{SFYD_231227_90}",acceptok="#{SFYD_231227_216}",
							submitfail="#{SFYD_231227_222}",submitsuc="#{SFYD_231227_228}",submiterror="#{SFYD_231227_106}",submitok="#{SFYD_231227_234}", },		--工程NPC
}

--MisDescEnd
