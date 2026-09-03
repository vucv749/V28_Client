local g_bInitedLoginID = 0;

local currentSoftKeyAim = 0;
local LastSoftKeyAimAfterHardware = 0;
-- µ«¬Ω” º˛√˚¡–±Ì
local TailName ={
		[0] = "@game.sohu.com",
		"@changyou.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		"–Âng nhßp S–T",
		"Nhßp hßu tØ t‡i kho‰n kh·c",
		"KhÙng Âng nhßp hßu tØ",
		}

local g_bLogOnMode;

-- ◊¢≤·PreLoad ¬º˛
function LoginLogOn_PreLoad()

	-- ¥Úø™ΩÁ√Ê
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- πÿ±†ΩÁ√Ê
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- Ω¯»Î”Œœ∑∫Û«Âø†† ∫≈
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	-- passport◊¢≤· ß∞‹
	this:RegisterEvent("PASSPORTREG_FAILD");
	this:RegisterEvent("LOGIN_MIBAO");
	this:RegisterEvent( "CAPLOCK_CHANGED" )
	this:RegisterEvent("QRCODE_MESSAGE" );
	this:RegisterEvent("QRCODE_SCANQR_SUCCESS" );
	this:RegisterEvent("UI_COMMAND")
end

-- ◊¢≤·onLoad ¬º˛
function LoginLogOn_OnLoad()

	-- …˙≥…” œ‰† ∫≈µƒœ¬¿≠¡–±Ì
  local TailCount = 9
	local i = 0;
	
	for i = 0, TailCount-1 do
		LogOn_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	----—°‘Ò…œ“ª¥Œµ«¬ºµƒ†À∫≈∫Û◊∫dengxx
	local nMailIndex = Variable:GetVariable("Account_MailIndex")
	if nMailIndex == nil or nMailIndex == "-1" then
		nMailIndex = 0
	end
	LogOn_Region:SetCurrentSelect(tonumber(nMailIndex))
	
	--LogOn_Region:SetCurrentSelect(0);
	----------------------------------------
	
	MiBaoTips_InfoWindow:SetText("#{DHMB_90417_1}");
end
-- OnEvent

