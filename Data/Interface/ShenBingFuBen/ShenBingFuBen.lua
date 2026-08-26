local g_ShenBingFuBen_UnifiedPosition

function ShenBingFuBen_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

end


function ShenBingFuBen_OnLoad()
	g_ShenBingFuBen_UnifiedPosition = ShenBingFuBen:GetProperty("UnifiedPosition")
end


function ShenBingFuBen_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99848002) then
		
		local nParam = Get_XParam_INT(0) --Right
		if nParam == 0 then
			ShenBingFuBen_MengYanTime:Hide();
			this:Hide();
		else
			ShenBingFuBen_MengYanTime:Show();
			this:Show();
		end
	elseif event=="HIDE_ON_SCENE_TRANSED"  then
		this:Hide()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			ShenBingFuBen_ResetPos()
        end
	end
	
end

function ShenBingFuBen_ResetPos()
	ShenBingFuBen:SetProperty("UnifiedPosition", g_ShenBingFuBen_UnifiedPosition)
end