--ËµÃ÷£¬ÔÚ â¸öluaÀïÍ·£¬Ö»ÄÜÌí¼ÓÀ´×ÔÆäËûÍæ¼ÒµÄÏûÏ¢»áÖ±½ÓÔÚ
--      Íæ¼ÒµÄ½çÃæÖĞÖ±½Óµ¯³öÒªÇóÈ·ÈÏ¶Ô»°¿òµÄÇé¿ö

--1¡¢ÏµÍ³ÌáÊ¾
--2¡¢À­ÈË¼¼ÄÜ
--3¡¢¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄã£¨¶Ó³¤£©Í¬Òâ
--4¡¢¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½


g_InitiativeClose = 0;

local g_FrameInfo
local STALL_RENT_FRAME			= 1;
local DISCARD_ITEM_FRAME		= 2;
local CANNT_DISCARD_ITEM		= 3;
local TEAM_ASKJOIN					= 4;	--?????????
local TEAM_MEMBERINVERT			= 5;	--???????????????
local TEAM_SOMEASK					= 6;	--????????
local TEAM_FOLLOW		 				= 7;	--????????
local FRAME_AFFIRM_SHOW 		= 8;	--??????????
local GUILD_CREATE_CONFIRM	= 9; 	--????????
local SYSTEM_TIP_INFO 			= 10; --?????????
local GUILD_QUIT_CONFIRM 		= 11; --????????
local GUILD_DESTORY_CONFIRM = 12; --????????
local CALL_OF								= 13;	--??
local INVITE_RIDE						= 14;  --????
local Quest_Number;
local g_MessageBox_Other_Frame_UnifiedPosition;
--===============================================
-- OnLoad()
--===============================================
function MessageBox_Other_PreLoad()

	this:RegisterEvent("OPEN_SYSTEM_TIP_INFO_DLG");
	--this:RegisterEvent("OPEN_CALLOF_PLAYER");
		
	-- ÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
	this:RegisterEvent("SHOW_TEAM_YES_NO");
	-- ¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄãÍ¬Òâ.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	-- Ä³ÈËÉêÇë¼ÓÈë¶ÓÎé.
	this:RegisterEvent("TEAM_APPLY");
	-- ¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½
	this:RegisterEvent("TEAM_FOLLOW_INVITE");
	
	this:RegisterEvent("RECIVE_RIDE");
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function MessageBox_Other_OnLoad()
	-- Òş²ØÖĞ¼äµÄ°´Å¥
	MessageBox_Other_Info_Button:Hide();
  g_MessageBox_Other_Frame_UnifiedPosition=MessageBox_Other_Frame:GetProperty("UnifiedPosition");		
end