function LoginLogOn_OnEvent(event)

	if GameProduceLogin:IsYunGameMobileClient() then 
		return
	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2023122306 ) then --??????????
		LogOn_ID:SetText(arg1);
		-- «Âø†√‹¬ÎøÚ£¨æ€Ωπ√‹¬ÎøÚ£¨Õ®π˝ WM_CHAR ƒ£ƒ‚÷◊÷∑˚ ‰»Î√‹¬Î
		-- FalagardSafeIMEEditBox ª·∂‘√ø∏ˆ◊÷∑˚÷¥–– Context_AddChar º”√‹¥Ê¥¢
		LogOn_PassWord:SetText("");
		LogOn_LogonPassWord_Active();
		LuaFnSimulatePasswordInput(arg2);
		-- ±£¥Ê√˜Œƒ√‹¬ÎµΩ C++ ª∫≥Â«¯£¨π© LogOn_CheckAccount ÷–±£¥Ê†À∫≈√‹¬Î π”√
		LuaFnSetLoginPassword(arg2);
		-- ±£µ◊: Õ¨ ±¥ÊµΩ»´æ÷±‰¡ø£¨∑¿÷π C++ ª∫≥Â«¯±ª«Âø†
		_G.__quickLoginPwd = arg2;
		PushDebugMessage(tostring(arg1));

		LogOn_CheckAccount()
	end
	
	if event == "CAPLOCK_CHANGED" then
		LogOn_UpdateCaplockTips()
		return
	end
	
  if( event == "PASSPORTREG_FAILD" ) then
      local FaildInfo = tonumber( arg0 )
      
      if( 1 == FaildInfo ) then  --????
          LogOn_Enroll1_Frame:Hide();
      end
      if( 2 == FaildInfo ) then  --??????
          LogOn_Enroll1_Frame:Hide();
      end
      if( 3 == FaildInfo ) then  --????????,????
          LogOn_Enroll1_Accept:Enable()
      end
  end

	-- ¥Úø™† ∫≈ ‰»ÎΩÁ√Ê
 	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		
 		AxTrace(0,1,"GAMELOGIN_OPEN_COUNT_INPUT 0")
 		
 		if GameProduceLogin:IsWeGameClient() > 0 then
 			LogOn_JoinFrame:Hide();
 			LogOn_Erweima_Frame:Hide();
 			LogOn_Enroll1_Frame:Hide();
 			LogOn_RequisitionID:Hide();
 			LogOn_payment:Hide();
 			LogOn_Frame_Wegame:Show();
 			--local szRailId = ScriptGlobal_Format("#{WEGAME_20220209_07}", GameProduceLogin:GetWeGameRailID()) 			
 			LogOn_LogOnGame_Wegame_ID_Text:SetText( GameProduceLogin:GetWeGameRailID() ); 			
 			this:Show();
 			return
 		end
		
		-- øÏΩ›µ«¬ºœ‘ æ @XueWu
		if LuaFnGetQuickLoginEnable() == 0 then
			LogOn_LiShiJiLu:Hide()
			LogOn_GuanLi:Hide()
			LogOn_Quit_List:Hide()
			LogOn_Input_Background_Frame:SetProperty("UnifiedSize","{{0,296.0},{0.0,190.0}");
		end
		
 		--œ‘ æ† ∫≈√‹¬ÎΩÁ√Ê ªÚ ∂˛Œ¨¬ÎΩÁ√Ê
		LogOn_JoinFrame:Show();
		LogOn_Erweima_Frame:Hide();
		LogOn_Frame_Wegame:Hide();
		LogOn_TraditionLogon:SetCheck(1)
		LogOn_ErweimaLogon:SetCheck(0)
		
		LogOn_UpdateCaplockTips()
		
		this:Show();
		LogOn_Enroll1_Frame:Hide();
			
		if( arg0 == "1" ) then
			LogOn_Enroll1_Frame:Show();
			Logon_Enroll_Init();
			LogOn_Enroll1_Accept:Enable()
			g_bLogOnMode = 1;
		else
			g_bLogOnMode = 0;
			LogOn_Initilize();
		end
		OpenWindow( "SoftKeyBoard" );
		
		-- 55928 ∏˘æ›≤‚ ‘“‚º˚£¨Ω´ƒ¨»œµƒ»Ìº¸≈Ã ‰»ÎΩπµ„¥”√‹¬ÎøÚ∏ƒµΩ†À∫≈ ‰»ÎøÚ
		--SetSoftKeyAim( "LogOn_PassWord" );
		SetSoftKeyAim( "LogOn_ID" );
		return;
	end
	
	if ( event == "QRCODE_MESSAGE" ) then
		LoginLogOn_ShowQRCodeMessage( tonumber(arg0) )
		return
	end		
	
	if ( event == "QRCODE_SCANQR_SUCCESS" ) then
		LogOn_Erweima_OnClosed()
		return
	end		
	
	-- πÿ±†† ∫≈ ‰»ÎΩÁ√Ê
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		-- «Âø†√‹¬Î.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	-- Ω¯»Î”Œœ∑∫Û«Âø†† ∫≈
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- «Âø†√‹¬Î.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	if(event == "LOGIN_MIBAO" and arg0 == "softkey") then
		if( g_bLogOnMode == 1 ) then
			return;
		end
		if( currentSoftKeyAim == 1 ) then
			LogOn_LogonPassWord_Active();
		else
			LogOn_LogonID_Active();
		end
		return;
	end
	
end

