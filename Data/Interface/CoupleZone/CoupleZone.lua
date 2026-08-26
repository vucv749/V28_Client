local objCared = -1;								--关心NPC的Obj的编号（Server传过来）

--UI
local g_CoupleZone_UI_Button_Scry = ""
local g_CoupleZone_UI_Button_Diary = ""
local g_CoupleZone_UI_Button_Calendar = ""
local g_CoupleZone_UI_Button_Annal = ""

local g_CoupleZone_UI_Button_Mission = ""
local g_CoupleZone_UI_Button_Shop = ""
local g_CoupleZone_UI_Button_Vault = ""
local g_CoupleZone_UI_Button_Marry = ""

local g_CoupleZone_UI_Progress_Level = ""

local g_CoupleZone_UI_Animate_Scry = ""

--UI Editable
local g_CoupleZone_UI_Text_Name_0 = ""
local g_CoupleZone_UI_Text_Name_1 = ""
local g_CoupleZone_UI_Img_Head_0 = ""
local g_CoupleZone_UI_Img_Head_1 = ""
local g_CoupleZone_UI_Text_MarriedDay = ""
local g_CoupleZone_UI_Text_MarriedDate = ""
local g_CoupleZone_UI_Text_ScryResult = ""
local g_CoupleZone_UI_Img_Level = ""

--UI Tips
local g_CoupleZone_UI_Tip_Scry = ""
local g_CoupleZone_UI_Tip_Task = ""

local g_CoupleZone_UICommand_OpenUI = 99832401
local g_CoupleZone_UICommand_UpdateScryResult = 99832404

local g_CoupleZone_Scry_MD = 916 ---MD_COUPLEZONE_DATA
local g_CoupleZone_Scry_Info = 
{
	[1] = "#{QLKJ_230331_39}",
	[2] = "#{QLKJ_230331_40}",
	[3] = "#{QLKJ_230331_41}",
	[4] = "#{QLKJ_230331_42}",
}

local g_CoupleZone_Scry_Animate_Time = 2000

local g_CoupleZone_Frame_UnifiedXPosition = 0
local g_CoupleZone_Frame_UnifiedYPosition = 0

local g_CoupleZone_IsDebug = 0

--!!!reloadscript =CoupleZone

function CoupleZone_Debug(str)
	if g_CoupleZone_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_Debug : "..str)
	end
end

function CoupleZone_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OPEN_COUPLEZONE_MAIN") 
	this:RegisterEvent("UPDATE_COUPLEZONE_DATA")
	this:RegisterEvent("UPDATE_COUPLEZONE_REDPOINT")
	this:RegisterEvent("UPDATE_COUPLEZONE_SCRY")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function CoupleZone_OnLoad()
	
	g_CoupleZone_Frame_UnifiedXPosition = CoupleZone_Frame:GetProperty("UnifiedXPosition")
	g_CoupleZone_Frame_UnifiedYPosition = CoupleZone_Frame:GetProperty("UnifiedYPosition")	
	
	g_CoupleZone_UI_Text_Name_0 = CoupleZone_Name1
	g_CoupleZone_UI_Text_Name_1 = CoupleZone_Name2
	g_CoupleZone_UI_Img_Head_0 = CoupleZone_Head1
	g_CoupleZone_UI_Img_Head_1 = CoupleZone_Head2
	g_CoupleZone_UI_Text_MarriedDay = CoupleZone_Day
	g_CoupleZone_UI_Text_MarriedDate = CoupleZone_Date
	--g_CoupleZone_UI_Text_ScryResult = CoupleZone_Zhanbu_Result
	---g_CoupleZone_UI_Img_Level = CoupleZone_Level
	
	g_CoupleZone_UI_Tip_Scry = CoupleZone_Zhanbu_Tips
	g_CoupleZone_UI_Animate_Scry = CoupleZone_Zhanbu_Anim
	g_CoupleZone_UI_Tip_Task = CoupleZone_Task_Tips

end

