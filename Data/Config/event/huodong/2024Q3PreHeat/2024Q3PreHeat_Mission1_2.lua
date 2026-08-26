--MisDescBegin
-- 脚本号 同时挂在接受任务NPC和提交任务NPC身上
x999432_g_ScriptId 				= 999432
x999432_g_MissionMainScriptId 	= 999430
x999432_g_MainScriptId 			= 999429
--任务号(找策划要)
x999432_g_MissionId 			= 2341
--任务类型(找策划要，对应Client/Config/MissionKind.txt)
x999432_g_MissionKind 			= 71
--任务等级
x999432_g_MissionLevel 			= 30
--是否是精英任务
x999432_g_IfMissionElite 		= 0

-- 任务名
x999432_g_MissionName						= "#{ERYR_240701_223}"
-- 任务目标
x999432_g_MissionTarget						= "#{ERYR_240701_227}"	
-- 任务参数 0号潜规则只能用作标记任务是否完成，会自动影响客户端任务列表是否显示已完成
x999432_g_IsMissionOkFail					= 0
--任务完成情况中显示，根据类别来使用
--完成任务需要物品的类型（寻物脚本）,id见CommonItem.txt
--x890227_g_DemandItem 					= {{id=20309001, num=1}, {id=20309005, num=1}}
--任务需要杀的怪物（杀怪任务），id见MonsterAttrExTable.txt
--x890227_g_DemandKill 					= {id=779, num=8}
--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x999432_g_Custom							= {{ id = "探查线索", num = 6},{ id = "梳理案情", num = 1}} 
-- x999432_g_ClueNum 						= {{ id = "探查线索", num = 6}}		 --第1位变量 
-- x999432_g_IsIntergration					= {{ id = "梳理案情", num = 1}}	 -- 第2位变量 
x999432_g_ContinueInfo 						= ""

-- x999432_g_MoneyJZBonus 					= 0
-- x999432_g_ExpBonus 						= 0


--MisDescEnd
