-- Ê±×°ÏâÇ¶ÊÔÒÂ¼ä

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0

local g_DressEnchase_Fitting_Frame_UnifiedPosition;

function DressEnchase_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING");
	this:RegisterEvent("CLOSE_DRESS_ENCHASE_FITTING");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("PROGRESSBAR_SHOW");	
	this:RegisterEvent("OPEN_EQUIP");
	this:RegisterEvent("SEX_CHANGED");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN",false)
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function DressEnchase_Fitting_OnLoad()
	g_DressEnchase_Fitting_Frame_UnifiedPosition=DressEnchase_Fitting_Frame:GetProperty("UnifiedPosition");
end

function DressEnchase_Fitting_OnEvent(event)
	
	-- Àë¿ªÓÎÏ·ÊÀ½ç
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();
		end
	end
	
	-- ÏâÇ¶³É¹¦£¬Èç¹ûÊÔÒÂ¼ä¿ª×Å£¬¾ÍÏÈ¹Ø± 
	if event == "UI_COMMAND" and tonumber(arg0) == 09111602 then		
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();										-- ??“????”???,??????????????,??????“????”??
		end
	end
	
	-- ¹Ø± ÊÔÒÂ¼ä
	if (event == "CLOSE_DRESS_ENCHASE_FITTING") then		
		if this:IsVisible() then
			DressEnchase_Fitting_OnHiden();										-- ??????????????????????,??????“????”??
		end
	end
	
	-- FakeObjectÄ£ĞÍ½çÃæ»¥³â
	if ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 )  --??
		then   --????
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed()
			return
		end
	end	
	
	-- ¿ªÊ¼°ÚÌ¯
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();										-- ??“????”???,????“????”??
		end
	end
	
	-- ¶Á½ø¶ÈÌõÖĞ
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- ??“????”???,????“????”??
		end
	end
	
	-- ÊÔÒÂµÄÊ±ºò²»ÄÜ´ò¿ª½ÇÉ«×ÊÁÏ´°¿Ú
	if ( event == "OPEN_EQUIP" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- ??“????”???,????“????”??
		end
	end
	
	-- ÊÔÒÂµÄÊ±ºò²»ÄÜ´ò¿ªÒÂ¹ñ´°¿Ú
	if ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then
			DressEnchase_Fitting_OnClosed();									-- ??“????”???,????“????”??
		end
	end
	
	-- ´ò¿ªÊÔÒÂ¼ä
	if(event == "OPEN_DRESS_ENCHASE_FITTING") then
		
		-- ÖØĞÂ¼¤»î¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥
		if (IsWindowShow("Dress_Enchase")) then
			DressEnchasing : EnableDressEnchasePreview()
		end
		
		PushEvent( "CLOSE_DRESSPREVIEW")	
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")

		-- ÊÔÒÂ
		local nDressBagPos	= tonumber(arg0)
		local nGemBagPos		= tonumber(arg1)
		DressEnchasing : FittingOnDress (nDressBagPos, nGemBagPos)
		this:Show();
		
		-- ÉèÖÃÊ¹ÓÃÄÄ¸öÄ£ĞÍ
		DressEnchase_Fitting_FakeObject : SetFakeObject("");	
		DressEnchase_Fitting_FakeObject : SetFakeObject("DressEnchase_Player");
				
		-- ¿ªÊ¼¹ØĞÄNPC
		local npcID = Get_XParam_INT(0);
		local objCared = DataPool : GetNPCIDByServerID(npcID);
		if objCared == -1 then
			return;
		end		
		this:CareObject(objCared, 1, "DressEnchase_Fitting");
	end	
	
	-- ¹ØĞÄNPC
	if (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍÉÌÈËµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if this:IsVisible() then
				DressEnchase_Fitting_OnHiden();								-- ??“????”???,????NPC??,???????????,???????“????”????
			end
		end
	end
	
	-- ±äĞÔ
	if event == "SEX_CHANGED" and  this:IsVisible() then
		DressEnchase_Fitting_FakeObject : Hide();
		DressEnchase_Fitting_FakeObject : Show();
		DressEnchase_Fitting_FakeObject : SetFakeObject("DressEnchase_Player")
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressEnchase_Fitting_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressEnchase_Fitting_Frame_On_ResetPos()
	end

end

--*******************************************************************************
-- ×¢Òâ£¡£¡£¡
-- OnHiden() º¯Êı¹Ø± ½çÃæµÄÊ±ºò£¬²»»áÔÙ´Î¼¤»î¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥
-- OnClosed() º¯Êı¹Ø± ½çÃæµÄÊ±ºò£¬»áÔÙ´Î¼¤»î¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥
--  âÁ½¸öº¯Êı²»ÄÜÍ¨ÓÃ~~
--*******************************************************************************

----------------------------------------------------------------------------------
--
-- Òş²Ø
--
function DressEnchase_Fitting_OnHiden()
	SetDefaultMouse();

	-- »Ö¸´ÊÔÒÂÇ°µÄ×°±¸²ÎÊı
	DressEnchasing : RestoreDressEnchaseFitting()
	DressEnchase_Fitting_FakeObject:SetFakeObject("")
	--È¡Ïû¹ØĞÄ
	this:CareObject(objCared, 0, "DressEnchase_Fitting");
	objCared = -1

	this:Hide();
end

----------------------------------------------------------------------------------
--
-- ¹Ø± 
--
function DressEnchase_Fitting_OnClosed()
	
	-- »Ö¸´ÊÔÒÂÇ°µÄ×°±¸²ÎÊı
	DressEnchasing : RestoreDressEnchaseFitting()	
	
	--È¡Ïû¹ØĞÄ
	this:CareObject(objCared, 0, "DressEnchase_Fitting");
	objCared = -1

	-- ÖØĞÂ¼¤»î¡°ÏâÇ¶Ô¤ÀÀ¡±°´Å¥
	if (IsWindowShow("Dress_Enchase")) then
		DressEnchasing : EnableDressEnchasePreview()
	end
	
	this:Hide();

end

----------------------------------------------------------------------------------
--
-- Ğı×ªÈËÎïÍ·ÏñÄ£ĞÍ£¨Ïò×ó)
--
function DressEnchase_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--Ïò×óĞı×ª¿ªÊ¼
		if(start == 1) then
			DressEnchase_Fitting_FakeObject:RotateBegin(-0.3);
		--Ïò×óĞı×ª½áÊø
		else
			DressEnchase_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ªÈËÎïÍ·ÏñÄ£ĞÍ£¨ÏòÓÒ)
--
function DressEnchase_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then	
		--ÏòÓÒĞı×ª¿ªÊ¼
		if(start == 1) then
			DressEnchase_Fitting_FakeObject:RotateBegin(0.3);
		--ÏòÓÒĞı×ª½áÊø
		else
			DressEnchase_Fitting_FakeObject:RotateEnd();
		end
	end
end

function DressEnchase_Fitting_Frame_On_ResetPos()
  DressEnchase_Fitting_Frame:SetProperty("UnifiedPosition", g_DressEnchase_Fitting_Frame_UnifiedPosition);
end
