-- Ê±×°È¾É«ÊÔÒÂ¼ä

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0

local g_DressPaint_Fitting_Frame_UnifiedPosition;

function DressPaint_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UI_COMMAND");
	--this:RegisterEvent("OPEN_DRESS_PAINT_FITTING");
	this:RegisterEvent("CLOSE_DRESS_PAINT_FITTING");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PROGRESSBAR_SHOW");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN",false)
end

function DressPaint_Fitting_OnLoad()
	g_DressPaint_Fitting_Frame_UnifiedPosition=DressPaint_Fitting_Frame:GetProperty("UnifiedPosition");
end

function DressPaint_Fitting_OnEvent(event)

	-- Àë¿ªÓÎÏ·ÊÀ½ç
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		DressPaint_Fitting_OnHiden();
		return
	end

	-- ¹Ø± ÊÔÒÂ¼ä
	if (event == "CLOSE_DRESS_PAINT_FITTING") then
		if (this:IsVisible()) then		
			DressPaint_Fitting_OnHiden();									-- ??????????????????????,??????“????”??
		end
	end
	
	-- ²»ÄÜºÍ±äĞÔÍ¬Ê±´æÔÚ
	if (event == "UI_COMMAND" and tonumber(arg0) == 20120406) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								
		end
	end

	-- È¾É«³É¹¦£¬Èç¹ûÊÔÒÂ¼ä¿ª×Å£¬¾ÍÏÈ¹Ø± 
	if event == "UI_COMMAND" and tonumber(arg0) == 091111 then		
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- ??“????”???,?????????????,????????“????”??
		end
	end
	
	-- ¿ªÊ¼°ÚÌ¯£¬²»ÄÜ½øĞĞÊÔÒÂ
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();									-- ??“????”???,????“????”??
		end
	end

	-- ¶Á½ø¶ÈÌõÖĞ£¬²»ÄÜ½øĞĞÊÔÒÂ
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- ??“????”???,????“????”??
		end
	end

	-- ÊÔÒÂµÄÊ±ºò²»ÄÜ´ò¿ª½ÇÉ«×ÊÁÏ´°¿Ú
	if ( event == "OPEN_EQUIP" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- ??“????”???,????“????”??
		end
	end
	
	-- ÊÔÒÂµÄÊ±ºò²»ÄÜ´ò¿ªÒÂ¹ñ
	if ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then
			DressPaint_Fitting_OnClosed();								-- ??“????”???,????“????”??
		end
	end
	
	-- ´ò¿ªÊÔÒÂ¼ä
	if(event == "OPEN_DRESS_PAINT_FITTING") then
			
		-- ÊÔÒÂ
		local nDressBagPos = tonumber(arg0)
		DressReplaceColor : FittingOnDress(nDressBagPos)
		this:Show()
		
		-- ÉèÖÃÊ¹ÓÃÄÄ¸öÄ£ĞÍ
		DressPaint_Fitting_FakeObject : SetFakeObject("");	
		DressPaint_Fitting_FakeObject : SetFakeObject("DressPaint_Player");
				
		-- ¿ªÊ¼¹ØĞÄNPC
		local npcID = Get_XParam_INT(0);
		local objCared = DataPool:GetNPCIDByServerID(npcID);
		if objCared == -1 then
			return;
		end		
		this:CareObject(objCared, 1, "DressPaint_Fitting");
	end
	
	-- ¹ØĞÄNPC
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍÉÌÈËµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			DressPaint_Fitting_OnHiden();								-- ??“????”???,????NPC??,???????????,???????“????”????
		end
	end
	
	-- ±äĞÔ
	if event == "SEX_CHANGED" and  this:IsVisible() then
		DressPaint_Fitting_FakeObject : Hide();
		DressPaint_Fitting_FakeObject : Show();
		DressPaint_Fitting_FakeObject : SetFakeObject("DressPaint_Player");
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressPaint_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressPaint_Fitting_Frame_On_ResetPos()
	end

end

--*******************************************************************************
-- ×¢Òâ£¡£¡£¡
-- OnHiden() º¯Êı¹Ø± ½çÃæµÄÊ±ºò£¬²»»áÔÙ´Î¼¤»î¡°È¾É«×·×Ù¡±°´Å¥
-- OnClosed() º¯Êı¹Ø± ½çÃæµÄÊ±ºò£¬»áÔÙ´Î¼¤»î¡°È¾É«×·×Ù¡±°´Å¥
--  âÁ½¸öº¯Êı²»ÄÜÍ¨ÓÃ~~
--*******************************************************************************

----------------------------------------------------------------------------------
--
-- Òş²Ø
--
function DressPaint_Fitting_OnHiden()
	SetDefaultMouse();

	-- »Ö¸´ÊÔÒÂÇ°µÄ×°±¸²ÎÊı
	DressReplaceColor:RestoreDressPaintFitting()
	
	--È¡Ïû¹ØĞÄ
	this:CareObject(objCared, 0, "DressPaint_Fitting");
	objCared = -1

	this:Hide();
end

----------------------------------------------------------------------------------
--
-- ¹Ø± 
--
function DressPaint_Fitting_OnClosed()
	
	-- »Ö¸´ÊÔÒÂÇ°µÄ×°±¸²ÎÊı
	DressReplaceColor:RestoreDressPaintFitting()
	
	--È¡Ïû¹ØĞÄ
	this:CareObject(objCared, 0, "DressPaint_Fitting");
	objCared = -1
	
	this:Hide()

end

----------------------------------------------------------------------------------
--
-- Ğı×ªÈËÎïÍ·ÏñÄ£ĞÍ£¨Ïò×ó)
--
function DressPaint_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--Ïò×óĞı×ª¿ªÊ¼
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(-0.3);
		--Ïò×óĞı×ª½áÊø
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ªÈËÎïÍ·ÏñÄ£ĞÍ£¨ÏòÓÒ)
--
function DressPaint_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--ÏòÓÒĞı×ª¿ªÊ¼
		if(start == 1) then
			DressPaint_Fitting_FakeObject:RotateBegin(0.3);
		--ÏòÓÒĞı×ª½áÊø
		else
			DressPaint_Fitting_FakeObject:RotateEnd();
		end
	end
end

function DressPaint_Fitting_Frame_On_ResetPos()
  DressPaint_Fitting_Frame:SetProperty("UnifiedPosition", g_DressPaint_Fitting_Frame_UnifiedPosition);
end
