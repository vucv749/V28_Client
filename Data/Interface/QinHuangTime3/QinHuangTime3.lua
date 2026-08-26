
local g_QinHuangTime3_UnifiedPosition;

local g_QinHuangTime3_Scene = 0
local g_QinHuangTime3_state= 0
local g_QinHuangTime3_count = 0
local g_QinHuangTime3_qinjiangCount = 0

local g_BaoXiangStateUI = {}
local g_BaoXiangState = {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}
local g_AllBaoXiangNum = 5

function QinHuangTime3_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("QIHUANTIME_SWITCH")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end
--界面21点50到24点显示
function QinHuangTime3_OnLoad()	
	g_QinHuangTime3_UnifiedPosition  =QinHuangTime3:GetProperty("UnifiedPosition");

	g_BaoXiangStateUI[1] = QinHuangTime3_DiHunEnt2
	g_BaoXiangStateUI[2] = QinHuangTime3_DiJiang1Ent2
	g_BaoXiangStateUI[3] = QinHuangTime3_DiJiang2Ent2
	g_BaoXiangStateUI[4] = QinHuangTime3_DiJiang3Ent2
	g_BaoXiangStateUI[5] = QinHuangTime3_DiJiang4Ent2
end

function QinHuangTime3_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20210519 then
		local opType =  Get_XParam_INT( 0 );
		g_QinHuangTime3_Scene =  Get_XParam_INT( 1 );
		g_QinHuangTime3_state = Get_XParam_INT(2)
		g_QinHuangTime3_count = Get_XParam_INT(3)
		g_QinHuangTime3_qinjiangCount = Get_XParam_INT(4)
			
		for index = 1, g_AllBaoXiangNum do
			g_BaoXiangState[index] = Get_XParam_INT(4 + index)
		end
		if opType == 1 then
			QinHuangTime3_Show()
			QinHuangTime3_InitFrame()
		elseif opType == 2 then
			QinHuangTime3_InitFrame()
		elseif opType == 1000 then
			if (this:IsVisible()) then
				QinHuangTime3_Hide()
			end
		else
			if (this:IsVisible()) then
				QinHuangTime3_Hide()
			end
		end

	elseif event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		--第四就直接关睜就完事了
		if (this:IsVisible()) then
			QinHuangTime3_Hide()
		end
	end

	if event == "QIHUANTIME_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 3 then
			QinHuangTime3_Show()
			QinHuangTime3_InitFrame()
		else
			QinHuangTime3_Hide()
		end
	end

	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		QinHuangTime3_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		QinHuangTime3_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		QinHuangTime3_Hide()
	end	
end

--显示UI
function QinHuangTime3_Show()
	this:Show()
	SetTimer("QinHuangTime3","QinHuangTime3_Timer()", 1000)
	
end
--隐藏UI
function QinHuangTime3_Hide()
	KillTimer("QinHuangTime3_Timer()")
	this:Hide()
end
function QinHuangTime3_Timer()
	local curTime = tonumber(DataPool:GetServerMinuteTime())
	if curTime >= 202000 and curTime < 202003 then	
		QinHuangTime3_Text:SetText("#{MJXZ_210510_251}")
	end

end
function QinHuangTime3_On_ResetPos()
	QinHuangTime3:SetProperty("UnifiedPosition", g_QinHuangTime3_UnifiedPosition);
end

function QinHuangTime3_InitFrame()

	local curTime = tonumber(DataPool:GetServerMinuteTime())
	if curTime >= 202000 then
		QinHuangTime3_Text:SetText("#{MJXZ_210510_251}")
	else
		QinHuangTime3_Text:SetText("#{MJXZ_210510_27}")
	end
	QinHuangTime3_Time:SetText("#G"..g_QinHuangTime3_count)
	QinHuangTime3_Num2:SetText("#G"..g_QinHuangTime3_qinjiangCount)
	
	if g_QinHuangTime3_state == 0 then
		QinHuangTime3_Num:SetText("#{MJXZ_210510_14}")
	elseif g_QinHuangTime3_state == 1 then
		QinHuangTime3_Num:SetText("#{MJXZ_210510_130}")
	elseif g_QinHuangTime3_state == 2 then
		QinHuangTime3_Num:SetText("#{MJXZ_210510_131}")
	elseif g_QinHuangTime3_state == 3 then
		QinHuangTime3_Num:SetText("#{MJXZ_210510_13}")
	elseif g_QinHuangTime3_state == 4 then
		QinHuangTime3_Num:SetText("#{MJXZ_210510_14}")
	end
	--PushDebugMessage(state)
	local sec = Lua_GetDiffTime_InSecond_ServerTime(20,39,59)
	QinHuangTime3_Time2:SetProperty("TextColor","FB00FF00")
	QinHuangTime3_Time2:SetProperty("Timer",sec)

	-- PushDebugMessage(g_BaoXiangState[1].." "..g_BaoXiangState[2])
	for index = 1, g_AllBaoXiangNum do
		if g_BaoXiangState[index] == 0 or g_BaoXiangState[index] == 1 then
			g_BaoXiangStateUI[index]:SetText("#{MJXZ_210510_139}")
		else
			g_BaoXiangStateUI[index]:SetText("#{MJXZ_210510_140}")
		end
	end
end


function QinHuangTime3_OpenMini()
	PushEvent("QIHUANTIME_SWITCH",1,g_QinHuangTime3_Scene)
end
