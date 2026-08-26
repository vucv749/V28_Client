--MisDescBegin

--脚本号
x228903_g_ScriptId = 228903

--任务号
x228903_g_MissionId = 947

-- 前续任务
x228903_g_PreMissionId = 946

-- 目标 NPC
x228903_g_Position_X = 262
x228903_g_Position_Z = 46
x228903_g_SceneID = 18
x228903_g_AccomplishNPC_Name = "种世衡"

--目标NPC
x228903_g_Name = "种世衡"

--任务等级
x228903_g_MissionLevel = 30

--任务归类
x228903_g_MissionKind = 28

--是否是精英任务
x228903_g_IfMissionElite = 0

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--角色Mission变量说明
x228903_g_IsMissionOkFail			=0	--0 任务完成标记
x228903_g_DemandKill				= { { id = 540, num = 1 }, { id = 541, num = 4 } }		--变量第1位
x228903_g_Param_QinNumber			=1	--1 需要杀死秦伯光数量
x228903_g_Param_LubaNumber			=2	--2 需要消灭的秦家寨路霸数量
x228903_g_MonsterList				= { [x228903_g_Param_QinNumber] = { "秦伯光", 1 }, [x228903_g_Param_LubaNumber] = { "秦家寨路霸", 4 } }
x228903_g_Param_sceneid				=3	--3号：当前副本任务的场景号
x228903_g_Param_teamid				=4	--4号：接副本任务时候的队伍号

--**********************************以上是动态****************************

--任务文本描述
x228903_g_MissionName = "就地正法"
x228903_g_MissionInfo = "#{TIANSHAN_SKILL_03}"													--任务描述
x228903_g_MissionTarget = "    #G雁门关#W的#R种世衡#W#{_INFOAIM263,46,18,种世衡}要你在雁门关太守府中杀死秦伯光和四名秦家寨路霸。"		--任务目标
x228903_g_ContinueInfo = "#{TIANSHAN_SKILL_04}"								--未完成任务的npc对话
x228903_g_MissionComplete = "#{TIANSHAN_SKILL_05}"							--完成任务npc说话的话

--任务奖励
x228903_g_MoneyBonus = 1000
x228903_g_exp = 2000


--MisDescEnd
