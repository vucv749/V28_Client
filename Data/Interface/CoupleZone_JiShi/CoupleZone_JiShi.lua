--UI
local g_CoupleZone_JiShi_UI_Button_LastPage = ""
local g_CoupleZone_JiShi_UI_Button_NextPage = ""

--UI Editable
local g_CoupleZone_JiShi_UI_ActivityList_1 = {}   --Img,LevelCount,AccomplishText
local g_CoupleZone_JiShi_UI_ActivityList_2 = {}   --Img,LevelCount,AccomplishText
local g_CoupleZone_JiShi_UI_Activity_CurCount_1 = ""
local g_CoupleZone_JiShi_UI_Activity_CurCount_2 = ""


local g_CoupleZone_JiShi_UI_ImageNormal = "set:CoupleZone1 image:Man_Normal"
local g_CoupleZone_JiShi_UI_ImageLight = "set:CoupleZone1 image:Man_Light"

local g_CoupleZone_JiShi_UICommand_OpenUI = 99832701
local g_CoupleZone_JiShi_UICommand_UpdateRedPoint = 99832403

local g_CoupleZone_JiShi_Frame_UnifiedXPosition = 0
local g_CoupleZone_JiShi_Frame_UnifiedYPosition = 0

--SpecialData
local g_CoupleZone_JiShi_AnnalType = 2

local g_CoupleZone_JiShi_AnnalInfo_1 =    --有几个就是几级
{
	[1] = { count = 100 },
	[2] = { count = 300 },
	[3] = { count = 900 },
	[4] = { count = 1800 },
	[5] = { count = 4000 },
}

local g_CoupleZone_JiShi_AnnalInfo_2 =    --有几个就是几级
{
	[1] = { count = 200 },
	[2] = { count = 600 },
	[3] = { count = 1800 },
	[4] = { count = 3600 },
	[5] = { count = 8000 },
}


--running data
local g_CoupleZone_JiShi_AnnalLevel_1 = -1
local g_CoupleZone_JiShi_AnnalLevel_2 = -1

local g_CoupleZone_JiShi_IsDebug = 0

--!!!reloadscript =CoupleZone_JiShi

function CoupleZone_JiShi_Debug(str)
	if g_CoupleZone_JiShi_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_JiShi_Debug : "..str)
	end
end

function CoupleZone_JiShi_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("UPDATE_COUPLEZONE_DATA")
	this:RegisterEvent("UPDATE_COUPLEZONE_REDPOINT")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OPEN_COUPLEZONE_ANNAL")
end

