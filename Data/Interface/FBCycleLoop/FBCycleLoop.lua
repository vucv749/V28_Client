--******************************************
--—„√≈¬€Œ‰≥¨Ãÿ∑˛‘¬≥£ΩÁ√Ê
--create by  limengyue 
--2025-10-21
--******************************************

local g_FBCycleLoop_Frame_UnifiedPosition;

--=========================================================
--PreLoad
--=========================================================
function FBCycleLoop_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--æ‡¿ÎNPCæ‡¿Î
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--«–≥°æ∞ ¬º˛
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function FBCycleLoop_OnLoad()
	g_FBCycleLoop_Frame_UnifiedPosition	= FBCycleLoop_Frame : GetProperty("UnifiedPosition");
end

--=========================================================
--ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--=========================================================
function FBCycleLoop_On_ResetPos()
	FBCycleLoop_Frame : SetProperty("UnifiedPosition", g_FBCycleLoop_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function FBCycleLoop_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89313001 ) then
		--¥Úø™ΩÁ√Ê
		if(IsWindowShow("FBCycleLoop")) then
			CloseWindow("FBCycleLoop", true)
		end
		FBCycleLoop_Open()
	end
	-- ¥∞ø⁄±‰ªØ
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	elseif (event == "ADJEST_UI_POS" ) then
		FBCycleLoop_On_ResetPos();
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		FBCycleLoop_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       FBCycleLoop_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--¥Úø™ΩÁ√Ê
--=========================================================
function FBCycleLoop_Open()
	--÷±Ω”œ‘ ææÕ––¡À
	this:Show()

end
--=========================================================
--πÿ±†ΩÁ√Ê
--=========================================================
function FBCycleLoop_OnClosed()
	this:Hide()
end

--=========================================================
--—∞¬∑
--=========================================================
function FBCycleLoop_Goto(nIndex)
	if nIndex == 1 then
		--—„√≈¬€Œ‰
		AutoRuntoTargetExWithName(59, 95, 0, "M’nh S§m")
	else
		AutoRuntoTargetExWithName(193, 144, 1, "Xung Sﬂ –’o")
	end
end

--=========================================================
--∞Ô÷˙
--=========================================================
function FBCycleLoop_HelpClick()
	PushEvent("QUEST_HELPINFO", "#{CTYM_251020_06}")
end
