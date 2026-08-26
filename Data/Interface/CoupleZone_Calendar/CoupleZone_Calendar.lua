local objCared = -1								--关心NPC的Obj的编号（Server传过来）

--UI
local g_CoupleZone_Calendar_UI_Button_LastMonth = ""
local g_CoupleZone_Calendar_UI_Button_NextMonth = ""


--UI Editable
local g_CoupleZone_Calendar_UI_Text_CurrentDayNote = ""
local g_CoupleZone_Calendar_UI_DayInfoList = {}   --DateNumText,Content,Img1,Img2


local g_CoupleZone_Calendar_Frame_UnifiedXPosition = 0
local g_CoupleZone_Calendar_Frame_UnifiedYPosition = 0

local g_CoupleZone_Calendar_DayInfoNum = 42
local g_CoupleZone_Calendar_Data_DayInfoList = {}   --DateNum,MainText,NoteFlag


local g_CoupleZone_Calendar_UICommand_OpenUI = 99832601
local g_CoupleZone_Calendar_UICommand_UpdateRedPoint = 99832403

--running data
local g_CoupleZone_Calendar_Current_Month_Chosen = 2  -- 上月 1 本月 2 下月 3
local g_CoupleZone_Calendar_Current_Grid_Chosen = 1

local g_CoupleZone_Calendar_IsDebug = 0

local g_MonthDay = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

local g_TodayDate = 0
local g_TodayWeek = 0

local g_ChosenDay = 0
--!!!reloadscript =CoupleZone_Calendar

function CoupleZone_Calendar_Debug(str)
	if g_CoupleZone_Calendar_IsDebug == 1 then
		PushDebugMessage(tostring(str))
		Lua_TDU_Log("CoupleZone_Calendar_Debug : "..tostring(str))
	end	
end