function CoupleZone_JiShi_OnLoad()
	
	g_CoupleZone_JiShi_Frame_UnifiedXPosition = CoupleZone_JiShi_Frame:GetProperty("UnifiedXPosition")
	g_CoupleZone_JiShi_Frame_UnifiedYPosition = CoupleZone_JiShi_Frame:GetProperty("UnifiedYPosition")	
		
	g_CoupleZone_JiShi_UI_ActivityList_1[1] = {}
	g_CoupleZone_JiShi_UI_ActivityList_1[1].Img = CoupleZone_JiShi_Item1_Img1
	g_CoupleZone_JiShi_UI_ActivityList_1[1].LevelCount = CoupleZone_JiShi_Item1_Text1
	g_CoupleZone_JiShi_UI_ActivityList_1[1].AccomplishText = CoupleZone_JiShi_Item1_Text2
	g_CoupleZone_JiShi_UI_ActivityList_1[2] = {}
	g_CoupleZone_JiShi_UI_ActivityList_1[2].Img = CoupleZone_JiShi_Item2_Img1
	g_CoupleZone_JiShi_UI_ActivityList_1[2].LevelCount = CoupleZone_JiShi_Item2_Text1
	g_CoupleZone_JiShi_UI_ActivityList_1[2].AccomplishText = CoupleZone_JiShi_Item2_Text2
	g_CoupleZone_JiShi_UI_ActivityList_1[3] = {}
	g_CoupleZone_JiShi_UI_ActivityList_1[3].Img = CoupleZone_JiShi_Item3_Img1
	g_CoupleZone_JiShi_UI_ActivityList_1[3].LevelCount = CoupleZone_JiShi_Item3_Text1
	g_CoupleZone_JiShi_UI_ActivityList_1[3].AccomplishText = CoupleZone_JiShi_Item3_Text2
	g_CoupleZone_JiShi_UI_ActivityList_1[4] = {}
	g_CoupleZone_JiShi_UI_ActivityList_1[4].Img = CoupleZone_JiShi_Item4_Img1
	g_CoupleZone_JiShi_UI_ActivityList_1[4].LevelCount = CoupleZone_JiShi_Item4_Text1
	g_CoupleZone_JiShi_UI_ActivityList_1[4].AccomplishText = CoupleZone_JiShi_Item4_Text2
	g_CoupleZone_JiShi_UI_ActivityList_1[5] = {}
	g_CoupleZone_JiShi_UI_ActivityList_1[5].Img = CoupleZone_JiShi_Item5_Img1
	g_CoupleZone_JiShi_UI_ActivityList_1[5].LevelCount = CoupleZone_JiShi_Item5_Text1
	g_CoupleZone_JiShi_UI_ActivityList_1[5].AccomplishText = CoupleZone_JiShi_Item5_Text2

	g_CoupleZone_JiShi_UI_ActivityList_2[1] = {}
	g_CoupleZone_JiShi_UI_ActivityList_2[1].Img = CoupleZone_JiShi_Item6_Img1
	g_CoupleZone_JiShi_UI_ActivityList_2[1].LevelCount = CoupleZone_JiShi_Item6_Text1
	g_CoupleZone_JiShi_UI_ActivityList_2[1].AccomplishText = CoupleZone_JiShi_Item6_Text2
	g_CoupleZone_JiShi_UI_ActivityList_2[2] = {}
	g_CoupleZone_JiShi_UI_ActivityList_2[2].Img = CoupleZone_JiShi_Item7_Img1
	g_CoupleZone_JiShi_UI_ActivityList_2[2].LevelCount = CoupleZone_JiShi_Item7_Text1
	g_CoupleZone_JiShi_UI_ActivityList_2[2].AccomplishText = CoupleZone_JiShi_Item7_Text2
	g_CoupleZone_JiShi_UI_ActivityList_2[3] = {}
	g_CoupleZone_JiShi_UI_ActivityList_2[3].Img = CoupleZone_JiShi_Item8_Img1
	g_CoupleZone_JiShi_UI_ActivityList_2[3].LevelCount = CoupleZone_JiShi_Item8_Text1
	g_CoupleZone_JiShi_UI_ActivityList_2[3].AccomplishText = CoupleZone_JiShi_Item8_Text2
	g_CoupleZone_JiShi_UI_ActivityList_2[4] = {}
	g_CoupleZone_JiShi_UI_ActivityList_2[4].Img = CoupleZone_JiShi_Item9_Img1
	g_CoupleZone_JiShi_UI_ActivityList_2[4].LevelCount = CoupleZone_JiShi_Item9_Text1
	g_CoupleZone_JiShi_UI_ActivityList_2[4].AccomplishText = CoupleZone_JiShi_Item9_Text2
	g_CoupleZone_JiShi_UI_ActivityList_2[5] = {}
	g_CoupleZone_JiShi_UI_ActivityList_2[5].Img = CoupleZone_JiShi_Item10_Img1
	g_CoupleZone_JiShi_UI_ActivityList_2[5].LevelCount = CoupleZone_JiShi_Item10_Text1
	g_CoupleZone_JiShi_UI_ActivityList_2[5].AccomplishText = CoupleZone_JiShi_Item10_Text2
	
	g_CoupleZone_JiShi_UI_Activity_CurCount_1 = CoupleZone_JiShi_Bijian_TextNUM
	g_CoupleZone_JiShi_UI_Activity_CurCount_2 = CoupleZone_JiShi_Xieshou_TextNUM
	
end

function CoupleZone_JiShi_OnEvent(event)
	
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		CoupleZone_JiShi_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CoupleZone_JiShi_Frame_On_ResetPos()
		--切场景
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CoupleZone_JiShi_OnClose()
	end	
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_JiShi_UICommand_OpenUI) then
		

	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_JiShi_UICommand_UpdateRedPoint) then
		
		
	end	
	
	
	if event == "OPEN_COUPLEZONE_ANNAL" then
		CoupleZone_JiShi_UpdateAnnalData()
		this:Show()
	end		
	
end

function CoupleZone_JiShi_OnShow()
	CoupleZone_JiShi_Debug("CoupleZone_JiShi_OnShow")
	this:Show()
end


