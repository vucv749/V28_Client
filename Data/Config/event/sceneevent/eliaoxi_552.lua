--MisDescBegin
--脚本号
x212107_g_ScriptId = 212107

--任务号
x212107_g_MissionId = 552

--任务归类
x212107_g_MissionKind = 32

--任务等级
x212107_g_MissionLevel = 75

--是否是精英任务
x212107_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x212107_g_IsMissionOkFail = 0		--变量的第0位
x212107_g_Custom	= { {id="已经点燃干狼粪",num=1} }

--以上是动态**************************************************************

--任务需要得到的物品
--x212107_g_DemandItem={{id=40002112,num=1}}		--变量第1位

--任务文本描述
x212107_g_MissionName="驱赶黑蜂"
x212107_g_MissionInfo="#{Lua_liaoxi_001}"
x212107_g_MissionTarget="  杀死#R白狼王#W#{_INFOAIM161,268,21,-1}，得到干狼粪。用火折子点燃干狼粪，驱赶黑蜂，然后回到#G广宁镇#W，向#R伯颜#W#{_INFOAIM164,199,21,伯颜}报告你的发现。"
x212107_g_ContinueInfo="  你已经驱赶完黑蜂了吗？"
x212107_g_MissionComplete="  年轻人，你真是我们的救星啊！我代表所有的族人感谢你的帮助！我们永远都不会忘记你的。"

--奖励
x212107_g_MoneyBonus=49800
x212107_g_Exp = 45000
--x212107_g_ItemBonus={{id=30003007,num=5}}
x212107_g_RadioItemBonus={{id=10411081 ,num=1},{id=10412074,num=1}}



--MisDescEnd