function CoupleZone_Calendar_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OPEN_COUPLEZONE_CALENDAR")
	this:RegisterEvent("UPDATE_COUPLEZONE_DATA")
	this:RegisterEvent("UPDATE_COUPLEZONE_REDPOINT")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function CoupleZone_Calendar_OnLoad()
	
	g_CoupleZone_Calendar_Frame_UnifiedXPosition = CoupleZone_Calendar_Frame:GetProperty("UnifiedXPosition")
	g_CoupleZone_Calendar_Frame_UnifiedYPosition = CoupleZone_Calendar_Frame:GetProperty("UnifiedYPosition")	
	
	g_CoupleZone_Calendar_UI_Button_LastMonth = CoupleZone_Calendar_Client1_Before
	g_CoupleZone_Calendar_UI_Button_NextMonth = CoupleZone_Calendar_Client1_After

	CoupleZone_Calendar_UI_Text_CurrentDayEditText = CoupleZone_Calendar_Client2_Text1
	
	g_CoupleZone_Calendar_UI_DayInfoList = {}
	g_CoupleZone_Calendar_UI_DayInfoList.Btn = {}
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum = {}
	g_CoupleZone_Calendar_UI_DayInfoList.Text = {}
	g_CoupleZone_Calendar_UI_DayInfoList.Img1 = {}
	g_CoupleZone_Calendar_UI_DayInfoList.Img2 = {}
	
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[1] =	CoupleZone_Calendar_Set1
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[2] =	CoupleZone_Calendar_Set2
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[3] =	CoupleZone_Calendar_Set3
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[4] =	CoupleZone_Calendar_Set4
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[5] =	CoupleZone_Calendar_Set5
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[6] =	CoupleZone_Calendar_Set6
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[7] =	CoupleZone_Calendar_Set7
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[8] =	CoupleZone_Calendar_Set8
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[9] =	CoupleZone_Calendar_Set9
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[10] =	CoupleZone_Calendar_Set10
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[11] =	CoupleZone_Calendar_Set11
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[12] =	CoupleZone_Calendar_Set12
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[13] =	CoupleZone_Calendar_Set13
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[14] =	CoupleZone_Calendar_Set14
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[15] =	CoupleZone_Calendar_Set15
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[16] =	CoupleZone_Calendar_Set16
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[17] =	CoupleZone_Calendar_Set17
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[18] =	CoupleZone_Calendar_Set18
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[19] =	CoupleZone_Calendar_Set19
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[20] =	CoupleZone_Calendar_Set20
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[21] =	CoupleZone_Calendar_Set21
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[22] =	CoupleZone_Calendar_Set22
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[23] =	CoupleZone_Calendar_Set23
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[24] =	CoupleZone_Calendar_Set24
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[25] =	CoupleZone_Calendar_Set25
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[26] =	CoupleZone_Calendar_Set26
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[27] =	CoupleZone_Calendar_Set27
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[28] =	CoupleZone_Calendar_Set28
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[29] =	CoupleZone_Calendar_Set29
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[30] =	CoupleZone_Calendar_Set30
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[31] =	CoupleZone_Calendar_Set31
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[32] =	CoupleZone_Calendar_Set32
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[33] =	CoupleZone_Calendar_Set33
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[34] =	CoupleZone_Calendar_Set34
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[35] =	CoupleZone_Calendar_Set35
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[36] =	CoupleZone_Calendar_Set36
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[37] =	CoupleZone_Calendar_Set37
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[38] =	CoupleZone_Calendar_Set38
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[39] =	CoupleZone_Calendar_Set39
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[40] =	CoupleZone_Calendar_Set40
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[41] =	CoupleZone_Calendar_Set41
	g_CoupleZone_Calendar_UI_DayInfoList.Btn[42] =	CoupleZone_Calendar_Set42
	
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[1] =	CoupleZone_Calendar_Set1_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[2] =	CoupleZone_Calendar_Set2_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[3] =	CoupleZone_Calendar_Set3_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[4] =	CoupleZone_Calendar_Set4_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[5] =	CoupleZone_Calendar_Set5_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[6] =	CoupleZone_Calendar_Set6_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[7] =	CoupleZone_Calendar_Set7_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[8] =	CoupleZone_Calendar_Set8_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[9] =	CoupleZone_Calendar_Set9_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[10] =	CoupleZone_Calendar_Set10_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[11] =	CoupleZone_Calendar_Set11_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[12] =	CoupleZone_Calendar_Set12_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[13] =	CoupleZone_Calendar_Set13_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[14] =	CoupleZone_Calendar_Set14_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[15] =	CoupleZone_Calendar_Set15_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[16] =	CoupleZone_Calendar_Set16_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[17] =	CoupleZone_Calendar_Set17_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[18] =	CoupleZone_Calendar_Set18_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[19] =	CoupleZone_Calendar_Set19_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[20] =	CoupleZone_Calendar_Set20_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[21] =	CoupleZone_Calendar_Set21_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[22] =	CoupleZone_Calendar_Set22_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[23] =	CoupleZone_Calendar_Set23_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[24] =	CoupleZone_Calendar_Set24_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[25] =	CoupleZone_Calendar_Set25_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[26] =	CoupleZone_Calendar_Set26_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[27] =	CoupleZone_Calendar_Set27_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[28] =	CoupleZone_Calendar_Set28_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[29] =	CoupleZone_Calendar_Set29_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[30] =	CoupleZone_Calendar_Set30_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[31] =	CoupleZone_Calendar_Set31_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[32] =	CoupleZone_Calendar_Set32_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[33] =	CoupleZone_Calendar_Set33_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[34] =	CoupleZone_Calendar_Set34_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[35] =	CoupleZone_Calendar_Set35_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[36] =	CoupleZone_Calendar_Set36_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[37] =	CoupleZone_Calendar_Set37_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[38] =	CoupleZone_Calendar_Set38_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[39] =	CoupleZone_Calendar_Set39_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[40] =	CoupleZone_Calendar_Set40_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[41] =	CoupleZone_Calendar_Set41_Text1
	g_CoupleZone_Calendar_UI_DayInfoList.DateNum[42] =	CoupleZone_Calendar_Set42_Text1
	
	g_CoupleZone_Calendar_UI_DayInfoList.Text[1] =	CoupleZone_Calendar_Set1_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[2] =	CoupleZone_Calendar_Set2_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[3] =	CoupleZone_Calendar_Set3_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[4] =	CoupleZone_Calendar_Set4_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[5] =	CoupleZone_Calendar_Set5_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[6] =	CoupleZone_Calendar_Set6_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[7] =	CoupleZone_Calendar_Set7_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[8] =	CoupleZone_Calendar_Set8_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[9] =	CoupleZone_Calendar_Set9_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[10] =	CoupleZone_Calendar_Set10_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[11] =	CoupleZone_Calendar_Set11_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[12] =	CoupleZone_Calendar_Set12_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[13] =	CoupleZone_Calendar_Set13_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[14] =	CoupleZone_Calendar_Set14_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[15] =	CoupleZone_Calendar_Set15_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[16] =	CoupleZone_Calendar_Set16_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[17] =	CoupleZone_Calendar_Set17_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[18] =	CoupleZone_Calendar_Set18_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[19] =	CoupleZone_Calendar_Set19_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[20] =	CoupleZone_Calendar_Set20_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[21] =	CoupleZone_Calendar_Set21_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[22] =	CoupleZone_Calendar_Set22_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[23] =	CoupleZone_Calendar_Set23_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[24] =	CoupleZone_Calendar_Set24_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[25] =	CoupleZone_Calendar_Set25_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[26] =	CoupleZone_Calendar_Set26_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[27] =	CoupleZone_Calendar_Set27_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[28] =	CoupleZone_Calendar_Set28_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[29] =	CoupleZone_Calendar_Set29_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[30] =	CoupleZone_Calendar_Set30_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[31] =	CoupleZone_Calendar_Set31_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[32] =	CoupleZone_Calendar_Set32_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[33] =	CoupleZone_Calendar_Set33_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[34] =	CoupleZone_Calendar_Set34_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[35] =	CoupleZone_Calendar_Set35_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[36] =	CoupleZone_Calendar_Set36_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[37] =	CoupleZone_Calendar_Set37_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[38] =	CoupleZone_Calendar_Set38_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[39] =	CoupleZone_Calendar_Set39_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[40] =	CoupleZone_Calendar_Set40_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[41] =	CoupleZone_Calendar_Set41_Text2
	g_CoupleZone_Calendar_UI_DayInfoList.Text[42] =	CoupleZone_Calendar_Set42_Text2
	
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[1] =	CoupleZone_Calendar_Set1Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[2] =	CoupleZone_Calendar_Set2Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[3] =	CoupleZone_Calendar_Set3Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[4] =	CoupleZone_Calendar_Set4Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[5] =	CoupleZone_Calendar_Set5Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[6] =	CoupleZone_Calendar_Set6Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[7] =	CoupleZone_Calendar_Set7Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[8] =	CoupleZone_Calendar_Set8Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[9] =	CoupleZone_Calendar_Set9Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[10] =	CoupleZone_Calendar_Set10Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[11] =	CoupleZone_Calendar_Set11Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[12] =	CoupleZone_Calendar_Set12Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[13] =	CoupleZone_Calendar_Set13Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[14] =	CoupleZone_Calendar_Set14Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[15] =	CoupleZone_Calendar_Set15Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[16] =	CoupleZone_Calendar_Set16Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[17] =	CoupleZone_Calendar_Set17Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[18] =	CoupleZone_Calendar_Set18Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[19] =	CoupleZone_Calendar_Set19Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[20] =	CoupleZone_Calendar_Set20Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[21] =	CoupleZone_Calendar_Set21Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[22] =	CoupleZone_Calendar_Set22Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[23] =	CoupleZone_Calendar_Set23Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[24] =	CoupleZone_Calendar_Set24Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[25] =	CoupleZone_Calendar_Set25Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[26] =	CoupleZone_Calendar_Set26Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[27] =	CoupleZone_Calendar_Set27Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[28] =	CoupleZone_Calendar_Set28Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[29] =	CoupleZone_Calendar_Set29Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[30] =	CoupleZone_Calendar_Set30Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[31] =	CoupleZone_Calendar_Set31Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[32] =	CoupleZone_Calendar_Set32Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[33] =	CoupleZone_Calendar_Set33Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[34] =	CoupleZone_Calendar_Set34Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[35] =	CoupleZone_Calendar_Set35Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[36] =	CoupleZone_Calendar_Set36Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[37] =	CoupleZone_Calendar_Set37Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[38] =	CoupleZone_Calendar_Set38Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[39] =	CoupleZone_Calendar_Set39Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[40] =	CoupleZone_Calendar_Set40Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[41] =	CoupleZone_Calendar_Set41Today
	g_CoupleZone_Calendar_UI_DayInfoList.Img1[42] =	CoupleZone_Calendar_Set42Today
	
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[1] =	CoupleZone_Calendar_Set1_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[2] =	CoupleZone_Calendar_Set2_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[3] =	CoupleZone_Calendar_Set3_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[4] =	CoupleZone_Calendar_Set4_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[5] =	CoupleZone_Calendar_Set5_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[6] =	CoupleZone_Calendar_Set6_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[7] =	CoupleZone_Calendar_Set7_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[8] =	CoupleZone_Calendar_Set8_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[9] =	CoupleZone_Calendar_Set9_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[10] =	CoupleZone_Calendar_Set10_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[11] =	CoupleZone_Calendar_Set11_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[12] =	CoupleZone_Calendar_Set12_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[13] =	CoupleZone_Calendar_Set13_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[14] =	CoupleZone_Calendar_Set14_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[15] =	CoupleZone_Calendar_Set15_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[16] =	CoupleZone_Calendar_Set16_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[17] =	CoupleZone_Calendar_Set17_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[18] =	CoupleZone_Calendar_Set18_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[19] =	CoupleZone_Calendar_Set19_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[20] =	CoupleZone_Calendar_Set20_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[21] =	CoupleZone_Calendar_Set21_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[22] =	CoupleZone_Calendar_Set22_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[23] =	CoupleZone_Calendar_Set23_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[24] =	CoupleZone_Calendar_Set24_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[25] =	CoupleZone_Calendar_Set25_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[26] =	CoupleZone_Calendar_Set26_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[27] =	CoupleZone_Calendar_Set27_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[28] =	CoupleZone_Calendar_Set28_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[29] =	CoupleZone_Calendar_Set29_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[30] =	CoupleZone_Calendar_Set30_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[31] =	CoupleZone_Calendar_Set31_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[32] =	CoupleZone_Calendar_Set32_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[33] =	CoupleZone_Calendar_Set33_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[34] =	CoupleZone_Calendar_Set34_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[35] =	CoupleZone_Calendar_Set35_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[36] =	CoupleZone_Calendar_Set36_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[37] =	CoupleZone_Calendar_Set37_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[38] =	CoupleZone_Calendar_Set38_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[39] =	CoupleZone_Calendar_Set39_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[40] =	CoupleZone_Calendar_Set40_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[41] =	CoupleZone_Calendar_Set41_Mark
	g_CoupleZone_Calendar_UI_DayInfoList.Img2[42] =	CoupleZone_Calendar_Set42_Mark

