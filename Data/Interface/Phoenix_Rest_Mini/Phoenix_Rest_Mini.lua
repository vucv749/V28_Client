local g_Phoenix_Rest_Mini_Frame_UnifiedPosition = nil 

function Phoenix_Rest_Mini_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("TSPHEONIX_SWITCH")

end 

-- Phoenix_Rest_Mini => TLBB_ButtonNULL
function Phoenix_Rest_Mini_OnLoad()
	g_Phoenix_Rest_Mini_Frame_UnifiedPosition = Phoenix_Rest_Mini_Frame:GetProperty("UnifiedPosition");
end

function Phoenix_Rest_Mini_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Phoenix_Rest_Mini_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Phoenix_Rest_Mini_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Phoenix_Rest_Mini_On_Hide()
	elseif(event == "TSPHEONIX_SWITCH") then
		local opType = tonumber(arg0)
		local level = tonumber(arg1)
		if opType == 1 then

			if level == 1 then
				Phoenix_Rest_Mini_PageHeader:SetText("#{FHKF_20240315_50}")
			elseif level == 2 then
				Phoenix_Rest_Mini_PageHeader:SetText("#{FHKF_20240315_141}")
			
			else
				Phoenix_Rest_Mini_PageHeader:SetText("#{FHKF_20240315_187}")
			end
			this:Show()
		else
			this:Hide()
		end		
	end
end

function Phoenix_Rest_Mini_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Phoenix_Rest_Mini");
end

function Phoenix_Rest_Mini_On_ResetPos()
	Phoenix_Rest_Mini_Frame:SetProperty("UnifiedPosition", g_Phoenix_Rest_Mini_Frame_UnifiedPosition)
end

function Phoenix_Rest_Mini_On_Hide()
	this:Hide()
end

function Phoenix_Rest_Mini_Click()
end


function Phoenix_Rest_Mini_Open()
	PushEvent("TSPHEONIX_SWITCH", 2)
end
