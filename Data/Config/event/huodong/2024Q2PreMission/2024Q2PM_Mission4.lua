--MisDescBegin
-- 脚本号 同时挂在接受任务NPC和提交任务NPC身上
x998777_g_ScriptId = 998777
x998777_g_MainScriptId = 998773

-- 任务号(找策划要)
x998777_g_MissionId = 2263
x998777_g_MissionId1 = 2260
x998777_g_MissionId2 = 2261
x998777_g_MissionId3 = 2262
-- 任务类型(找策划要，对应Client/Config/MissionKind.txt)
x998777_g_MissionKind = 68
-- 任务等级
x998777_g_MissionLevel = 30
-- 是否是精英任务
x998777_g_IfMissionElite = 0

-- 任务名
x998777_g_MissionName = "#{JJFY_240407_11}"
-- 任务目标
x998777_g_MissionTarget = "#{JJFY_240407_152}"
-- 任务参数 0号潜规则只能用作标记任务是否完成，会自动影响客户端任务列表是否显示已完成
x998777_g_IsMissionOkFail = 0
-- 任务完成情况中显示，根据类别来使用
-- 完成任务需要物品的类型（寻物脚本）,id见CommonItem.txt
-- x890227_g_DemandItem 					= {{id=20309001, num=1}, {id=20309005, num=1}}
-- 任务需要杀的怪物（杀怪任务），id见MonsterAttrExTable.txt
-- x890227_g_DemandKill 					= {id=779, num=8}
-- 自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
-- x998777_g_Custom 							= {{ id = 40005168, num = 1}} 
x998777_g_Custom = {}
x998777_g_ContinueInfo = ""

-- x998777_g_MoneyJZBonus 					= 0
-- x998777_g_ExpBonus 						= 0


--MisDescEnd
