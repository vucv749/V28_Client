function SetMinorPassword_PreLoad()
	
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("MINORPASSWORD_OPEN_SET_PASSWORD_DLG");

	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	
end

function SetMinorPassword_OnLoad()

end

-- OnEvent
function SetMinorPassword_OnEvent(event)
	 		
	if( event == "MINORPASSWORD_OPEN_SET_PASSWORD_DLG" ) then
	
		this:Show();
		
		SetMinorPassword_EditBox1:SetText( "" );
		SetMinorPassword_EditBox2:SetText( "" );
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "SetMinorPassword_EditBox1" );
	
	end;	

	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide();
	end
	
end;
function SetMinorPassword_EditBox1_OnActive()
	SetSoftKeyAim( "SetMinorPassword_EditBox1" );
end
function SetMinorPassword_EditBox2_OnActive()
	SetSoftKeyAim( "SetMinorPassword_EditBox2" );
end
---------------------------------------------------------------------------------------------------------
--
-- È·¶¨ÉèÖÃÃÜÂë
--
function SetMinorPassword_OK()

	local strPassword1 = SetMinorPassword_EditBox1:GetText();
	local strPassword2 = SetMinorPassword_EditBox2:GetText();
	
	-- Èç¹ûÃÜÂë²»Ò»ÖÂ
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("M§t mã ðßa vào không ð°ng nh¤t Trí!");
		return;
	end;
	
	local iLen = string.len(strPassword1);
	if(iLen < 4) then
	
		ShowSystemTipInfo("M§t mã không th¬ Thi¬u Vu 4Cá tñ phù!");
		return;
	end;
	
	--AxTrace(0, 0, "ÃÜÂë³¤¶È"..tostring(iLen));
	-- Èç¹ûÃÜÂëÒ»ÖÂ¡£·¢ËÍ¸Ä±äÃÜÂëÏûÏ¢¡£
	SendSetMinorPassword(tostring(strPassword1));
	this:Hide();
	
end;


---------------------------------------------------------------------------------------------------------
--
-- È¡ÏûÉèÖÃÃÜÂë
--
function SetMinorPassword_Exit()


	this:Hide();
end;

function SetMinorPassword_Frame_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end