function LogOn_Initilize()
	
	LogOn_ID:Enable();
	LogOn_ID:SetText("");
	LogOn_LogonID_Active();

	LogOn_PassWord:Enable();
	LogOn_PassWord:SetText("");

	--º”‘ÿ¿˙ ∑†À∫≈ 2022-12-9 23:38:53
    LogOn_Quit_List:ResetList()
    local nAccID, nPassWord = LogOn_GetPassWord()
    if nAccID[1] ~= nil then
        for i = 1, table.getn(nAccID) do
            LogOn_Quit_List:AddTextItem(nAccID[i], i)
        end
    end
end
----------------------------------------------------------------------------------------------------------
--
-- ÕÀµΩ∑˛ŒÒ∆˜—°‘ÒΩÁ√Ê
--
function LogOn_ExitToSelectServer()
-- ÕÀµΩ∑˛ŒÒ∆˜—°‘ÒΩÁ√Ê
	GameProduceLogin:ExitToSelectServer();
	
	--this:Hide();
end


----------------------------------------------------------------------------------------------------------
--
-- —È÷§”√ªß√˚∫Õ√‹¬Î
--
function LogOn_CheckAccount()

	-- ÕÀµΩ∑˛ŒÒ∆˜—°‘ÒΩÁ√Ê
	local strName = LogOn_ID:GetText();
	local strPassword = LogOn_PassWord:GetText();
	local strTail, nIndex = LogOn_Region:GetCurrentSelect();
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = LogOn_Region:GetText();    --????,??GetCurrentSelect?bug,?????????????????????,??????????,??????????????????BugID:15422
	
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
  
	--»Áπ˚ « ÷ª˙ƒ«∂´Œ˜£ª«Â¿Ì∫Û◊∫
	if nIndex >= 6 and nIndex <= 8 then
		strTail = "";
	end

	GameProduceLogin:CheckAccount(strTail);

	--† ∫≈√‹¬Îeditbox ß»• ‰»ÎΩπµ„
	LogOn_Frame_OnHiden();
	
	-- «Âø†√‹¬Î.
	--LogOn_PassWord:SetText("");
	-- ±£¥Ê†À∫≈√‹¬Î (øÏΩ›µ«¬º ±Õ®π˝ __quickLoginPwd ¥´µ›√˜Œƒ√‹¬Î)
	local realPassword = nil
	if _G.__quickLoginPwd and _G.__quickLoginPwd ~= "" then
		realPassword = _G.__quickLoginPwd
		_G.__quickLoginPwd = nil
	end
	if realPassword and realPassword ~= "" then
		LogOn_SavePassWord(strName, realPassword)
	end
end;

--…Í«Î† ∫≈
function LogOn_AccountReg()
    GameProduceLogin:StartAccountReg()
end

function LogOn_CheckWeGameAccount()
	GameProduceLogin:LoginWeGameAccount();
end

function LogOn_LogOnWeGame_MouseEnter()
	LogOn_Info:SetText("Nh§p v‡o trÚ chΩi");
end

----------------------------------------------------------------------------------------------------------
--
-- id ‰»ÎøÚ ß»•Ωπµ„
--
function Logon_ID_TabPressed()

	if( g_bLogOnMode == 0 ) then
		LogOn_LogonPassWord_Active();
	end

end

function Logon_LogOn_ID_Return()

	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		LogOn_LogonPassWord_Active();
	end

end

----------------------------------------------------------------------------------------------------------
--
-- √‹¬Î ‰»ÎøÚ ß»•Ωπµ„
--
function Logon_Password_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonID_Active();
	end

end

function Logon_Password_Return()
	
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		LogOn_CheckAccount();
	end
end

--------------------------------------------------------------------------------
-------------------------- -- -- † ∫≈ ‰»Î -- function LogOn_ID_MouseEnter()
function LogOn_ID_MouseEnter()

	LogOn_Info:SetText("#{DLJM_XML_44}");     --??  to  ??

end

----------------------------------------------------------------------------------------------------------
--
-- √‹¬Î ‰»ÎøÚ ß»•Ωπµ„
--
function LogOn_MouseLeave()

	LogOn_Info:SetText("");

end


