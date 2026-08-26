
local g_NewPvpTime2_UnifiedPosition

local g_NewPvpTime2_UICommand = 89029501
local g_NewPvpTime2_opType = {
	show1 = 1,						-- ??UI1
	show2 = 2,						-- ??UI2
	update1 = 3,					-- ???UI1
	update2 = 4,					-- ???UI2
	close = 1000,					-- ??UI
}


local g_Data = {}

local g_StateCreateBoss1 = 2

function NewPvpTime2_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS", false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)		
end
--界面21点50到24点显示
function NewPvpTime2_OnLoad()
	g_NewPvpTime2_UnifiedPosition = NewPvpTime2_Frame:GetProperty("UnifiedPosition")
end

function NewPvpTime2_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == g_NewPvpTime2_UICommand then
		g_Data = {}
		local opType =  Get_XParam_INT( 0 )
		-- 获取奖励次数
		g_Data.Reward = Get_XParam_INT( 1 )
		-- 时间类型
		g_Data.ActIndex = Get_XParam_INT( 2 )
		-- BOSS
		g_Data.BossZhong = Get_XParam_INT( 3 )
		g_Data.BossGao = Get_XParam_INT( 4 )
		g_Data.EndTime = Get_XParam_INT( 5 )
		g_Data.TodayWeek = Get_XParam_INT( 6 )

		if opType == g_NewPvpTime2_opType.show2 then
			NewPvpTime2_Show()
			NewPvpTime2_InitFrame()
		elseif opType == g_NewPvpTime2_opType.update2 then
			if (this:IsVisible()) then
				NewPvpTime2_InitFrame()
			end
		elseif opType == g_NewPvpTime2_opType.close then
			if (this:IsVisible()) then
				NewPvpTime2_Hide()
			end
		else
			if (this:IsVisible()) then
				NewPvpTime2_Hide()
			end
		end
	-- 游戏窗口尺寸发生了变化
	elseif event == "ADJEST_UI_POS" then
		NewPvpTime2_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NewPvpTime2_On_ResetPos()
	elseif event == "PLAYER_LEAVE_WORLD" then
		NewPvpTime2_Hide()
	end	
end

--显示UI
function NewPvpTime2_Show()

	if(IsWindowShow("NewPvpTime_Mini")) then
		CloseWindow("NewPvpTime_Mini", true)
	end
	this:Show()
	--SetTimer("NewPvpTime2","NewPvpTime2_Timer()", 1000)
end

--隐藏UI
function NewPvpTime2_Hide()
	this:Hide()
end

function NewPvpTime2_Timer()

end
function NewPvpTime2_On_ResetPos()
	NewPvpTime2_Frame:SetProperty("UnifiedPosition", g_NewPvpTime2_UnifiedPosition)
end

function NewPvpTime2_InitFrame()
	NewPvpTime2_DragTitle:SetText("#{RPVP_240102_12}")

	--活动剩余中BOSS
	NewPvpTime2_BossNum:SetText("#cfff263"..g_Data.BossZhong)
	NewPvpTime2_BossNumTitle:SetText("#{RPVP_240102_15}")
	--活动剩余高BOSS
	NewPvpTime2_BossNum2:SetText("#cfff263"..g_Data.BossGao)
	NewPvpTime2_BossNumTitle2:SetText("#{RPVP_240102_42}")
	-- 奖励次数
	NewPvpTime2_AwardsNumTitle:SetText("#{RPVP_240102_16}")
	local prefix = "#cfff263"
	if g_Data.Reward < 1 then
		prefix = "#cFF0000"
	end
	NewPvpTime2_AwardsNum:SetText(prefix..g_Data.Reward)

	-- 活动时间
	local timer = 0
	
	NewPvpTime2_TimeTitle:SetText("#{RPVP_240102_18}")
	local TimeData = g_Data.EndTime
	local actEndSec = math.mod(TimeData,100)
	TimeData = math.floor(TimeData/100)
	local actEndMin = math.mod(TimeData,100)
	TimeData = math.floor(TimeData/100)
	local actEndHour =  TimeData
	timer = Lua_GetDiffTime_InSecond_ServerTime(actEndHour,actEndMin,actEndSec)
	-- 提示

	if (g_Data.TodayWeek == 1 or g_Data.TodayWeek == 3 or g_Data.TodayWeek ==5) and g_Data.ActIndex == 3 then
		NewPvpTime2_Text:SetText( "#{RPVP_240102_59}")
	else
		NewPvpTime2_Text:SetText( "#{RPVP_240102_13}")
	end
	

	if timer > 0 then
		NewPvpTime2_Time:SetProperty("Timer", timer)
	else
		NewPvpTime2_Time:SetProperty("Timer", 0)
	end
	NewPvpTime2_Time:SetProperty("TextColor","FFFFF263")
end

function NewPvpTime2_OnTimerEnd()
	--NewPvpTime2_Time2:SetText("#{BLDPVP_221214_16}")
end

function NewPvpTime2_OpenMini()
	PushEvent("OPEN_NEWPVPTIME_MINI")
	this:Hide()
end

function NewPvpTime2_OnHiden()
	--KillTimer("NewPvpTime2_Timer()")
end