function CoupleZone_JiShi_UpdateAnnalData()
		
	local activityData1 = CoupleZone:LuaFnGetCoupleZoneData_Annal_WithId(1)   --1开始
	if type(activityData1) ~= "table" then
		CoupleZone_JiShi_Debug("CoupleZone_JiShi_UpdateAnnalData : activityData1 not table")
		return
    end
	
	local currentCount1 = activityData1["currentCount"]

	for i = 1, table.getn(g_CoupleZone_JiShi_AnnalInfo_1) do
		g_CoupleZone_JiShi_UI_ActivityList_1[i].Img:Hide()
		g_CoupleZone_JiShi_UI_ActivityList_1[i].AccomplishText:SetText("#{QLKJ_230331_87}")
		if currentCount1 >= g_CoupleZone_JiShi_AnnalInfo_1[i].count then
			g_CoupleZone_JiShi_AnnalLevel_1 = i
		end
	end
	
	if g_CoupleZone_JiShi_AnnalLevel_1 >= 1 then
		for i = 1, g_CoupleZone_JiShi_AnnalLevel_1 do
			local accomplishDate = tonumber(activityData1["level_"..i.."_date"])
			local yy = math.floor(accomplishDate / 10000) + 2000
			local mm = math.floor(math.mod(accomplishDate,10000) / 100)
			local dd = math.floor(math.mod(accomplishDate,100))
			local showstr = ScriptGlobal_Format("#{QLKJ_230331_86}", yy, mm, dd)
			g_CoupleZone_JiShi_UI_ActivityList_1[i].AccomplishText:SetText(showstr)
			g_CoupleZone_JiShi_UI_ActivityList_1[i].Img:Show() ----SetProperty("Image",g_CoupleZone_JiShi_UI_ImageLight)
		end
	end
	
	g_CoupleZone_JiShi_UI_Activity_CurCount_1:SetText(ScriptGlobal_Format("#{QLKJ_230331_38}", currentCount1))
	---g_CoupleZone_JiShi_UI_Activity_CurCount_1:SetText(currentCount1)
	
	local activityData2 = CoupleZone:LuaFnGetCoupleZoneData_Annal_WithId(2)   --1开始
	if type(activityData2) ~= "table" then
		CoupleZone_JiShi_Debug("CoupleZone_JiShi_UpdateAnnalData : activityData2 not table")
		return
    end
	
	local currentCount2 = activityData2["currentCount"]

	for i = 1, table.getn(g_CoupleZone_JiShi_AnnalInfo_2) do
		g_CoupleZone_JiShi_UI_ActivityList_2[i].Img:Hide()
		g_CoupleZone_JiShi_UI_ActivityList_2[i].AccomplishText:SetText("#{QLKJ_230331_87}")
		if currentCount2 >= g_CoupleZone_JiShi_AnnalInfo_2[i].count then
			g_CoupleZone_JiShi_AnnalLevel_2 = i
		end
	end
	
	---CoupleZone_JiShi_Debug(g_CoupleZone_JiShi_AnnalLevel_2)
	
	if g_CoupleZone_JiShi_AnnalLevel_2 >= 1 then
		for i = 1, g_CoupleZone_JiShi_AnnalLevel_2 do
			local accomplishDate = tonumber(activityData2["level_"..i.."_date"])
			local yy = math.floor(accomplishDate / 10000) + 2000
			local mm = math.floor(math.mod(accomplishDate,10000) / 100)
			local dd = math.floor(math.mod(accomplishDate,100))
			local showstr = ScriptGlobal_Format("#{QLKJ_230331_86}", yy, mm, dd)
			g_CoupleZone_JiShi_UI_ActivityList_2[i].AccomplishText:SetText(showstr)
			g_CoupleZone_JiShi_UI_ActivityList_2[i].Img:Show() ----:SetProperty("Image",g_CoupleZone_JiShi_UI_ImageLight)
		end
	end
	
	g_CoupleZone_JiShi_UI_Activity_CurCount_2:SetText(ScriptGlobal_Format("#{QLKJ_230331_38}", currentCount2))
	---g_CoupleZone_JiShi_UI_Activity_CurCount_2:SetText(currentCount2)
		
	
end

function CoupleZone_JiShi_OnClose()
	CoupleZone_JiShi_Debug("CoupleZone_JiShi_OnClose")
	CoupleZone_JiShi_Clear()
	this:Hide()
end

function CoupleZone_JiShi_Clear()
	CoupleZone_JiShi_Debug("CoupleZone_JiShi_Clear")
	g_CoupleZone_JiShi_AnnalLevel_1 = -1
	g_CoupleZone_JiShi_AnnalLevel_2 = -1
end

function CoupleZone_JiShi_OnClickedHelp()
	CoupleZone_JiShi_Debug("CoupleZone_JiShi_OnClickedHelp")
	PushEvent("QUEST_HELPINFO","#{QLKJ_230331_96}")
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function CoupleZone_JiShi_Frame_On_ResetPos()
	CoupleZone_JiShi_Frame : SetProperty("UnifiedXPosition", g_CoupleZone_JiShi_Frame_UnifiedXPosition);
	CoupleZone_JiShi_Frame : SetProperty("UnifiedYPosition", g_CoupleZone_JiShi_Frame_UnifiedYPosition);
end

