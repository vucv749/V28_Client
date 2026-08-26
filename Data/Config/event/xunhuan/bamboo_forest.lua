--MisDescBegin

-- 脚本号
x050101_g_ScriptId = 050101

--角色活跃值副本的index
x050101_g_activePointIndex = 7

-- 任务号
x050101_g_MissionId = 1261					-- 1260 - 1269

-- 上一个任务的 ID
-- g_MissionIdPre = 1260

-- 任务目标 NPC
x050101_g_Name = "花剑雨"

--任务归类
x050101_g_MissionKind = 8

--任务等级
x050101_g_MissionLevel = 10000

-- 任务文本描述
x050101_g_MissionName = "除害"
x050101_g_MissionInfo = "    "														-- 任务描述
x050101_g_MissionTarget = "    苏州的花剑雨#{_INFOAIM251,108,1,花剑雨}让你杀死80只野熊，并杀死红熊王。#r    #{FQSH_090206_01}"						-- 任务目标
x050101_g_ContinueInfo = "    你们准备好了就请前去竹林消灭红熊王！"					-- 未完成任务的npc对话
x050101_g_SubmitInfo = "    任务做得怎么样了？"										-- 提交时的答复
x050101_g_MissionComplete = "    既然你们已经杀死红熊王了，那么依约我也该告诉你们这块令牌的来历了。你们把这封信交给钱宏宇#{_INFOAIM62,162,1,钱宏宇},他自然会明白一切的。"	--完成任务npc说的话

x050101_g_IsMissionOkFail = 0														-- 0 号：当前任务是否完成(0未完成；1完成；2失败)
x050101_g_DemandKill = { { id = 4110, num = 80 },  { id = 4120, num = 1 } }			-- 1 ~ 2 号，怪物信息
x050101_g_Param_sceneid = 3															-- 3 号：当前副本任务的场景号
x050101_BossSecKill = {4120,4121,4122,4123,4124,4125,4126,4127,4128,4129,34120,34121,34122,34123,34124,34125,34126,34127,34128,34129}	
-- 任务奖励


--MisDescEnd
