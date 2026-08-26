local g_DuoBao_XiuXi_Frame_UnifiedPosition = nil 

function DuoBao_XiuXi_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("DUOBAO_XIUXI_SWITCH")

end 

-- DuoBao_XiuXi_DragTitle => TLBB_DragTitle
-- DuoBao_XiuXi_Help => TLBB_ButtonHelp
-- DuoBao_XiuXi_Frame_Client => DefaultWindow
-- DuoBao_XiuXi_MiniButton => TLBB_ButtonNULL
function DuoBao_XiuXi_OnLoad()
	g_DuoBao_XiuXi_Frame_UnifiedPosition = DuoBao_XiuXi_Frame:GetProperty("UnifiedPosition");
end

function DuoBao_XiuXi_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		DuoBao_XiuXi_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		DuoBao_XiuXi_On_ResetPos()
	elseif(event == "SCENE_TRANSED") then
		DuoBao_XiuXi_On_Hide()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 20240717 ) then
		local count = Get_XParam_INT( 0 )
		local tttime = Get_XParam_INT(1)
		local bday = Get_XParam_INT(2)
		DuoBao_XiuXi_Init(count,tttime,bday)
		if IsWindowShow("DuoBao_XiuXi_Mini") == false then
			this:Show()
		end
	elseif(event == "DUOBAO_XIUXI_SWITCH") then

		local opType = tonumber(arg0)
		if opType == 2 then
			this:Show()
		else
			this:Hide()	
		end
	end
end


function DuoBao_XiuXi_MiniButton_Clicked()

	PushEvent("DUOBAO_XIUXI_SWITCH",1)
end

function DuoBao_XiuXi_TimeOut()

end


function DuoBao_XiuXi_FormatRank(rank)
	local str = "#{DDDB_20240711_59}"
	local tab = 
	{
		[0] = "#{DDDB_20240711_59}",
		[1] = "#{DDDB_20240711_62}",
		[2] = "#{DDDB_20240711_63}",
		[3] = "#{DDDB_20240711_64}",
		[4] = "#{DDDB_20240711_65}",
	}

	if tab[rank] ~= nil then
		str = tab[rank]
	end

	DuoBao_XiuXi_Ranking2:SetText(str)

end
function DuoBao_XiuXi_Init(count,tttime,bday)
	DuoBao_XiuXi_TeamNUM2:SetText(count)
	local sec = Lua_GetDiffTime_InSecond_ServerTime(21,0,0)
	DuoBao_XiuXi_FinishTime2:Show()
	DuoBao_XiuXi_FinishTime2:SetProperty("Timer",sec)
	if tttime < 0 then
		DuoBao_XiuXi_StartTime2:Hide()
		DuoBao_XiuXi_StartTime2:SetProperty("Timer",0)
	else
		DuoBao_XiuXi_StartTime2:Show()
		DuoBao_XiuXi_StartTime2:SetProperty("Timer",tttime)
	end

	if bday == 0 then
		DuoBao_XiuXi_FinishTime2:Hide()
		DuoBao_XiuXi_FinishTime2:SetProperty("Timer",0)

		DuoBao_XiuXi_StartTime2:Hide()
		DuoBao_XiuXi_StartTime2:SetProperty("Timer",0)
	end




end

function DuoBao_XiuXi_On_ResetPos()
	DuoBao_XiuXi_Frame:SetProperty("UnifiedPosition", g_DuoBao_XiuXi_Frame_UnifiedPosition)
end

function DuoBao_XiuXi_OnHiden()

end
function DuoBao_XiuXi_On_Hide()
	
	this:Hide()
end

function DuoBao_XiuXi_Help_Click()
end

function DuoBao_XiuXi_MiniButton_Click()
end

