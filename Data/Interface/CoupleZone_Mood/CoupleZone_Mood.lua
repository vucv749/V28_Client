--UI
local g_CoupleZone_Mood_UI_Button_OK = ""

--UI Editable
local g_CoupleZone_Mood_UI_NoteEditText = ""

--×î´ó×ÖÊý
local g_CoupleZone_Mood_MaxLength = 30

local g_CoupleZone_Mood_IsDebug = 0

--!!!reloadscript =CoupleZone_Mood

function CoupleZone_Mood_Debug(str)
	if g_CoupleZone_Mood_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_Mood_Debug : "..str)
	end	
end

function CoupleZone_Mood_PreLoad()
	this:RegisterEvent("OPEN_COUPLEZONE_WRITENOTE")
end

function CoupleZone_Mood_OnLoad()

	g_CoupleZone_Mood_UI_NoteEditText = CoupleZone_Mood_Edit
	g_CoupleZone_Mood_UI_Button_OK = CoupleZone_Mood_OK

end

function CoupleZone_Mood_OnEvent(event)
	
	if ( event == "OPEN_COUPLEZONE_WRITENOTE" ) then
		CoupleZone_Mood_OnShow();
	end

end

function CoupleZone_Mood_OnShow()
	CoupleZone_Mood_Debug("CoupleZone_Mood_OnShow")
	this:Show()
	g_CoupleZone_Mood_UI_NoteEditText:SetProperty("MaxTextLength",g_CoupleZone_Mood_MaxLength)
	g_CoupleZone_Mood_UI_NoteEditText:SetText("")
	g_CoupleZone_Mood_UI_NoteEditText:SetProperty("DefaultEditBox", "True")

end

function CoupleZone_Mood_CheckState(checktype)
	local text = g_CoupleZone_Mood_UI_NoteEditText:GetText();
	if( nil == text or "" == text ) then 
		g_CoupleZone_Mood_UI_Button_OK:Disable();
	else
		g_CoupleZone_Mood_UI_Button_OK:Enable();
	end
	
	if checktype == 1 then
		if(string.len(text) >= g_CoupleZone_Mood_MaxLength ) then
			PushDebugMessage("#{QLKJ_230331_23}")
			return 0
		end
	else
		if(string.len(text) > g_CoupleZone_Mood_MaxLength ) then
			PushDebugMessage("#{QLKJ_230331_23}")
			return 0
		end
	end
	
	
	return 1
end

function CoupleZone_Mood_OnClicked_Emoji()
	CoupleZone_Mood_Debug("CoupleZone_Mood_OnClicked_Emoji")
	Talk:SelectFaceMotion("select", g_CoupleZone_Mood_UI_NoteEditText:GetProperty("AbsoluteXPosition"));
	--PushEvent("CHAT_FACEMOTION_SELECT", "select");
end

function CoupleZone_Mood_OnClicked_OK()
	CoupleZone_Mood_Debug("CoupleZone_Mood_OnClicked_OK")

	local calendarText = g_CoupleZone_Mood_UI_NoteEditText:GetText()

	if calendarText == "" then
		PushDebugMessage("#{QLKJ_230331_25}")  --?????????
	end
	
	if CoupleZone_Mood_CheckState(2) ~= 1 then
		return
	end

	if(CoupleZone:LuaFnWriteNewCalendar(calendarText) > 0) then
		CoupleZone_Mood_OnClose()
	end
end

function CoupleZone_Mood_OnClose()
	CoupleZone_Mood_Debug("CoupleZone_Mood_OnClose")
	CoupleZone_Mood_Clear()
	CoupleZone_Mood_OnHidden()
end

function CoupleZone_Mood_Clear()
	CoupleZone_Mood_Debug("CoupleZone_Mood_Clear")
end

function CoupleZone_Mood_OnHidden()
--	CoupleZone_Mood_Debug("CoupleZone_Mood_OnHidden")
	this:Hide()
end
