
function MenPaiFirstOne_Progress_Mini_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_XXS_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SHOW_DDZWAR_MINI");
end

function MenPaiFirstOne_Progress_Mini_OnLoad()
end

function MenPaiFirstOne_Progress_Mini_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SHOW_DDZWAR_MINI") then
		if arg0=="1" then
			this:Show()
		else
			this:Hide()
		end
	end
end

function MenPaiFirstOne_Progress_Mini_Open()
	this:Hide()
	PushEvent("SHOW_DDZWAR_MINI",0)
end