function CoupleZone_OnEvent(event)
	
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		CoupleZone_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CoupleZone_Frame_On_ResetPos()
		--切场景
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CoupleZone_OnClose()
	end	
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_UICommand_OpenUI) then
		--CoupleZone_Debug("UI_COMMAND  99832401  ")
		local param = Get_XParam_INT( 0 )		
		if param == 1 then
			CoupleZone_AskCoupleZoneData()
		elseif param == 30003 then
			local total = 0
			for i = 1, 10 do	
				if(CoupleZone:LuaFnWriteNewDiary("test diary No. "..i) > 0) then
					total = total + 1
				end
			end
		elseif param == 0 then
			CoupleZone_OnClose()
		end
		
	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == CoupleZone_UICommand_UpdateRedPoint) then
		
		
	end	
	
		
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_CoupleZone_UICommand_UpdateScryResult) then
		if this:IsVisible() then
			local scryResult = Get_XParam_INT( 0 )
			local param =  Get_XParam_INT( 1 )
			if param == 2 then
				CoupleZone_PlayScryAnimate()
			end
		end	
	end	
	
	if ( event == "OPEN_COUPLEZONE_MAIN") then
		if this:IsVisible() then
			CoupleZone_OnClose()
		else
			CoupleZone_AskCoupleZoneData()
		end
	end
	
	if event == "UPDATE_COUPLEZONE_DATA" then
		local param = tonumber(arg0)
		if param == 0 then   
			CoupleZone_UpdateAllCoupleZoneData()
			CoupleZone_OnShow()
		end
	end		
	
	if event == "UPDATE_COUPLEZONE_REDPOINT" then
		CoupleZone_UpdateRedPoint()
	end			
	
end

function CoupleZone_OnShow()
	CoupleZone_Debug("CoupleZone_OnShow")
	g_CoupleZone_UI_Animate_Scry:Hide()
	this:Show()
end

function CoupleZone_UpdateScryResult(scryResult)
	CoupleZone_Debug("CoupleZone_UpdateScryResult")
	--g_CoupleZone_UI_Text_ScryResult:SetText(g_CoupleZone_Scry_Info[scryResult])
end

function CoupleZone_AskCoupleZoneData()
	CoupleZone_Debug("CoupleZone_AskCoupleZoneData")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnAskCoupleZoneData" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 998324 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1);    					-- 请求类型  1  打开空间主界面前请求
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_UpdateAllCoupleZoneData()
	
	local mainData = CoupleZone:LuaFnGetCoupleZoneData_Main()
	if type(mainData) ~= "table" then
		CoupleZone_Debug("CoupleZone_UpdateAllCoupleZoneData : mainData not table")
		return
    end
	
	local portraitImg_0 = mainData["portrait_0"]
	local portraitImg_1 = mainData["portrait_1"]
	local name_0 = mainData["name_0"]
	local name_1 = mainData["name_1"]
	local zoneLevel = mainData["zoneLevel"]
	local zoneExp = mainData["zoneExp"]
	local marriedDate = mainData["marriedDate"]
	local marriedDay = mainData["marriedDay"]
	
	marriedDate = math.floor(marriedDate / 10000)
	local yy = math.floor(marriedDate / 10000) + 2000
	local mm = math.floor(math.mod(marriedDate,10000) / 100)
	local dd = math.floor(math.mod(marriedDate,100))

	local marriedDateStr = ScriptGlobal_Format("#{QLKJ_230331_36}", yy, mm, dd)	
	local marriedDayStr = ScriptGlobal_Format("#{QLKJ_230331_37}", marriedDay)
	local scryResult = DataPool:GetPlayerMission_DataRound(g_CoupleZone_Scry_MD)

	--if scryResult <= 0 or scryResult > table.getn(g_CoupleZone_Scry_Info) then
		--g_CoupleZone_UI_Text_ScryResult:SetText("#{QLKJ_230331_47}")
	--else
		--g_CoupleZone_UI_Text_ScryResult:SetText(g_CoupleZone_Scry_Info[scryResult])
	--end
	
	g_CoupleZone_UI_Text_Name_0:SetText(name_0)
	g_CoupleZone_UI_Text_Name_1:SetText(name_1)
	g_CoupleZone_UI_Img_Head_0:SetProperty("Image", tostring(portraitImg_0))
	g_CoupleZone_UI_Img_Head_1:SetProperty("Image", tostring(portraitImg_1));	
	g_CoupleZone_UI_Text_MarriedDay:SetText(marriedDayStr)
	g_CoupleZone_UI_Text_MarriedDate:SetText(marriedDateStr)
	---g_CoupleZone_UI_Img_Level:SetProperty("Image", "set:Menpaishuxing image:Shuxing_Fire");
end

function CoupleZone_UpdateAllRedPoint()
	CoupleZone_Debug("CoupleZone_UpdateAllRedPoint")
end

function CoupleZone_UpdateRedPoint(redIndex)
	CoupleZone_Debug("CoupleZone_UpdateRedPoint")
	if CoupleZone:LuaFnIsCZoneRedPointInUIShow(0) == 1 then
		g_CoupleZone_UI_Tip_Scry:Show()
	else
		g_CoupleZone_UI_Tip_Scry:Hide()
	end
	
	if CoupleZone:LuaFnIsCZoneRedPointInUIShow(1) == 1 then
		g_CoupleZone_UI_Tip_Task:Show()
	else
		g_CoupleZone_UI_Tip_Task:Hide()
	end
