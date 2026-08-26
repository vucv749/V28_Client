local g_MonthPVP_Goto_Frame_UnifiedXPosition
local g_MonthPVP_Goto_Frame_UnifiedYPosition

local g_Rand_MainCity =
{
	[1] = {PosX = 172, PosZ = 115, Scene = 0, Name = "Cây nho Ti¬u T±"}, --??
}

--Ô¤¼ÓÔØº¯Êı£¬¿ÉÒÔ¶øÇÒÖ»ÄÜÔÚ âÀï×¢²á½Å±¾¹ØĞÄµÄÊÂ¼ş
function MonthPVP_Goto_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--¼ÓÔØ´°¿ÚµÄÊ±ºòµ÷ÓÃµÄº¯Êı£¬¼ÓÔØ´°¿ÚÊ±µ÷ÓÃÒ»´Î
function MonthPVP_Goto_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_MonthPVP_Goto_Frame_UnifiedXPosition	= MonthPVP_Goto_Frame:GetProperty("UnifiedXPosition");
	g_MonthPVP_Goto_Frame_UnifiedYPosition	= MonthPVP_Goto_Frame:GetProperty("UnifiedYPosition");

end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function MonthPVP_Goto_ResetPos()
	MonthPVP_Goto_Frame:SetProperty("UnifiedXPosition", g_MonthPVP_Goto_Frame_UnifiedXPosition);
	MonthPVP_Goto_Frame:SetProperty("UnifiedYPosition", g_MonthPVP_Goto_Frame_UnifiedYPosition);
end


--ÏìÓ¦ÊÂ¼şµÄº¯Êı£¬µ±×¢²áµÄÊÂ¼ş·¢ÉúÊ±»áµ÷ÓÃµÄº¯Êı
function MonthPVP_Goto_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 82002301 then
		--´ò¿ª½çÃæ
		MonthPVP_Goto_Show()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 82002302 then
		--Ç°ÍùÑ°Â·
		local RandVal = 1
		AutoRuntoTargetExWithName(g_Rand_MainCity[RandVal].PosX,g_Rand_MainCity[RandVal].PosZ,g_Rand_MainCity[RandVal].Scene,g_Rand_MainCity[RandVal].Name)
		MonthPVP_Goto_OnHide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		MonthPVP_Goto_OnHide()
	elseif event == "ADJEST_UI_POS" then
		MonthPVP_Goto_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		MonthPVP_Goto_ResetPos()
	end
end

--ÏÔÊ¾UI
function MonthPVP_Goto_Show()

	this:Show()
end

--Òş²ØUI
function MonthPVP_Goto_OnHide()
	this:Hide()
end

--¹Ø± ½çÃæ
function MonthPVP_Goto_Hide()
	this:Hide()
end


function MonthPVP_Goto_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Help")
		Set_XSCRIPT_ScriptID(820023)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function MonthPVP_Goto_Goto()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GOTO")
		Set_XSCRIPT_ScriptID(820023)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