end

function CoupleZone_Calendar_OnEvent(event)
	-- 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		CoupleZone_Calendar_Frame_On_ResetPos()
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" then
		this:Hide()
	end
	
	--	local curDate = GetTime2Day()
	--	local curWeek = GetTodayWeek()
	--	BeginUICommand(sceneId)
	--		UICommand_AddInt(sceneId, targetId)
	--		UICommand_AddInt(sceneId, curDate)
	--		UICommand_AddInt(sceneId, curWeek)
	--	EndUICommand(sceneId)
	--	DispatchUICommand(sceneId, selfId, 99832601)
	--	服务器添加上面代码打开界面
	if event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_Calendar_UICommand_OpenUI then
		g_CoupleZone_Calendar_Current_Month_Chosen = 2
		local ojb_id = Get_XParam_INT(0)
		g_TodayDate = Get_XParam_INT(1)
		g_TodayWeek = Get_XParam_INT(2)
		
		if g_CoupleZone_Calendar_Current_Month_Chosen >= 1 and g_CoupleZone_Calendar_Current_Month_Chosen <= 3 then
			if this:IsVisible() then
				this:Hide()
			else
				CoupleZone_Calendar_CleanUp()
				CoupleZone_Calendar_UpdateCalendarData()
				this:Show()
				CoupleZone_Calendar_Update()
				---CoupleZone_Calendar_BeginCareObject(ojb_id)
			end
		end
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_Calendar_UICommand_UpdateRedPoint then
		
		
	end	
	
	if event == "UPDATE_COUPLEZONE_CALENDAR_PAGEX" then
		local page = tonumber(arg0)
		if page >= 0 and page < CoupleZone_Calendar_PageMax then   --所有数据
			CoupleZone_Calendar_UpdateCalendarData()
			CoupleZone_Calendar_Update()
		end
	end		
	
	if event == "UPDATE_COUPLEZONE_REDPOINT" then
		local param = tonumber(arg0)
		if param == 99999 then   --所有红点
			CoupleZone_Calendar_UpdateAllRedPoint()
		else
			--单个红点
			CoupleZone_Calendar_UpdateRedPoint(param)
		end
	end			
	
