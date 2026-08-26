local g_QinHuangTime_Data = {}
local g_QinHuangTime_UnifiedPosition;

local g_QinHuangTime_Scene = 0
local g_QinHuangTime_state= 0
local g_QinHuangTime_count = 0

function QinHuangTime_PreLoad()
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
function QinHuangTime_OnLoad()	
	g_QinHuangTime_Data[1286] = {title = "#{MJXZ_210510_09}",board="#{MJXZ_210510_10}",msg="#{MJXZ_210510_11}"}
	g_QinHuangTime_Data[1287] = {title = "#{MJXZ_210510_18}",board="#{MJXZ_210510_19}",msg="#{MJXZ_210510_20}"}
	g_QinHuangTime_Data[1288] = {title = "#{MJXZ_210510_21}",board="#{MJXZ_210510_22}",msg="#{MJXZ_210510_23}"}
	g_QinHuangTime_UnifiedPosition  =QinHuangTime:GetProperty("UnifiedPosition");
end

function QinHuangTime_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20210510 then
		local opType =  Get_XParam_INT( 0 );
		g_QinHuangTime_Scene =  Get_XParam_INT( 1 );
		g_QinHuangTime_state = Get_XParam_INT(2)
		g_QinHuangTime_count = Get_XParam_INT(3)
		if opType == 1 then
			this:Show()
			QinHuangTime_InitFrame()
		elseif opType == 2 then
			QinHuangTime_InitFrame()
		elseif opType == 1000 then
			if (this:IsVisible()) then
				this:Hide()
			end
		else
			if (this:IsVisible()) then
				this:Hide()
			end
		end
	end
	if event == "UI_COMMAND" and tonumber(arg0) == 20210519 then
		if (this:IsVisible()) then
			this:Hide()
		end
	end

	if event == "QIHUANTIME_SWITCH" then
		local opType = tonumber(arg0)
		if opType == 2 then
			this:Show()
			QinHuangTime_InitFrame()
		else
			this:Hide()
		end
	end

			-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		QinHuangTime_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		QinHuangTime_On_ResetPos()
	elseif (event == "PLAYER_LEAVE_WORLD") then
		this:Hide()
	end
end


function QinHuangTime_On_ResetPos()
	QinHuangTime:SetProperty("UnifiedPosition", g_QinHuangTime_UnifiedPosition);
end

function QinHuangTime_InitFrame(index)

	local strInfo = g_QinHuangTime_Data[g_QinHuangTime_Scene];
	if strInfo then
		QinHuangTime_DragTitle:SetText(strInfo.title)
		QinHuangTime_Text:SetText(strInfo.board)
		QinHuangTime_Pair_Title1:SetText(strInfo.msg)
		QinHuangTime_TimeTitle:SetText("#{MJXZ_210510_15}")
		QinHuangTime_Time:SetText("#G"..g_QinHuangTime_count)

		if g_QinHuangTime_state == 0 then
			QinHuangTime_Num:SetText("#{MJXZ_210510_14}")
		elseif g_QinHuangTime_state == 1 then
			QinHuangTime_Num:SetText("#{MJXZ_210510_130}")
		elseif g_QinHuangTime_state == 2 then
			QinHuangTime_Num:SetText("#{MJXZ_210510_131}")
		elseif g_QinHuangTime_state == 3 then
			QinHuangTime_Num:SetText("#{MJXZ_210510_13}")
		elseif g_QinHuangTime_state == 4 then
			QinHuangTime_Num:SetText("#{MJXZ_210510_14}")
		end
		
		local sec = Lua_GetDiffTime_InSecond_ServerTime(20,39,59)
		QinHuangTime_Time2:SetProperty("TextColor","FB00FF00")
		QinHuangTime_Time2:SetProperty("Timer",sec)
	end
end

function QinHuangTime_OpenMini()
	PushEvent("QIHUANTIME_SWITCH",1,g_QinHuangTime_Scene)
end
