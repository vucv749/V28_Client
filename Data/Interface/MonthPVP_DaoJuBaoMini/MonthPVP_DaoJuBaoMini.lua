local g_MonthPVP_DaoJuBaoMini_Frame_UnifiedPosition

function MonthPVP_DaoJuBaoMini_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function MonthPVP_DaoJuBaoMini_OnLoad()
	g_MonthPVP_DaoJuBaoMini_Frame_UnifiedPosition = MonthPVP_DaoJuBaoMini_Frame:GetProperty("UnifiedPosition")
end

function MonthPVP_DaoJuBaoMini_OnEvent(event)

	if(event == "OPEN_WINDOW") then
		if( arg0 == "MonthPVP_DaoJuBaoMini") then
			this:Show()
		end
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "MonthPVP_DaoJuBaoMini") then
			this:Hide()
		end	
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD"  then
		MonthPVP_DaoJuBaoMini_OnHidden()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			MonthPVP_DaoJuBaoMini_ResetPos()
        end
	end

end

function MonthPVP_DaoJuBaoMini_ResetPos()
    MonthPVP_DaoJuBaoMini_Frame:SetProperty("UnifiedPosition", g_MonthPVP_DaoJuBaoMini_Frame_UnifiedPosition)
end

function MonthPVP_DaoJuBaoMini_OnHidden()
	this:Hide()
end

function MonthPVP_DaoJuBaoMini_OnClose()
	OpenWindow("MonthPVP_DaoJuBao")
	this:Hide()
end