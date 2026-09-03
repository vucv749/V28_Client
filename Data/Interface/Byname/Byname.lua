local TITLE_COUNT = {};
local EVENT_TYPE;
local strFrontTitle1
local strFrontTitle2
local g_Byname_Frame_UnifiedPosition;
--===============================================
-- PreLoad
--===============================================
function Byname_PreLoad()
	this:RegisterEvent("DRAW_SWEAR_TITLE");
	this:RegisterEvent("CHANGE_SWEAR_TITLE");
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

--===============================================
-- OnLoad
--===============================================
function Byname_OnLoad()
	TITLE_COUNT[0] = "Linh";
	TITLE_COUNT[1] = "Mµt";
	TITLE_COUNT[2] = "Nh¸";
	TITLE_COUNT[3] = "Tam";
	TITLE_COUNT[4] = "TÑ";
	TITLE_COUNT[5] = "Ngû";
	TITLE_COUNT[6] = "Løc";
	
	Byname_Text4:SetText( "Chi" );
  g_Byname_Frame_UnifiedPosition=Byname_Frame:GetProperty("UnifiedPosition");	
end

--===============================================
-- OnEvent
--===============================================
function Byname_OnEvent(event)
	EVENT_TYPE = event
	if ( event == "DRAW_SWEAR_TITLE" ) then
		Byname_Item1_Frame:Show();
		Byname_Item2_Frame:Hide();
		Byname_Text2:SetText( TITLE_COUNT[tonumber( arg0 )] )
	this:Show()
	elseif ( event == "CHANGE_SWEAR_TITLE" ) then
		Byname_Item1_Frame:Hide();
		Byname_Item2_Frame:Show();
		Byname_Text3:SetText( tostring( arg0 ) )
		Byname_Text5:SetText( tostring( arg1 ) )
		strFrontTitle1 = tostring( arg0 )
		strFrontTitle2 = tostring( arg1 )
	this:Show()
	end
	--this:Show()
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		Byname_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Byname_Frame_On_ResetPos()
	end			
end

--===============================================
-- ÁìÈ¡/ÐÞ¸Ä³ÆºÅ
--===============================================
function DrawSwearTitle_Accept()
	--ÁìÈ¡³ÆºÅ
	if EVENT_TYPE == "DRAW_SWEAR_TITLE" then
		local msg = Byname_Input1:GetText();
		if msg == "" then
			AxTrace(0,0,"Danh hi®u b¸ l²i 1")
			PushDebugMessage( "Nh§p danh hi®u l²i" )
			return
		end
		msg = Byname_Input3:GetText();
		if msg == "" then
			AxTrace(0,0,"Danh hi®u b¸ l²i 3")
			PushDebugMessage( "Nh§p danh hi®u l²i" )
			return
		end
		local	buf	= Byname_Input1:GetText()..Byname_Text2:GetText()..Byname_Input3:GetText()
		if string.len( buf ) > 8 then
			AxTrace(0,0,"Danh hi®u b¸ l²i 9")
			PushDebugMessage( "Nh§p danh hi®u l²i" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
			PushDebugMessage( "Nh§p danh hi®u l²i" )
			return
		end
			
		Player:DrawSwearTitle(buf)
	end
	
	--ÐÞ¸Ä³ÆºÅ
	if EVENT_TYPE == "CHANGE_SWEAR_TITLE" then
		local msg = Byname_Input4:GetText();
		if msg == "" then
			AxTrace(0,0,"Danh hi®u b¸ l²i 4")
			PushDebugMessage( "Nh§p danh hi®u l²i" )
			return
		end
		local	buf	= strFrontTitle1..Byname_Text4:GetText()..Byname_Input4:GetText()..strFrontTitle2
		if string.len( buf ) > 16 then
			AxTrace(0,0,"Danh hi®u b¸ l²i 9: "..buf)
			PushDebugMessage( "Nh§p danh hi®u l²i" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
				PushDebugMessage( "Nh§p danh hi®u l²i" )
				return
		end

		Player:ChangeSwearTitle(buf)
	end
	
	DrawSwearTitle_Cancel()
end

function DrawSwearTitle_Cancel()
	Byname_Input1:SetText( "" )
	Byname_Input3:SetText( "" )
	Byname_Input4:SetText( "" )
	this:Hide();
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Byname_Frame_On_ResetPos()
  Byname_Frame:SetProperty("UnifiedPosition", g_Byname_Frame_UnifiedPosition);
end
