--Cload_Login

-- µÇÂ½ÓÊ¼þÃûÁÐ±í
local TailName ={
		[0] = "@changyou.com",
		"@game.sohu.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		"S¯ ði®n thoÕi di ðµng ðång ký",
		"Ðßa vào m£t khác tài khoän h§u t¯",
		"Vô h§u t¯ tài khoän ðång ký",
		}
		
local g_CloudLogin_IsQRCode = 0;

--===============================================
-- PreLoad()
--===============================================
function Cloud_Login_PreLoad()

	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- ¹Ø± ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- ½øÈëÓÎÏ·ºóÇå¿  ÊºÅ
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	this:RegisterEvent("QRCODE_MESSAGE" );
	this:RegisterEvent("QRCODE_SCANQR_SUCCESS" );
	
end

--===============================================
-- OnLoad()
--===============================================
function Cloud_Login_OnLoad()

	-- Éú³ÉÓÊÏä ÊºÅµÄÏÂÀ­ÁÐ±í
  local TailCount = 9
	local i = 0;
	
	for i = 0, TailCount-1 do
		Cloud_Login_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	----Ñ¡ÔñÉÏÒ»´ÎµÇÂ¼µÄ ËºÅºó×ºdengxx
	local nMailIndex = Variable:GetVariable("Account_MailIndex")
	if nMailIndex == nil or nMailIndex == "-1" then
		nMailIndex = 0
	end
	Cloud_Login_Region:SetCurrentSelect(tonumber(nMailIndex))
	
end

--===============================================
-- OnEvent()
--===============================================
function Cloud_Login_OnEvent(event)

	-- ´ò¿ª ÊºÅÊäÈë½çÃæ
 	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		
		if not GameProduceLogin:IsYunGameMobileClient() then 
			return
		end
		
 		--ÏÔÊ¾ ÊºÅÃÜÂë½çÃæ
		Cloud_Login_Tradition_MouseDown()
		Cloud_Login_Initilize();
		this:Show();
		
		return;
	end
	
	-- ¹Ø±  ÊºÅÊäÈë½çÃæ
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		Cloud_Login_PassWord:SetText("");
		Cloud_Login_ID:SetText("");
		this:Hide();
		return;
	end
	
	-- ½øÈëÓÎÏ·ºóÇå¿  ÊºÅ
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- Çå¿ ÃÜÂë.
		Cloud_Login_PassWord:SetText("");
		Cloud_Login_ID:SetText("");
		this:Hide();
		return;
	end
		
	if ( event == "QRCODE_MESSAGE" ) then
		Cloud_Login_ShowQRCodeMessage( tonumber(arg0) )
		return
	end		
	
	if ( event == "QRCODE_SCANQR_SUCCESS" ) then
		Cloud_Login_QRCode_OnClosed()
		return
	end		
	
end

function Cloud_Login_Initilize()
	
	Cloud_Login_ID:SetText("");
	Cloud_Login_PassWord:SetText("");
	
	Cloud_Login_ID:Enable();
	Cloud_Login_PassWord:Enable();
	
	Cloud_Login_ID_Active();
end

--µã»÷ ÊäÈëºó×ºµÇÂ¼
function Cloud_Login_Tradition_MouseDown()

	Cloud_Login_JoinFrame:Show();
	Cloud_Login_QRCodeFrame:Hide();
	Cloud_Login_ImageFrame:Hide();
 	Cloud_Login_Image2Frame:Hide();
	Cloud_Login_Tradition:SetCheck(1)
	Cloud_Login_QRCodeLogin:SetCheck(0)
	g_CloudLogin_IsQRCode = 0;
	
	GameProduceLogin:CloseAccReg()
end

--µã»÷ ¶þÎ¬ÂëµÇÂ¼
function Cloud_Login_QRCodeLogin_MouseDown()
	Cloud_Login_JoinFrame:Hide();
	Cloud_Login_QRCodeFrame:Show();
	Cloud_Login_ImageFrame:Hide();
 	Cloud_Login_Image2Frame:Hide();
	Cloud_Login_Tradition:SetCheck(0)
	Cloud_Login_QRCodeLogin:SetCheck(1)
	g_CloudLogin_IsQRCode = 1;
	
	GameProduceLogin:StartQRCode()
end

function Cloud_Login_ID_Return()
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		Cloud_Login_PassWord_Active();
	end
end

function Cloud_Login_ID_TabPressed()
	Cloud_Login_PassWord_Active();
end

function Cloud_Login_ID_Active()
	Cloud_Login_ID:SetProperty("DefaultEditBox", "True");
	Cloud_Login_PassWord:SetProperty("DefaultEditBox", "False");
end

function Cloud_Login_Password_Return()
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		Cloud_Login_CheckAccount();
	end
end

function Cloud_Login_Password_TabPressed()
	Cloud_Login_ID_Active()
end

function Cloud_Login_PassWord_Active()
	Cloud_Login_PassWord:SetProperty("DefaultEditBox", "True");
	Cloud_Login_ID:SetProperty("DefaultEditBox", "False");
end

