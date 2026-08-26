--******************************************
--±ùÑ©ÊÀ½çÔªµ©´ò¿¨-ÅÝÎÂÈª
--Ö¸Òý½çÃæ
--create by  limengyue 
--2024-10-09
--******************************************

local g_Frozen_HotSpringEnter_Frame_UnifiedPosition;

--===============================================
-- OnLoad()
--===============================================
function Frozen_HotSpringEnter_PreLoad()
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
function Frozen_HotSpringEnter_OnLoad()   
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Frozen_HotSpringEnter_Frame_UnifiedPosition = Frozen_HotSpringEnter_Frame_BK:GetProperty("UnifiedPosition");
	
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Frozen_HotSpringEnter_Frame_On_ResetPos()
	Frozen_HotSpringEnter_Frame_BK:SetProperty("UnifiedPosition", g_Frozen_HotSpringEnter_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function Frozen_HotSpringEnter_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 99957403) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("Frozen_Guide")) then
			CloseWindow("Frozen_Guide", true)
		end
		if(IsWindowShow("Frozen_HotSpringEnter")) then
			CloseWindow("Frozen_HotSpringEnter", true)
		end
		Frozen_HotSpringEnter_Open()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 99957404) then
		AutoRuntoTargetExWithName(92, 126, 728, "Ti¬u Th¯ Th¯")
		Frozen_HotSpringEnter_OnClose()
	end
    -- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		Frozen_HotSpringEnter_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Frozen_HotSpringEnter_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       Frozen_HotSpringEnter_OnClose()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end
         
end

--===============================================
-- Frozen_HotSpringEnter_OnClose()
--===============================================
function Frozen_HotSpringEnter_OnClose()
	this:Hide()
end


--=========================================================
--Ä¬ÈÏ´ò¿ª½çÃæ
--=========================================================
function Frozen_HotSpringEnter_Open()
	--PushDebugMessage(" Frozen_HotSpringEnter_Open")
	-- local is69kaji = Player : GetData("69KAJI")  
	-- local is89kaji = Player : GetData("89KAJI") 
	-- if is69kaji ~= 1 and  is89kaji ~= 1  then
		-- Frozen_HotSpringEnter_Text:SetText("#{BXPWQ_240927_84}")
	-- else
		-- --¿¨¼¶·þ
		-- Frozen_HotSpringEnter_Text:SetText("È±×Öµä")
	-- end
	this:Show()		
end

--=========================================================
--Ç°Íù²ÎÓë
--=========================================================
function Frozen_HotSpringEnter_Goto()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenUIHelp")
		Set_XSCRIPT_ScriptID(999574)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end


--=========================================================
--°ïÖú
--=========================================================
function Frozen_HotSpringEnter_Help()
	local is69kaji = Player : GetData("69KAJI")  
	local is89kaji = Player : GetData("89KAJI") 
	if is69kaji ~= 1 and  is89kaji ~= 1  then
		PushEvent("QUEST_HELPINFO", "#{BXPWQ_240927_06}")
	else
		--¿¨¼¶·þ
		PushEvent("QUEST_HELPINFO", "#{BXPWQ_240927_85}")
	end
end



