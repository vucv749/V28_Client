local g_Peak_LuckyTime_UnifiedPosition = nil 
local g_Peak_LuckyTime_Npcnum = 0

local g_Peak_LuckyTime_ActiveTime = 
{
    [1] = {begintime = 1100,secondflash = 1110, thirdflash = 1120, endthird = 1130, endtime=1200},
    [2] = {begintime = 1600,secondflash = 1610, thirdflash = 1620, endthird = 1630, endtime=1700},
    [3] = {begintime = 2000,secondflash = 2010, thirdflash = 2020, endthird = 2030, endtime=2100},
}
--1143
function Peak_LuckyTime_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	

	this:RegisterEvent("PEAK_LUCKYTIME_SWITCH")
end 


function Peak_LuckyTime_OnLoad()
	g_Peak_LuckyTime_UnifiedPosition = Peak_LuckyTime:GetProperty("UnifiedPosition");
end

function Peak_LuckyTime_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Peak_LuckyTime_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Peak_LuckyTime_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then

		--Peak_LuckyTime_On_Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20250714 then
		Peak_LuckyTime_InitFrame()

	elseif event == "UI_COMMAND" and tonumber(arg0) == 20250730 then	
		this:Hide()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()	
	elseif (event == "PEAK_LUCKYTIME_SWITCH") then
		local opType = tonumber(arg0)
		if opType == 2 then
			this:Show()
		else
			this:Hide()
		end

	end
end


function Peak_LuckyTime_GetState(maintype,subtype)
	if g_Peak_LuckyTime_ActiveTime[maintype] == nil then
		return "",0
	end


	local timedata = g_Peak_LuckyTime_ActiveTime[maintype]

	if subtype == 1 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.secondflash/100),math.mod(timedata.secondflash,100),00)
		return "#{JYMJ_250711_65}",sec
	end

	if subtype == 2 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.thirdflash/100),math.mod(timedata.thirdflash,100),00)
		return "#{JYMJ_250711_66}",sec
	end

	if subtype == 3 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.endtime/100),math.mod(timedata.endtime,100),00)
		return "#{JYMJ_250711_67}",sec
	end	
	return "",0
end

function Peak_LuckyTime_InitFrame()
	local scenename = GetCurrentSceneName()
	Peak_LuckyTime_DragTitle:SetText("#gFF0FA0"..scenename)
	local str,time = Peak_LuckyTime_GetState(Get_XParam_INT( 0 ),Get_XParam_INT( 2 ))

	local mdinfo  = DataPool:GetPlayerMission_DataRound(1289)
	local part = math.mod(mdinfo,10000)
	local weekcount = math.floor(part/1000)
	local str2 =ScriptGlobal_Format("#{JYMJ_250711_88}",4-weekcount)
	Peak_LuckyTime_Text3:SetText(str2)

	g_Peak_LuckyTime_Npcnum = Get_XParam_INT( 1 )
	Peak_LuckyTime_Time:SetText("#G"..g_Peak_LuckyTime_Npcnum)
	Peak_LuckyTime_TimeTitle2:SetText(str)
	Peak_LuckyTime_Time2:SetProperty("TextColor","FF00FF00")
	Peak_LuckyTime_Time2:SetProperty("Timer",time)
	if(IsWindowShow("Peak_LuckyTimeMini")) then
		this:Hide()
	else
		this:Show()
	end	
end

function Peak_LuckyTime_TimeOut()

end





function Peak_LuckyTime_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Peak_LuckyTime");
end

function Peak_LuckyTime_On_ResetPos()
	Peak_LuckyTime:SetProperty("UnifiedPosition", g_Peak_LuckyTime_UnifiedPosition)
end

function Peak_LuckyTime_On_Hide()
	this:Hide()
end

function Peak_LuckyTime_Image_Click()
end

function Peak_LuckyTime_Help_Click()
end

function Peak_LuckyTime_OpenMini()
	PushEvent("PEAK_LUCKYTIME_SWITCH",1)

end