local g_Wakuang4_Data = {}
local g_Wakuang4_UnifiedPosition;

local g_Wakuang4_Scene = 0
local g_Wakuang4_state= 0
local g_Wakuang4_count = 0
local g_Wakuang4_Midcount = 0
local g_Wakuang4_Highcount = 0
local g_Wakuang4_strInfo = ""
local g_Wakuang4_stopTime = 0

local g_Wakuang4_scnid = 617
function Wakuang4_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("WAKUANG_SWITCH2")
end
--界面21点50到24点显示
function Wakuang4_OnLoad()	
	g_Wakuang4_UnifiedPosition  =Wakuang4_Frame:GetProperty("UnifiedPosition");
end

function Wakuang4_OnEvent(event)
	--PushDebugMessage("tonumber(arg0)="..tonumber(arg0))
	if event == "UI_COMMAND" and tonumber(arg0) == 20230510 then
		local opType =  Get_XParam_INT( 0 );
		if opType == 4 then
			this:Hide()
		elseif opType == 5 then
			g_Wakuang4_count = Get_XParam_INT( 1 )
			g_Wakuang4_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang4_InitFrame()
		else
			g_Wakuang4_count = Get_XParam_INT( 1 )
			g_Wakuang4_Midcount = Get_XParam_INT( 2 )
			g_Wakuang4_Highcount = Get_XParam_INT(3)
			g_Wakuang4_stopTime = Get_XParam_INT(4)
			g_Wakuang4_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang4_InitFrame()
		end
	end


	if event == "WAKUANG_SWITCH2" then
		local opType = tonumber(arg0)
		if opType == 2 and GetSceneID() == g_Wakuang4_scnid then
			this:Show()
		else
			this:Hide()
		end
	end
			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Wakuang4_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Wakuang4_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	end
end


function Wakuang4_On_ResetPos()
	Wakuang4_Frame:SetProperty("UnifiedPosition", g_Wakuang4_UnifiedPosition);
end

function Wakuang4_InitFrame(index)
	Wakuang4_ToDay_Num1:SetText(ScriptGlobal_Format("#{CJWK_221220_37}",g_Wakuang4_count))
	Wakuang4_Remain1_Num:SetText("#G"..g_Wakuang4_Highcount)
	Wakuang4_Remain2_Num:SetText("#G"..g_Wakuang4_Midcount)
	Wakuang4_NextTime2:SetText(g_Wakuang4_strInfo)

	-- 倒计时
	local stoptime = g_Wakuang4_stopTime
	if stoptime == nil or stoptime < 0 then
		stoptime = 0
	end

	local sec = math.mod(stoptime, 100)
	local hour = math.floor(stoptime*0.0001)
	local min = math.mod(math.floor(stoptime*0.01), 100)

	local sectime = Lua_GetDiffTime_InSecond_ServerTime(hour,min,sec)
	Wakuang4_Remain_TimeWatch:SetProperty("Timer",sectime)

	if(IsWindowShow("Wakuang_Mini2")) then
		CloseWindow("Wakuang_Mini2", true)
	end
end

function Wakuang4_ClickClose()
	PushEvent("WAKUANG_SWITCH2",1)
end

function Wakuang4_OnTimer()
end
