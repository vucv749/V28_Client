local g_bInitedLoginID = 0;

local currentSoftKeyAim = 0;
local LastSoftKeyAimAfterHardware = 0;
-- 登陆邮件名列表
local TailName ={
		[0] = "@game.sohu.com",
		"@changyou.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		"手机号码登录",
		"输入其他账号后缀",
		"无后缀账号登录",
		}

local g_bLogOnMode;

-- 注册PreLoad事件
function LoginLogOn_PreLoad()

	-- 打开界面
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- 进入游戏后清空帐号
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	-- passport注册失败
	this:RegisterEvent("PASSPORTREG_FAILD");
	this:RegisterEvent("LOGIN_MIBAO");
	this:RegisterEvent( "CAPLOCK_CHANGED" )
	this:RegisterEvent("QRCODE_MESSAGE" );
	this:RegisterEvent("QRCODE_SCANQR_SUCCESS" );
	this:RegisterEvent("UI_COMMAND")
end

-- 注册onLoad事件
function LoginLogOn_OnLoad()

	-- 生成邮箱帐号的下拉列表
  local TailCount = 9
	local i = 0;
	
	for i = 0, TailCount-1 do
		LogOn_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	----选择上一次登录的账号后缀dengxx
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
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2023122306 ) then --快捷登录自动填入账号
		LogOn_ID:SetText(arg1);
		-- 清空密码框，聚焦密码框，通过 WM_CHAR 模拟逐字符输入密码
		-- FalagardSafeIMEEditBox 会对每个字符执行 Context_AddChar 加密存储
		LogOn_PassWord:SetText("");
		LogOn_LogonPassWord_Active();
		LuaFnSimulatePasswordInput(arg2);
		-- 保存明文密码到 C++ 缓冲区，供 LogOn_CheckAccount 中保存账号密码使用
		LuaFnSetLoginPassword(arg2);
		-- 保底: 同时存到全局变量，防止 C++ 缓冲区被清空
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
      
      if( 1 == FaildInfo ) then  --注册失败
          LogOn_Enroll1_Frame:Hide();
      end
      if( 2 == FaildInfo ) then  --注册已经存在
          LogOn_Enroll1_Frame:Hide();
      end
      if( 3 == FaildInfo ) then  --某些信息填写错误,允许重填
          LogOn_Enroll1_Accept:Enable()
      end
  end

	-- 打开帐号输入界面
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
		
		-- 快捷登录显示 @XueWu
		if LuaFnGetQuickLoginEnable() == 0 then
			LogOn_LiShiJiLu:Hide()
			LogOn_GuanLi:Hide()
			LogOn_Quit_List:Hide()
			LogOn_Input_Background_Frame:SetProperty("UnifiedSize","{{0,296.0},{0.0,190.0}");
		end
		
 		--显示帐号密码界面 或 二维码界面
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
		
		-- 55928 根据测试意见，将默认的软键盘输入焦点从密码框改到账号输入框
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
	
	-- 关闭帐号输入界面
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		-- 清空密码.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	-- 进入游戏后清空帐号
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- 清空密码.
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

	--加载历史账号 2022-12-9 23:38:53
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
-- 退到服务器选择界面
--
function LogOn_ExitToSelectServer()
-- 退到服务器选择界面
	GameProduceLogin:ExitToSelectServer();
	
	--this:Hide();
end


----------------------------------------------------------------------------------------------------------
--
-- 验证用户名和密码
--
function LogOn_CheckAccount()

	-- 退到服务器选择界面
	local strName = LogOn_ID:GetText();
	local strPassword = LogOn_PassWord:GetText();
	local strTail, nIndex = LogOn_Region:GetCurrentSelect();
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = LogOn_Region:GetText();    --暂时修改,因为GetCurrentSelect的bug,导致在某些操作的时候不能正确取得当前的选择,而界面底层正在修改中,暂时用此函数解决用户名后缀为空的问题BugID:15422
	
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
  
	--如果是手机那东西；清理后缀
	if nIndex >= 6 and nIndex <= 8 then
		strTail = "";
	end

	GameProduceLogin:CheckAccount(strTail);

	--帐号密码editbox失去输入焦点
	LogOn_Frame_OnHiden();
	
	-- 清空密码.
	--LogOn_PassWord:SetText("");
	-- 保存账号密码 (快捷登录时通过 __quickLoginPwd 传递明文密码)
	local realPassword = nil
	if _G.__quickLoginPwd and _G.__quickLoginPwd ~= "" then
		realPassword = _G.__quickLoginPwd
		_G.__quickLoginPwd = nil
	end
	if realPassword and realPassword ~= "" then
		LogOn_SavePassWord(strName, realPassword)
	end
