--MisDescBegin

-- 脚本号
x050222_g_ScriptId = 050222

--角色活跃值副本的index
x050222_g_activePointIndex = 11

-- 任务号
x050222_g_MissionId = 1258					--1256 黄金之链--1257 玄佛珠--1258 熔岩之地

-- 任务目标 NPC
x050222_g_Name = "何悦"

--任务归类
x050222_g_MissionKind = 8

--任务等级
x050222_g_MissionLevel = 10000

-- 任务文本描述
x050222_g_MissionName = "熔岩之地"
x050222_g_MissionInfo = "    "														-- 任务描述
x050222_g_MissionTarget = "    #{LLFBM_80918_3}"						-- 任务目标
--x050222_g_ContinueInfo = "    "					-- 未完成任务的npc对话
x050222_g_SubmitInfo = "#{LLFB_80816_53}"										-- 提交时的答复
--x050222_g_MissionComplete = "   #{LLFB_80816_53}"	--完成任务npc说的话

x050222_g_IsMissionOkFail = 0														-- 0 号位置：当前任务是否完成(0未完成；1完成；2失败)
x050222_g_IsKillBossFire = 1														-- 1 号位置：杀死火焰妖魔数量(0和1)
x050222_g_Param_sceneid = 3															-- 3 号位置：当前任务数据的3位置设置为场景ID

-- 任务完成情况,内容动态刷新,从任务参数的第1位开始
x050222_g_Custom	= { {id="已杀死：#r  火焰妖魔",num=1} }


--MisDescEnd