end

function CoupleZone_OnClicked_Scry()
	CoupleZone_Debug("CoupleZone_OnClicked_Scry")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "BeforeDoScry" ); 		    -- 函数名
		Set_XSCRIPT_ScriptID( 998324 );						-- 脚本编号
		Set_XSCRIPT_ParamCount( 0 );						-- 参数个数
	Send_XSCRIPT()	

end

function CoupleZone_PlayScryAnimate()
	
	SetTimer("CoupleZone_Zhanbu","CoupleZone_Scry_Animate_Close()", g_CoupleZone_Scry_Animate_Time)
	CoupleZone_Scry_AnimateShow()

end

function CoupleZone_Scry_Animate_Close()
    KillTimer("CoupleZone_Scry_Animate_Close()")
    --停止动画
    g_CoupleZone_UI_Animate_Scry:Play(false)
	g_CoupleZone_UI_Animate_Scry:Hide()
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnDoScry" ); 		    -- 函数名
		Set_XSCRIPT_ScriptID( 998324 );						-- 脚本编号
		Set_XSCRIPT_ParamCount( 0 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_Scry_AnimateShow()
	g_CoupleZone_UI_Animate_Scry:Show()
	g_CoupleZone_UI_Animate_Scry:Play(true)
end

function CoupleZone_OnClicked_ScryHelp()
	CoupleZone_Debug("CoupleZone_OnClicked_ScryHelp")
	PushEvent("OPEN_COUPLEZONE_HELP",1)
end

function CoupleZone_OnClicked_Diary()
	CoupleZone_Debug("CoupleZone_OnClicked_Diary")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnAskCoupleDiaryData" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 998325 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1);    					-- 请求类型  1  打开空间主界面前请求
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_OnClicked_Marry()
	CoupleZone_Debug("CoupleZone_OnClicked_Marry")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskHunShu" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 806003 );						-- 脚本编号
		Set_XSCRIPT_ParamCount( 0 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_OnClicked_Calendar()
	CoupleZone_Debug("CoupleZoner_OnClicked_Calendar")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnAskCoupleCalendarData" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 998326 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1);    					-- 请求类型  1  打开空间主界面前请求
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_OnClicked_Annal()
	CoupleZone_Debug("CoupleZone_OnClicked_Annal")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnAskCoupleAnnalData" ); 		-- 函数名
		Set_XSCRIPT_ScriptID( 998327 );						-- 脚本编号
		Set_XSCRIPT_Parameter(0, 1);    					-- 请求类型  1  打开空间主界面前请求
		Set_XSCRIPT_ParamCount( 1 );						-- 参数个数
	Send_XSCRIPT()
end

function CoupleZone_OnClose()
	CoupleZone_Debug("CoupleZone_OnClose")
	CoupleZone_Clear()
	CoupleZone_OnHidden()
end

function CoupleZone_Clear()
	CoupleZone_Debug("CoupleZone_Clear")
end

function CoupleZone_OnHidden()
--	CoupleZone_Debug("CoupleZone_OnHidden")
	this:Hide()
end

function CoupleZone_OnClicked_Mission()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenUI")
		Set_XSCRIPT_ScriptID(998293)
		Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end

function CoupleZone_OnClicked_Shop()
	CoupleZone_Debug("CoupleZone_OnClicked_Shop")
	DataPool:Lua_OpenFuQiShop()
end

function CoupleZone_OnClicked_Vault()
	--Clear_XSCRIPT()
    --    Set_XSCRIPT_Function_Name("OpenCoupleVault_Client")
	--    Set_XSCRIPT_ScriptID(998336)
    --    Set_XSCRIPT_ParamCount(0)
    --Send_XSCRIPT()
	
	-- 金库入口改成共享衣柜
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenCoupleFashion_Client")
		Set_XSCRIPT_ScriptID(998346)
		Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end

function CoupleZone_OnClicked_LevelInfo()
	CoupleZone_Debug("CoupleZone_OnClicked_LevelInfo()")
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function CoupleZone_Frame_On_ResetPos()
	CoupleZone_Frame : SetProperty("UnifiedXPosition", g_CoupleZone_Frame_UnifiedXPosition);
	CoupleZone_Frame : SetProperty("UnifiedYPosition", g_CoupleZone_Frame_UnifiedYPosition);
end


--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_CoupleZone(objCaredId)
	this:CareObject(objCaredId, 1, "CoupleZone");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_CoupleZone(objCaredId)
	this:CareObject(objCaredId, 0, "CoupleZone");
	objCared = -1;
end