end

function CoupleZone_Calendar_Update()
	local iTodayYear = math.floor(g_TodayDate / 10000)
	local iTodayMonth = math.floor(math.mod(g_TodayDate, 10000) / 100)
	local iTodayDay = math.mod(g_TodayDate, 100)

	local today_year_days = g_MonthDay
	if CoupleZone_Calendar_IsLeapYear(iTodayYear) == 1 then
		today_year_days[2] = 29
	end
	
	local start_week = 0
	if g_CoupleZone_Calendar_Current_Month_Chosen == 1 then
		start_week = CoupleZone_Calendar_GetPreMonthBeginWeek(g_TodayDate, g_TodayWeek)
		g_CoupleZone_Calendar_UI_Button_LastMonth:Disable()
		g_CoupleZone_Calendar_UI_Button_NextMonth:Enable()
	elseif g_CoupleZone_Calendar_Current_Month_Chosen == 2 then
		start_week = CoupleZone_Calendar_GetCurMonthBeginWeek(g_TodayDate, g_TodayWeek)
		g_CoupleZone_Calendar_UI_Button_LastMonth:Enable()
		g_CoupleZone_Calendar_UI_Button_NextMonth:Enable()
	elseif g_CoupleZone_Calendar_Current_Month_Chosen == 3 then
		start_week = CoupleZone_Calendar_GetNextMonthBeginWeek(g_TodayDate, g_TodayWeek)
		g_CoupleZone_Calendar_UI_Button_LastMonth:Enable()
		g_CoupleZone_Calendar_UI_Button_NextMonth:Disable()
	end

	local chosenMonth = 0
	local chosenYear = 0
	if g_CoupleZone_Calendar_Current_Month_Chosen == 1 then
		chosenMonth = iTodayMonth - 1
	elseif g_CoupleZone_Calendar_Current_Month_Chosen == 2 then
		chosenMonth = iTodayMonth
	elseif g_CoupleZone_Calendar_Current_Month_Chosen == 3 then
		chosenMonth = iTodayMonth + 1
	end
	
	if chosenMonth <= 0 then
		chosenMonth = 12
		chosenYear = iTodayYear - 1
	elseif chosenMonth > 12 then
		chosenMonth = 1
		chosenYear = iTodayYear + 1
	else
		chosenYear = iTodayYear
	end
	
	local nowString = ScriptGlobal_Format("#{QLKJ_230331_97}", tostring(chosenYear), tostring(chosenMonth))
	CoupleZone_Calendar_Client1_Now:SetText(nowString)
	
	for i = 1, g_CoupleZone_Calendar_DayInfoNum do
		---g_CoupleZone_Calendar_UI_DayInfoList.Btn[i]:SetCheck(0)
		g_CoupleZone_Calendar_UI_DayInfoList.Btn[i]:Disable()
		g_CoupleZone_Calendar_UI_DayInfoList.DateNum[i]:SetText("")
		g_CoupleZone_Calendar_UI_DayInfoList.Text[i]:SetText("")
		g_CoupleZone_Calendar_UI_DayInfoList.Img1[i]:Hide()
		g_CoupleZone_Calendar_UI_DayInfoList.Img2[i]:Hide()
	end
	
	local index = start_week + 1
	for i = 1, today_year_days[chosenMonth] do
		g_CoupleZone_Calendar_UI_DayInfoList.Btn[index]:Enable()
		g_CoupleZone_Calendar_UI_DayInfoList.DateNum[index]:SetText("#R"..tostring(i))
		
		local iDate = chosenYear*10000 + chosenMonth*100 + i
		local strInfo, imgSet = LuaFnGetCoupleCalendarDayText(iDate)
		g_CoupleZone_Calendar_UI_DayInfoList.Text[index]:SetText(tostring(strInfo))
		if imgSet ~= nil and imgSet ~= "" then
			g_CoupleZone_Calendar_UI_DayInfoList.Img2[index]:SetProperty("Image",imgSet)
			g_CoupleZone_Calendar_UI_DayInfoList.Img2[index]:Show()		
		else
			g_CoupleZone_Calendar_UI_DayInfoList.Img2[index]:Hide()		
		end
		g_CoupleZone_Calendar_UI_DayInfoList.Img1[index]:Hide()
		
		if g_CoupleZone_Calendar_Current_Month_Chosen == 2 and i == iTodayDay then
			g_CoupleZone_Calendar_UI_DayInfoList.Img1[index]:Show()
		end
		
		---if g_ChosenDay == i then
		---	g_CoupleZone_Calendar_UI_DayInfoList.Btn[i]:SetCheck(1)
		---else
		---	g_CoupleZone_Calendar_UI_DayInfoList.Btn[i]:SetCheck(0)
		---end
		index = index + 1
	end	