end;

--申请帐号
function LogOn_AccountReg()
    GameProduceLogin:StartAccountReg()
end

function LogOn_CheckWeGameAccount()
	GameProduceLogin:LoginWeGameAccount();
end

function LogOn_LogOnWeGame_MouseEnter()
	LogOn_Info:SetText("点击登入游戏");
end

----------------------------------------------------------------------------------------------------------
--
-- id输入框失去焦点
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
-- 密码输入框失去焦点
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
-------------------------- -- -- 帐号输入 -- function LogOn_ID_MouseEnter()
function LogOn_ID_MouseEnter()

	LogOn_Info:SetText("#{DLJM_XML_44}");     --帐号  to  账号

end

----------------------------------------------------------------------------------------------------------
--
-- 密码输入框失去焦点
--
function LogOn_MouseLeave()

	LogOn_Info:SetText("");

end


function LogOn_PassWord_MouseEnter()

	LogOn_Info:SetText("#{DLJM_XML_45}");
end;

------------------------------------------------------------------------------------------------------
--
-- 账号后缀选择框
--
function LogOn_Region_MouseEnter()

	LogOn_Info:SetText("#{DLYH_091208_1}");
	
end;

------------------------------------------------------------------------------------------------------
--
-- 模拟键盘
--
function LogOn_KeyBoard()
	if GameProduceLogin:IsWeGameClient() > 0 then
		return
	end	
	
	ToggleWindow( "SoftKeyBoard" );
	SetSoftKeyAim( "LogOn_PassWord" );	
end


function LogOn_Keyboard_MouseEnter()

	LogOn_Info:SetText("#{DLJM_XML_43}");  --帐号  to  账号

end


function LogOn_LogOnGame_MouseEnter()

	LogOn_Info:SetText("点击登入游戏");
end;

function LogOn_Payment_MouseEnter()

	LogOn_Info:SetText("为您的账号充值");  --帐号  to  账号
end

function LogOn_RequisitionID_MouseEnter()

	LogOn_Info:SetText("申请一个新账号");	--帐号  to  账号
end;

function LogOn_Author_MouseEnter()

	LogOn_Info:SetText("查看游戏开发团队信息");
end;

function LogOn_Last_MouseEnter()

	LogOn_Info:SetText("返回服务器选择列表");
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
	
	--发送默认密码
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

--打开二维码登录界面
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

--刷新二维码
function LogOn_ReFalshQRCode_OnClicked()
	GameProduceLogin:ReFalshQRCode()
end

--下载畅游+
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

	-- 显示二维码成功
	if nMsgType == 0 then
		
	-- 二维码已过期，请点击刷新二维码按钮进行更新。DLLC_170814_69
	elseif nMsgType == 1 then
		LogOn_Erweima_Text:SetText( "#{DLLC_170814_69}" );
		
	-- 二维码更新中，请稍后。DLLC_180306_134
	elseif nMsgType == 2 then
		LogOn_Erweima_Text:SetText( "#{DLLC_180306_134}" );
		
	-- 二维码获取失败，请点击刷新二维码按钮重新获取。DLLC_180306_135
	elseif nMsgType == 3 then
		LogOn_Erweima_Text:SetText( "#{DLLC_180306_135}" );
		
	-- 二维码登录异常，请选择后缀登录方式或输入后缀登录方式登录游戏。DLLC_180306_136
	elseif nMsgType == 4 then
		LogOn_Erweima_Text:SetText( "#{DLLC_180306_136}" );

	end
		
end

function LogOn_FangChenMi_Weblink_OnClicked()
	GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT5"))
end

--清空登陆登陆记录 雪舞
function LogOn_EmptyContent()
    local nSvaeData = ""
    local file = io.open(g_UserPassWord, "wb")
    if file ~= nil and nSvaeData ~= "" then
        file:write(nSvaeData)
        file:close()
    end
end

--保存登录的账号
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

--管理账号
function LogOn_GuanLiAcc()
	PushEvent("UI_COMMAND",2023122205);
end