-- ÑéÖ¤ÓÃ»§ÃûºÍÃÜÂë
function Cloud_Login_CheckAccount()
	-- ÍËµ½·þÎñÆ÷Ñ¡Ôñ½çÃæ
	local strName = Cloud_Login_ID:GetText();
	local strPassword = Cloud_Login_PassWord:GetText();
	local strTail, nIndex = Cloud_Login_Region:GetCurrentSelect();
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = Cloud_Login_Region:GetText();    --????,??GetCurrentSelect?bug,?????????????????????,??????????,??????????????????BugID:15422
	
	if(Variable:GetVariable("System_CodePage") == "1258") then
		strTail = "";
	end
	
	if( strName =="" ) then
		PushEvent( "GAMELOGIN_SHOW_SYSTEM_INFO", "#{DLLC_180306_124}" );
		return;
	end
	if( strPassword == "" ) then
		PushEvent( "GAMELOGIN_SHOW_SYSTEM_INFO", "#{DLLC_180306_125}" );
		return;
	end
		
  if nIndex and nIndex == -1 then
  	nIndex = 0
  end
  Variable:SetVariable("Account_MailIndex", tostring(nIndex), 0);
  
  --Èç¹ûÊÇÊÖ»úÄÇ¶«Î÷£»ÇåÀíºó×º
	if nIndex >= 6 and nIndex <= 8 then
		strTail = "";
	end
  
  GameProduceLogin:CheckAccount(strTail);

	-- ÊºÅÃÜÂëeditboxÊ§È¥ÊäÈë½¹µã
	Cloud_Login_Frame_OnHiden()
end

function Cloud_Login_LostPassWord()
	if(Variable:GetVariable("System_CodePage") == "1258") then
    GameProduceLogin:OpenURL(GetWeblink("WEB_CHANGEPWD"))
	else
    GameProduceLogin:OpenURL(GetWeblink("WEB_CHANGEPWD"))
	end
end

--¹Ø± ¶þÎ¬Âë½çÃæ
function Cloud_Login_QRCode_OnClosed()
	Cloud_Login_Tradition_MouseDown()
end

--Ë¢ÐÂ¶þÎ¬Âë
function Cloud_Login_ReFalshQRCode_OnClicked()
	GameProduceLogin:ReFalshQRCode()
end

--ÏÂÔØ³©ÓÎ+
function Cloud_Login_Download_CYJ_OnClicked()
	GameProduceLogin:OpenURL(GetWeblink("WEB_DOWNLOAD"))
end

function Cloud_Login_Frame_OnHiden()
	Cloud_Login_ID:SetProperty("DefaultEditBox", "False");
	Cloud_Login_PassWord:SetProperty("DefaultEditBox", "False");
end

function Cloud_Login_ShowQRCodeMessage( nMsgType )
	-- ÏÔÊ¾¶þÎ¬Âë³É¹¦
	if nMsgType == 0 then
		
	-- ¶þÎ¬ÂëÒÑ¹ýÆÚ£¬Çëµã»÷Ë¢ÐÂ¶þÎ¬Âë°´Å¥½øÐÐ¸üÐÂ¡£DLLC_170814_69
	elseif nMsgType == 1 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_170814_69}" );
		
	-- ¶þÎ¬Âë¸üÐÂÖÐ£¬ÇëÉÔºó¡£DLLC_180306_134
	elseif nMsgType == 2 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_180306_134}" );
		
	-- ¶þÎ¬Âë»ñÈ¡Ê§°Ü£¬Çëµã»÷Ë¢ÐÂ¶þÎ¬Âë°´Å¥ÖØÐÂ»ñÈ¡¡£DLLC_180306_135
	elseif nMsgType == 3 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_180306_135}" );
		
	-- ¶þÎ¬ÂëµÇÂ¼Òì³££¬ÇëÑ¡Ôñºó×ºµÇÂ¼·½Ê½»òÊäÈëºó×ºµÇÂ¼·½Ê½µÇÂ¼ÓÎÏ·¡£DLLC_180306_136
	elseif nMsgType == 4 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_180306_136}" );

	end
	
end

-----------------------------

-- ÊºÅ×¢²á
function Cloud_Login_AccountReg()
	GameProduceLogin:StartAccountReg()
end

--
function Cloud_Login_FollowClicked()
	Cloud_Login_JoinFrame:Hide();
	Cloud_Login_QRCodeFrame:Hide();
	Cloud_Login_ImageFrame:Hide();
 	Cloud_Login_Image2Frame:Show(); 	
end

function Cloud_Login_DesktopClicked()
	Cloud_Login_JoinFrame:Hide();
	Cloud_Login_QRCodeFrame:Hide();
	Cloud_Login_ImageFrame:Show();
 	Cloud_Login_Image2Frame:Hide();
end

function Cloud_Login_Image_OnClosed()
	if g_CloudLogin_IsQRCode == 1 then
		Cloud_Login_QRCodeLogin_MouseDown();
	else
		Cloud_Login_Tradition_MouseDown();
	end
	
end

function Cloud_Login_Image2_OnClosed()
	if g_CloudLogin_IsQRCode == 1 then
		Cloud_Login_QRCodeLogin_MouseDown();
	else
		Cloud_Login_Tradition_MouseDown();
	end
end

--ÉÏÒ»²½
function Cloud_Login_ExitToSelectServer()
	-- ÍËµ½·þÎñÆ÷Ñ¡Ôñ½çÃæ
	GameProduceLogin:ExitToSelectServer();
end

function Cloud_Login_ID_MouseEnter()
end

function Cloud_Login_PassWord_MouseEnter()
end

function Cloud_Login_Region_MouseEnter()
end

function Cloud_Login_RequisitionID_MouseEnter()
end

function Cloud_Login_Payment_MouseEnter()
end

function Cloud_Login_Last_MouseEnter()
end

function Cloud_Login_MouseLeave()
end