end

function CoupleZone_Calendar_AskCoupleZone_CalendarData()
	CoupleZone_Calendar_Debug("CoupleZone_Calendar_AskCoupleZone_CalendarData")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAskCoupleZoneData") 		-- 函数名
		Set_XSCRIPT_ScriptID(998324)					-- 脚本编号
		Set_XSCRIPT_Parameter(0, 2)   					-- 请求类型  2  打开日历请求
		Set_XSCRIPT_ParamCount(1)						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_Calendar_UpdateCalendarData(pageIndex)
	
--	local mainData = LuaFnGetCoupleZoneData_Calendar()
--	if type(mainData) ~= "table" then
--		CoupleZone_Calendar_Debug("CoupleZone_Calendar_UpdateCalendarData : mainData not table")
--		return
--   end
end

function CoupleZone_Calendar_UpdateAllRedPoint()
	CoupleZone_Calendar_Debug("CoupleZone_Calendar_UpdateAllRedPoint")
end

function CoupleZone_Calendar_UpdateRedPoint(redIndex)
	CoupleZone_Calendar_Debug("CoupleZone_Calendar_UpdateRedPoint")
end

function CoupleZone_Calendar_OnCloseClicked()
	this:Hide()
	CoupleZone_Calendar_CleanUp()	
end

