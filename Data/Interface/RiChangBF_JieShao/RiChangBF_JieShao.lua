local g_RiChangBF_JieShao_Frame_UnifiedPosition

function RiChangBF_JieShao_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function RiChangBF_JieShao_OnLoad()
	g_RiChangBF_JieShao_Frame_UnifiedPosition = RiChangBF_JieShao_Frame:GetProperty("UnifiedPosition")
end

function RiChangBF_JieShao_OnEvent(event)

	if(event == "OPEN_WINDOW") then
		if( arg0 == "RiChangBF_JieShao") then
			this:Show()
		end
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "RiChangBF_JieShao") then
			this:Hide()
		end	
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD"  then
		RiChangBF_JieShao_OnClose()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			RiChangBF_JieShao_ResetPos()
        end
	end

end

function RiChangBF_JieShao_ResetPos()
    RiChangBF_JieShao_Frame:SetProperty("UnifiedPosition", g_RiChangBF_JieShao_Frame_UnifiedPosition)
end

function RiChangBF_JieShao_OnHidden()
	this:Hide()
end

function RiChangBF_JieShao_OnClose()
	this:Hide()
end