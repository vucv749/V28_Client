--SMSCode
local g_SMSCode_UnifiedPosition;
local g_SMSCode_SecurityCodeTime = 0;
local g_SMSCode_Status = 0;
local g_SMSCode_BindPhone = 0;

function SMSCode_PreLoad()
	this:RegisterEvent("OPEN_SMSCODE");
	this:RegisterEvent("CLOSE_SMSCODE");
	this:RegisterEvent("SMSCODE_SECURITYCODE")
	this:RegisterEvent("SMSCODE_APPROVE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SMSCode_OnLoad()
	g_SMSCode_UnifiedPosition=SMSCode_Frame:GetProperty("UnifiedPosition")
	
end

function SMSCode_OnEvent(event)
	if (event == "OPEN_SMSCODE") then
		SMSCode_Show( tonumber(arg0) )
		return 
		
	elseif (event == "CLOSE_SMSCODE") then
		this:Hide();
		return 
	
	--手机认证-获取验证码
	elseif (event == "SMSCODE_SECURITYCODE" ) then
		if ( tonumber(arg0) == 1 ) then
			PushDebugMessage("#{GZSZH_230427_09}");
			SMSCode_Get:SetText("#{YZGN_230830_22}");
			SMSCode_Get:Enable();
			g_SMSCode_Status = 1
		else
			PushDebugMessage("#{GZSZH_231214_1}");
			this:Hide();
		end		
	
	--手机认证-认证
	elseif (event == "SMSCODE_APPROVE" ) then
		if ( tonumber(arg0) == 1 ) then
			PushDebugMessage("#{GZSZH_230427_12}");
		else
			PushDebugMessage("#{GZSZH_230427_11}");
		end
	end
		
	if (event == "ADJEST_UI_POS") then
		SMSCode_On_ResetPos()
		return
	end
	
	if (event == "VIEW_RESOLUTION_CHANGED") then
		SMSCode_On_ResetPos()
		return
	end

end

function SMSCode_Show( bBindPhone )
	g_SMSCode_BindPhone = bBindPhone
	if g_SMSCode_BindPhone == 0 then
		SMSCode_Edit:SetProperty("MaxTextLength", "20")
		SMSCode_Edit:SetText("游戏账号尚未认证手机");
	elseif g_SMSCode_BindPhone == 1 then
		SMSCode_Edit:SetProperty("MaxTextLength", "20")
		SMSCode_Edit:SetText("请点击获取验证码按钮");
	end
	SMSCode_Get:SetText("#{YZGN_230830_21}");	
	SMSCode_Get:Enable();
	g_SMSCode_Status = 0;
	
	--倒计时
	g_SMSCode_SecurityCodeTime = 120;
	SMSCode_ApproveTimerProc()
	KillTimer( "SMSCode_ApproveTimerProc()" );
	SetTimer("SMSCode","SMSCode_ApproveTimerProc()", 1000)
	
	this:Show()
end

--得到验证码
function SMSCode_OnGetPhoneTextClicked()
	if g_SMSCode_BindPhone == 0 then   --未绑定状态
		return
	end
	
	if g_SMSCode_Status == 0 then
		DataPool:GetSMSCodeSecurityCode()
		SMSCode_Get:Disable();
		SMSCode_Edit:SetProperty("DefaultEditBox", "True");
		SMSCode_InputCode_OnActived();
	else
		local szText = SMSCode_Edit:GetText();
		local nCode = tonumber(szText);
		if nCode == nil then
			PushDebugMessage("#{GZSZH_230427_11}")
			return
		end
		DataPool:DoSMSCodeMobileApprove( tostring(szText) )
		--this:Hide()
	end
	
end

function SMSCode_InputCode_OnActived()
	local szText = SMSCode_Edit:GetText();
	if tonumber(szText) == nil then
		SMSCode_Edit:SetText("");
		SMSCode_Edit:SetProperty("MaxTextLength", "6")
	end
end

function SMSCode_ApproveTimerProc()
	local strBtnText = ScriptGlobal_Format( "#{YZGN_230830_24}", g_SMSCode_SecurityCodeTime )
	g_SMSCode_SecurityCodeTime = g_SMSCode_SecurityCodeTime -1;
	if g_SMSCode_SecurityCodeTime < 0 then
		this:Hide();
		return
	end
	SMSCode_TimeLeft:SetText( strBtnText )
end

function SMSCode_SecurityCode_Msg( nErrCode )

	if nErrCode == 6 then		--一天50次超限制
		PushDebugMessage( "#{SJRZ_180827_29}");
	elseif nErrCode == 88 then --海外短信发送功能被关闭
		PushDebugMessage( "#{SJRZ_180827_30}")
	elseif nErrCode == 90 then --手机号处于黑名单
		PushDebugMessage( "#{SJRZ_180827_31}")
	elseif nErrCode == 98 then --服务器IP不在白名单中或者发送短信的IP受限
		PushDebugMessage( "#{SJRZ_180827_32}")
	else
		local strMsg =	ScriptGlobal_Format( "#{SJRZ_180827_28}", nErrCode)	
		PushDebugMessage(strMsg);
	end
	
end

function SMSCode_On_ResetPos()
  SMSCode_Frame:SetProperty("UnifiedPosition", g_SMSCode_UnifiedPosition);
end

function SMSCode_OnHide()
	KillTimer( "SMSCode_ApproveTimerProc()" );
end

function SMSCode_OnChangePhoneClicked()
	GameProduceLogin:OpenURL(GetWeblink("WEB_CTU"))
end
