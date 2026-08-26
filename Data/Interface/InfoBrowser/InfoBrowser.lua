local nCurrentMail = 0;
local g_InfoBrowser_Frame_UnifiedXPosition;
local g_InfoBrowser_Frame_UnifiedYPosition;
--===============================================
-- OnLoad()
--===============================================
function InfoBrowser_PreLoad()
	this:RegisterEvent("OPEN_EMAIL");
	this:RegisterEvent("UPDATE_EMAIL");
	this:RegisterEvent("HAVE_MAIL");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
end

function InfoBrowser_OnLoad()
	Variable:SetVariable( "IsInfoBrowerShow","False", 1 );
	g_InfoBrowser_Frame_UnifiedXPosition	= InfoBrowser_Frame:GetProperty("UnifiedXPosition");
	g_InfoBrowser_Frame_UnifiedYPosition	= InfoBrowser_Frame:GetProperty("UnifiedYPosition");
	
end

--===============================================
-- OnEvent()
--===============================================
function InfoBrowser_OnEvent( event )
	--ÏÔÊ¾ÏµÍ³ÓÊ¼þµÄÊ±ºò±Ø¶¨»á¹Ø± ±¾½çÃæ
	if( event == "OPEN_EMAIL" ) then
		SystemInfo_NextPage();
		
	elseif( event == "UPDATE_EMAIL" ) then
		AxTrace( 0, 0, "UPDATE_EMAIL" );
		nCurrentMail = tonumber( arg0 );		
		
		-- [ QUFEI 2007-09-15 17:05 UPDATE BugID #25107 ]
		-- Ê µ½ÎÞÐ§ÓÊ¼þÊ±¹Ø± ÓÊ¼þ¶ÁÈ¡´°¿Ú
		if( nCurrentMail < 100000 ) then
			Update_Player_Mail();
		elseif( nCurrentMail >= 100000 and nCurrentMail < 300000 ) then
			nCurrentMail = nCurrentMail - 100000;
			InfoBrowser_Close()			
		else
			nCurrentMail = nCurrentMail - 300000;
			Update_System_Mail();
		end
		
	elseif( event == "HAVE_MAIL" ) then
		if( this:IsVisible() ) then
			InfoBrowser_Update();
		end
	elseif (event == "ADJEST_UI_POS" ) then
		InfoBrowser_Frame_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		InfoBrowser_Frame_ResetPos()
	end

end
function Update_System_Mail()
	AxTrace( 0, 0, "Update_System_Mail" );
	SystemInfo_Show();
	SystemInfo_Update();
end

function Update_Player_Mail()
	AxTrace( 0, 0, "Update_Player_Mail" );
	InfoBrowser_Show();
	InfoBrowser_Update();
end

function InfoBrower_DisableButton()
	InfoBrowser_Next:Disable();
	InfoBrowser_AddFriend:Disable();
	InfoBrowser_ExamineData:Disable();
	InfoBrowser_AddFriend:Disable();
	InfoBrowser_Respondence:Disable();
	InfoBrowser_ExamineData:Disable();
	InfoBrowser_Next:Disable();
	InfoBrowser_PlayerHead:SetProperty("Image", "");
	AxTrace( 0,0,"InfoBrower_DisableButton" );
end
--===============================================
-- UpdateFrame()
--===============================================
function InfoBrowser_Update()
	InfoBrower_UpdateButton();
	Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
	local sender  = DataPool:GetMail( nCurrentMail,"SENDER" );
	local context = DataPool:GetMail( nCurrentMail,"CONTEX" );
	local time	  = DataPool:GetMail( nCurrentMail,"TIME" );

	
	InfoBrowser_From:SetText( "Tên:"..sender.."#b#c0000FF#effffff(ngß¶i ch½i)" );
	InfoBrowser_Time:SetText( "Th.Gian:"..time );
	InfoBrowser_Context:SetText( context );
	local strFaceImage = DataPool:GetMail( nCurrentMail,"PORTRAIT" );
	AxTrace( 0,0,"InfoBrowser_Update head image = "..tostring(strFaceImage) );
	InfoBrowser_PlayerHead:SetProperty("Image", tostring(strFaceImage));
	InfoBrowser_Report:Show();
	
	
end

function InfoBrower_UpdateButton()
	InfoBrower_DisableButton();
	if( DataPool:GetMailNumber() == 0 ) then
		InfoBrowser_Next:Disable();
	else
		InfoBrowser_Next:Enable();
	end

	local nchannel,nindex;
	nchannel, nindex  = DataPool:GetFriendByName( DataPool:GetMail( nCurrentMail,"SENDER" ) );
	
	if( tonumber( nchannel ) == -1 ) then
		InfoBrowser_AddFriend:Enable();
	else
		InfoBrowser_AddFriend:Disable();
	end
	
	InfoBrowser_ExamineData:Enable();
	
	InfoBrowser_Respondence:Enable();

end

function InfoBrowser_Close()
	this:Hide();
	Variable:SetVariable( "IsInfoBrowerShow","False", 1 );
end

function InfoBrowser_Show()
	this:Show();
	Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
	InfoBrowser_Frame_Title:SetText( "#gFF0FA0thß tín xem" );
	InfoBrowser_Frame_System:Hide();
	InfoBrowser_Frame_Player:Show();
	InfoBrowser_Respondence:Show();
	InfoBrowser_AddFriend:Show();
	--Í¶Ëß°´Å¥show
end

function SystemInfo_Show()
	this:Show();
	Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
	InfoBrowser_Frame_Player:Hide();
	InfoBrowser_Frame_Title:SetText( "#gFF0FA0h® th¯ng tin tÑc" );
	InfoBrowser_Frame_System:Show();
	InfoBrowser_AddFriend:Hide();
	InfoBrowser_Respondence:Hide();
	--Í¶Ëß°´Å¥hide	
end


function InfoBrowser_NextMail()
	DataPool:GetNextMail();
end

function InfoBrowser_AddToFriend()
	local sender = DataPool:GetMail(nCurrentMail, "SENDER")
	DataPool:AddFriendAndGrouping(sender)
end

function InfoBrowser_PlayerInfo()
	local name = DataPool:GetMail( nCurrentMail, "SENDER" )
	if( Friend:IsPlayerIsFriend( name ) == 1 ) then	
		DataPool:ShowFriendInfo( name );
	else
		DataPool:ShowChatInfo( name );
	end

	
end

function InfoBrowser_MailBack()
	local sender = DataPool:GetMail(nCurrentMail, "SENDER")
	local nChannel, nIndex = DataPool:GetFriendByName(sender)
	if tonumber(nChannel) == -1 then
		DataPool:AddFriend(8, sender)
	end	
	DataPool:OpenMail(sender)
end

function InfoBrowser_Help()
end

function SystemInfo_Update()
	
		Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
		InfoBrower_UpdateButton();
		local sender  = DataPool:GetMail( nCurrentMail,"SENDER" );
		local context = DataPool:GetMail( nCurrentMail,"CONTEX" );
		local time	  = DataPool:GetMail( nCurrentMail,"TIME" );
	
		
		SystemInfo_From:SetText( "#b#cFF0000#effffffh® th¯ng bßu ki®n" );
		SystemInfo_Time:SetText( "Th.Gian:"..time );
		SystemInfo_Context:SetText( context );
		InfoBrowser_Report:Hide();
end


function SystemInfo_NextPage()
	InfoBrower_DisableButton();
	local mailnumber = DataPool:GetMailNumber();

	if( mailnumber > 0 ) then
		InfoBrowser_NextMail();
	end
end
function InfoBrowser_OnHiden()	
	Variable:SetVariable( "IsInfoBrowerShow","False", 1 );
end

function InfoBrowser_toushu()
	local MailTime = DataPool:GetMailTimeInt(nCurrentMail);
	local sender  = DataPool:GetMail( nCurrentMail,"SENDER" );
	local context = DataPool:GetMail( nCurrentMail,"CONTEX" );
	Talk:DisclosureToGM("mail",sender,context,MailTime);
end
function InfoBrowser_Frame_ResetPos()
	InfoBrowser_Frame:SetProperty("UnifiedXPosition", g_InfoBrowser_Frame_UnifiedXPosition);
	InfoBrowser_Frame:SetProperty("UnifiedYPosition", g_InfoBrowser_Frame_UnifiedYPosition);
end
