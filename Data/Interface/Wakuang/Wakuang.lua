local g_Wakuang_Data = {}
local g_Wakuang_UnifiedPosition;

local g_Wakuang_Scene = 0
local g_Wakuang_state= 0
local g_Wakuang_count = 0
local g_Wakuang_Midcount = 0
local g_Wakuang_Highcount = 0
local g_Wakuang_strInfo = ""
local g_Wakuang_stopTime = 0

local g_Wakuang_scnid = 617
function Wakuang_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("WAKUANG_SWITCH")
end
--界面21点50到24点显示
function Wakuang_OnLoad()	
	g_Wakuang_UnifiedPosition  =Wakuang_Frame:GetProperty("UnifiedPosition");
end

function Wakuang_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20230315 then
		local opType =  Get_XParam_INT( 0 );
		if opType == 4 then
			this:Hide()
		elseif opType == 5 then
			g_Wakuang_count = Get_XParam_INT( 1 )
			g_Wakuang_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang_InitFrame()
		else
			g_Wakuang_count = Get_XParam_INT( 1 )
			g_Wakuang_Midcount = Get_XParam_INT( 2 )
			g_Wakuang_Highcount = Get_XParam_INT(3)
			g_Wakuang_stopTime = Get_XParam_INT(4)
			g_Wakuang_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang_InitFrame()
		end
	end


	if event == "WAKUANG_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 2 and GetSceneID() == g_Wakuang_scnid then
			this:Show()
		else
			this:Hide()
		end
	end
			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Wakuang_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Wakuang_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	end
end


function Wakuang_On_ResetPos()
	Wakuang_Frame:SetProperty("UnifiedPosition", g_Wakuang_UnifiedPosition);
end

function Wakuang_InitFrame(index)
	Wakuang_ToDay_Num1:SetText(ScriptGlobal_Format("#{CJWK_221220_37}",g_Wakuang_count))
	Wakuang_Remain1_Num:SetText("#G"..g_Wakuang_Highcount)
	Wakuang_Remain2_Num:SetText("#G"..g_Wakuang_Midcount)
	Wakuang_NextTime2:SetText(g_Wakuang_strInfo)

	-- 倒计时
	local stoptime = g_Wakuang_stopTime
	if stoptime == nil or stoptime < 0 then
		stoptime = 0
	end

	local sec = math.mod(stoptime, 100)
	local hour = math.floor(stoptime*0.0001)
	local min = math.mod(math.floor(stoptime*0.01), 100)

	local sectime = Lua_GetDiffTime_InSecond_ServerTime(hour,min,sec)
	Wakuang_Remain_TimeWatch:SetProperty("Timer",sectime)

	if(IsWindowShow("Wakuang_Mini")) then
		CloseWindow("Wakuang_Mini", true)
	end
end

function Wakuang_ClickClose()
	PushEvent("WAKUANG_SWITCH",1)
end

function Wakuang_OnTimer()
end
