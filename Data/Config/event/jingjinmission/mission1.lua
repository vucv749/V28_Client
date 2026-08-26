--MisDescBegin
x998355_g_ScriptId = 998355
x998355_g_MissionId = 2212
x998355_g_MainScriptId = 998354--主脚本号

--kdzz
x998355_g_KDZZID = 1006000587
x998355_g_KDZZSubID = 1

--后续任务
--x998355_g_NextScirptId = 893187--下一脚本号
--x998355_g_NextMissionId = 2083--下一任务号

--完成任务npc

x998355_g_AccomplishInfo={
{question="#{WDJJ_230614_213}",name="段延庆",Answer="#{WDJJ_230614_237}",}, --大理 214，283  2
{question="#{WDJJ_230614_214}",name="段延庆",Answer="#{WDJJ_230614_237}",},
{question="#{WDJJ_230614_215}",name="段延庆",Answer="#{WDJJ_230614_237}",},

{question="#{WDJJ_230614_219}",name="慕容复",Answer="#{WDJJ_230614_239}",}, --苏州129，76  1
{question="#{WDJJ_230614_220}",name="慕容复",Answer="#{WDJJ_230614_239}",},
{question="#{WDJJ_230614_221}",name="慕容复",Answer="#{WDJJ_230614_239}",},

{question="#{WDJJ_230614_222}",name="游坦之",Answer="#{WDJJ_230614_240}",}, --洛阳 57，82  0
{question="#{WDJJ_230614_223}",name="游坦之",Answer="#{WDJJ_230614_240}",},
{question="#{WDJJ_230614_224}",name="游坦之",Answer="#{WDJJ_230614_240}",},

{question="#{WDJJ_230614_225}",name="智光大师",Answer="#{WDJJ_230614_241}",}, --洛阳 77，72  0
{question="#{WDJJ_230614_226}",name="智光大师",Answer="#{WDJJ_230614_241}",},
{question="#{WDJJ_230614_227}",name="智光大师",Answer="#{WDJJ_230614_241}",},

{question="#{WDJJ_230614_228}",name="段正淳",Answer="#{WDJJ_230614_242}",}, --大理 62，35  2
{question="#{WDJJ_230614_229}",name="段正淳",Answer="#{WDJJ_230614_242}",},
{question="#{WDJJ_230614_230}",name="段正淳",Answer="#{WDJJ_230614_242}",},

{question="#{WDJJ_230614_231}",name="叶二娘",Answer="#{WDJJ_230614_243}",}, --大理 54，265  2
{question="#{WDJJ_230614_232}",name="叶二娘",Answer="#{WDJJ_230614_243}",},
{question="#{WDJJ_230614_233}",name="叶二娘",Answer="#{WDJJ_230614_243}",},

{question="#{WDJJ_230614_234}",name="包不同",Answer="#{WDJJ_230614_244}",}, --苏州115，71  1
{question="#{WDJJ_230614_235}",name="包不同",Answer="#{WDJJ_230614_244}",},
{question="#{WDJJ_230614_236}",name="包不同",Answer="#{WDJJ_230614_244}",},

}
--任务数据
x998355_g_MissionKind = 7
x998355_g_MissionLevel = 70
x998355_g_IfMissionElite = 0

x998355_g_IsMissionOkFail = 0--任务完成标志位(一定要为0)
x998355_g_QuestionIndex = 2--答题随机索引

x998355_g_MissionName="#{WDJJ_230614_25}"--任务名
x998355_g_MissionInfo="#{WDJJ_230614_26}"--任务文本描述（任务领取对白）
x998355_g_MissionComplete="#{WDJJ_230614_28}"--任务完成对白
x998355_g_MissionUnComplete="#{WDJJ_230614_27}"--任务未完成对白
x998355_g_MissionTarget=""--任务目标(任务面板中任务信息显示内容)

--自定义完成情况，内容不能使用字典，分别对应missionparam的第1位后延
x998355_g_Custom = {{id="找到长老所说之人",num=1}}
x998355_g_ParamIndex = 2--任务参数0-完成标记1-完成情况2-随机索引

--npc距离
x998355_g_NpcDist = 5

--奖励
x998355_g_WDPoint_max =3645
x998355_g_WDPointTotal_max =2970 + 2430 + 3645


x998355_g_Missionexp = 100
x998355_g_MissionMoney =100
x998355_g_MissionWDPoint =9


--MisDescEnd
