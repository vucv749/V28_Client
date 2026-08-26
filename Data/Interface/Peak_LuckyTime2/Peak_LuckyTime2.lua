local g_Peak_LuckyTime2_UnifiedPosition = nil 
local g_Peak_LuckyTime2_Npcnum = 0
local g_Peak_LuckyTime2_timestr = ""
local g_Peak_LuckyTime2_Sec = 0
local g_Peak_LuckyTime2_subType = 0

local g_Peak_LuckyTime2_ActiveTime = 
{
    [1] = {begintime = 1100,secondflash = 1110, thirdflash = 1120, endthird = 1130, endtime=1200},
    [2] = {begintime = 1600,secondflash = 1610, thirdflash = 1620, endthird = 1630, endtime=1700},
    [3] = {begintime = 2000,secondflash = 2010, thirdflash = 2020, endthird = 2030, endtime=2100},
}

--1143
function Peak_LuckyTime2_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	

	this:RegisterEvent("PEAK_LUCKYTIME_SWITCH")
end 


function Peak_LuckyTime2_OnLoad()
	g_Peak_LuckyTime2_UnifiedPosition = Peak_LuckyTime2:GetProperty("UnifiedPosition");
end

function Peak_LuckyTime2_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Peak_LuckyTime2_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Peak_LuckyTime2_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then

		--Peak_LuckyTime2_On_Hide()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20250718 then
		Peak_LuckyTime2_InitFrame()

	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()	
	elseif (event == "PEAK_LUCKYTIME_SWITCH") then
		local opType = tonumber(arg0)
		if opType == 4 then
			this:Show()
		else
			this:Hide()
		end

	end
end


function Peak_LuckyTime2_GetState(maintype,subtype)
	if g_Peak_LuckyTime2_ActiveTime[maintype] == nil then
		return "",0
	end


	local timedata = g_Peak_LuckyTime2_ActiveTime[maintype]

	if subtype == 1 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.secondflash/100),math.mod(timedata.secondflash,100),00)
		return "#{JYMJ_250711_63}",sec
	end

	if subtype == 2 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.thirdflash/100),math.mod(timedata.thirdflash,100),00)
		return "#{JYMJ_250711_63}",sec
	end

	if subtype == 3 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.endtime/100),math.mod(timedata.endtime,100),00)
		return "#{JYMJ_250711_64}",sec
	end	

	if subtype == 4 then
		local sec = Lua_GetDiffTime_InSecond_ServerTime(math.floor(timedata.endtime/100),math.mod(timedata.endtime,100),00)
		return "#{JYMJ_250711_64}",sec
	end		
	return "",0
end

function Peak_LuckyTime2_InitFrame()
	-- local scenename = GetCurrentSceneName()
	-- Peak_LuckyTime2_DragTitle:SetText(scenename)

	local timecount = Get_XParam_INT( 0 )
	--Peak_LuckyTime2_Time:SetText(g_Peak_LuckyTime2_Npcnum)
	
	Peak_LuckyTime2_Time:SetProperty("TextColor","FF00FF00")
	Peak_LuckyTime2_Time:SetProperty("Timer",3600-timecount)

	local campcount =  Get_XParam_INT( 1 )
	-- Peak_LuckyTime2_Time2Text:SetText("#G"..campcount)

	local param1 = Get_XParam_INT(2)

	local param2 = Get_XParam_INT(3)

	if campcount <= 1 then
		Peak_LuckyTime2_TimeTitle2:SetText("#{JYMJ_250711_89}")
		Peak_LuckyTime2_TimeTitle3:SetText("#{JYMJ_250711_92}")
	else
		Peak_LuckyTime2_TimeTitle2:SetText(ScriptGlobal_Format("#{JYMJ_250711_90}",campcount))
		Peak_LuckyTime2_TimeTitle3:SetText("#{JYMJ_250711_93}")
	end
	KillTimer("Peak_LuckyTime2_Timer()")
	local str,sec = Peak_LuckyTime2_GetState(param1,param2)
	if sec - 1 > 0 then
		sec = sec-1
	end

	if string.len(str) > 0 then

		g_Peak_LuckyTime2_timestr = str
		g_Peak_LuckyTime2_Sec = sec	

		g_Peak_LuckyTime2_subType = param2
		

		if g_Peak_LuckyTime2_subType >= 3 then
			Peak_LuckyTime2_TimeTitle5:Hide()
			Peak_LuckyTime2_TimeTitle4:Show()
			Peak_LuckyTime2_Time3:Hide()
		else
			Peak_LuckyTime2_TimeTitle5:Show()
			Peak_LuckyTime2_TimeTitle5:SetText(g_Peak_LuckyTime2_timestr)
			Peak_LuckyTime2_TimeTitle4:Hide()
			Peak_LuckyTime2_Time3:Show()
			Peak_LuckyTime2_Time3:SetText(Peak_LuckyTime2_formatSec(g_Peak_LuckyTime2_Sec))
		end


	end

			--挂计时器
		SetTimer("Peak_LuckyTime2","Peak_LuckyTime2_Timer()", 1000);--计时

	if(IsWindowShow("Peak_LuckyTimeMini")) then
		this:Hide()
	else
		this:Show()
	end	


end

function Peak_LuckyTime2_formatSec(sec) 

	local min = math.floor(sec/60)
	local sec = math.mod(sec,60)

	return ScriptGlobal_Format("#{JYMJ_250711_91}",min,sec)
end



function Peak_LuckyTime2_Timer()
	g_Peak_LuckyTime2_Sec = g_Peak_LuckyTime2_Sec - 1
	if g_Peak_LuckyTime2_Sec < 0 then
		g_Peak_LuckyTime2_Sec = 0
		KillTimer("Peak_LuckyTime2_Timer()")
	end
	-- Peak_LuckyTime2_TimeTitle3:SetText(ScriptGlobal_Format(g_Peak_LuckyTime2_timestr,g_Peak_LuckyTime2_Sec))


	if g_Peak_LuckyTime2_subType >= 3 then
		Peak_LuckyTime2_TimeTitle5:Hide()
		Peak_LuckyTime2_TimeTitle4:Show()
		Peak_LuckyTime2_Time3:Hide()
	else
		Peak_LuckyTime2_TimeTitle5:Show()
		Peak_LuckyTime2_TimeTitle5:SetText(g_Peak_LuckyTime2_timestr)
		Peak_LuckyTime2_TimeTitle4:Hide()
		Peak_LuckyTime2_Time3:Show()
		Peak_LuckyTime2_Time3:SetText(Peak_LuckyTime2_formatSec(g_Peak_LuckyTime2_Sec))
	end

end





function Peak_LuckyTime2_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Peak_LuckyTime2");
end

function Peak_LuckyTime2_On_ResetPos()
	Peak_LuckyTime2:SetProperty("UnifiedPosition", g_Peak_LuckyTime2_UnifiedPosition)
end

function Peak_LuckyTime2_On_Hide()
	this:Hide()
end

function Peak_LuckyTime2_Image_Click()
end

function Peak_LuckyTime2_Help_Click()
end

function Peak_LuckyTime2_OpenMini()

	PushEvent("PEAK_LUCKYTIME_SWITCH",3)

end