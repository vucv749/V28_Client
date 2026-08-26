local g_Frozen_BXJR_SD_BK_UnifiedPosition = nil 

function Frozen_BXJR_SD_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("UI_COMMAND")

end 

-- Frozen_BXJR_SD_Frame_Right2 => TLBB_StaticImageNULL(2249)
-- Frozen_BXJR_SD_Frame1 => DefaultWindow
function Frozen_BXJR_SD_OnLoad()
	g_Frozen_BXJR_SD_BK_UnifiedPosition = Frozen_BXJR_SD_Frame:GetProperty("UnifiedPosition");
end

function Frozen_BXJR_SD_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Frozen_BXJR_SD_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Frozen_BXJR_SD_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Frozen_BXJR_SD_OnHide()
	elseif(event == "UI_COMMAND") then
		local commandIndex = tonumber(arg0)
		if commandIndex == 20241225 then
			Frozen_BXJR_SD_Show()
		end
	end
end



function Frozen_BXJR_SD_On_ResetPos()
	Frozen_BXJR_SD_Frame:SetProperty("UnifiedPosition", g_Frozen_BXJR_SD_Frame_UnifiedPosition)
end

function Frozen_BXJR_SD_OnHide()
	this:Hide()
end


function Frozen_BXJR_SD_Show()

	Frozen_BXJR_SD_Text:SetText("#{BXJR_240913_82}")

	this:Show()
end
function Frozen_BXJR_SD_Goto()
	local nServerDay = tonumber(DataPool:GetServerDayTime())
	local nServerTime = tonumber(DataPool:GetServerMinuteTime())
	if nServerDay ~= 20241225 then
		PushDebugMessage("#{BXJR_240913_9}")
		return
	else
		if nServerTime < 200000 or nServerTime > 210000 then
			PushDebugMessage("#{BXJR_240913_9}")
			return
		end
	end


	if DataPool:Lua_IsMissionHaveDone(2332) > 0 then
		PushDebugMessage("#{BXJR_240913_58}")
		return
	end
	local nLevel = Player:GetLevel();
	if nLevel < 30 then
		PushDebugMessage("#{BXJR_240913_10}")
		return
	end

	PushDebugMessage("#{BXJR_240913_86}")

end


function Frozen_BXJR_SD_ShowHelp()

		PushEvent("QUEST_HELPINFO","#{BXJR_240913_8}")

	
end
