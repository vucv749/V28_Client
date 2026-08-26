--MisDescBegin
--脚本号
x808010_g_ScriptId	= 808010
--接受任务NPC属性
x808010_g_Position_X=47.0185
x808010_g_Position_Z=62.9575
x808010_g_SceneID=0
x808010_g_AccomplishNPC_Name="月老"

--任务号
x808010_g_MissionId			= 1144

--任务目标npc
x808010_g_Name 					= "月老"
--任务归类
x808010_g_MissionKind			= 11
--任务等级
x808010_g_MissionLevel		= 10000
--是否是精英任务
x808010_g_IfMissionElite	= 0
--任务是否已经完成
x808010_g_IsMissionOkFail	= 0		--任务参数的第0位

--任务文本描述
x808010_g_MissionName			= "永恒钻戒"
--任务描述
x808010_g_MissionInfo			= ""
--任务目标
x808010_g_MissionTarget		= "%f"
--未完成任务的npc对话
x808010_g_ContinueInfo		= ""
--完成任务npc说的话
x808010_g_MissionComplete	= ""

x808010_g_StrForePart = 4

--用来保存字符串格式化的数据
x808010_g_FormatList = {"请夫妻两人组队前往%s，%s，%s，用月老给的葫芦收集一些仙灵之气回来。",}

--最大资质数
x808010_g_MaxZizhiType= 6

x808010_g_StrList = {
	"无量山的白猿石阵#{_INFOAIM53,264,6,}",
	"剑阁的剑门叠翠#{_INFOAIM130,135,7,}",
	"敦煌的瀚海求佛#{_INFOAIM260,260,8,}",
	"镜湖的玉带临风#{_INFOAIM39,261,5,}",
	"太湖的舞榭歌台#{_INFOAIM160,252,4,}",
	"嵩山的江山多娇#{_INFOAIM275,85,3,}",
	"西湖的一望虎跑#{_INFOAIM170,235,30,}",
	"洱海的百舸争流#{_INFOAIM260,270,24,}",
	"雁南的枫桥夕照#{_INFOAIM150,250,18,}",
	"龙泉的飞流直下#{_INFOAIM270,280,31,}",
	"苍山的似水年华#{_INFOAIM258,73,25,}",
	"雁北的壁立千仞#{_INFOAIM283,179,19,}",
	"武夷的烟锁二乔#{_INFOAIM54,182,32,}",
	"石林的峰峦入聚#{_INFOAIM195,53,26,}",
	"草原的狼王石阵#{_INFOAIM143,254,20,}",
	"梅岭的梅岭佛光#{_INFOAIM284,82,33,}",
	"玉溪的青眉如豆#{_INFOAIM268,116,27,}",
	"辽西的敖包相会#{_INFOAIM277,117,21,}",
	"南海的天南一柱#{_INFOAIM61,225,34,}",
	"黄龙府的天池雪景#{_INFOAIM289,66,23,}",
}

x808010_g_MaxRound	= 3
--控制脚本
x808010_g_ControlScript		= 808010

--任务完成情况,内容动态刷新,分别占用任务参数的第1位
x808010_g_Custom	= { {id="已收集仙灵之气",num=3}}

--MisDescEnd
