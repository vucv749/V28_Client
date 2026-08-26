--Cloud_Agreement
local g_fullPath = "..\\Helper\\license-game.txt"
local g_Text = "no license..."
local g_fullPath_Privacy="..\\Helper\\license-privacy.txt"
local g_Text_Privacy = "no license..."

--===============================================
-- PreLoad()
--===============================================
function Cloud_Agreement_PreLoad()

	this:RegisterEvent("OPEN_AGREEMENT_DLG");
	this:RegisterEvent("NET_HAS_CLOSED");
end

--===============================================
-- OnLoad()
--===============================================
function Cloud_Agreement_OnLoad()
		local f = io.open(g_fullPath,"rb");
		if(f)then
			g_Text = f : read("*all");
		end
		if(f)then
			f : close();
			f = nil;
		end
		
		-- ÒþË½Ð­Òé
		local fprivacy = io.open(g_fullPath_Privacy,"rb");
		if(fprivacy)then
			g_Text_Privacy = fprivacy : read("*all");
		end
		if(fprivacy)then
			fprivacy : close();
			fprivacy = nil;
		end
end

--===============================================
-- OnEvent()
--===============================================
function Cloud_Agreement_OnEvent(event)
	if(event == "OPEN_AGREEMENT_DLG") then
		if not GameProduceLogin:IsYunGameMobileClient() then 
			return
		end
		
		CloseWindow( "SoftKeyBoard" );
		Cloud_Agreement_Button_Accept : Disable();
		Cloud_Agreement_Button_Continue : Enable();
		Cloud_Agreement_User_ShowText();
		Cloud_Agreement_User_Bind : SetCheck(0);
		Cloud_Agreement_Privacy_Bind : SetCheck(0);
		
		Cloud_Agreement_User_Text:SetText("#{TYXY_20211105_01}")
		Cloud_Agreement_Privacy_Text:SetText("#{TYXY_20211105_02}")
		
		if(not this:IsVisible() ) then
			this:Show()
		end
	end
	if( event == "NET_HAS_CLOSED" ) then
		this : Hide();
	end
end

function Cloud_Agreement_Accept()
	GameProduceLogin:AgreeProtocol();
	this : Hide();
end

function Cloud_Agreement_Cancel()
	GameProduceLogin:ReturnToAccountDlg();
	this : Hide();
end

function Cloud_Agreement_User_SetCheck()
	local bUserChk = Cloud_Agreement_User_Bind : GetCheck();
	local bPrivacyChk = Cloud_Agreement_Privacy_Bind : GetCheck();
	if bUserChk > 0 and bPrivacyChk > 0 then
		Cloud_Agreement_Button_Accept : Enable();
	else
		Cloud_Agreement_Button_Accept : Disable();
	end
	
	if bUserChk > 0 then
		Cloud_Agreement_User_ShowText()
	end
end

function Cloud_Agreement_User_ShowText()
	Cloud_Agreement_Text : SetText(" ");
	Cloud_Agreement_Text : SetText(g_Text);
end

function Cloud_Agreement_Privacy_SetCheck()
	local bUserChk = Cloud_Agreement_User_Bind : GetCheck();
	local bPrivacyChk = Cloud_Agreement_Privacy_Bind : GetCheck();
	if bUserChk > 0 and bPrivacyChk > 0 then
		Cloud_Agreement_Button_Accept : Enable();
	else
		Cloud_Agreement_Button_Accept : Disable();
	end
	
	if bPrivacyChk > 0 then
		Cloud_Agreement_Privacy_ShowText()
	end
end

function Cloud_Agreement_Privacy_ShowText()
	Cloud_Agreement_Text : SetText(" ");
	Cloud_Agreement_Text : SetText(g_Text_Privacy);
end

function Cloud_Agreement_User_MouseEnter()
	Cloud_Agreement_User_Text:SetText("#{TYXY_20211105_08}")
end

function Cloud_Agreement_User_MouseLeave()
	Cloud_Agreement_User_Text:SetText("#{TYXY_20211105_01}")
end

function Cloud_Agreement_Privacy_MouseEnter()
	Cloud_Agreement_Privacy_Text:SetText("#{TYXY_20211105_09}")
end

function Cloud_Agreement_Privacy_MouseLeave()
	Cloud_Agreement_Privacy_Text:SetText("#{TYXY_20211105_02}")
end

