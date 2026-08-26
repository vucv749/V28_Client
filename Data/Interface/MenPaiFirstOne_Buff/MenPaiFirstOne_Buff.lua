local g_MenPaiFirstOne_baoji_Buff = 4892
  
function MenPaiFirstOne_Buff_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_XXS_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND");
end

function MenPaiFirstOne_Buff_OnLoad()
end

function MenPaiFirstOne_Buff_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			KillTimer("MenPaiFirstOne_Buff_Timer()")
			this:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 202205010 ) then
		this:Show()
		SetTimer("MenPaiFirstOne_Buff", "MenPaiFirstOne_Buff_Timer()", 1000)
	end
end

function MenPaiFirstOne_Buff_Timer()
	local isChalView = DataPool:IfHaveBuffByID(g_MenPaiFirstOne_baoji_Buff)
	if isChalView == 1 then
		return
	end

	KillTimer("MenPaiFirstOne_Buff_Timer()")
	this:Hide()
end

