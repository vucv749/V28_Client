local g_CoupleZone_RecordDiary_Frame_UnifiedXPosition = 0
local g_CoupleZone_RecordDiary_Frame_UnifiedYPosition = 0

--UI
local g_CoupleZone_RecordDiary_UI_Button_OK = ""

--UI Editable
local g_CoupleZone_RecordDiary_UI_NoteEditText = ""
local g_CoupleZone_RecordDiary_UI_CurCountText = ""

--最大字数
local g_CoupleZone_RecordDiary_MaxLength = 120

local g_CoupleZone_RecordDiary_IsDebug = 0

--!!!reloadscript =CoupleZone_RecordDiary

function CoupleZone_RecordDiary_Debug(str)
	if g_CoupleZone_RecordDiary_IsDebug == 1 then
		PushDebugMessage(str)
		Lua_TDU_Log("CoupleZone_RecordDiary_Debug : "..str)
	end	
end

function CoupleZone_RecordDiary_PreLoad()
	this:RegisterEvent("OPEN_COUPLEZONE_WRITEDIARY")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function CoupleZone_RecordDiary_OnLoad()

	g_CoupleZone_RecordDiary_UI_NoteEditText = CoupleZone_RecordDiary_Edit
	g_CoupleZone_RecordDiary_UI_Button_OK = CoupleZone_RecordDiary_OK
	g_CoupleZone_RecordDiary_UI_CurCountText = CoupleZone_RecordDiary_EditText
	
	g_CoupleZone_RecordDiary_Frame_UnifiedXPosition = CoupleZone_RecordDiary_Frame:GetProperty("UnifiedXPosition")
	g_CoupleZone_RecordDiary_Frame_UnifiedYPosition = CoupleZone_RecordDiary_Frame:GetProperty("UnifiedYPosition")	

end

function CoupleZone_RecordDiary_OnEvent(event)
	
	if ( event == "OPEN_COUPLEZONE_WRITEDIARY" ) then
		CoupleZone_RecordDiary_OnShow();
	end

	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		CoupleZone_RecordDiary_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CoupleZone_RecordDiary_Frame_On_ResetPos()
		--切场景
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		CoupleZone_RecordDiary_OnClose()
	end	
end

function CoupleZone_RecordDiary_OnShow()
	CoupleZone_RecordDiary_Debug("CoupleZone_RecordDiary_OnShow")
	this:Show()
	g_CoupleZone_RecordDiary_UI_NoteEditText:SetProperty("MaxTextLength",g_CoupleZone_RecordDiary_MaxLength)
	g_CoupleZone_RecordDiary_UI_NoteEditText:SetText("")
	g_CoupleZone_RecordDiary_UI_CurCountText:SetText(ScriptGlobal_Format("#{QLKJ_230331_98}", 0)	)
	g_CoupleZone_RecordDiary_UI_NoteEditText:SetProperty("DefaultEditBox", "True")

end

function CoupleZone_RecordDiary_CheckState(checktype)
	local text = g_CoupleZone_RecordDiary_UI_NoteEditText:GetText();
	if( nil == text or "" == text ) then 
		g_CoupleZone_RecordDiary_UI_Button_OK:Disable();
	else
		g_CoupleZone_RecordDiary_UI_Button_OK:Enable();
	end
	
	
	local lengthtip = ScriptGlobal_Format("#{QLKJ_230331_98}", math.floor(string.len(text)/2))	
	g_CoupleZone_RecordDiary_UI_CurCountText:SetText(lengthtip)
	
	if checktype == 1 then
		if(string.len(text) >= g_CoupleZone_RecordDiary_MaxLength ) then
			PushDebugMessage("#{QLKJ_230331_23}")
			return 0
		end
	else
		if(string.len(text) > g_CoupleZone_RecordDiary_MaxLength ) then
			PushDebugMessage("#{QLKJ_230331_23}")
			return 0
		end
	end
	
	
	return 1
end

function CoupleZone_RecordDiary_OnClicked_Emoji()
	CoupleZone_RecordDiary_Debug("CoupleZone_RecordDiary_OnClicked_Emoji")
	Talk:SelectFaceMotion("select", g_CoupleZone_RecordDiary_UI_NoteEditText:GetProperty("AbsoluteXPosition"));
	--PushEvent("CHAT_FACEMOTION_SELECT", "select");
end

function CoupleZone_RecordDiary_OnClicked_OK()
	CoupleZone_RecordDiary_Debug("CoupleZone_RecordDiary_OnClicked_OK")

	local diaryText = g_CoupleZone_RecordDiary_UI_NoteEditText:GetText()

	if diaryText == "" then
		PushDebugMessage("#{QLKJ_230331_25}")  --记录内容不能为空。
	end
	
	if CoupleZone_RecordDiary_CheckState(2) ~= 1 then
		return
	end

	if(CoupleZone:LuaFnWriteNewDiary(diaryText) > 0) then
		CoupleZone_RecordDiary_OnClose()
	end
end

function CoupleZone_RecordDiary_OnClose()
	CoupleZone_RecordDiary_Debug("CoupleZone_RecordDiary_OnClose")
	CoupleZone_RecordDiary_Clear()
	CoupleZone_RecordDiary_OnHidden()
end

function CoupleZone_RecordDiary_Clear()
	CoupleZone_RecordDiary_Debug("CoupleZone_RecordDiary_Clear")
end

function CoupleZone_RecordDiary_OnHidden()
--	CoupleZone_RecordDiary_Debug("CoupleZone_RecordDiary_OnHidden")
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function CoupleZone_RecordDiary_Frame_On_ResetPos()
	CoupleZone_RecordDiary_Frame : SetProperty("UnifiedXPosition", g_CoupleZone_RecordDiary_Frame_UnifiedXPosition);
	CoupleZone_RecordDiary_Frame : SetProperty("UnifiedYPosition", g_CoupleZone_RecordDiary_Frame_UnifiedYPosition);
end
