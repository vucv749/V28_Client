--UI
local g_CoupleZone_Diary_UI_Button_LastPage = ""
local g_CoupleZone_Diary_UI_Button_NextPage = ""


--UI Editable
local g_CoupleZone_Diary_UI_DiaryList = {}  ----Client,DiaryText,Info
local g_CoupleZone_Diary_UI_CurrentPage = ""


local g_CoupleZone_Diary_UICommand_OpenUI = 99832501
local g_CoupleZone_Diary_UICommand_UpdateRedPoint = 99832403

local g_CoupleZone_Diary_Frame_UnifiedXPosition = 0
local g_CoupleZone_Diary_Frame_UnifiedYPosition = 0

local g_CoupleZone_Diary_UI_DiaryNumPerPage = 6

--running data
--diaryId从0开始的
local g_CoupleZone_Diary_Current_Page = 1  -- 当前打开的页
local g_CoupleZone_Diary_TotalDiaryItem = 0   --总条数
local g_CoupleZone_Diary_MaxPage = 1   --最大页数
local g_CoupleZone_Diary_DiaryList = {}  ----date,author,id

local g_CoupleZone_Diary_IsDebug = 0

--!!!reloadscript =CoupleZone_Diary

function CoupleZone_Diary_Debug(str)
	if g_CoupleZone_Diary_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_Diary_Debug : "..str)
	end
end

function CoupleZone_Diary_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("UPDATE_COUPLEZONE_DATA")
	this:RegisterEvent("UPDATE_COUPLEZONE_REDPOINT")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OPEN_COUPLEZONE_DIARY")
end

function CoupleZone_Diary_OnLoad()
	
	g_CoupleZone_Diary_Frame_UnifiedXPosition = CoupleZone_Diary_Frame:GetProperty("UnifiedXPosition")
	g_CoupleZone_Diary_Frame_UnifiedYPosition = CoupleZone_Diary_Frame:GetProperty("UnifiedYPosition")	
	
	g_CoupleZone_Diary_UI_Button_LastPage = CoupleZone_Diary_UpPage
	g_CoupleZone_Diary_UI_Button_NextPage = CoupleZone_Diary_DownPage
	
	g_CoupleZone_Diary_UI_DiaryList[1] = {}
	g_CoupleZone_Diary_UI_DiaryList[1].Client = CoupleZone_Diary_Item1
	g_CoupleZone_Diary_UI_DiaryList[1].DiaryText = CoupleZone_Diary_Item1_Text1
	g_CoupleZone_Diary_UI_DiaryList[1].Info = CoupleZone_Diary_Item1_Text2
	g_CoupleZone_Diary_UI_DiaryList[2] = {}
	g_CoupleZone_Diary_UI_DiaryList[2].Client = CoupleZone_Diary_Item2
	g_CoupleZone_Diary_UI_DiaryList[2].DiaryText = CoupleZone_Diary_Item2_Text1
	g_CoupleZone_Diary_UI_DiaryList[2].Info = CoupleZone_Diary_Item2_Text2
	g_CoupleZone_Diary_UI_DiaryList[3] = {}
	g_CoupleZone_Diary_UI_DiaryList[3].Client = CoupleZone_Diary_Item3
	g_CoupleZone_Diary_UI_DiaryList[3].DiaryText = CoupleZone_Diary_Item3_Text1
	g_CoupleZone_Diary_UI_DiaryList[3].Info = CoupleZone_Diary_Item3_Text2
	g_CoupleZone_Diary_UI_DiaryList[4] = {}
	g_CoupleZone_Diary_UI_DiaryList[4].Client = CoupleZone_Diary_Item4
	g_CoupleZone_Diary_UI_DiaryList[4].DiaryText = CoupleZone_Diary_Item4_Text1
	g_CoupleZone_Diary_UI_DiaryList[4].Info = CoupleZone_Diary_Item4_Text2
	g_CoupleZone_Diary_UI_DiaryList[5] = {}
	g_CoupleZone_Diary_UI_DiaryList[5].Client = CoupleZone_Diary_Item5
	g_CoupleZone_Diary_UI_DiaryList[5].DiaryText = CoupleZone_Diary_Item5_Text1
	g_CoupleZone_Diary_UI_DiaryList[5].Info = CoupleZone_Diary_Item5_Text2
	g_CoupleZone_Diary_UI_DiaryList[6] = {}
	g_CoupleZone_Diary_UI_DiaryList[6].Client = CoupleZone_Diary_Item6
	g_CoupleZone_Diary_UI_DiaryList[6].DiaryText = CoupleZone_Diary_Item6_Text1
	g_CoupleZone_Diary_UI_DiaryList[6].Info = CoupleZone_Diary_Item6_Text2

	
	g_CoupleZone_Diary_UI_CurrentPage = CoupleZone_Diary_Page
	
