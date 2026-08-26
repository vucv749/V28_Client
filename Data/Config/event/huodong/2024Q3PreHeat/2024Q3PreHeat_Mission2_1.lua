--MisDescBegin
-- 脚本号 同时挂在接受任务NPC和提交任务NPC身上
x999435_g_ScriptId = 999435
x999435_g_MissionMainScriptId 	= 999430
x999435_g_MainScriptId 			= 999429
x999435_g_UIMainScriptId        = 999441
-- 任务号(找策划要)
x999435_g_MissionId = 2344
-- 任务类型(找策划要，对应Client/Config/MissionKind.txt)
x999435_g_MissionKind = 71
-- 任务等级
x999435_g_MissionLevel = 30
-- 是否是精英任务
x999435_g_IfMissionElite = 0

-- 任务名
x999435_g_MissionName = "#{ERYR_240701_253}"
-- 任务目标
x999435_g_MissionTarget = "#{ERYR_240701_264}"
-- 任务参数 0号潜规则只能用作标记任务是否完成，会自动影响客户端任务列表是否显示已完成
x999435_g_IsMissionOkFail = 0
-- 任务完成情况中显示，根据类别来使用
-- 完成任务需要物品的类型（寻物脚本）,id见CommonItem.txt
-- x999435_g_DemandItem 					= {{id=20309001, num=1}, {id=20309005, num=1}}
-- 任务需要杀的怪物（杀怪任务），id见MonsterAttrExTable.txt
-- x999435_g_DemandKill 					= {id=779, num=8}
-- 自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x999435_g_Custom 							= {{ id = "寻施浩然问明缘由", num = 1},{ id = "剿灭黑衫打手", num = 10}} 
--拜访侠客
-- x999435_g_TalkWithNPC                    = {{ id = "寻施浩然问明缘由", num = 1}}         --第一位变量
-- 杀怪数量
-- x999435_g_nMonsterKill                   = {{ id = "剿灭黑衫打手", num = 10}}  --第二位变量
x999435_g_ContinueInfo = ""

-- x999435_g_MoneyJZBonus 					= 0
-- x999435_g_ExpBonus 						= 0


--MisDescEnd
