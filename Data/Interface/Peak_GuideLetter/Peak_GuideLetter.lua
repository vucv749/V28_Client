--2025áÛ·åÏµÍ³Òýµ¼ÈÎÎñ

local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function Peak_GuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function Peak_GuideLetter_OnLoad()

	g_Frame_UnifiedPosition = Peak_GuideLetter_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function Peak_GuideLetter_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 9998401 then

		local param = Get_XParam_INT(0)
		if param == 1 then
			--´ò¿ª½çÃæ
			this:Show()
		elseif param == 2 then
			--×Ô¶¯Ñ°Â·£º Ònpc
			Peak_GuideLetter_GoToFindNpc()
			--¹Ø± ½çÃæ
			Peak_GuideLetter_OnClose()			
		elseif param == 3 then
			--¹Ø± ½çÃæ
			Peak_GuideLetter_OnClose()
		elseif param == 4 then
			--´ò¿ªáÛ·åÏµÍ³µÄ½çÃæ
			TogglePeak()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		Peak_GuideLetter_OnClose()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Peak_GuideLetter_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Peak_GuideLetter_ResetPos()
	
	end

end

--µã»÷£ºÇ°ÍùserverÅÐ¶Ï£¬ÊÇ·ñ¿ÉÒÔÑ°Â· Ònpc
function Peak_GuideLetter_OnGoButtonClicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenUI");
		Set_XSCRIPT_ScriptID(999840);
		Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end

--ÏìÓ¦£ºÍ¨¹ýserverÅÐ¶Ï£¬¿ÉÒÔÑ°Â· Ònpc
function Peak_GuideLetter_GoToFindNpc()
	
	AutoRuntoTargetExWithName(219, 43, 2, "Huy«n Trí pháp sß") --??
	
end

--µ÷ û£º½çÃæÎ»ÖÃ
function Peak_GuideLetter_ResetPos()

	Peak_GuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--¹Ø± £º½çÃæ
function Peak_GuideLetter_OnClose()
	this:Hide()
end

