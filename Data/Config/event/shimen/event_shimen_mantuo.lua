--MisDescBegin
--脚本号
x893259_g_ScriptId = 893259

--接受任务NPC属性                 （临时坐标）
x893259_g_Position_X=129
x893259_g_Position_Z=106
x893259_g_SceneID=1283
x893259_g_AccomplishNPC_Name="王安歌"

--前提任务
--g_MissionIdPre =

--任务目标npc
x893259_g_Name	= "王安歌"

--任务号
x893259_g_MissionId = 2126

--任务归类
x893259_g_MissionKind = 61

--任务等级
x893259_g_MissionLevel = 10000

--是否是精英任务
x893259_g_IfMissionElite = 0

--下面几项是动态显示的内容，用于在任务列表中动态显示任务情况**********************
--任务是否已经完成
x893259_g_IsMissionOkFail = 0		--变量的第0位

--以上是动态**************************************************************

--任务变量第一位用来存储随机得到的脚本号

--任务文本描述
x893259_g_MissionName="师门任务"
x893259_g_MissionInfo=""  --任务描述
x893259_g_MissionTarget = "%f"
x893259_g_ContinueInfo="干得不错"		--未完成任务的npc对话
x893259_g_MissionComplete="我交给你的事情已经做完了吗？"					--完成任务npc说话的话
x893259_g_MissionRound=17
x893259_g_DoubleExp = 48
x893259_g_AccomplishCircumstance = 1

x893259_g_ShimenTypeIndex = 1
x893259_g_Parameter_Kill_AllRandom={{id=7,numa=3,numb=3,bytenuma=0,bytenumb=1}}
x893259_g_Parameter_Item_IDRandom={{id=6,num=5}}
x893259_g_NpcIdIndicator={{key=2,npcIdIndex=5},{key=9,npcIdIndex=7}}

--用来保存字符串格式化的数据
x893259_g_FormatList = {
								"好久没有见到#R%n#W了，很是想念啊。这个#G%s#W是我的一点心意，请你把它送过去吧。#r  #G小提示：#W#r  你可以在曼陀山庄找到#R幽草#W#{_INFOAIM143,159,592,幽草}，请她把你送往各大城市。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"我的#G%i#W怎么不见了？如果你能帮我找回来，我是不会亏待你的。#r  #G小提示：#W#r   你可以在曼陀山庄找到#R幽草#W#{_INFOAIM143,159,592,幽草}，请她把你送往各大城市。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"#G%n#W为非作歹，我有心去教训一下，可惜没有时间，你能代劳吗？#r  #G小提示：#W#r  你可以在曼陀山庄找到#R幽草#W#{_INFOAIM143,159,592,幽草}，请她把你送往各大城市。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"请你使用#Y%s#W，在#G%s#W的#G%s#W附近进行播种。#r  #G小提示：#W#r  当你来到进行播种的地点附近时，你可以按#GAlt+A#W可以打开物品栏，点击#G“任务”#W页面就可以打开任务物品栏，右键点击#Y花种#W，就可以完成播撒了。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"请你去找到#R%s#W， 他会带你去本派#G%s#W的放置处。#r  #G小提示：#W#r  王叠涓就在曼陀山庄#{_INFOAIM30,197,592,王叠涓}。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"请你帮我抓一只#G%p#W来。#B#r  #G小提示：#W#r  #G曼陀山庄的幽草#{_INFOAIM143,159,592,幽草}#W可以送你去玄武岛，而玄武岛有一条小路通往圣兽山。你可以在玄武岛或者圣兽山上捕捉我需要的珍兽。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"请你在曼陀山庄四处看看，帮我找来5个#G%s#W。#r  #G小提示：#W#r  你可以在屏幕右上角的小地图上找到黄色的指示点。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"请给#R%s#W送去一个#G%i#W吧，事成之后，我会给你报酬的！#r  #G小提示：#W#r  严妈妈就在曼陀山庄#{_INFOAIM228,196,592,严妈妈}。#r  柳扶风就在曼陀山庄#{_INFOAIM125,195,592,柳扶风}。#r  关山月就在曼陀山庄#{_INFOAIM210,158,592,关山月}。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								"去杀死#G%s%s#W个#G%n#W。#{MTSZSMRW_20220621_26}#r#{MTSZSMRW_20220621_21}",
								}


--格式字符串中的索引, 表示从4开始,后多少位视SetMissionByIndex(...)的多少而定
x893259_g_StrForePart=4
x893259_g_ShimenPet_Index = 1

x893259_g_StrList = {
						"花种",
						"承露堂",
						"流芳甸",
						"琅嬛屿",
						"驻云琴台",
						"王叠涓",
						"皓月洲副本",
						"香料",
						"琼玉油脂",
						"琴木",
						"严妈妈",
						"柳扶风",
						"关山月",
						"野生柴猫",
						"花田",
						"0",
						"1",
						"2",
						"3",
						"4",
						"5",
						"6",
						"7",
						"8",
						"9",
						}

--MisDescEnd
