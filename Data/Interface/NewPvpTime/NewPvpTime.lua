
local g_NewPvpTime_UnifiedPosition

local g_NewPvpTime_UICommand = 89029501
local g_NewPvpTime_opType = {
	show1 = 1,						-- ??UI1
	show2 = 2,						-- ??UI2
	update1 = 3,					-- ???UI1
	update2 = 4,					-- ???UI2
	close = 1000,					-- ??UI
}


local g_Data = {}


function NewPvpTime_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)		
end
--界面21点50到24点显示
function NewPvpTime_OnLoad()
	g_NewPvpTime_UnifiedPosition = NewPvpTime_Frame:GetProperty("UnifiedPosition")
end

function NewPvpTime_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == g_NewPvpTime_UICommand then
		g_Data = {}
		local opType =  Get_XParam_INT( 0 )
		-- 获取奖励次数
		g_Data.Reward = Get_XParam_INT( 1 )
		-- 时间类型
		g_Data.ActIndex = Get_XParam_INT( 2 )
		-- BOSS
		g_Data.BossDi = Get_XParam_INT( 3 )
		g_Data.BossZhong = Get_XParam_INT( 4 )
		g_Data.EndTime = Get_XParam_INT( 5 )
		g_Data.TodayWeek = Get_XParam_INT( 6 )


		if opType == g_NewPvpTime_opType.show1 then
			NewPvpTime_Show()
			NewPvpTime_InitFrame()
		elseif opType == g_NewPvpTime_opType.update1 then
			if (this:IsVisible()) then
				NewPvpTime_InitFrame()
			end
		elseif opType == g_NewPvpTime_opType.close then
			if (this:IsVisible()) then
				NewPvpTime_Hide()
			end
		else
			if (this:IsVisible()) then
				NewPvpTime_Hide()
			end
		end
	-- 游戏窗口尺寸发生了变化
	elseif event == "ADJEST_UI_POS" then
		NewPvpTime_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NewPvpTime_On_ResetPos()
	elseif event == "PLAYER_LEAVE_WORLD" then
		NewPvpTime_Hide()
	end	
end

--显示UI
function NewPvpTime_Show()

	if(IsWindowShow("NewPvpTime_Mini")) then
		CloseWindow("NewPvpTime_Mini", true)
	end
	this:Show()
	--SetTimer("NewPvpTime","NewPvpTime_Timer()", 1000)
end

--隐藏UI
function NewPvpTime_Hide()
	this:Hide()
end

function NewPvpTime_Timer()

end
function NewPvpTime_On_ResetPos()
	NewPvpTime_Frame:SetProperty("UnifiedPosition", g_NewPvpTime_UnifiedPosition)
end

function NewPvpTime_InitFrame()
	--活动剩余低级BOSS
	NewPvpTime_DragTitle:SetText("#{RPVP_240102_12}")
	NewPvpTime_Num:SetText("#cfff263"..g_Data.BossDi)
	NewPvpTime_NumTitle:SetText("#{RPVP_240102_14}")
	NewPvpTime_Num2:SetText("#cfff263"..g_Data.BossZhong)
	NewPvpTime_NumTitle2:SetText("#{RPVP_240102_15}")
	-- 奖励次数
	NewPvpTime_TimeTitle:SetText("#{RPVP_240102_16}")
	local prefix = "#cfff263"
	if g_Data.Reward < 1 then
		prefix = "#cFF0000"
	end
	NewPvpTime_Time:SetText(prefix..g_Data.Reward)

	-- 活动时间
	local timer = 0
	local TimeData = g_Data.EndTime
	local actEndSec = math.mod(TimeData,100)
	TimeData = math.floor(TimeData/100)
	local actEndMin = math.mod(TimeData,100)
	TimeData = math.floor(TimeData/100)
	local actEndHour =  TimeData
	timer = Lua_GetDiffTime_InSecond_ServerTime(actEndHour,actEndMin,actEndSec)
	NewPvpTime_TimeTitle2:SetText("#{RPVP_240102_18}")
	-- 提示
	if (g_Data.TodayWeek == 1 or g_Data.TodayWeek == 3 or g_Data.TodayWeek ==5) and g_Data.ActIndex == 3 then
		NewPvpTime_Text:SetText( "#{RPVP_240102_59}")
	else
		NewPvpTime_Text:SetText( "#{RPVP_240102_13}")
	end

	if timer > 0 then
		NewPvpTime_Time2:SetProperty("Timer", timer)
	else
		NewPvpTime_Time2:SetProperty("Timer", 0)
	end
	NewPvpTime_Time2:SetProperty("TextColor","FFFFF263")
end

function NewPvpTime_OnTimerEnd()
	--NewPvpTime_Time2:SetText("#{BLDPVP_221214_16}")
end

function NewPvpTime_OpenMini()
	PushEvent("OPEN_NEWPVPTIME_MINI")
	this:Hide()
end

function NewPvpTime_OnHiden()
	--KillTimer("NewPvpTime_Timer()")
end
