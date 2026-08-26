--MisDescBegin
--脚本号
x050061_g_ScriptId	= 050061

--接受任务NPC属性
x050061_g_Position_X=78
x050061_g_Position_Z=95
x050061_g_SceneID=12
x050061_g_AccomplishNPC_Name="张中行"

--当前任务号
x050061_g_MissionId			= 1150
--下一个任务的ID
x050061_g_MissionIdNext	= -1
--任务目标npc
x050061_g_Name 					= ""
--任务归类
x050061_g_MissionKind			= 3
--任务等级
x050061_g_MissionLevel		= 10000
--是否是精英任务
x050061_g_IfMissionElite	= 0
--任务是否已经完成
x050061_g_IsMissionOkFail	= 0		--任务参数的第0位

--x050059_g_MissionRound = 249

--是否显示任务完成
x050061_g_AccomplishCircumstance = 0

--任务文本描述
x050061_g_MissionName			= "门派年货大采购"
--任务描述
x050061_g_MissionInfo			= ""
--任务目标
x050061_g_MissionTarget		= "%f"
--未完成任务的npc对话
x050061_g_ContinueInfo		= ""
--完成任务npc说的话
x050061_g_MissionComplete	= ""
--每次活动可以完成的次数
x050061_g_MaxRound	= 3

--用来保存字符串格式化的数据
x050061_g_FormatList = {
								"#{SMCJ_081021_29}",
								"#{SMCJ_081021_30}",
								"#{SMCJ_081021_31}",
								"#{SMCJ_081021_32}",
								"#{SMCJ_081021_33}",
								"#{SMCJ_081021_34}",
								"#{SMCJ_081021_35}",
								"#{SMCJ_081021_36}",
								"#{SMCJ_081021_37}",
								"#{SMCJ_081021_38}",
								"#{SMCJ_081021_39}",
								"#{SMCJ_081021_40}",
								"#{SMCJ_081021_41}",
								"#{SMCJ_081021_42}",
								"#{SMCJ_081021_43}",
								"#{SMCJ_081021_44}",
								"#{SMCJ_081021_45}",
								"#{SMCJ_081021_46}",
								}


-- 任务完成情况,内容动态刷新,占用任务参数的第1,2位
x050061_g_Custom	=  { {id="#Y任务当前环数",num=8}}

--MisDescEnd
