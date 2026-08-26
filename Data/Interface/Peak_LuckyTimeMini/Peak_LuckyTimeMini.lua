

local g_Peak_LuckyTimeMini_op = 0;

function Peak_LuckyTimeMini_PreLoad()

	--离开场景，自动关睜
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)	
	this:RegisterEvent("PEAK_LUCKYTIME_SWITCH")
	this:RegisterEvent("UI_COMMAND")
end

function Peak_LuckyTimeMini_OnLoad()	

end

function Peak_LuckyTimeMini_OnEvent(event)

	if event == "PEAK_LUCKYTIME_SWITCH" then
		local opType = tonumber(arg0)
		g_Peak_LuckyTimeMini_op = opType
		if opType == 1 then
			this:Show()
			if(IsWindowShow("Peak_LuckyTime")) then
				CloseWindow("Peak_LuckyTime", true)
			end	

		elseif opType == 3 then
			this:Show()

			if(IsWindowShow("Peak_LuckyTime2")) then
				CloseWindow("Peak_LuckyTime2", true)
			end				
		else
			this:Hide()
		end
	elseif event == "PLAYER_LEAVE_WORLD" then
		this:Hide()	
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20250730 then	
		this:Hide()	
	end
end


function Peak_LuckyTimeMini_Open()
		if g_Peak_LuckyTimeMini_op == 1 then
			PushEvent("PEAK_LUCKYTIME_SWITCH", 2)
		elseif g_Peak_LuckyTimeMini_op == 3 then
			PushEvent("PEAK_LUCKYTIME_SWITCH", 4)
		end
end
