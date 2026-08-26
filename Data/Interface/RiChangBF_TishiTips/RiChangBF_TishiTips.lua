local g_RiChangBF_TishiTips_Frame_UnifiedPosition

function RiChangBF_TishiTips_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end


function RiChangBF_TishiTips_OnLoad()
	g_RiChangBF_TishiTips_Frame_UnifiedPosition = RiChangBF_TishiTips_Frame:GetProperty("UnifiedPosition")
end


function RiChangBF_TishiTips_OnEvent(event)

	--打开界面
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99880613) then
		if(not this:IsVisible() ) then
			this:Show()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99880614)   then
		if( this:IsVisible() ) then
			RiChangBF_TishiTips_CleanUp()	
			this:Hide()
		end
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD"  then
		RiChangBF_TishiTips_CloseClicked()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			RiChangBF_TishiTips_ResetPos()
        end
	end
	
end

function RiChangBF_TishiTips_CloseClicked()
	RiChangBF_TishiTips_CleanUp()	
	this:Hide()
end

function RiChangBF_TishiTips_ResetPos()
    RiChangBF_TishiTips_Frame:SetProperty("UnifiedPosition", g_RiChangBF_TishiTips_Frame_UnifiedPosition)
end

function RiChangBF_TishiTips_CleanUp()	

end