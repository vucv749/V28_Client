





-------------------------------------------------------------------------------------------------------
--
-- ×¢²áÊÂ¼þ
--
function ChangeMinorPassword_PreLoad()
	
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("MINORPASSWORD_OPEN_CHANGE_PASSWORD_DLG");
	this:RegisterEvent("MINORPASSWORD_CLEAR_PASSWORD_DLG");
end

function ChangeMinorPassword_OnLoad()
end


--===============================================
-- OnEvent()
--===============================================
function ChangeMinorPassword_OnEvent(event)

	if(event == "MINORPASSWORD_OPEN_CHANGE_PASSWORD_DLG") then
		this:Show();
		ChangeMinorPassword_EditBox1:SetText( "" );
		ChangeMinorPassword_EditBox2:SetText( "" );
		ChangeMinorPassword_EditBox3:SetText( "" );
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "ChangeMinorPassword_EditBox1" );
	elseif(event == "MINORPASSWORD_CLEAR_PASSWORD_DLG") then 
	
		ClearPassword_Box();
	end	
		
end	

function ChangeMinorPassword_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end


-------------------------------------------------------------------------------------------------------
--
-- µã»÷È·ÈÏÉèÖÃ¶þ¼¶±£»¤ÃÜÂë°´Å¥¡£
--
function ChangeMinorPassword_SetPassword()
	
	-- ¾ÉµÄÃÜÂë
	local strPasswordOld = ChangeMinorPassword_EditBox1:GetText();
	
	-- ÐÂµÄÃÜÂë¡£
	local strPassword1 = ChangeMinorPassword_EditBox2:GetText(); 
	local strPassword2 = ChangeMinorPassword_EditBox3:GetText();

	
	-- Èç¹ûÃÜÂë²»Ò»ÖÂ
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("M§t mã ðßa vào không ð°ng nh¤t Trí!")
		
		ChangeMinorPassword_EditBox1:SetText("");
		ChangeMinorPassword_EditBox2:SetText(""); 
		ChangeMinorPassword_EditBox3:SetText("");
		return;
	end;
	
	
	local iLenOld = string.len(strPasswordOld);
	local iLenNew = string.len(strPassword1);
	if(iLenOld < 4) then
	
		ShowSystemTipInfo("Cñu m§t mã không th¬ Thi¬u Vu 4Cá tñ phù!");
		return;
	end;
	
	if(iLenNew < 4) then
	
		ShowSystemTipInfo("M§t mã m¾i không dß¾i 4 ký tñ!");
		return;
	end;

	-- Èç¹ûÃÜÂëÒ»ÖÂ¡£·¢ËÍ¸Ä±äÃÜÂëÏûÏ¢¡£
	ModifyMinorPassword(strPasswordOld, strPassword1);
	
	this:Hide();

end


-------------------------------------------------------------------------------------------------------
--
-- µã»÷È¡ÏûÉèÖÃ¶þ¼¶±£»¤ÃÜÂë°´Å¥¡£
--
function ChangeMinorPassword_Cancel()
	CloseWindow( "SoftKeyBoard" );
 	this:Hide();
 	
 	-- ´ò¿ª½âËø¶Ô»°¿ò¡£ ²âÊÔ¡£
 	--OpenUnLockeMinorPasswordDlg();
end;

-------------------------------------------------------------------------------------------------------
--
-- µã»÷°ïÖú°´Å¥
--
function ChangeMinorPassword_Help()

end;


-------------------------------------------------------------------------------------------------------
--
-- Çå¿ ÃÜÂë
--
function ClearPassword_Box()

	-- ¾ÉµÄÃÜÂë
	ChangeMinorPassword_EditBox1:SetText("");
	
	-- ÐÂµÄÃÜÂë¡£
	ChangeMinorPassword_EditBox2:SetText(""); 
	ChangeMinorPassword_EditBox3:SetText("");
	
end;


function ChangeMinorPassword_EditBox1_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox1" );
end
function ChangeMinorPassword_EditBox2_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox2" );
end
function ChangeMinorPassword_EditBox3_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox3" );
end