end

function CoupleZone_Diary_OnEvent(event)
	
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		CoupleZone_Diary_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CoupleZone_Diary_Frame_On_ResetPos()
		--切场景
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CoupleZone_Diary_OnClose()
	end	
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_Diary_UICommand_OpenUI) then
		

	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_Diary_UICommand_UpdateRedPoint) then
		
		
	end	
	
	
	if event == "OPEN_COUPLEZONE_DIARY" then
		g_CoupleZone_Diary_Current_Page = tonumber(arg0)  -- 当前打开的页
		g_CoupleZone_Diary_TotalDiaryItem = tonumber(arg1)    --总条数
		g_CoupleZone_Diary_MaxPage = tonumber(arg2)  --最大页数
		CoupleZone_Diary_UpdateDiaryData()
		this:Show()
	end		
	
end

function CoupleZone_Diary_OnShow()
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnShow")
	this:Show()
end

function CoupleZone_Diary_AskDiaryData()
	CoupleZone_Diary_Debug("CoupleZone_Diary_AskDiaryData")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnAskCoupleDiaryData" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 998325 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1);    					-- 请求类型  1  打开空间主界面前请求
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_Diary_UpdateDiaryData()
	CoupleZone_Diary_Debug("CoupleZone_Diary_UpdateDiaryData "..g_CoupleZone_Diary_Current_Page)
	
	g_CoupleZone_Diary_UI_Button_LastPage:Enable()
	g_CoupleZone_Diary_UI_Button_NextPage:Enable()	
	
	local mainData = CoupleZone:LuaFnGetCoupleZoneData_Diary_WithPage(g_CoupleZone_Diary_Current_Page)
	if type(mainData) ~= "table" then
		CoupleZone_Diary_Debug("CoupleZone_Diary_UpdateDiaryData : mainData not table, page : "..g_CoupleZone_Diary_Current_Page)
		return
    end
	local realOpenPage = mainData["realOpenPage"]
	local curPageTotal = mainData["curPageTotal"]
	
	if realOpenPage ~= g_CoupleZone_Diary_Current_Page then
		g_CoupleZone_Diary_Current_Page = realOpenPage
		CoupleZone_Diary_Debug("CoupleZone_Diary_UpdateDiaryData 数据错误 打开最后一页")
	end

	for i = 1, curPageTotal do

		g_CoupleZone_Diary_DiaryList[i] = {}
		g_CoupleZone_Diary_DiaryList[i].writeDate = mainData["diary_"..i.."_time"]
		g_CoupleZone_Diary_DiaryList[i].authorName = mainData["diary_"..i.."_author"]
		g_CoupleZone_Diary_DiaryList[i].realId = mainData["diary_"..i.."_realid"]

		local yy = math.floor(g_CoupleZone_Diary_DiaryList[i].writeDate / 10000) + 2000
		local mm = math.floor(math.mod(g_CoupleZone_Diary_DiaryList[i].writeDate,10000) / 100)
		local dd = math.floor(math.mod(g_CoupleZone_Diary_DiaryList[i].writeDate,100))
		
		local infoStr = ScriptGlobal_Format("#{QLKJ_230331_50}", g_CoupleZone_Diary_DiaryList[i].authorName, yy, mm, dd)
		
		g_CoupleZone_Diary_UI_DiaryList[i].DiaryText:SetText("#c993333"..mainData["diary_"..i.."_text"])
		g_CoupleZone_Diary_UI_DiaryList[i].Info:SetText(infoStr)
		g_CoupleZone_Diary_UI_DiaryList[i].Client:Show()
	end
	
	if curPageTotal < g_CoupleZone_Diary_UI_DiaryNumPerPage then
		for i = curPageTotal + 1, g_CoupleZone_Diary_UI_DiaryNumPerPage do
			g_CoupleZone_Diary_UI_DiaryList[i].Client:Hide()
		end
	end
	
	g_CoupleZone_Diary_UI_CurrentPage:SetText(g_CoupleZone_Diary_Current_Page)
	
	if g_CoupleZone_Diary_Current_Page > 1 then
		g_CoupleZone_Diary_UI_Button_LastPage:Enable()
	else
		g_CoupleZone_Diary_UI_Button_LastPage:Disable()
	end

	if g_CoupleZone_Diary_Current_Page < g_CoupleZone_Diary_MaxPage then
		g_CoupleZone_Diary_UI_Button_NextPage:Enable()
	else
		g_CoupleZone_Diary_UI_Button_NextPage:Disable()
	end	
	
