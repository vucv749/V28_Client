local g_ConfraternityPKStart_Frame_UnifiedPosition;

function ConfraternityPKStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDENEMY_DLG");		

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternityPKStart_OnLoad()
	g_ConfraternityPKStart_Frame_UnifiedPosition=ConfraternityPKStart_Frame:GetProperty("UnifiedPosition");
end


function ConfraternityPKStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDENEMY_DLG") then
		ConfraternityPKStart_InitDlg()
		this:Show()
	end
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityPKStart_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityPKStart_Frame_On_ResetPos()
	end
end

function ConfraternityPKStart_InitDlg()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityPKStart_Input:SetText("");
end


function ConfraternityPKStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityPKStart_OnHide()
end

function ConfraternityPKStart_OnHide()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityPKStart_Accept_BtnClick()
	if DataPool:Lua_IsInTServer() == 1 then
		PushDebugMessage("#{HSLJ_190919_268}")
		return
	end
	local guid = ConfraternityPKStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("id bang hµi khÙng th¨ bˆ trØng!");
		return;
	end
	City:SendAddEnemyMsg(tonumber(guid));
	this:Hide();
end


--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function ConfraternityPKStart_Frame_On_ResetPos()
  ConfraternityPKStart_Frame:SetProperty("UnifiedPosition", g_ConfraternityPKStart_Frame_UnifiedPosition);
end
