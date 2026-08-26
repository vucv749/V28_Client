local g_Wakuang2_Data = {}
local g_Wakuang2_UnifiedPosition;

local g_Wakuang2_Scene = 0
local g_Wakuang2_state= 0
local g_Wakuang2_count = 0
local g_Wakuang2_lowcount = 0
local g_Wakuang2_strInfo = ""
local g_Wakuang2_stopTime = 0

local g_Wakuang2_scenedata = {
	[613] = {name="#{CJWK_221220_70}",},
	[614] = {name="#{CJWK_221220_71}",},
	[615] = {name="#{CJWK_221220_72}",},
	[616] = {name="#{CJWK_221220_73}",},
}
function Wakuang2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("WAKUANG_SWITCH")
end
--界面21点50到24点显示
function Wakuang2_OnLoad()	
	g_Wakuang2_UnifiedPosition = Wakuang2_Frame:GetProperty("UnifiedPosition")
end

function Wakuang2_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 202303151 then
		local opType =  Get_XParam_INT( 0 )
		if opType == 4 then
			this:Hide()
		elseif opType == 5 then
			g_Wakuang2_count = Get_XParam_INT( 1 )
			g_Wakuang2_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang2_InitFrame()
		else
			g_Wakuang2_count = Get_XParam_INT( 1 )
			g_Wakuang2_lowcount = Get_XParam_INT( 2 )
			g_Wakuang2_stopTime = Get_XParam_INT(3)
			g_Wakuang2_strInfo = Get_XParam_STR(0)
			this:Show()
			Wakuang2_InitFrame()
		end
	end


	if event == "WAKUANG_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 2 and Wakuang2_IsRightScene() > 0 then
			this:Show()
		else
			this:Hide()
		end
	end
			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Wakuang2_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Wakuang2_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	end
end


function Wakuang2_On_ResetPos()
	Wakuang2_Frame:SetProperty("UnifiedPosition", g_Wakuang2_UnifiedPosition)
end

function Wakuang2_InitFrame(index)
	local szremain = ScriptGlobal_Format("#{CJWK_221220_68}", Wakuang2_GetSceneName())
	Wakuang2_ToDay_Num1:SetText(ScriptGlobal_Format("#{CJWK_221220_37}", g_Wakuang2_count))
	Wakuang2_Remain2:SetText(szremain)
	Wakuang2_Remain2_Num:SetText(ScriptGlobal_Format("#{CJWK_221220_69}", g_Wakuang2_lowcount))
	Wakuang2_NextTime2:SetText(g_Wakuang2_strInfo)


	-- 倒计时
	local stoptime = g_Wakuang2_stopTime
	if stoptime == nil or stoptime < 0 then
		stoptime = 0
	end

	local sec = math.mod(stoptime, 100)
	local hour = math.floor(stoptime*0.0001)
	local min = math.mod(math.floor(stoptime*0.01), 100)

	local sectime = Lua_GetDiffTime_InSecond_ServerTime(hour,min,sec)
	Wakuang2_Remain_TimeWatch:SetProperty("Timer",sectime)

	if(IsWindowShow("Wakuang_Mini")) then
		CloseWindow("Wakuang_Mini", true)
	end
end

function Wakuang2_ClickClose()
	PushEvent("WAKUANG_SWITCH",1)
end

function Wakuang2_OnTimer()
end

function Wakuang2_IsRightScene()
	
	local scnid = GetSceneID()
	for id, data in(g_Wakuang2_scenedata or {}) do
		if scnid == id then
			return 1
		end
	end

	return 0
end

function Wakuang2_GetSceneName()
	
	local scnid = GetSceneID()
	for id, data in(g_Wakuang2_scenedata or {}) do
		if scnid == id then
			return data.name
		end
	end

	return ""
end
