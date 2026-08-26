--MisDescBegin

--脚本号
x600009_g_ScriptId = 600009

--任务号
x600009_g_MissionId = 1106

--目标NPC
x600009_g_Name = "朱世友"

--任务等级
x600009_g_MissionLevel = 10000

--任务归类
x600009_g_MissionKind = 50

--是否是精英任务
x600009_g_IfMissionElite = 0

--********下面几项是动态显示的内容，用于在任务列表中动态显示任务情况******
--角色Mission变量说明
x600009_g_IsMissionOkFail			=0	--0 任务完成标记
x600009_g_MissionParam_SubId		=1	--1 子任务脚本号存放位置
x600009_g_Param_sceneid				=2	--2号：当前副本任务的场景号

--循环任务的数据索引，里面存着已做的环数
x600009_g_MissionRound = 40
--**********************************以上是动态****************************

--任务文本描述
x600009_g_MissionName = "发展任务"
x600009_g_MissionInfo = ""													--任务描述
x600009_g_MissionTarget = "    护送 %n 到 %s%s 附近。#r#{BHRW_091224_1}"	--任务目标
x600009_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600009_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600009_g_MissionComplete = "    干得不错，甚好甚好。"						--完成任务npc说话的话

x600009_g_StrForePart = 3

x600009_g_FamilyNameStart = 0												-- x600009_g_StrList 中的姓的起始位置
x600009_g_FamilyNameCount = 13												-- x600009_g_StrList 中的姓的数量
x600009_g_StrList = { [0] = "周", [1] = "赵", [2] = "杨", [3] = "韩", [4] = "林", [5] = "郭", [6] = "孟",
			  [7] = "常", [8] = "吴", [9] = "崔", [10] = "金", [11] = "薛", [12] = "关",
			  [13] = "燕", [14] = "婷", [15] = "霖", [16] = "琴", [17] = "倩", [18] = "璇",
			  [19] = "巧巧", [20] = "莺莺", [21] = "思思", [22] = "印儿", [23] = "月儿",
			  [24] = "雪儿", [25] = "宛儿",
}

-- 通用城市任务脚本
x600009_g_CityMissionScript = 600001
x600009_g_DevelopmentScript = 600007

--任务奖励


--MisDescEnd
