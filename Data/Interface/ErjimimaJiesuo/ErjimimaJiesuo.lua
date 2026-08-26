local g_CurrectOperate = 0;  --1?pk???????????. 2??????????????
local g_PKModeWant = 0;  --1?pk???????????.


function ErjimimaJiesuo_PreLoad()
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG");
	this:RegisterEvent("OPENINPUTPASSWORD_PKVERIFY");
	this:RegisterEvent("OPENINPUTPASSWORD_BANKVERIFY");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end


function ErjimimaJiesuo_OnLoad()


end

function ErjimimaJiesuo_OnEvent( event )
	if(event == "MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG") then
		g_CurrectOperate = 0
		ErjimimaJiesuo_Show()
	end	
	
	if(event == "OPENINPUTPASSWORD_PKVERIFY") then
		g_PKModeWant = tonumber(arg0);
		g_CurrectOperate = 1
		ErjimimaJiesuo_Show()
	end	
	
	if( event == "OPENINPUTPASSWORD_BANKVERIFY" ) then
		g_CurrectOperate = 2
		ErjimimaJiesuo_Show()
	end

	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ErjimimaJiesuo_Close();
	end
end

function ErjimimaJiesuo_Show()
		CloseWindow("SafeTime" , true)
		CloseWindow("ErjimimaXiugai", true)
		CloseWindow("ErjimimaShezhi", true)
		CloseWindow("Fangdao", true)
		CloseWindow("DianhuaMibao", true)
		
		local safeTimePos = Variable:GetVariable("SafeTimePos");
		if(safeTimePos ~= nil) then
			ErjimimaJiesuo_Frame:SetProperty("UnifiedPosition", safeTimePos);
		end
		this:Show();
		ErjimimaJiesuo_Jiesuo:SetText( "" );
		ErjimimaJiesuo_SoftKey:SetAimEditBox( "ErjimimaJiesuo_Jiesuo" );

end

function ErjimimaJiesuo_Jiesuo_OnActive()
	ErjimimaJiesuo_SoftKey:SetAimEditBox( "ErjimimaJiesuo_Jiesuo" );
end

function ErjimimaJiesuo_Close()
	Variable:SetVariable("SafeTimePos", ErjimimaJiesuo_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function ErjimimaJiesuo_OnHide()
	Variable:SetVariable("SafeTimePos", ErjimimaJiesuo_Frame:GetProperty("UnifiedPosition"), 1);
end

function ErjimimaJiesuo_OK_Click()
	if( 2 == g_CurrectOperate ) then
		local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
		local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("M§t mã không th¬ Thi¬u Vu 4Cá tñ phù!");
			return;
		end
		BankAcquireListWithPW( strPassword )
		-- Òþ²Ø´°¿Ú.
		ErjimimaJiesuo_Close();
	        return
	end
    
	if( 1 == g_CurrectOperate ) then
		local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
		local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("M§t mã không th¬ Thi¬u Vu 4Cá tñ phù!");
			return;
		end
		Player:ChangePVPModeWithPassword( g_PKModeWant, strPassword )
	        -- Òþ²Ø´°¿Ú.
		ErjimimaJiesuo_Close();
		return
	end

	local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
	local iLen = string.len(strPassword);
	if(iLen < 4) then
	
		ShowSystemTipInfo("M§t mã không th¬ Thi¬u Vu 4Cá tñ phù!");
		return;
	end;
	-- ½âËøÃÜÂë¡£
	UnLockMinorPassword(strPassword);
	-- Òþ²Ø´°¿Ú.
	ErjimimaJiesuo_Close();
end

--Ç¿ÖÆ½â³ýÃÜÂë
function ErjimimaJiesuo_Jiechu()
	-- Ç¿ÖÆ½Ó´¥ÃÜÂë
	ForceUnLockMinorPassword();
	
	-- Òþ²Ø´°¿Ú.
	ErjimimaJiesuo_Close();
end
