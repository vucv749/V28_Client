
local g_unifiedposistion
local g_NewPvpTime_Mini_SceneId = 0
local g_NewPvpTime_Mini_opType = {
	close = 1000,					-- ¹Ø±ÕUI
}
local g_scene_res_ids={[673]=1,[674]=1,[675]=1,[655]=1,[656]=1,[657]=1}

function NewPvpTime_Mini_PreLoad()
	this:RegisterEvent("OPEN_NEWPVPTIME_MINI")
	this:RegisterEvent("UI_COMMAND", false)
	this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)	
end

function NewPvpTime_Mini_OnLoad()	
	g_unifiedposistion = NewPvpTime_Mini_Frame:GetProperty("UnifiedPosition")
end

function NewPvpTime_Mini_OnEvent(event)
	if event == "OPEN_NEWPVPTIME_MINI" then
		this:Show()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89029501 then
		local opType =  Get_XParam_INT( 0 )
		if opType == g_NewPvpTime_Mini_opType.close then
			this:Hide()
		end
	elseif event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
	elseif event == "ADJEST_UI_POS" then
		NewPvpTime_Mini_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NewPvpTime_Mini_ResetPos()
	end
end

function NewPvpTime_Mini_ResetPos()
	NewPvpTime_Mini_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function NewPvpTime_Mini_Open()
	if g_scene_res_ids[GetSceneID()]==1 then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenFlashUI")
		Set_XSCRIPT_ScriptID(890295)
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
end