local g_ConfraternityZTStart_Frame_UnifiedPosition;

function ConfraternityZTStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDBATTLE_DLG");

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")				
end

function ConfraternityZTStart_OnLoad()
		g_ConfraternityZTStart_Frame_UnifiedPosition=ConfraternityZTStart_Frame:GetProperty("UnifiedPosition");
end


function ConfraternityZTStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDBATTLE_DLG") then
		ConfraternityZTStart_InitDlg()
		this:Show()
	end
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityZTStart_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityZTStart_Frame_On_ResetPos()
	end
end

function ConfraternityZTStart_InitDlg()
	ConfraternityZTStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityZTStart_Input:SetText("");
end


function ConfraternityZTStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityZTStart_OnHide()
end

function ConfraternityZTStart_OnHide()
	ConfraternityZTStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityZTStart_Accept_BtnClick()
	local guid = ConfraternityZTStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("Bang hµi idkhÙng th¨ Vi KhÙng!");
		return;
	end
	City:SendAddGuildBattleMsg(tonumber(guid));
	this:Hide();
end


--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ConfraternityZTStart_Frame_On_ResetPos()
  ConfraternityZTStart_Frame:SetProperty("UnifiedPosition", g_ConfraternityZTStart_Frame_UnifiedPosition);
end
