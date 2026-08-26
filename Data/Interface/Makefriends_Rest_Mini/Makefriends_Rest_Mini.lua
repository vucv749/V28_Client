local Makefriends_Rest_Mini_UnifiedPosition = nil
function Makefriends_Rest_Mini_PreLoad()
	this:RegisterEvent("SOCIALACTIVITYES_REST_XXS_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS",false)

	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function Makefriends_Rest_Mini_OnLoad()
	Makefriends_Rest_Mini_UnifiedPosition = Makefriends_Rest_Mini_Frame:GetProperty("UnifiedPosition")
end

function Makefriends_Rest_Mini_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Makefriends_Rest_Mini_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_Rest_Mini_ResetPos()
	elseif (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SOCIALACTIVITYES_REST_XXS_MINI") then
		
		if arg0=="0" then
			this:Show()
		else
			this:Hide()
		end
	end
end

function Makefriends_Rest_Mini_Open()
	this:Hide()
	PushEvent("SOCIALACTIVITYES_REST_XXS_MINI",1)
end


function Makefriends_Rest_Mini_ResetPos()

	if (Makefriends_Rest_Mini_UnifiedPosition ~= nil) then
		Makefriends_Rest_Mini_Frame:SetProperty("UnifiedPosition", Makefriends_Rest_Mini_UnifiedPosition)
	end

end