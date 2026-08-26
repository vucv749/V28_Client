local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function Peak_WarmUp_Letter_PreLoad()

	this:RegisterEvent("UI_COMMAND")--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function Peak_WarmUp_Letter_OnLoad()
	g_Frame_UnifiedPosition = Peak_WarmUp_Letter_Frame:GetProperty("UnifiedPosition")
end

--=========
-- Event
--=========
function Peak_WarmUp_Letter_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99990901 ) then

		this:Show()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Peak_WarmUp_Letter_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Peak_WarmUp_Letter_On_ResetPos()
    end

end


function Peak_WarmUp_Letter_On_ResetPos()
	Peak_WarmUp_Letter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end


function  Peak_WarmUp_Letter_OnGoButtonClicked()
	AutoRuntoTargetExWithName(179, 170, 18, "阿紫")
end


function  Peak_WarmUp_Letter_OnClose()
	this:Hide()
end