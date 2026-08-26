local g_Wakuang3_Data = {}
local g_Wakuang3_UnifiedPosition;

local g_Wakuang3_Scene = 0
local g_Wakuang3_state= 0
local g_Wakuang3_count = 0
local g_Wakuang3_lowcount = 0
local g_Wakuang3_strInfo = ""
local g_Wakuang3_stopTime = 0

local g_Wakuang3_scenedata = {
	[613] = {name="#{CJWK_221220_70}",},
	[614] = {name="#{CJWK_221220_71}",},
	[615] = {name="#{CJWK_221220_72}",},
	[616] = {name="#{CJWK_221220_73}",},
}
function Wakuang3_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("WAKUANG_SWITCH2")
end
--界面21点50到24点显示
function Wakuang3_OnLoad()	
	g_Wakuang3_UnifiedPosition = Wakuang3_Frame:GetProperty("UnifiedPosition")
end

function Wakuang3_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 202305101 then

		local opType =  Get_XParam_INT( 0 )
		if opType == 4 then
			this:Hide()
		elseif opType == 5 then
			g_Wakuang3_count = Get_XParam_INT( 1 )
			g_Wakuang3_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang3_InitFrame()
		else
			g_Wakuang3_count = Get_XParam_INT( 1 )
			g_Wakuang3_lowcount = Get_XParam_INT( 2 )
			g_Wakuang3_stopTime = Get_XParam_INT(3)
			g_Wakuang3_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang3_InitFrame()
		end
	end


	if event == "WAKUANG_SWITCH2" then
		local opType = tonumber(arg0)
		if opType == 2 and Wakuang3_IsRightScene() > 0 then
			this:Show()
		else
			this:Hide()
		end
	end
			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Wakuang3_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Wakuang3_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	end
end


function Wakuang3_On_ResetPos()
	Wakuang3_Frame:SetProperty("UnifiedPosition", g_Wakuang3_UnifiedPosition)
end

function Wakuang3_InitFrame(index)
	local szremain = ScriptGlobal_Format("#{CJWK_221220_68}", Wakuang3_GetSceneName())
	Wakuang3_ToDay_Num1:SetText(ScriptGlobal_Format("#{CJWK_221220_37}", g_Wakuang3_count))
	--Wakuang3_Remain2:SetText(szremain)
	--Wakuang3_Remain2_Num:SetText(ScriptGlobal_Format("#{CJWK_221220_69}", g_Wakuang3_lowcount))
	--Wakuang3_NextTime2:SetText(g_Wakuang3_strInfo)


	-- 倒计时
	local stoptime = g_Wakuang3_stopTime
	if stoptime == nil or stoptime < 0 then
		stoptime = 0
	end

	local sec = math.mod(stoptime, 100)
	local hour = math.floor(stoptime*0.0001)
	local min = math.mod(math.floor(stoptime*0.01), 100)

	local sectime = Lua_GetDiffTime_InSecond_ServerTime(hour,min,sec)
	Wakuang3_Remain_TimeWatch:SetProperty("Timer",sectime)

	if(IsWindowShow("Wakuang_Mini2")) then
		CloseWindow("Wakuang_Mini2", true)
	end
end

function Wakuang3_ClickClose()
	PushEvent("WAKUANG_SWITCH2",1)
end

function Wakuang3_OnTimer()
end

function Wakuang3_IsRightScene()
	
	local scnid = GetSceneID()
	for id, data in(g_Wakuang3_scenedata or {}) do
		if scnid == id then
			return 1
		end
	end

	return 0
end

function Wakuang3_GetSceneName()
	
	local scnid = GetSceneID()
	for id, data in(g_Wakuang3_scenedata or {}) do
		if scnid == id then
			return data.name
		end
	end

	return ""
end