function CoupleZone_Calendar_CleanUp()
	for i = 1, g_CoupleZone_Calendar_DayInfoNum do
		g_CoupleZone_Calendar_UI_DayInfoList.DateNum[i]:SetText("")
		g_CoupleZone_Calendar_UI_DayInfoList.Text[i]:SetText("")
		g_CoupleZone_Calendar_UI_DayInfoList.Img1[i]:Hide()
		g_CoupleZone_Calendar_UI_DayInfoList.Img2[i]:Hide()
	end
	CoupleZone_Calendar_Client1_Now:SetText("")
	g_ChosenDay = 0
end

function CoupleZone_Calendar_OnHidden()

end

function CoupleZone_Calendar_OnClicked_WriteNote()
	CoupleZone_Calendar_Debug("CoupleZone_Calendar_OnClicked_WriteNote")
	PushEvent("OPEN_COUPLEZONE_WRITENOTE")
end

function CoupleZone_Calendar_OnClicked_LastMonth()
	if g_CoupleZone_Calendar_Current_Month_Chosen < 2 then
		return
	end
	g_CoupleZone_Calendar_Current_Month_Chosen = g_CoupleZone_Calendar_Current_Month_Chosen - 1
	g_ChosenDay = 0
	CoupleZone_Calendar_Update()
end

function CoupleZone_Calendar_OnClicked_NextMonth()
	if g_CoupleZone_Calendar_Current_Month_Chosen > 2 then
		return
	end
	g_ChosenDay = 0
	g_CoupleZone_Calendar_Current_Month_Chosen = g_CoupleZone_Calendar_Current_Month_Chosen + 1
	CoupleZone_Calendar_Update()
end

