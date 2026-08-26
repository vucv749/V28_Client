local g_DaHua_Goto_Frame_UnifiedXPosition
local g_DaHua_Goto_Frame_UnifiedYPosition


local g_Rand_MainCity =
{
	[1] = {PosX = 142, PosZ = 82, Scene = 700, Name = "Ngßu H°ng H°ng"}, --???
	[2] = {PosX = 163, PosZ = 150, Scene = 701, Name = "Tôn Ti¬u Võ"}, --???
	[3] = {PosX = 123, PosZ = 152, Scene = 702, Name = "Lý Thiên Quân"}, --shiji
}

local g_UI_Info = {
	[1] = {title="#{QXPVE_240522_7}",info="#{QXPVE_240522_8}",tips="#{QXPVE_240522_127}"},
	[2] = {title="#{QXPVE_240522_133}",info="#{QXPVE_240522_9}",tips="#{QXPVE_240522_128}"},
	[3] = {title="#{QXPVE_240522_134}",info="#{QXPVE_240522_10}",tips="#{QXPVE_240522_129}"},
}
local g_StageImage = {
	[1] = "set:DaHua_PvE image:DaHua_PVE",
	[2] = "set:DaHua_PvE image:DaHua_PVE2",
	[3] = "set:DaHua_PvE2 image:DaHua_PVE3",
}
--Ô¤¼ÓÔØº¯Êý£¬¿ÉÒÔ¶øÇÒÖ»ÄÜÔÚ âÀï×¢²á½Å±¾¹ØÐÄµÄÊÂ¼þ
function DaHua_Goto_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

end

--¼ÓÔØ´°¿ÚµÄÊ±ºòµ÷ÓÃµÄº¯Êý£¬¼ÓÔØ´°¿ÚÊ±µ÷ÓÃÒ»´Î
function DaHua_Goto_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_DaHua_Goto_Frame_UnifiedXPosition	= DaHua_Goto_Frame:GetProperty("UnifiedXPosition");
	g_DaHua_Goto_Frame_UnifiedYPosition	= DaHua_Goto_Frame:GetProperty("UnifiedYPosition");

end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function DaHua_Goto_ResetPos()
	DaHua_Goto_Frame:SetProperty("UnifiedXPosition", g_DaHua_Goto_Frame_UnifiedXPosition);
	DaHua_Goto_Frame:SetProperty("UnifiedYPosition", g_DaHua_Goto_Frame_UnifiedYPosition);
end


--ÏìÓ¦ÊÂ¼þµÄº¯Êý£¬µ±×¢²áµÄÊÂ¼þ·¢ÉúÊ±»áµ÷ÓÃµÄº¯Êý
function DaHua_Goto_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 05112804 then
		local opType =  Get_XParam_INT( 0 )
		if opType == 10 then
			--Ç°ÍùÑ°Â·
			local stage = Get_XParam_INT( 1 )
			if g_Rand_MainCity[stage] then
			--	PushDebugMessage(ScriptGlobal_Format("#{QXPVE_240522_14}",g_Rand_MainCity[stage].Name))
				AutoRuntoTargetExWithName(g_Rand_MainCity[stage].PosX,g_Rand_MainCity[stage].PosZ,g_Rand_MainCity[stage].Scene,g_Rand_MainCity[stage].Name)
			end
			DaHua_Goto_OnHide()
		elseif opType == 1 then
			local stage = Get_XParam_INT( 1 )
			DaHua_Goto_Show(stage)
		end
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		DaHua_Goto_OnHide()
	elseif event == "ADJEST_UI_POS" then
		DaHua_Goto_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		DaHua_Goto_ResetPos()
	end
end

--ÏÔÊ¾UI
function DaHua_Goto_Show(stage)
	if g_UI_Info[stage] then
		DaHua_Goto_DragTitle:SetText(g_UI_Info[stage].title)
		DaHua_Goto_Text:SetText(g_UI_Info[stage].info)
		DaHua_Goto_GoBtn:SetToolTip(ScriptGlobal_Format("#{QXPVE_240522_11}",g_UI_Info[stage].tips))
		DaHua_Goto_BKPic:SetProperty("Image",g_StageImage[stage] )
		this:Show()
	else
		PushDebugMessage("#{QXPVE_240522_13}")
	end
end

--Òþ²ØUI
function DaHua_Goto_OnHide()
	this:Hide()
end

--¹Ø± ½çÃæ
function DaHua_Goto_Hide()
	this:Hide()
end


function DaHua_Goto_ShowHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UIHelp")
		Set_XSCRIPT_ScriptID(051128)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function DaHua_Goto_Goto()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UIGOTO")
		Set_XSCRIPT_ScriptID(051128)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


