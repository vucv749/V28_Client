
function SongliaoWarDaojishi_Mini_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_XXS_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function SongliaoWarDaojishi_Mini_OnLoad()
end

function SongliaoWarDaojishi_Mini_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SONGLIAOSINGLE_XXS_MINI") then
		
		if arg0=="0" then
			this:Show()
		else
			this:Hide()
		end
	end
end

function SongliaoWarDaojishi_Mini_Open()
	this:Hide()
	PushEvent("SONGLIAOSINGLE_XXS_MINI",1)
end

