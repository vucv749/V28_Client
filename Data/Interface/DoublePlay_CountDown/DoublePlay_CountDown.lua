

function DoublePlay_CountDown_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function DoublePlay_CountDown_OnLoad()
	
end

function DoublePlay_CountDown_OnEvent(event)
	if (event=="SCENE_TRANSED") or (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			DoublePlay_CountDown_Hide()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99829704) then
		this:Show()
		DoublePlay_CountDown_Animate:Play(true)
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99829705) then
		if( this:IsVisible() ) then
			DoublePlay_CountDown_Hide()
		end	
	end
end

function DoublePlay_CountDown_Hide()
	this:Hide()
end
