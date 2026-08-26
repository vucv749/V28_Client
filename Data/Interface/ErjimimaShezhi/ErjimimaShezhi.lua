
local g_ErjimimaShezhi_Frame_UnifiedXPosition;
local g_ErjimimaShezhi_Frame_UnifiedYPosition;
function ErjimimaShezhi_PreLoad()
	-- 打开界面
	this:RegisterEvent("MINORPASSWORD_OPEN_SET");
	this:RegisterEvent("MINORPASSWORD_CLEAR_PASSWORD_DLG");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


function ErjimimaShezhi_OnLoad()

g_ErjimimaShezhi_Frame_UnifiedXPosition	= ErjimimaShezhi_Frame:GetProperty("UnifiedXPosition");
g_ErjimimaShezhi_Frame_UnifiedYPosition	= ErjimimaShezhi_Frame:GetProperty("UnifiedYPosition");

end

function ErjimimaShezhi_OnEvent( event )
	if(event == "MINORPASSWORD_OPEN_SET") then

		if( this:IsVisible() ) then
			return;
		end
		CloseWindow("SafeTime" , true)
		CloseWindow("ErjimimaXiugai", true)
		CloseWindow("ErjimimaJiesuo", true)
		CloseWindow("Fangdao", true)
		CloseWindow("DianhuaMibao", true)
		
		local safeTimePos = Variable:GetVariable("SafeTimePos");
		if(safeTimePos ~= nil) then
			ErjimimaShezhi_Frame:SetProperty("UnifiedPosition", safeTimePos);
		end

		this:Show();
		ErjimimaShezhi_Shuru:SetText( "" );
		ErjimimaShezhi_Queren:SetText( "" );

		ErjimimaShezhi_SoftKey:SetAimEditBox( "ErjimimaShezhi_Shuru" );

	elseif(event == "MINORPASSWORD_CLEAR_PASSWORD_DLG") then 
	
		ErjimimaShezhi_Shuru:SetText( "" );
		ErjimimaShezhi_Queren:SetText( "" );
	elseif( event == "ADJEST_UI_POS" ) then
		ErjimimaShezhi_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ErjimimaShezhi_ResetPos()
	end

end

function ErjimimaShezhi_Shuru_OnActive()
	ErjimimaShezhi_SoftKey:SetAimEditBox( "ErjimimaShezhi_Shuru" );
end
function ErjimimaShezhi_Queren_OnActive()
	ErjimimaShezhi_SoftKey:SetAimEditBox( "ErjimimaShezhi_Queren" );
end

function ErjimimaShezhi_Close()
	Variable:SetVariable("SafeTimePos", ErjimimaShezhi_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function ErjimimaShezhi_OnHide()
	Variable:SetVariable("SafeTimePos", ErjimimaShezhi_Frame:GetProperty("UnifiedPosition"), 1);
end

function ErjimimaShezhi_OK_Click()
	local strPassword1 = ErjimimaShezhi_Shuru:GetText();
	local strPassword2 = ErjimimaShezhi_Queren:GetText();
	
	-- 如果密码不一致
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("密码输入不一致！");
		ErjimimaShezhi_Shuru:SetText( "" );
		ErjimimaShezhi_Queren:SetText( "" );
		return;
	end;
	
	local iLen = string.len(strPassword1);
	if(iLen < 4) then
	
		ShowSystemTipInfo("密码不能少于4个字符！");
		return;
	end;
	
	-- 如果密码一致。发送改变密码消息。
	SendSetMinorPassword(tostring(strPassword1));
	this:Hide();
end

function ErjimimaShezhi_ResetPos()
	ErjimimaShezhi_Frame:SetProperty("UnifiedXPosition", g_ErjimimaShezhi_Frame_UnifiedXPosition);
	ErjimimaShezhi_Frame:SetProperty("UnifiedYPosition", g_ErjimimaShezhi_Frame_UnifiedYPosition);

end