function CoupleZone_Calendar_OnClicked_GridX(gridX)
	local start_week = 0
	if g_CoupleZone_Calendar_Current_Month_Chosen == 1 then
		start_week = CoupleZone_Calendar_GetPreMonthBeginWeek(g_TodayDate, g_TodayWeek)
	elseif g_CoupleZone_Calendar_Current_Month_Chosen == 2 then
		start_week = CoupleZone_Calendar_GetCurMonthBeginWeek(g_TodayDate, g_TodayWeek)
	elseif g_CoupleZone_Calendar_Current_Month_Chosen == 3 then
		start_week = CoupleZone_Calendar_GetNextMonthBeginWeek(g_TodayDate, g_TodayWeek)
	end
	g_ChosenDay = gridX - start_week
	
	CoupleZone_Calendar_Debug(g_ChosenDay.."号")
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function CoupleZone_Calendar_Frame_On_ResetPos()
	CoupleZone_Calendar_Frame:SetProperty("UnifiedXPosition", g_CoupleZone_Calendar_Frame_UnifiedXPosition)
	CoupleZone_Calendar_Frame:SetProperty("UnifiedYPosition", g_CoupleZone_Calendar_Frame_UnifiedYPosition)
end
--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function CoupleZone_Calendar_BeginCareObject(objCaredId)
	local npc_id = DataPool:GetNPCIDByServerID(objCaredId)
	this:CareObject(npc_id, 1)
end

--得到当前月1号是周几
function CoupleZone_Calendar_GetCurMonthBeginWeek(iTodayDate, iTodayWeek)
	local iTodayYear = math.floor(iTodayDate / 10000)
	local iTodayMonth = math.floor(math.mod(iTodayDate, 10000) / 100)
	local iTodayDay = math.mod(iTodayDate, 100)

	local today_year_days = g_MonthDay
	if CoupleZone_Calendar_IsLeapYear(iTodayYear) == 1 then
		today_year_days[2] = 29
	end

	local iDiffDays = math.mod(iTodayDay - 1, 7)
	if iDiffDays <= iTodayWeek then
		return iTodayWeek - iDiffDays
	end
	return 7 - iDiffDays + iTodayWeek
end

--得到上个月1号是周几
function CoupleZone_Calendar_GetPreMonthBeginWeek(iTodayDate, iTodayWeek)
	local iTodayYear = math.floor(iTodayDate / 10000)
	local iTodayMonth = math.floor(math.mod(iTodayDate, 10000) / 100)
	local iTodayDay = math.mod(iTodayDate, 100)

	local today_year_days = g_MonthDay
	if CoupleZone_Calendar_IsLeapYear(iTodayYear) == 1 then
		today_year_days[2] = 29
	end

	local iDiffDays = 0	
	if iTodayMonth > 1 then
		iDiffDays = today_year_days[iTodayMonth - 1] + iTodayDay - 1
	elseif iTodayMonth == 1 then
		iDiffDays = today_year_days[12] + iTodayDay - 1
	end

	iDiffDays = math.mod(iDiffDays, 7)
	if iDiffDays <= iTodayWeek then
		return iTodayWeek - iDiffDays
	end
	return 7 - iDiffDays + iTodayWeek
end

--得到下个月1号是周几
function CoupleZone_Calendar_GetNextMonthBeginWeek(iTodayDate, iTodayWeek)
	local iTodayYear = math.floor(iTodayDate / 10000)
	local iTodayMonth = math.floor(math.mod(iTodayDate, 10000) / 100)
	local iTodayDay = math.mod(iTodayDate, 100)

	local today_year_days = g_MonthDay
	if CoupleZone_Calendar_IsLeapYear(iTodayYear) == 1 then
		today_year_days[2] = 29
	end

	local iDiffDays = today_year_days[iTodayMonth] - iTodayDay + 1
	return math.mod(iDiffDays + iTodayWeek, 7)
end

--是不是闰年
function CoupleZone_Calendar_IsLeapYear(iYear)
	if iYear > 0 then
		if math.mod(iYear, 4) == 0 and math.mod(iYear, 100) ~= 0 then
			return 1
		end
		
		if math.mod(iYear, 400) == 0 then
			return 1
		end
	end	
	return 0
end