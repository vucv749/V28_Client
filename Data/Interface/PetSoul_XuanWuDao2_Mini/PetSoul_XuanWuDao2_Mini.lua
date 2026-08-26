--2025兽穴PVP活动

function PetSoul_XuanWuDao2_Mini_PreLoad()
	
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SHOW_PETSOULWAR2_MINI");
	
end

function PetSoul_XuanWuDao2_Mini_OnLoad()
end

function PetSoul_XuanWuDao2_Mini_OnEvent(event)

	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
		
	elseif (event=="SHOW_PETSOULWAR2_MINI") then
		if arg0 == "1" then
			this:Show()
		else
			this:Hide()
		end
		
	elseif (event  == "UI_COMMAND") and (tonumber(arg0) == 89334201) then
	
		if Get_XParam_INT(0) <= 0 then
			this:Hide()
			return
		end
		
	end
end

function PetSoul_XuanWuDao2_Mini_Open()

	this:Hide()
	PushEvent("SHOW_PETSOULWAR2_MINI", 0)
	
end

