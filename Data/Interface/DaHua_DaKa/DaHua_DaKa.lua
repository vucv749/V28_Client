--******************************************
--´ó»°Î÷ÓÎ´ò¿¨»î¶¯
--ÈÎÎñµÀ¾ß ºÁÃ«
--limengyue 2024-05-28
--******************************************

local g_DaHua_DaKa_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function DaHua_DaKa_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--ÇÐ³¡¾°ÊÂ¼þ
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--===============================================
-- OnLoad()
--===============================================
function DaHua_DaKa_OnLoad()   
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_DaHua_DaKa_Frame_UnifiedPosition = DaHua_DaKa_Frame_BK:GetProperty("UnifiedPosition");
	
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function DaHua_DaKa_Frame_On_ResetPos()
	DaHua_DaKa_Frame_BK:SetProperty("UnifiedPosition", g_DaHua_DaKa_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function DaHua_DaKa_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 99913702) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("DaHua_Guide")) then
			CloseWindow("DaHua_Guide", true)
		end
		if(IsWindowShow("DaHua_DaKa")) then
			CloseWindow("DaHua_DaKa", true)
		end
		DaHua_DaKa_Open()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99913703) then
		AutoRuntoTargetExWithName(158, 110, 0, "B° Ð« Ti¬u T±")
		DaHua_DaKa_OnClose()
	end
    -- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		DaHua_DaKa_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DaHua_DaKa_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       DaHua_DaKa_OnClose()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end
         
end

--===============================================
-- DaHua_DaKa_OnClose()
--===============================================
function DaHua_DaKa_OnClose()
	this:Hide()
end


--=========================================================
--Ä¬ÈÏ´ò¿ª½çÃæ
--=========================================================
function DaHua_DaKa_Open()
	--PushDebugMessage(" DaHua_DaKa_Open")

	this:Show()		
end

--=========================================================
--Ç°Íù²ÎÓë
--=========================================================
function DaHua_DaKa_GoTo()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenUIHelp")
		Set_XSCRIPT_ScriptID(999137)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


--=========================================================
--°ïÖú
--=========================================================
function DaHua_DaKa_Help()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TipsHelp")
		Set_XSCRIPT_ScriptID(999137)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end



