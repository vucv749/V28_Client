--Cload_Login

-- 登陆邮件名列表
local TailName ={
		[0] = "@changyou.com",
		"@game.sohu.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		"手机号码登录",
		"输入其他账号后缀",
		"无后缀账号登录",
		}
		
local g_CloudLogin_IsQRCode = 0;

--===============================================
-- PreLoad()
--===============================================
function Cloud_Login_PreLoad()

	-- 打开界面
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- 进入游戏后清空帐号
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	this:RegisterEvent("QRCODE_MESSAGE" );
	this:RegisterEvent("QRCODE_SCANQR_SUCCESS" );
	
end

--===============================================
-- OnLoad()
--===============================================
function Cloud_Login_OnLoad()

	-- 生成邮箱帐号的下拉列表
  local TailCount = 9
	local i = 0;
	
	for i = 0, TailCount-1 do
		Cloud_Login_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	----选择上一次登录的账号后缀dengxx
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

	-- 打开帐号输入界面
 	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		
		if not GameProduceLogin:IsYunGameMobileClient() then 
			return
		end
		
 		--显示帐号密码界面
		Cloud_Login_Tradition_MouseDown()
		Cloud_Login_Initilize();
		this:Show();
		
		return;
	end
	
	-- 关闭帐号输入界面
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		Cloud_Login_PassWord:SetText("");
		Cloud_Login_ID:SetText("");
		this:Hide();
		return;
	end
	
	-- 进入游戏后清空帐号
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- 清空密码.
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

--点击 输入后缀登录
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

--点击 二维码登录
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

-- 验证用户名和密码
function Cloud_Login_CheckAccount()
	-- 退到服务器选择界面
	local strName = Cloud_Login_ID:GetText();
	local strPassword = Cloud_Login_PassWord:GetText();
	local strTail, nIndex = Cloud_Login_Region:GetCurrentSelect();
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = Cloud_Login_Region:GetText();    --暂时修改,因为GetCurrentSelect的bug,导致在某些操作的时候不能正确取得当前的选择,而界面底层正在修改中,暂时用此函数解决用户名后缀为空的问题BugID:15422
	
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
	Cloud_Login_Frame_OnHiden()
end

function Cloud_Login_LostPassWord()
	if(Variable:GetVariable("System_CodePage") == "1258") then
    GameProduceLogin:OpenURL(GetWeblink("WEB_CHANGEPWD"))
	else
    GameProduceLogin:OpenURL(GetWeblink("WEB_CHANGEPWD"))
	end
end

--关闭二维码界面
function Cloud_Login_QRCode_OnClosed()
	Cloud_Login_Tradition_MouseDown()
end

--刷新二维码
function Cloud_Login_ReFalshQRCode_OnClicked()
	GameProduceLogin:ReFalshQRCode()
end

--下载畅游+
function Cloud_Login_Download_CYJ_OnClicked()
	GameProduceLogin:OpenURL(GetWeblink("WEB_DOWNLOAD"))
end

function Cloud_Login_Frame_OnHiden()
	Cloud_Login_ID:SetProperty("DefaultEditBox", "False");
	Cloud_Login_PassWord:SetProperty("DefaultEditBox", "False");
end

function Cloud_Login_ShowQRCodeMessage( nMsgType )
	-- 显示二维码成功
	if nMsgType == 0 then
		
	-- 二维码已过期，请点击刷新二维码按钮进行更新。DLLC_170814_69
	elseif nMsgType == 1 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_170814_69}" );
		
	-- 二维码更新中，请稍后。DLLC_180306_134
	elseif nMsgType == 2 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_180306_134}" );
		
	-- 二维码获取失败，请点击刷新二维码按钮重新获取。DLLC_180306_135
	elseif nMsgType == 3 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_180306_135}" );
		
	-- 二维码登录异常，请选择后缀登录方式或输入后缀登录方式登录游戏。DLLC_180306_136
	elseif nMsgType == 4 then
		Cloud_Login_QRCode_Text:SetText( "#{DLLC_180306_136}" );

	end
	
end

-----------------------------

--帐号注册
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

--上一步
function Cloud_Login_ExitToSelectServer()
	-- 退到服务器选择界面
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