--===============================================
-- OnEvent()
--===============================================
function MessageBox_Other_OnEvent(event)

	-- ÈËÓĞÑûÇëÄã¼ÓÈë¶ÓÎé
	if ( event == "SHOW_TEAM_YES_NO" ) then

		g_FrameInfo = TEAM_ASKJOIN;
		MessageBox_Other_Text:SetText(arg0.."M¶i Nhî gia nh§p ğµi ngû");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- ¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄãÍ¬Òâ
	elseif ( event == "TEAM_MEMBER_INVITE" ) then

		g_FrameInfo = TEAM_MEMBERINVERT;
		MessageBox_Other_Text:SetText(arg0.."M¶i" .. arg1 .. "Gia nh§p ğµi ngû, ğ°ng ı Ma?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- Ä³ÈËÉêÇë¼ÓÈë¶ÓÎé
	elseif ( event == "TEAM_APPLY" ) then

		g_FrameInfo = TEAM_SOMEASK;
		MessageBox_Other_Text:SetText(arg0.."Xin gia nh§p ğµi ngû, ğ°ng ı Ma?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- ¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½
	elseif ( event == "TEAM_FOLLOW_INVITE" ) then

		g_FrameInfo = TEAM_FOLLOW;
		AxTrace( 0, 0, "Ğµi trß·ng m¶i tiªn vào t± ğµi ği theo hình thÑc" );
		MessageBox_Other_Text:SetText(arg0.."Hy v÷ng Nhî ği theo ğµi ngû, ğ°ng ı Ma?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;

	-- ÌáÊ¾ÏµÍ³ĞÅÏ¢¡£
	elseif( event == "OPEN_SYSTEM_TIP_INFO_DLG" ) then
	
		-- ÏÔÊ¾ÏµÍ³ĞÅÏ¢¡£
		MessageBox_Other_Show_single_Info(1);
		MessageBox_Other_Text:SetText(tostring(arg0));
		this:Show();
		
	elseif( event == "OPEN_CALLOF_PLAYER" )   then 
		g_FrameInfo = CALL_OF;
		local szName = arg0;
		
		MessageBox_Other_Text:SetText(szName .. "LÕp Nhî, ğ°ng ı B¤t?");
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;
	elseif( event == "RECIVE_RIDE" ) then
		g_FrameInfo = INVITE_RIDE;
		local szName = arg0;
		MessageBox_Other_Text:SetText(szName .. "M¶i Nhî Ğ°ng KÜ");	
		this:Show();
		MessageBox_Other_Show_single_Info( 0 );
		g_InitiativeClose = 0;
	end
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		MessageBox_Other_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MessageBox_Other_Frame_On_ResetPos()
	end	
	MessageBox_Other_UpdateFrame();

end

--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Other_UpdateFrame()
	
	local nWidth, nHeight = MessageBox_Other_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBox_Other_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end

--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function MessageBox_Other_OK_Clicked()
	
	if(g_FrameInfo == TEAM_ASKJOIN) then
		--0 ÈËÓĞÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:AgreeJoinTeam();
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == TEAM_MEMBERINVERT) then
		--1 Ä³ÈËÉêÇë¼ÓÈë¶ÓÎé
		Player:SendAgreeJoinTeam_TeamMemberInvite();
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == TEAM_SOMEASK) then
		--´¦ÀíÉêÇë¼ÓÈë¶ÓÎé
		Player:SendAgreeJoinTeam_Apply();
		g_InitiativeClose = 1;
		this:Hide(); 

	elseif(g_FrameInfo == TEAM_FOLLOW) then
		--¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½
		Player:SendAgreeTeamFollow();
		g_InitiativeClose = 1;
		this:Hide();

	elseif(g_FrameInfo == CALL_OF)  then
		Friend:CallOf("ok");
		this:Hide();
	elseif( g_FrameInfo == INVITE_RIDE ) then
		AcceptRide(1);
		this:Hide();
	end
	
	this:Hide();
	g_FrameInfo = 0;
end

--===============================================
-- ·ÅÆú°ÚÌ¯(IDCONCEL)
--===============================================
function MessageBox_Other_Cancel_Clicked()
	
	-- Òş²ØÏûÏ¢°´Å¥2006£­3£­27
	MessageBox_Other_Show_single_Info(0);
	
	if(g_InitiativeClose == 1)  then
		return;
	end

	if ( g_FrameInfo == TEAM_ASKJOIN ) then 
		--Í¨Öª½â³ıËø¶¨
		Player:RejectJoinTeam();

	elseif ( g_FrameInfo == TEAM_MEMBERINVERT ) then 
		--´¦ÀíÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_TeamMemberInvite();

	elseif ( g_FrameInfo == TEAM_SOMEASK ) then 
		--´¦ÀíÉêÇë¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_Apply();

	elseif ( g_FrameInfo == TEAM_FOLLOW ) then 
		--¶Ó³¤ÑûÇë½øÈë×é¶Ó¸úËæÄ£Ê½
		Player:SendRefuseTeamFollow();
		g_FrameInfo = 0;
	elseif(g_FrameInfo == CALL_OF)  then
		Friend:CallOf("cancel");
	
	elseif( g_FrameInfo == INVITE_RIDE ) then
		AcceptRide(0);
		this:Hide();
	
	end
	

	this:Hide();
	g_FrameInfo = 0;
	
end



--------------------------------------------------------------------------------------------------------
--
-- µ¥Ò»ÌáÊ¾ĞÅÏ¢
--
function MessageBox_Other_Info_Clicked()

	-- ¹Ø± ĞÅÏ¢¶Ô»°¿ò¡£
	MessageBox_Other_Show_single_Info(0);
	this:Hide();
end


function MessageBox_Other_Show_single_Info(bShow)

	if(1 == bShow) then
		MessageBox_Other_OK_Button:SetText( "Xác nh§n" );
		MessageBox_Other_Cancel_Button:SetText( "Hüy bö" );
		MessageBox_Other_OK_Button:Hide();
		MessageBox_Other_Info_Button:Show();
		MessageBox_Other_Cancel_Button:Hide();
		
	elseif(0 == bShow) then
		MessageBox_Other_OK_Button:SetText( "Ğ°ng ı" );
		MessageBox_Other_Cancel_Button:SetText( "Cñ tuy®t" );
		MessageBox_Other_OK_Button:Show();
		MessageBox_Other_Info_Button:Hide();
		MessageBox_Other_Cancel_Button:Show();
	end;


end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function MessageBox_Other_Frame_On_ResetPos()
  MessageBox_Other_Frame:SetProperty("UnifiedPosition", g_MessageBox_Other_Frame_UnifiedPosition);
end
