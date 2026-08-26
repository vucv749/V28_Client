
local g_KunWu_Expedition_Popup_Frame_UnifiedPosition

function KunWu_Expedition_Popup_PreLoad()
	this:RegisterEvent("PET_DISPATCH_STARTPOP", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("ADJEST_UI_POS",false)
end

function KunWu_Expedition_Popup_OnLoad()
	g_KunWu_Expedition_Popup_Frame_UnifiedPosition = KunWu_Expedition_Popup_Frame:GetProperty("UnifiedPosition")

end

function KunWu_Expedition_Popup_OnEvent(event)
	if event == "PET_DISPATCH_STARTPOP" then
		this:Show()
		SetTimer("KunWu_Expedition_Popup","KunWu_Expedition_Popup_TimerProc()", 4000)
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		KunWu_Expedition_Popup_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		KunWu_Expedition_Popup_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		KunWu_Expedition_Popup_Close()
	
	end
	
end

function KunWu_Expedition_Popup_TimerProc()
	KunWu_Expedition_Popup_Close()
end


function KunWu_Expedition_Popup_Close()
	KillTimer("KunWu_Expedition_Popup_TimerProc()")
	this:Hide()
end

function KunWu_Expedition_Popup_On_ResetPos()
	KunWu_Expedition_Popup_Frame:SetProperty("UnifiedPosition", g_KunWu_Expedition_Popup_Frame_UnifiedPosition)
end



function KunWu_Expedition_Popup_OnHidden()
	
end