--MisDescBegin

-- 脚本号 同时挂在接受任务NPC和提交任务NPC身上
x791101_g_ScriptId 				= 791101
x791101_g_MainScriptId 			= 791100

--完成任务NPC属性
x791101_g_Position_X			= 131
x791101_g_Position_Z			= 135
x791101_g_SceneID				= 2
x791101_g_AccomplishNPC_Name	= "虚清"

--任务号
x791101_g_MissionId 			= 2228

--任务归类
x791101_g_MissionKind 			= 65

--任务等级
x791101_g_MissionLevel 			= 30

--是否是精英任务
x791101_g_IfMissionElite 		= 0

-- 任务名
-- SBYR_230707_22	神兵npc1阶段任务
x791101_g_MissionName						= "#{SBYR_230707_22}"
-- 任务目标
x791101_g_MissionTarget						= "#{SBYR_230707_79}"	
-- 任务参数 0号潜规则只能用作标记任务是否完成，会自动影响客户端任务列表是否显示已完成
x791101_g_IsMissionOkFail					= 0
x791101_g_Custom 							= {{ id = "找到嫌疑人", num = 3}, {id="指认嫌疑人", num=1} } 
x791101_g_ContinueInfo 						= ""
-- 完成任务的NPC对话
x791101_g_MissionComplete 					= "#{}"

-- x791101_g_MoneyJZBonus 						= 0
-- x791101_g_ExpBonus 							= 0


--MisDescEnd