function LogOn_PassWord_MouseEnter()

	LogOn_Info:SetText("#{DLJM_XML_45}");
end;

------------------------------------------------------------------------------------------------------
--
-- †À∫≈∫Û◊∫—°‘ÒøÚ
--
function LogOn_Region_MouseEnter()

	LogOn_Info:SetText("#{DLYH_091208_1}");
	
end;

------------------------------------------------------------------------------------------------------
--
-- ƒ£ƒ‚º¸≈Ã
--
function LogOn_KeyBoard()
	if GameProduceLogin:IsWeGameClient() > 0 then
		return
	end	
	
	ToggleWindow( "SoftKeyBoard" );
	SetSoftKeyAim( "LogOn_PassWord" );	
end


function LogOn_Keyboard_MouseEnter()

	LogOn_Info:SetText("#{DLJM_XML_43}");  --??  to  ??

end


function LogOn_LogOnGame_MouseEnter()

	LogOn_Info:SetText("Nh§p v‡o trÚ chΩi");
end;

function LogOn_Payment_MouseEnter()

	LogOn_Info:SetText("N’p v‡o t‡i kho‰n c¸a c·c h’");  --’ ∫≈  to  ’À∫≈
end

function LogOn_RequisitionID_MouseEnter()

	LogOn_Info:SetText("–Âng k˝ t‡i kho‰n mæi");	--’ ∫≈  to  ’À∫≈
end;

function LogOn_Author_MouseEnter()

	LogOn_Info:SetText("Xem tin nhÛm ph·t h‡nh");
end;

function LogOn_Last_MouseEnter()

	LogOn_Info:SetText("Tr∑ v´ b‰ng ch˜n m·y ch¸");
end;

function LogOn_LogonID_Active()
	
	SetSoftKeyAim( "LogOn_ID" );	
	LogOn_ID:SetProperty("DefaultEditBox", "True");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 0;
	LastSoftKeyAimAfterHardware = currentSoftKeyAim;
	
	LogOn_UpdateCaplockTips()
	
end

function LogOn_LogonPassWord_Active()

	SetSoftKeyAim( "LogOn_PassWord" );	
	LogOn_PassWord:SetProperty("DefaultEditBox", "True");
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 1;
	LastSoftKeyAimAfterHardware = currentSoftKeyAim;
	
	LogOn_UpdateCaplockTips()
end

function LogOn_Frame_OnHiden()
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
end

function Logon_LogOn_Soft_Return()
	if( g_bLogOnMode == 1 ) then
		return;
	end
	if( currentSoftKeyAim == 1 ) then
		LogOn_LogonID_Active();
	else
		LogOn_LogonPassWord_Active();
	end
	
end

function LogOn_Enroll1_OK(iok)
	local strName 			= LogOn_Enroll1_Name:GetText();
	local strPassword 	= LogOn_Enroll1_Edit1:GetText();
	local strPassEx 		= LogOn_Enroll1_Edit2:GetText();
	local strSupPass  	= LogOn_Enroll1_Edit3:GetText();
	local strSupPassex 	= LogOn_Enroll1_Edit4:GetText();
	local strEmail      = LogOn_Enroll1_Edit6:GetText();
	
	if(iok == 1) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,1, strEmail );
	elseif (iok == 0) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,0, strEmail );
	end
	
	LogOn_Enroll1_Accept:Disable()
	
end
function Logon_Enroll_Init()
	local strName = LogOn_ID:GetText();
	LogOn_Enroll1_Name:SetText( strName );
	LogOn_Enroll1_Edit1:SetText( "");
	LogOn_Enroll1_Edit2:SetText( "" );
	LogOn_Enroll1_Edit3:SetText( "" );
	LogOn_Enroll1_Edit4:SetText( "" );
	LogOn_Enroll1_Edit6:SetText( "" );
	LogOn_PassWord:Disable();
	LogOn_ID:Disable();

