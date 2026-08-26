--MisDescBegin
x893199_g_ScriptId = 893199
x893199_g_MissionId = 2088
x893199_g_MainScriptId = 893185--主脚本号

--kdzz
x893199_g_KDZZID = 1006000553
x893199_g_KDZZSubID = 4

--放弃任务重置标记
x893199_g_LastMissionId = 2084

--前置任务
x893199_g_PreScirptId = 893198--上一脚本号
x893199_g_PreMissionId = 2087--上一任务号

--接任务npc
x893199_g_AcceptNPC_Name="乔飞飞"--接任务的npc或者npc列表

--交任务npc
x893199_g_Position_X=150--完成任务NPC属性
x893199_g_Position_Z=208
x893199_g_SceneID=0
x893199_g_AccomplishNPC_Name=""

--任务数据
x893199_g_MissionKind = 7
x893199_g_MissionLevel = 65
x893199_g_IfMissionElite = 0
x893199_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)

x893199_g_MissionName="#{XZDZ_220428_168}"--任务名
x893199_g_MissionInfo="#{XZDZ_220428_169}"--任务文本描述（任务领取对白）
x893199_g_MissionComplete="#{XZDZ_220428_170}"--任务完成对白
x893199_g_MissionTarget=""--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x893199_g_Custom = {{id="向武道长老复命",num=1}}
x893199_g_ParamIndex = 2--任务参数0-完成标记1-完成情况2-随机索引

--npc距离
x893199_g_NpcDist = 5

--奖励
x893199_g_Reward = {
[0] = 45,
[1] = 90,
[2] = 45,
}
x893199_g_RewardMax =2970
x893199_g_WDPointTotal_max =2970 + 2430

x893199_g_Reward_Tips = {
[0] = "#{XZDZ_220428_195}",
[1] = "#{XZDZ_220428_196}",
[2] = "#{XZDZ_220428_197}",
}

--MisDescEnd
