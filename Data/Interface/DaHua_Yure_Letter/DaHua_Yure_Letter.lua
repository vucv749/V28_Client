
local g_DaHua_Yure_Letter_Frame_UnifiedPosition


function DaHua_Yure_Letter_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)
end

function DaHua_Yure_Letter_OnLoad()
	g_DaHua_Yure_Letter_Frame_UnifiedPosition = DaHua_Yure_Letter_Frame:GetProperty("UnifiedPosition")

end

function DaHua_Yure_Letter_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2024062602 then
		this:Show()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		DaHua_Yure_Letter_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		DaHua_Yure_Letter_OnClose()
	elseif event == "ADJEST_UI_POS" then
		DaHua_Yure_Letter_On_ResetPos()
	end
end


function DaHua_Yure_Letter_OnGoButtonClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGuideGoto")
		Set_XSCRIPT_ScriptID(999406)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function DaHua_Yure_Letter_OnClose()
	this:Hide()
end

function DaHua_Yure_Letter_On_ResetPos()
	DaHua_Yure_Letter_Frame:SetProperty("UnifiedPosition", g_DaHua_Yure_Letter_Frame_UnifiedPosition)

end