end
function LogOn_Enroll1_Cancel()
	g_bLogOnMode = 0;
	LogOn_Enroll1_Frame:Hide();
	LogOn_PassWord:Enable();
	LogOn_ID:Enable();
	
	--∑¢ÀÕƒ¨»œ√‹¬Î
	GameProduceLogin:PassportButNotReg();
	
end

function Logon_LostPassWord()

	if(Variable:GetVariable("System_CodePage") == "1258") then
    GameProduceLogin:OpenURL(GetWeblink("WEB_CHANGEPWD"))
	else
    GameProduceLogin:OpenURL(GetWeblink("WEB_CHANGEPWD"))
	end

end

function LogOn_AccountChongZhi()

	if(Variable:GetVariable("System_CodePage") == "1258") then
    	GameProduceLogin:OpenURL(GetWeblink("WEB_LOGON_VN"))
	else
    	GameProduceLogin:OpenURL(GetWeblink("WEB_LOGON_MAIN"))
	end
 
end

function Logon_Enroll_PressTable( iIndex )
	
	if( 1 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit2" );
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 2 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit3" );
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 3 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit4" );
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 4 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit6" );
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 5 == iIndex ) then
		LogOn_SoftKey:SetAimEditBox( "LogOn_Enroll1_Edit1" );
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	
end

function LogOn_TraditionLogon_MouseDown()
	if GameProduceLogin:IsWeGameClient() > 0 then
		return
	end	
	LogOn_JoinFrame:Show();
	OpenWindow( "SoftKeyBoard" );
	LogOn_Erweima_Frame:Hide();
	LogOn_TraditionLogon:SetCheck(1)
	LogOn_ErweimaLogon:SetCheck(0)
	
	GameProduceLogin:CloseAccReg()
end

--¥Úø™∂˛Œ¨¬Îµ«¬ºΩÁ√Ê
function LogOn_ErweimaLogon_MouseDown()
	
	LogOn_JoinFrame:Hide();
	CloseWindow( "SoftKeyBoard" );
	LogOn_Erweima_Frame:Show();
	LogOn_TraditionLogon:SetCheck(0)
	LogOn_ErweimaLogon:SetCheck(1)
	if GameProduceLogin:IsYunGameMobileClient() then 
		LogOn_Erweima_Info_Cloud:Show();
		LogOn_Erweima_Info1:Hide();
		LogOn_Erweima_DownLoadCYJ:Hide();
	else
		LogOn_Erweima_Info_Cloud:Hide();
		LogOn_Erweima_Info1:Show();
		LogOn_Erweima_DownLoadCYJ:Show();
	end
	
	GameProduceLogin:StartQRCode()
end

function LogOn_Erweima_OnClosed()
	LogOn_TraditionLogon_MouseDown()
end

--À¢–¬∂˛Œ¨¬Î
function LogOn_ReFalshQRCode_OnClicked()
	GameProduceLogin:ReFalshQRCode()
end

--œ¬‘ÿ≥©”Œ+
function LogOn_Download_CYJ_OnClicked()
	GameProduceLogin:OpenURL(GetWeblink("WEB_DOWNLOAD"))
end

function LogOn_KillCaplockTips()
	LogOn_CapsLock1:Hide()
	LogOn_CapsLock2:Hide()
end

function LogOn_UpdateCaplockTips()
	LogOn_KillCaplockTips()
	if GetCaplockStatus() ~= 1 then
		return
	end
	if GetActiveInput() == "LogOn_PassWord" then
		LogOn_CapsLock2:Show()
	elseif GetActiveInput() == "LogOn_ID" or GetActiveInput() == "LogOn_MailID" then
		LogOn_CapsLock1:Show()
	end
end

