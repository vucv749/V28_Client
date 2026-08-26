-- ConfraternityMessage.lua
-- °ï»áÁôÑÔ½çÃæ

local currentChoose = -1											-- 1:???;2:???;3:???
local waitLeaveWordUpdate = 0                 -- ??????LeaveWord??

local moneyCosts = 1000												-- ????


local g_ConfraternityMessage_Frame_UnifiedPosition;
function ConfraternityMessage_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "GUILD_LEAVE_WORD" )						-- ????

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityMessage_OnLoad()
	ConfraternityMessage_Clear()
	g_ConfraternityMessage_Frame_UnifiedPosition=ConfraternityMessage_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityMessage_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19840424 then	-- ????
		if this : IsVisible() then									-- ??????,????
			return
		end

		currentChoose = 1
		ConfraternityMessage_RefreshWindow()
		this : Show()
		return
	end

	if event == "GUILD_LEAVE_WORD" and this : IsVisible() then		-- ????
		if currentChoose == 2 then
			return
		end

		currentChoose = 2
		ConfraternityMessage_RefreshWindow()
		return
	end
	
	--×¼±¸´ò¿ª²é¿´ÁôÑÔ½çÃæ....²»Ö±½Ó´ò¿ªÊÇÒòÎª¿Í»§¶ËÖĞµÄLeaveWord¿ÉÄÜ²»ÊÇ×îĞÂµÄ....
	--Óë°ï»á×Ü¹Ü¶Ô»°Ñ¡²é¿´ÁôÑÔÊ±»áÏòworldÇëÇó×îĞÂµÄLeaveWord....µÈ×îĞÂµÄLeaveWord¹ıÀ´ºó»á·¢ËÍUI_COMMAND 19841121....µ½Ê±ºòÔÙÏÔÊ¾ÁôÑÔ´°¿Ú....
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19841120 then
		
		--ÉèÖÃµ±Ç°×´Ì¬ÎªµÈ´ıLeaveWord¸üĞÂ....
		waitLeaveWordUpdate = 1
		--ÏòWorldÇëÇó°ï»áÁôÑÔ(¸üĞÂ±¾µØ°ï»áÁôÑÔ)....
		Guild : AskGuildLeaveWord()

	end

	--LeaveWordÒÑ¾­¸üĞÂ....Èç¹ûµ±Ç°×´Ì¬ÎªµÈ´ıLeaveWord¸üĞÂÔò´ò¿ª²é¿´ÁôÑÔ½çÃæ....
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19841121 then

		if waitLeaveWordUpdate == 1 then
			currentChoose = 3
			ConfraternityMessage_RefreshWindow()
			this : Show()
			waitLeaveWordUpdate = 0
			return
		end
		
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityMessage_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityMessage_Frame_On_ResetPos()
	end
end

function ConfraternityMessage_RefreshWindow()

	local str = ""

	if currentChoose == 1 then										-- 1:???;2:????;3:???
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_55}" )
		ConfraternityMessage_EditInfo : Hide()
		ConfraternityMessage_Set : Hide()
		ConfraternityMessage_WarningText : SetText( "#{INTERFACE_XML_820}" )
		ConfraternityMessage_WarningText : Show()
		ConfraternityMessage_Ok : Show()
	elseif currentChoose == 2 then									-- 1:???;2:????;3:???
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_55}" )
		ConfraternityMessage_WarningText : Hide()
		ConfraternityMessage_Ok : Hide()
		ConfraternityMessage_EditInfo : Show()
		ConfraternityMessage_Set : Show()
	elseif currentChoose == 3 then									-- 1:???;2:????;3:???
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_972}" )
		str = Guild : GetGuildLeaveWord();
		ConfraternityMessage_WarningText : SetText( str )
		ConfraternityMessage_WarningText : Show()
		ConfraternityMessage_Ok : Hide()
		ConfraternityMessage_EditInfo : Hide()
		ConfraternityMessage_Set : Hide()
	end
	
end

function ConfraternityMessage_OK_Clicked()
	if currentChoose == 1 then										-- 1:???;2:????;3:???
		-- ÄúµÄ½ğÇ®²»×ã£¬ÇëÈ·ÈÏ
		if (Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" ) )< moneyCosts then
			PushDebugMessage( "Cüa ngß½i ti«n tài tña h° không ğü ğ¬ ti«n trä A." )
		else
			-- Í¬ÒâÖ§¸¶
			Guild : ModifyGuildLeaveWord( 1 )
			return
		end
	elseif currentChoose == 2 then									-- 1:???;2:????;3:???
		local ret = Guild : ModifyGuildLeaveWord( ConfraternityMessage_EditInfo : GetText() )
		if ret == false then
			return
		end
	end

	ConfraternityMessage_Close()
end

function ConfraternityMessage_Cancel_Clicked()
	ConfraternityMessage_Close()
end

function ConfraternityMessage_Close()
	this : Hide()
	ConfraternityMessage_Clear()
end

function ConfraternityMessage_Clear()
	currentChoose = -1
	ConfraternityMessage_EditInfo : SetText( "" )
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function ConfraternityMessage_Frame_On_ResetPos()
  ConfraternityMessage_Frame:SetProperty("UnifiedPosition", g_ConfraternityMessage_Frame_UnifiedPosition);
end
