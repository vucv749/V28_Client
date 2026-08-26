--MisDescBegin
-- 脚本号
x600032_g_ScriptId = 600032

--任务号
x600032_g_MissionId = 1109

--任务目标npc
x600032_g_Name = "武大威"

--任务归类
x600032_g_MissionKind = 50

--任务等级
x600032_g_MissionLevel = 10000

--是否是精英任务
x600032_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
x600032_g_IsMissionOkFail = 0							-- 任务完成标记

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号
--任务文本描述
x600032_g_MissionName = "追捕叛徒"
x600032_g_MissionInfo = ""													--任务描述
x600032_g_MissionTarget = "    我帮弟子%s%1s，窃取了本城重要情报，你速去找到%2n，他会协助我们的行动的。#r#{BHRW_091224_1}"	--任务目标
x600032_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600032_g_MissionComplete = "    干得不错，甚好甚好。"						--完成任务npc说话的话

x600032_g_MissionRound = 79

-- 通用城市任务脚本
x600032_g_CityMissionScript = 600001
x600032_g_MilitaryScript = 600030

--格式字符串中的索引, 表示从4开始,后多少位视SetMissionByIndex(...)的多少而定
x600032_g_StrForePart=5
x600032_g_StrList = {[0] = "司空",
										 [1] = "司马",
										 [2] = "欧阳",
										 [3] = "诸葛",
										 [4] = "单于",
										 [5] = "甲儿",
										 [6] = "小甲",
										 [7] = "乙儿",
										 [8] = "小乙",
										 [9] = "丙儿",
										 }



--MisDescEnd
