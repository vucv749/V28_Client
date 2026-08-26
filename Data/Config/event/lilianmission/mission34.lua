--MisDescBegin
x893209_g_ScriptId = 893209
x893209_g_MissionId = 2092
x893209_g_MainScriptId = 893185--主脚本号

--kdzz
x893209_g_KDZZID = 1006000554
x893209_g_KDZZSubID = 4

--放弃任务重置标记
x893209_g_LastMissionId = 2088

--前置任务
x893209_g_PreScirptId = 893209--上一脚本号
x893209_g_PreMissionId = 2091--上一任务号

--接任务npc
x893209_g_AcceptNPC_Name="祁婆婆"--接任务的npc或者npc列表

--交任务npc
x893209_g_Position_X=150--完成任务NPC属性
x893209_g_Position_Z=208
x893209_g_SceneID=2
x893209_g_AccomplishNPC_Name=""

--任务数据
x893209_g_MissionKind = 7
x893209_g_MissionLevel = 65
x893209_g_IfMissionElite = 0
x893209_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x893209_g_MissionName="#{LNQZ_220429_168}"--任务名
x893209_g_MissionInfo="#{LNQZ_220429_169}"--任务文本描述（任务领取对白）
x893209_g_MissionComplete="#{LNQZ_220429_170}"--任务完成对白
x893209_g_MissionTarget=""--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x893209_g_Custom = {{id="向武道长老复命",num=1}}
x893209_g_ParamIndex = 2--任务参数0-完成标记1-完成情况2-随机索引

--npc距离
x893209_g_NpcDist = 5

--奖励
x893209_g_Reward = {
[0] = 45,
[1] = 90,
[2] = 45,
}
x893209_g_RewardMax =2970
x893209_g_WDPointTotal_max =2970 + 2430

x893209_g_Reward_Tips = {
[0] = "#{LNQZ_220429_195}",
[1] = "#{LNQZ_220429_196}",
[2] = "#{LNQZ_220429_197}",
}

--MisDescEnd
