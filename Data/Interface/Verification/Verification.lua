--Verification
local g_Verification_SecurityCodeTime = 0;
local g_Verification_BindPhone = 0;

function Verification_PreLoad()
	this:RegisterEvent("CREATECHAR_SMSCODE_UI");
	this:RegisterEvent("CREATECHAR_SMSCODE_GETCODE",false)
	this:RegisterEvent("CREATECHAR_SMSCODE_APPROVE",false)
end

function Verification_OnLoad()
end

function Verification_OnEvent(event)
	if (event == "CREATECHAR_SMSCODE_UI") then
		if ( tonumber(arg0) == 1 ) then
			Verification_Show( tonumber(arg1) )
		else
			Verification_Close()
		end
		return 
	
	-- ÷ª˙»œ÷§-ªÒ»°—È÷§¬Î
	elseif (event == "CREATECHAR_SMSCODE_GETCODE" ) then
		if ( tonumber(arg0) == 1 ) then
			PushDebugMessage("#{CJYZ_20231214_12}");
		else
			Verification_HeChengNum_GetCode_Msg(tonumber(arg1));
		end		
	
	-- ÷ª˙»œ÷§-»œ÷§
	elseif (event == "CREATECHAR_SMSCODE_APPROVE" ) then
		if ( tonumber(arg0) == 1 ) then
			this:Hide();
		else
			Verification_Approve_Msg(tonumber(arg1));
		end
	end
		
end

function Verification_Show( bBindPhone )
	g_Verification_BindPhone = bBindPhone
	if g_Verification_BindPhone == 0 then
		Verification_HeChengNum:SetProperty("MaxTextLength", "20")
		Verification_HeChengNum:SetText("TrÚ chΩi t‡i kho‰n chﬂa ch—ng thÒc di µng");
		Verification_HeChengNum:Disable();
		Verification_HeChengNum_Get:Disable();
	elseif g_Verification_BindPhone == 1 then
		Verification_HeChengNum:SetProperty("MaxTextLength", "20")
		Verification_HeChengNum:SetText("H„y nhßp tin nh°n m„ ki¨m ch—ng.");
		Verification_HeChengNum:Enable();
		Verification_HeChengNum_Get:Enable();
	end
	
	Verification_HeChengNum_Get:SetText("#{CJYZ_20231214_4}")
	Verification_HeChengNum_Text:Hide();
	Verification_OK:Disable();
		
	this:Show()
end

function Verification_Close()
	this:Hide()
end

--µ√µΩ—È÷§¬Î
function Verification_OnMaxNum()
	if g_Verification_BindPhone == 0 then   --?????
		PushDebugMessage("#{CJYZ_20231214_7}");
		return
	end
	
	GameProduceLogin:LoginSMSCodeGetCode();
	
	Verification_HeChengNum:SetProperty("DefaultEditBox", "True");
	Verification_OnActive();
	Verification_HeChengNum_Get:Disable();
	g_Verification_SecurityCodeTime = 60;
	Verification_ApproveTimerProc();
	Verification_HeChengNum_Text:Show();
	KillTimer( "Verification_ApproveTimerProc()" );
	SetTimer("Verification","Verification_ApproveTimerProc()", 1000)
end

--—È÷§
function Verification_OK_Click()
	if g_Verification_BindPhone == 0 then   --?????
		PushDebugMessage("#{CJYZ_20231214_28}")
		return
	end
	
	local szText = Verification_HeChengNum:GetText();
	local nCode = tonumber(szText);
	if nCode == nil then
		PushDebugMessage("#{CJYZ_20231214_13}")
		return
	end
	
	local nCodeLen = string.len(szText)
	if nCodeLen ~= 6 then
		PushDebugMessage("#{CJYZ_20231214_14}")
		return
	end
	
	GameProduceLogin:LoginSMSCodeApprove( tostring(szText) );
end

function Verification_OnActive()
	if g_Verification_BindPhone == 0 then   --????
		return
	end
	
	local szText = Verification_HeChengNum:GetText();
	if tonumber(szText) == nil then
		Verification_HeChengNum:SetText("");
		Verification_HeChengNum:SetProperty("MaxTextLength", "6")
	end
end

function Verification_OnNumChanged()
	if g_Verification_BindPhone == 0 then   --?????
		return
	end
	
	local szText = Verification_HeChengNum:GetText();
	if tonumber(szText) ~= nil then
		Verification_OK:Enable();
	end
end

function Verification_Modify()
	GameProduceLogin:OpenURL(GetWeblink("WEB_CTU"))
end

function Verification_ApproveTimerProc()
	local strBtnText = ScriptGlobal_Format( "#{CJYZ_20231214_5}", g_Verification_SecurityCodeTime )
	g_Verification_SecurityCodeTime = g_Verification_SecurityCodeTime -1;
	if g_Verification_SecurityCodeTime < 0 then
		Verification_HeChengNum_Get:SetText( "#{CJYZ_20231214_4}" )
		Verification_HeChengNum_Get:Enable();
		Verification_HeChengNum_Text:Hide();
		KillTimer( "Verification_ApproveTimerProc()" );
		return
	end
	Verification_HeChengNum_Text:SetText( strBtnText )
end

function Verification_HeChengNum_GetCode_Msg( nErrCode )

	if nErrCode == 3 then
		PushDebugMessage( "#{CJYZ_20231214_7}");
	elseif nErrCode == 8 then
		PushDebugMessage( "#{CJYZ_20231214_25}");
	elseif nErrCode == 7 then
		PushDebugMessage( "#{CJYZ_20231214_27}");
	elseif nErrCode == 5 then
		PushDebugMessage( "#{CJYZ_20231214_11}");
	elseif nErrCode == 4 then
		PushDebugMessage( "#{CJYZ_20231214_26}");	
	else
		local strMsg =	ScriptGlobal_Format( "#{CJYZ_20231214_17}", nErrCode)	
		PushDebugMessage(strMsg);
	end
		
end

function Verification_Approve_Msg( nErrCode )

	if nErrCode == 6 then
		PushDebugMessage( "#{CJYZ_20231214_14}");
	elseif nErrCode == 9 then
		PushDebugMessage( "#{CJYZ_20231214_15}");
	elseif nErrCode == 5 then
		PushDebugMessage( "#{CJYZ_20231214_11}");
	end
	
end
