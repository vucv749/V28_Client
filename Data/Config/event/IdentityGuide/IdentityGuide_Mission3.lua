--MisDescBegin
x998657_g_ScriptId = 998657
x998657_g_MissionId = 2253

--前置任务
x998657_g_PreScriptId = 998659
x998657_g_PreMissionId = 2255
x998657_g_PreMissionName="#{SFYD_231227_29}"

--下一任务
x998657_g_NextScriptId = 998658
x998657_g_NextMissionId = 2254

--kdzz
x998657_g_KDZZID = 1006000598
x998657_g_KDZZSubID = 3

--接任务npc
x998657_g_AcceptNPC_Name=""--接任务的npc或者npc列表

--任务数据
x998657_g_MissionKind = 9
x998657_g_MissionLevel = 50
x998657_g_IfMissionElite = 0
x998657_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x998657_g_MissionName="#{SFYD_231227_30}"--任务名
x998657_g_MissionTarget=""--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998657_g_Custom = {}

--npc距离
x998657_g_NpcDist = 5

--任务npc
x998657_g_NpcList = 
{
	[51905] = {	IdentityId=IDENTITY_COOKING_IDX,acceptsuc="#{SFYD_231227_150}",accepterror="#{SFYD_231227_85}",acceptok="#{SFYD_231227_159}",
							submitfail="#{SFYD_231227_177}",submitsuc="#{SFYD_231227_190}",submiterror="#{SFYD_231227_101}",submitok="#{SFYD_231227_196}",},		--烹饪NPC
	[51906] = {	IdentityId=IDENTITY_PHARMACY_IDX,acceptsuc="#{SFYD_231227_151}",accepterror="#{SFYD_231227_86}",acceptok="#{SFYD_231227_160}",
							submitfail="#{SFYD_231227_178}",submitsuc="#{SFYD_231227_191}",submiterror="#{SFYD_231227_102}",submitok="#{SFYD_231227_197}",},		--制药NPC
	[51907] = {	IdentityId=IDENTITY_ATTACKEQUIP_IDX,acceptsuc="#{SFYD_231227_153}",accepterror="#{SFYD_231227_88}",acceptok="#{SFYD_231227_162}",
							submitfail="#{SFYD_231227_180}",submitsuc="#{SFYD_231227_193}",submiterror="#{SFYD_231227_104}",submitok="#{SFYD_231227_199}",},	--攻具NPC
	[51909] = {	IdentityId=IDENTITY_ENGINEER_IDX,acceptsuc="#{SFYD_231227_155}",accepterror="#{SFYD_231227_90}",acceptok="#{SFYD_231227_164}",
							submitfail="#{SFYD_231227_182}",submitsuc="#{SFYD_231227_195}",submiterror="#{SFYD_231227_106}",submitok="#{SFYD_231227_201}",},		--工程NPC
}

--MisDescEnd