end

function CoupleZone_Diary_OnClicked_Write()
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnClicked_Write")
	PushEvent("OPEN_COUPLEZONE_WRITEDIARY")
end

function CoupleZone_Diary_OnClicked_Delete(index)
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnClicked_Delete : "..index)
	if index <= 0 or index > g_CoupleZone_Diary_UI_DiaryNumPerPage then
		return
	end
	--CoupleZone:LuaFnDeleteDiaryByRealId(g_CoupleZone_Diary_DiaryList[index].realId)
	
	--二次确认
	PushEvent("DELETE_COUPLE_DIARY_CONFIRM",g_CoupleZone_Diary_DiaryList[index].realId)
	
end


function CoupleZone_Diary_OnClose()
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnClose")
	CoupleZone_Diary_Clear()
	CoupleZone_Diary_OnHidden()
end

function CoupleZone_Diary_Clear()
	CoupleZone_Diary_Debug("CoupleZone_Diary_Clear")
	g_CoupleZone_Diary_Current_Page = 1 
	g_CoupleZone_Diary_TotalDiaryItem = 0 
	g_CoupleZone_Diary_MaxPage = 1
end

function CoupleZone_Diary_OnHidden()
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnHidden")
	this:Hide()
end


function CoupleZone_Diary_OnClicked_LastPage()
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnClicked_LastPage")
	local newPage = g_CoupleZone_Diary_Current_Page - 1
	if newPage < 1 then
		newPage = 1
		g_CoupleZone_Diary_UI_Button_LastPage:Disable()
	end
	PushEvent("OPEN_COUPLEZONE_DIARY", newPage, g_CoupleZone_Diary_TotalDiaryItem, g_CoupleZone_Diary_MaxPage)
end

function CoupleZone_Diary_OnClicked_NextPage()
	CoupleZone_Diary_Debug("CoupleZone_Diary_OnClicked_NextPage")
	local newPage = g_CoupleZone_Diary_Current_Page + 1
	if newPage > g_CoupleZone_Diary_MaxPage then
		newPage = g_CoupleZone_Diary_MaxPage
		g_CoupleZone_Diary_UI_Button_NextPage:Disable()
	end
	PushEvent("OPEN_COUPLEZONE_DIARY", newPage, g_CoupleZone_Diary_TotalDiaryItem, g_CoupleZone_Diary_MaxPage)
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function CoupleZone_Diary_Frame_On_ResetPos()
	CoupleZone_Diary_Frame : SetProperty("UnifiedXPosition", g_CoupleZone_Diary_Frame_UnifiedXPosition);
	CoupleZone_Diary_Frame : SetProperty("UnifiedYPosition", g_CoupleZone_Diary_Frame_UnifiedYPosition);
end
