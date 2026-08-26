local g_Phoenix_Rest_UnifiedPosition = nil 

local g_Phoenix_Rest_Count = 0
local g_Phoenix_Rest_RaidNum = 0
local g_Phoenix_Rest_Maketime = 0
local g_Phoenix_Rest_level = -1

function Phoenix_Rest_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("TSPHEONIX_SWITCH")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
end 

-- Phoenix_Rest_Frame_Client => DefaultWindow
-- Phoenix_Rest_DragTitle => TLBB_DragTitle
-- Phoenix_Rest_Image => TLBB_ButtonNULL
-- Phoenix_Rest_Help => TLBB_ButtonHelp
function Phoenix_Rest_OnLoad()
	g_Phoenix_Rest_UnifiedPosition = Phoenix_Rest:GetProperty("UnifiedPosition");
end

function Phoenix_Rest_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 20240407 then
		local opType = Get_XParam_INT( 0 )

		g_Phoenix_Rest_Count = Get_XParam_INT( 1 )
		g_Phoenix_Rest_RaidNum = Get_XParam_INT(2)
		g_Phoenix_Rest_Maketime = Get_XParam_INT(3)
		if IsWindowShow("Phoenix_Rest_Mini") == false then
			this:Show()
		end
		g_Phoenix_Rest_level = opType
		Phoenix_Rest_Init(opType)

		
	elseif(event == "ADJEST_UI_POS") then
		Phoenix_Rest_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Phoenix_Rest_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Phoenix_Rest_On_Hide()
	elseif event == "TSPHEONIX_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 2 then
			this:Show()
			Phoenix_Rest_Init(g_Phoenix_Rest_level)
		else
			this:Hide()
		end
	
	end
end





function Phoenix_Rest_Init(level)
	


	Phoenix_Rest_Num:SetText(g_Phoenix_Rest_Count)
	Phoenix_Rest_TimeTitle2:SetText("#{FHKF_20240315_56}")
	local sec = Lua_GetDiffTime_InSecond_ServerTime(21,0,0)
	Phoenix_Rest_Time2:SetProperty("Timer",sec)
	if level == 1 then
		Phoenix_Rest:SetProperty("UnifiedSize","{{0.000000,280.000000},{0.000000,370.000000}}")
		Phoenix_Rest_Time:Hide()
		Phoenix_Rest_stTime:Show()
		Phoenix_Rest_TimeTitle:Show()
		Phoenix_Rest_NumTitle:SetText("#{FHKF_20240315_55}")
		Phoenix_Rest_Num:SetText(g_Phoenix_Rest_RaidNum)
		Phoenix_Rest_TimeTitle:SetText("#{FHKF_20240315_74}")
		Phoenix_Rest_Text:SetText("#{FHKF_20240315_51}")
		if g_Phoenix_Rest_Maketime == -1 then
			Phoenix_Rest_stTime:SetProperty("Timer",600)
		else	
			Phoenix_Rest_stTime:SetProperty("Timer",g_Phoenix_Rest_Maketime)
		end
	elseif level == 3 then
		Phoenix_Rest_NumTitle:SetText("#{FHKF_20240315_53}")
		Phoenix_Rest:SetProperty("UnifiedSize","{{0.000000,280.000000},{0.000000,267.000000}}")
		Phoenix_Rest_stTime:Hide()
		Phoenix_Rest_Time:Hide()
		Phoenix_Rest_TimeTitle:Hide()
		Phoenix_Rest_Text:SetText("#{FHKF_20240315_197}")
		
		local curHMS = tonumber(DataPool:GetServerMinuteTime())
		if curHMS < 200000 then
			Phoenix_Rest_TimeTitle2:SetText("#{FHKF_20240315_217}")
			local sec = Lua_GetDiffTime_InSecond_ServerTime(20,0,0)
			Phoenix_Rest_Time2:SetProperty("Timer",sec)
		end

	else
		Phoenix_Rest_NumTitle:SetText("#{FHKF_20240315_53}")
		Phoenix_Rest:SetProperty("UnifiedSize","{{0.000000,280.000000},{0.000000,370.000000}}")
		Phoenix_Rest_Time:Hide()
		Phoenix_Rest_stTime:Show()
		Phoenix_Rest_TimeTitle:Show()
		Phoenix_Rest_Text:SetText("#{FHKF_20240315_205}")
		Phoenix_Rest_TimeTitle:SetText("#{FHKF_20240315_74}")
		Phoenix_Rest_stTime:SetProperty("Timer",g_Phoenix_Rest_Maketime)
	end

	if level == 1 then
		Phoenix_Rest_DragTitle:SetText("#{FHKF_20240315_50}")
	elseif level == 2 then 
		Phoenix_Rest_DragTitle:SetText("#{FHKF_20240315_141}")
	else
		Phoenix_Rest_DragTitle:SetText("#{FHKF_20240315_187}")
	end



end
function Phoenix_Rest_On_ResetPos()
	Phoenix_Rest:SetProperty("UnifiedPosition", g_Phoenix_Rest_UnifiedPosition)
end

function Phoenix_Rest_On_Hide()
	this:Hide()
end

function Phoenix_Rest_Image_Click()
end

function Phoenix_Rest_Help_Click()
end


function Phoenix_Rest_OpenMini()
	PushEvent("TSPHEONIX_SWITCH",1,g_Phoenix_Rest_level)
end