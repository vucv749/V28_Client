local g_Phoenix_Entering_UnifiedPosition = nil 

function Phoenix_Entering_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

end 

-- Phoenix_Entering_Animate2 => TLBB_Animate
-- Phoenix_Entering_Animate3 => TLBB_Animate
function Phoenix_Entering_OnLoad()
	g_Phoenix_Entering_UnifiedPosition = Phoenix_Entering:GetProperty("UnifiedPosition");
end

function Phoenix_Entering_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Phoenix_Entering_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Phoenix_Entering_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Phoenix_Entering_On_Hide()
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 20240426 ) then
		
		local opType = Get_XParam_INT( 0 )

		if opType == 0 then
			this:Hide()
		else
			local raidnum = Get_XParam_INT( 1 )
			if raidnum < 4 then
				Phoenix_Entering_Animate2:Show()
				Phoenix_Entering_Animate3:Hide()

			elseif raidnum >= 4 then
				Phoenix_Entering_Animate2:Hide()
				Phoenix_Entering_Animate3:Show()

			end
			this:Show()
		end
	end
end

function Phoenix_Entering_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Phoenix");
end

function Phoenix_Entering_On_ResetPos()
	Phoenix_Entering:SetProperty("UnifiedPosition", g_Phoenix_Entering_UnifiedPosition)
end

function Phoenix_Entering_On_Hide()
	this:Hide()
end

