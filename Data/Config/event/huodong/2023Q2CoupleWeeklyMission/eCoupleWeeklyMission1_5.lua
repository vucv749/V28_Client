--MisDescBegin
--脚本号
x998317_g_ScriptId 						= 998317
--任务号(找策划要)
x998317_g_MissionId 					= 2208
--任务名
x998317_g_MissionName					= "#{FQZC_230331_51}"
x998317_g_MissionInfo					= "#{FQZC_230331_60}"--任务文本描述（任务领取对白）
--完成任务NPC信息(小地图和地图显示用)
x998317_g_Position_X					= 271
x998317_g_Position_Z					= 175
x998317_g_SceneID							= 121
x998317_g_AccomplishNPC_Name	= "晁端礼"

--任务类型(找策划要，对应Client/Config/MissionKind.txt)
x998317_g_MissionKind 				= 63
--任务等级(10000为等级自适应, 其他为具体等级)
x998317_g_MissionLevel 				= 30
--任务目标(任务面板中任务信息显示内容)
x998317_g_MissionTarget 			= "#{FQZC_230331_59}"
--任务完成标志位(一定要为0)
x998317_g_IsMissionOkFail			= 0

x998317_g_MissionParam_GameComplete = 1

--任务完成情况中显示，根据类别来使用
--完成任务需要物品的类型（寻物脚本）,id见CommonItem.txt
--x998317_g_DemandItem 					= {{id=20309001, num=1}, {id=20309005, num=1}}
--任务需要杀的怪物（杀怪任务），id见MonsterAttrExTable.txt
--x998317_g_DemandKill 					= {id=779, num=8}
--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998317_g_Custom							= {{id="游赏夜西湖",num=1}}

--物品奖励（不用选择）
--x998317_g_ItemBonus						= {{id=38002793, num=1},{id=38002794, num=1}}
--随机物品奖励（随机一项）
--x998317_g_RandomItemBonus 		= {{id=20309001, num=1}, {id=20309005, num=1}}
--物品奖励（需要用户选择一项）
--x998317_g_RadioItemBonus 			= {{id=20309001, num=1}, {id=20309005, num=1}}
--金钱奖励，铜币数量
--x998317_g_MoneyBonus 					= 1
--交子金钱奖励，任务一般不给交子，都是给金币
--x998317_g_MoneyJZBonus				= 1


--MisDescEnd
