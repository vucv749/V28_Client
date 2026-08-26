local g_Frozen_GeCao_Goto_Frame_UnifiedXPosition
local g_Frozen_GeCao_Goto_Frame_UnifiedYPosition

local g_Rand_MainCity =
{
	[1] = {PosX = 143, PosZ = 198, Scene = 728, Name = "H° Bång Phong"},
}

--Ô¤¼ÓÔØº¯Êı£¬¿ÉÒÔ¶øÇÒÖ»ÄÜÔÚ âÀï×¢²á½Å±¾¹ØĞÄµÄÊÂ¼ş
function Frozen_GeCao_Goto_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--¼ÓÔØ´°¿ÚµÄÊ±ºòµ÷ÓÃµÄº¯Êı£¬¼ÓÔØ´°¿ÚÊ±µ÷ÓÃÒ»´Î
function Frozen_GeCao_Goto_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Frozen_GeCao_Goto_Frame_UnifiedXPosition	= Frozen_GeCao_Goto_Frame:GetProperty("UnifiedXPosition");
	g_Frozen_GeCao_Goto_Frame_UnifiedYPosition	= Frozen_GeCao_Goto_Frame:GetProperty("UnifiedYPosition");

end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Frozen_GeCao_Goto_ResetPos()
	Frozen_GeCao_Goto_Frame:SetProperty("UnifiedXPosition", g_Frozen_GeCao_Goto_Frame_UnifiedXPosition);
	Frozen_GeCao_Goto_Frame:SetProperty("UnifiedYPosition", g_Frozen_GeCao_Goto_Frame_UnifiedYPosition);
end


--ÏìÓ¦ÊÂ¼şµÄº¯Êı£¬µ±×¢²áµÄÊÂ¼ş·¢ÉúÊ±»áµ÷ÓÃµÄº¯Êı
function Frozen_GeCao_Goto_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 82004101 then
		--´ò¿ª½çÃæ
		Frozen_GeCao_Goto_Show()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 82004102 then
		--Ç°ÍùÑ°Â·
		local RandVal = 1
		AutoRuntoTargetExWithName(g_Rand_MainCity[RandVal].PosX,g_Rand_MainCity[RandVal].PosZ,g_Rand_MainCity[RandVal].Scene,g_Rand_MainCity[RandVal].Name)
		Frozen_GeCao_Goto_OnHide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Frozen_GeCao_Goto_OnHide()
	elseif event == "ADJEST_UI_POS" then
		Frozen_GeCao_Goto_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Frozen_GeCao_Goto_ResetPos()
	end
end

--ÏÔÊ¾UI
function Frozen_GeCao_Goto_Show()

	this:Show()
end

--Òş²ØUI
function Frozen_GeCao_Goto_OnHide()
	this:Hide()
end


function Frozen_GeCao_Goto_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("Help")
		Set_XSCRIPT_ScriptID(820041)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function Frozen_GeCao_Goto_Goto()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GOTO")
		Set_XSCRIPT_ScriptID(820041)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