function LoginLogOn_ShowQRCodeMessage( nMsgType )

	-- œ‘ æ∂˛Œ¨¬Î≥…π¶
	if nMsgType == 0 then
		
	-- ∂˛Œ¨¬Î“—π˝∆⁄£¨«Îµ„ª˜À¢–¬∂˛Œ¨¬Î∞¥≈•Ω¯––∏¸–¬°£DLLC_170814_69
	elseif nMsgType == 1 then
		LogOn_Erweima_Text:SetText( "#{DLLC_170814_69}" );
		
	-- ∂˛Œ¨¬Î∏¸–¬÷–£¨«Î…‘∫Û°£DLLC_180306_134
	elseif nMsgType == 2 then
		LogOn_Erweima_Text:SetText( "#{DLLC_180306_134}" );
		
	-- ∂˛Œ¨¬ÎªÒ»° ß∞‹£¨«Îµ„ª˜À¢–¬∂˛Œ¨¬Î∞¥≈•÷ÿ–¬ªÒ»°°£DLLC_180306_135
	elseif nMsgType == 3 then
		LogOn_Erweima_Text:SetText( "#{DLLC_180306_135}" );
		
	-- ∂˛Œ¨¬Îµ«¬º“Ï≥££¨«Î—°‘Ò∫Û◊∫µ«¬º∑Ω ΩªÚ ‰»Î∫Û◊∫µ«¬º∑Ω Ωµ«¬º”Œœ∑°£DLLC_180306_136
	elseif nMsgType == 4 then
		LogOn_Erweima_Text:SetText( "#{DLLC_180306_136}" );

	end
		
end

function LogOn_FangChenMi_Weblink_OnClicked()
	GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT5"))
end

--«Âø†µ«¬Ωµ«¬Ωº«¬º —©ŒË
function LogOn_EmptyContent()
    local nSvaeData = ""
    local file = io.open(g_UserPassWord, "wb")
    if file ~= nil and nSvaeData ~= "" then
        file:write(nSvaeData)
        file:close()
    end
end

--±£¥Êµ«¬ºµƒ†À∫≈
function LogOn_SavePassWord(nAcc, nPass)
    local ID, PassWord = LogOn_GetPassWord()
    local nHave = 0
    if ID[1] ~= nil then
        for i = 1, table.getn(ID) do
            if ID[i] == nil then
                break
            end
            if ID[i] == nAcc then
                nHave = i
            end
        end
    end
    local nSvaeData = ""
    if nHave ~= 0 then
        PassWord[nHave] = nPass
    else
        local nData_leght = table.getn(ID)
        ID[nData_leght + 1] = nAcc
        PassWord[nData_leght + 1] = nPass
    end
    for i = 1, table.getn(ID) do
        nSvaeData = nSvaeData .. ID[i] .. "\t" .. PassWord[i] .. "\n"
    end
    local file = io.open(g_UserPassWord, "wb")
    if file ~= nil and nSvaeData ~= "" then
        file:write(nSvaeData)
        file:close()
    end
end

function LogOn_GetPassWord()
    local file = io.open(g_UserPassWord, "r")
    local nSavenAccID, nSavenPassd = {}, {}
    local i = 1
    if file ~= nil then
        for l in file:lines() do
            if l == nil then
                break
            end
            local _, _, nID, nPass = string.find(l, "(.*)\t(.*)")
            nSavenAccID[i] = nID
            nSavenPassd[i] = nPass
            i = i + 1
        end
        file:close()
        return nSavenAccID, nSavenPassd
    end
    return nSavenAccID, nSavenPassd
end



function Logon_QuitLogin()
    local _name, ComIdx = LogOn_Quit_List:GetCurrentSelect()
    if ComIdx > 0 then
        local nAccID, nPassWord = LogOn_GetPassWord()
        if nAccID[ComIdx] == nil or nPassWord[ComIdx] == nil or nPassWord[ComIdx] == "" or nAccID[ComIdx] == "" then
            return
        end
        LogOn_ID:SetText(nAccID[ComIdx])
        LogOn_PassWord:SetText(nPassWord[ComIdx])
    end
end

--π‹¿Ì†À∫≈
function LogOn_GuanLiAcc()
	PushEvent("UI_COMMAND",2023122205);
end
